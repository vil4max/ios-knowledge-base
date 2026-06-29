# Collection Views

## In 30 seconds

**UICollectionView** displays a grid or custom layout of reusable cells. **`UICollectionViewCompositionalLayout`** (iOS 13+) builds layouts from composable **sections**, **groups**, and **items** with orthogonal scrolling, headers, and supplementary views — replacing most custom `UICollectionViewLayout` subclasses. **`UICollectionViewDiffableDataSource`** applies snapshot updates with automatic diffing and animations, reducing `performBatchUpdates` crashes. **Cell reuse** via `dequeueReusableCell` keeps memory flat during scroll; **`prepareForReuse`** resets stale state. **Prefetching** (`UICollectionViewDataSourcePrefetching`) loads data/images ahead of the visible rect. SwiftUI's **`LazyVGrid`** / **`LazyHGrid`** offer declarative lazy grids but differ in identity, diffing, and UIKit integration — know when to bridge with `UIViewRepresentable` vs stay in UIKit for complex compositional layouts.

## Apple docs

- [UICollectionView](https://developer.apple.com/documentation/uikit/uicollectionview) — data source, delegate, scrolling, selection.
- [UICollectionViewCompositionalLayout](https://developer.apple.com/documentation/uikit/uicollectionviewcompositionallayout) — sections, groups, items, orthogonal scrolling.
- [UICollectionViewDiffableDataSource](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource) — snapshots, animating differences.
- [NSDiffableDataSourceSnapshot](https://developer.apple.com/documentation/uikit/nsdiffabledatasourcesnapshot) — sections, items, reload/reconfigure.
- [UICollectionViewDataSourcePrefetching](https://developer.apple.com/documentation/uikit/uicollectionviewdatasourceprefetching) — prefetch and cancel.
- [UICollectionViewCell](https://developer.apple.com/documentation/uikit/uicollectionviewcell) — reuse, `prepareForReuse`.
- [UICollectionViewListCell](https://developer.apple.com/documentation/uikit/uicollectionviewlistcell) — list appearance, swipe actions (iOS 14+).
- [LazyVGrid (SwiftUI)](https://developer.apple.com/documentation/swiftui/lazyvgrid) — lazy vertical grid.
- [Updating collection views using diffable data sources](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/updating_collection_views_using_diffable_data_sources) — migration guide.

## 🎯 Focus vs Defer

### Focus

- **Reuse lifecycle:** register → dequeue → configure → `prepareForReuse` — never assume cell state survives off-screen.
- **Compositional layout mental model:** `NSCollectionLayoutSection` = group(s) + orthogonal scrolling + boundary items (headers/footers).
- **Diffable snapshots:** `apply(_:animatingDifferences:)` vs `reloadData()` — item **identity** (`Hashable`) drives moves/inserts/deletes.
- **Prefetching:** implement `prefetchItemsAt` **and** `cancelPrefetchingForItemsAt` to avoid wasted network/decode work.
- **Performance:** avoid heavy work in `cellForItemAt`, decode images off main, measure with Instruments (Core Animation FPS, Time Profiler).
- **Self-sizing cells:** estimated vs final size, invalidation on content change — tie to Auto Layout in cell contentView.
- **SwiftUI comparison:** `LazyVGrid` identity via `ForEach(id:)`; UIKit diffable uses stable item IDs — same concept, different API.

### Defer

- **Custom `UICollectionViewLayout`** from scratch — compositional layout covers lists, grids, carousels, pinned headers in most apps.
- **`performBatchUpdates` gymnastics** in new code — prefer diffable unless you need fine-grained control diffable lacks.
- **Full SwiftUI rewrite** of a mature compositional feed — hybrid or UIKit often ships faster for complex supplementary views and prefetch.
- **Prefetch everything** — prefetch only when decode/load is measurable bottleneck; always cancel.

## Key concepts

| Term | Meaning |
|------|---------|
| **Reuse identifier** | Key for dequeuing a cell type from the reuse pool. |
| **Supplementary view** | Header, footer, decoration (section background). |
| **Compositional item** | Smallest layout unit; size (fractional/fixed/estimated), insets, zIndex. |
| **Compositional group** | Arranges items (horizontal/vertical); defines group size. |
| **Compositional section** | Group + section insets + orthogonal scrolling + boundary supplementary items. |
| **Diffable snapshot** | Immutable description of sections/items; diff engine computes updates. |
| **Item identity** | Stable `Hashable` ID — changing identity = delete+insert, not update. |
| **Reconfigure (iOS 15+)** | Refresh cell content without full reload when identity unchanged. |
| **Prefetch** | Callback before cell becomes visible to warm caches. |
| **Orthogonal scrolling** | Section scrolls perpendicular to collection's main axis (carousel row). |

### UICollectionView vs SwiftUI LazyVGrid

| Topic | UICollectionView | SwiftUI LazyVGrid |
|-------|------------------|-------------------|
| Layout | Compositional / custom layout | `GridItem` flex/adaptive/fixed |
| Updates | Diffable snapshot | `ForEach` + state; `.id()` for force refresh |
| Reuse | Explicit dequeue pool | Lazy creation, view identity rules |
| Prefetch | `UICollectionViewDataSourcePrefetching` | No first-class prefetch; `.task` per cell |
| Complex sections | Headers, footers, decorations, orthogonal | `Section`, custom `Layout`, or UIKit bridge |
| Selection | `didSelectItemAt` | `onTapGesture`, `NavigationLink` |

**When UIKit wins:** heterogeneous feeds, pinned section headers, orthogonal carousels in one vertical scroll, fine-grained prefetch/cancel, mature list cell swipe APIs. **When SwiftUI wins:** simple adaptive grids, shared state with rest of SwiftUI tree, less boilerplate for small lists.

### Diffable pitfalls

1. **Duplicate item identifiers** in one snapshot → undefined behavior / crashes.
2. **Mutating model** without new snapshot — UI stale until `apply`.
3. **Animating huge snapshots** — disable animation or batch for mass reloads.
4. **Forgetting `reloadSections`** when section structure changes but item IDs reused incorrectly.

## 🏋️ Exercises

1. **Basic grid:** 3-column compositional grid with fractional width items and 8 pt spacing. **Expected:** explain item → group → section chain without copying boilerplate blindly.

2. **Diffable feed:** `UICollectionViewDiffableDataSource<String, UUID>` with pull-to-refresh inserting items at top. **Expected:** smooth insert animation, no batch update exceptions.

3. **Reuse bug hunt:** Cell shows wrong avatar after fast scroll — fix missing reset in `prepareForReuse` and async image callback guard (`cell reuseIdentifier` / model version check). **Expected:** describe race between dequeue and late network.

4. **Prefetch:** Image URLs prefetched in `prefetchItemsAt`, cancelled in `cancelPrefetchingForItemsAt`. Scroll fast back and forth — no runaway downloads. **Expected:** paired prefetch/cancel discipline.

5. **Orthogonal carousel:** Vertical collection with one section = horizontal scrolling group (App Store–style row). **Expected:** `orthogonalScrollingBehavior = .continuous` or `.groupPaging`.

6. **Self-sizing cell:** Dynamic text height in list layout; adjust estimated height and invalidation. **Expected:** no jump on first scroll pass.

7. **Reconfigure:** Toggle favorite star on item without reload identity — use `reconfigureItems`. **Expected:** know difference vs `reloadItems`.

8. **LazyVGrid parity:** Rebuild exercise 1 in SwiftUI `LazyVGrid`; list trade-offs (reuse, prefetch, compositional carousel). **Expected:** articulate hybrid strategy.

## Links

- [WWDC 2019 — Advances in Collection View Layout](https://developer.apple.com/videos/play/wwdc2019/215/)
- [WWDC 2020 — Build lists in UICollectionView](https://developer.apple.com/videos/play/wwdc2020/10026/)
- [WWDC 2021 — Make UICollectionView diffable](https://developer.apple.com/videos/play/wwdc2021/10252/)
- [WWDC 2022 — What's new in UIKit](https://developer.apple.com/videos/play/wwdc2022/10068/) — reconfigure, self-sizing updates
- [Updating collection views using diffable data sources](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/updating_collection_views_using_diffable_data_sources)

## Code patterns

### Compositional grid section

```swift
let itemSize = NSCollectionLayoutSize(
    widthDimension: .fractionalWidth(1.0 / 3.0),
    heightDimension: .fractionalWidth(1.0 / 3.0)
)
let item = NSCollectionLayoutItem(layoutSize: itemSize)
item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
let groupSize = NSCollectionLayoutSize(
    widthDimension: .fractionalWidth(1.0),
    heightDimension: .fractionalWidth(1.0 / 3.0)
)
let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
return NSCollectionLayoutSection(group: group)
```

### Diffable apply

```swift
var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
snapshot.appendSections([.main])
snapshot.appendItems(items, toSection: .main)
dataSource.apply(snapshot, animatingDifferences: true)
```

### Prefetch pair

```swift
func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    for indexPath in indexPaths {
        imagePipeline.prefetch(url: items[indexPath.item].imageURL)
    }
}

func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
    for indexPath in indexPaths {
        imagePipeline.cancelPrefetch(url: items[indexPath.item].imageURL)
    }
}
```

---

## Interview Q&A (Knowledge cards)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question:** How does UICollectionView cell reuse work, and what belongs in `prepareForReuse`?

- **Answer:** Off-screen cells enter a reuse pool; dequeue returns arbitrary instances. Reset UI in `prepareForReuse` and guard async callbacks against stale index paths.

- **Follow-up:** register class vs nib?

### Q2
- **Question:** UICollectionViewCompositionalLayout — what builds a section?

- **Answer:** Item sizes feed groups; groups feed sections; sections add insets, orthogonal scrolling, and boundary supplementary views — composable declarative layout.

### Q3
- **Question:** Why UICollectionViewDiffableDataSource over performBatchUpdates?

- **Answer:** Snapshots declare end state; UIKit diffs safely. Stable item IDs are mandatory; reconfigure refreshes content without identity change.

### Q4
- **Question:** UICollectionView vs SwiftUI LazyVGrid — when to choose which?

- **Answer:** UIKit for complex compositional feeds, prefetch, and mature list features; LazyVGrid for simple SwiftUI-native grids. Hybrid bridges have sizing and lifecycle cost.

<!-- knowledge-cards-canonical:end -->
