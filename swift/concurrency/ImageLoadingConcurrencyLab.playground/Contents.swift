import Foundation
import PlaygroundSupport
import UIKit

/*
 Лаборатория для собеса: N картинок по HTTPS, не больше 10 одновременных загрузок.

 Три подхода:
 1) GCD — concurrent worker-очередь + семафор(10) ограничивает параллелизм; UI только на main.
 2) OperationQueue — maxConcurrentOperationCount = 10; система сама держит «окно».
 3) Swift Concurrency — withTaskGroup + скользящее окно из 10 задач; отмена через Task.

 Переключатель сегментов перезапускает загрузку: отмена Operation, отмена Task, для GCD — счётчик поколения,
 чтобы старые completion не писали в массив после смены режима.

 Важно: Data(contentsOf:) — синхронный вызов, в проде для сети используют URLSession (в третьем режиме — async URLSession).
*/

PlaygroundPage.current.needsIndefiniteExecution = true

final class ImageCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ImageCollectionViewCell"
    let cardImageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.backgroundColor = .tertiarySystemFill
        cardImageView.translatesAutoresizingMaskIntoConstraints = false
        cardImageView.contentMode = .scaleAspectFill
        cardImageView.clipsToBounds = true
        contentView.addSubview(cardImageView)
        NSLayoutConstraint.activate([
            cardImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func apply(image: UIImage?) {
        cardImageView.image = image
    }
}

@MainActor
final class RootViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let segmentedControl = UISegmentedControl(items: ["GCD + семафор", "OperationQueue", "Swift Concurrency"])
    private var collectionView: UICollectionView!
    private var urls: [URL] = []
    private var imageSlots: [UIImage?] = []
    private var loadGeneration = 0
    private let gcdWorkerQueue = DispatchQueue(
        label: "image-lab.gcd.worker",
        qos: .userInitiated,
        attributes: .concurrent
    )
    private let gcdSemaphore = DispatchSemaphore(value: 10)
    private let operationDownloadQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 10
        queue.qualityOfService = .userInitiated
        return queue
    }()
    private var swiftLoadTask: Task<Void, Never>?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        let flow = UICollectionViewFlowLayout()
        flow.minimumInteritemSpacing = 8
        flow.minimumLineSpacing = 8
        flow.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flow)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        urls = Self.makeDemoURLs(count: 24)
        startLoadingForCurrentMode()
    }
    @objc private func segmentChanged() {
        startLoadingForCurrentMode()
    }
    private func startLoadingForCurrentMode() {
        loadGeneration += 1
        let generation = loadGeneration
        operationDownloadQueue.cancelAllOperations()
        swiftLoadTask?.cancel()
        swiftLoadTask = nil
        imageSlots = Array(repeating: nil, count: urls.count)
        collectionView.reloadData()
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            startGCDLoading(generation: generation)
        case 1:
            startOperationLoading(generation: generation)
        default:
            swiftLoadTask = Task { [weak self] in
                await self?.runSwiftPipeline(generation: generation)
            }
        }
    }
    private func startGCDLoading(generation: Int) {
        /*
         Шаг 1: concurrent очередь gcdWorkerQueue — сюда кладём N независимых блоков; они могут стартовать параллельно.
         Шаг 2: семафор gcdSemaphore(value: 10) — перед загрузкой wait(), после signal(); одновременно не больше 10 потоков
         из пула пройдут «ворота».
         Шаг 3: Data(contentsOf:) выполняется на воркере (демо); в проде — URLSession с async/await или callback.
         Шаг 4: DispatchQueue.main.async — любые изменения imageSlots и reloadItems только на главной очереди (UIKit).
         Шаг 5: сравнение generation с loadGeneration — если пользователь сменил режим, старые completion игнорируются.
         */
        for (index, url) in urls.enumerated() {
            gcdWorkerQueue.async { [weak self] in
                guard let self else { return }
                self.gcdSemaphore.wait()
                defer { self.gcdSemaphore.signal() }
                guard let data = try? Data(contentsOf: url) else { return }
                let image = UIImage(data: data)
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    guard generation == self.loadGeneration else { return }
                    self.imageSlots[index] = image
                    self.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
                }
            }
        }
    }
    private func startOperationLoading(generation: Int) {
        /*
         Шаг 1: operationDownloadQueue.maxConcurrentOperationCount = 10 — система сама не допускает больше 10
         одновременно исполняемых Operation (аналог «окна» без семафора).
         Шаг 2: на каждый URL создаём BlockOperation с телом загрузки (синхронное демо Data(contentsOf:)).
         Шаг 3: по завершении ставим OperationQueue.main.addOperation — UI снова только на main-очереди операций
         (= main dispatch queue по смыслу для UIKit).
         Шаг 4: cancelAllOperations вызывается при смене режима до постановки новых операций — не стартовавшие отменятся;
         уже бегущие синхронные загрузки в демо не прервать без кооперации внутри тела.
         Шаг 5: проверка generation на main — защита от гонки со старым запуском.
         */
        for (index, url) in urls.enumerated() {
            let operation = BlockOperation { [weak self] in
                guard let self else { return }
                guard let data = try? Data(contentsOf: url) else { return }
                let image = UIImage(data: data)
                OperationQueue.main.addOperation { [weak self] in
                    guard let self else { return }
                    guard generation == self.loadGeneration else { return }
                    self.imageSlots[index] = image
                    self.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
                }
            }
            operationDownloadQueue.addOperation(operation)
        }
    }
    private func runSwiftPipeline(generation: Int) async {
        /*
         Шаг 1: Task из UI наследует MainActor — координация старта/отмены удобна; тяжёлая сеть уходит в group.addTask.
         Шаг 2: withTaskGroup — структурированный параллелизм; addTask добавляет подзадачи.
         Шаг 3: скользящее окно — сначала запускаем до 10 задач, затем на каждое завершение (await group.next())
         стартуем следующий индекс, пока не обработаем все URL; так одновременно не больше 10 загрузок.
         Шаг 4: downloadData нанесён как nonisolated static + URLSession.shared.data(from:) — правильный async API сети.
         Шаг 5: UIImage создаём на MainActor после получения Data — декодирование не размазываем по Sendable-границам
         (в лаборатории упрощение; при желании перенесите decode в подзадачу и возвращайте Sendable-данные).
         Шаг 6: Task.isCancelled + generation — отмена экрана/режима останавливает дальнейшие обновления и cancelAll() группы.
         */
        let urlList = urls
        let maxConcurrent = 10
        await withTaskGroup(of: (Int, Data?).self) { group in
            var nextIndex = 0
            let initialWave = min(maxConcurrent, urlList.count)
            for _ in 0..<initialWave {
                let index = nextIndex
                let url = urlList[index]
                nextIndex += 1
                group.addTask {
                    let data = await Self.downloadData(from: url)
                    return (index, data)
                }
            }
            var completed = 0
            while completed < urlList.count {
                guard let result = await group.next() else { break }
                completed += 1
                if Task.isCancelled || generation != loadGeneration {
                    group.cancelAll()
                    return
                }
                let (index, data) = result
                let image = data.flatMap { UIImage(data: $0) }
                imageSlots[index] = image
                collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
                if nextIndex < urlList.count {
                    let idx = nextIndex
                    let url = urlList[idx]
                    nextIndex += 1
                    group.addTask {
                        let data = await Self.downloadData(from: url)
                        return (idx, data)
                    }
                }
            }
        }
    }
    nonisolated private static func downloadData(from url: URL) async -> Data? {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let http = response as? HTTPURLResponse else {
                return nil
            }
            guard (200..<300).contains(http.statusCode) else {
                return nil
            }
            return data
        } catch {
            return nil
        }
    }
    private static func makeDemoURLs(count: Int) -> [URL] {
        (0..<count).compactMap { index in
            URL(string: "https://picsum.photos/seed/concurrency-lab-\(index)/200/200")
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        urls.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath)
        if let imageCell = cell as? ImageCollectionViewCell {
            imageCell.apply(image: imageSlots[indexPath.item])
        }
        return cell
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let flow = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpacing = flow.sectionInset.left + flow.sectionInset.right + flow.minimumInteritemSpacing * 2
        let width = (collectionView.bounds.width - totalSpacing) / 3
        let side = max(80, floor(width))
        return CGSize(width: side, height: side)
    }
}

let liveController = RootViewController()
liveController.view.bounds = CGRect(x: 0, y: 0, width: 390, height: 780)
liveController.view.layoutIfNeeded()
PlaygroundPage.current.liveView = liveController
