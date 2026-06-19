import UIKit
import PlaygroundSupport

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "UIKit Example"
        setupViews()
    }
    
    private func setupViews() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "backpack.jpeg")
        imageView.contentMode = .scaleAspectFit
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        """
        descriptionLabel.numberOfLines = 0
        
        let weightImageView = UIImageView()
        weightImageView.contentMode = .scaleAspectFit
        weightImageView.image = UIImage(systemName: "scalemass.fill")
        
        // Formatted weight
        let weight = Measurement(value: 1.5, unit: UnitMass.kilograms)
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitStyle = .medium
        measurementFormatter.unitOptions = .naturalScale
        let formattedWeight = measurementFormatter.string(from: weight)
        
        let weigthLabel = UILabel()
        weigthLabel.text = formattedWeight
        weigthLabel.textAlignment = .center
        
        let labelsStackView1 = UIStackView(arrangedSubviews: [weightImageView, weigthLabel])
        labelsStackView1.distribution = .fillEqually
        labelsStackView1.axis = .horizontal
        
        let moneyImageView = UIImageView()
        moneyImageView.contentMode = .scaleAspectFit
        moneyImageView.image = UIImage(systemName: "dollarsign.circle")
        
        // Formatted Price
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        let price: NSNumber = 149.99
        let formattedPrice = numberFormatter.string(from: price) ?? "$0.00"
        
        let moneyLabel = UILabel()
        moneyLabel.text = formattedPrice
        moneyLabel.textAlignment = .center
        
        let labelsStackView2 = UIStackView(arrangedSubviews: [moneyImageView, moneyLabel])
        labelsStackView2.distribution = .fillEqually
        labelsStackView2.axis = .horizontal
        
        let mainStackView = UIStackView(arrangedSubviews: [imageView, descriptionLabel, labelsStackView1, labelsStackView2])
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }
}

let navController = UINavigationController(rootViewController: ViewController())
navController.navigationBar.prefersLargeTitles = true

PlaygroundPage.current.liveView = navController
