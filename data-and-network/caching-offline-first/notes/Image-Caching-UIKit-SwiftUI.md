# Image Caching in UIKit and SwiftUI

Notes for **22 — Caching** and interviews (UIKit / SwiftUI / memory). Card **Q35** in `Caching-Offline-First.md`. Related: [Networking Q HTTP cache](../../20%20Networking%20—%20URLSession,%20REST,%20WebSocket,%20GraphQL,%20gRPC/Networking-URLSession-REST-WebSocket.md), playground [ImageLoadingConcurrencyLab](../../../II.%20Swift/08%20Swift%20Concurrency%20—%20async-await,%20actor,%20isolation/ImageLoadingConcurrencyLab.playground/Contents.swift).

## Background

At WWDC26 Apple finally improved image caching support in SwiftUI's `AsyncImage`.

Many developers expected this functionality from the very first release of `AsyncImage` because image caching had already been a solved problem in UIKit for many years.

---

# What AsyncImage Did Before WWDC26

`AsyncImage` could:

- Download an image from a URL
- Display a placeholder
- Render the loaded image

Example:

```swift
AsyncImage(url: imageURL)
```

However, developers had little control over:

- Memory cache
- Disk cache
- Cache policies
- Prefetching
- Cache invalidation

As a result, images could be reloaded when:

- Scrolling lists
- Reopening screens
- SwiftUI views were recreated

For production apps, developers often used:

- Kingfisher
- Nuke
- SDWebImage

---

# UIKit Image Caching Architecture

UIKit never provided built-in image caching through `UIImageView`.

Instead, Apple provided the building blocks.

## Main Components

```text
Network
   ↓
URLCache
   ↓
Disk Cache (optional)
   ↓
NSCache (memory)
   ↓
UIImageView
```

---

# URLCache

`URLCache` stores HTTP responses automatically.

Example:

```swift
let (data, _) = try await URLSession.shared.data(from: url)
```

If the server returns:

```http
Cache-Control: max-age=86400
ETag: "abc123"
```

the system may:

- Serve cached data
- Send conditional requests
- Receive `304 Not Modified`

### Important

`URLCache` stores:

```text
JPEG bytes
PNG bytes
HTTP responses
```

It does NOT store:

```text
UIImage
```

---

# NSCache

`NSCache` is Apple's in-memory cache.

Example:

```swift
let cache = NSCache<NSURL, UIImage>()
```

Usage:

```swift
if let image = cache.object(forKey: url as NSURL) {
    imageView.image = image
} else {
    let image = try await download(url)

    cache.setObject(image, forKey: url as NSURL)

    imageView.image = image
}
```

---

# Who Puts Images Into NSCache?

The developer.

UIKit never automatically executes:

```text
Download image
   ↓
Put into NSCache
```

The developer must explicitly call:

```swift
cache.setObject(image, forKey: key)
```

---

# Why Store UIImage Instead of JPEG?

Loading from URLCache still requires:

```text
JPEG bytes
   ↓
Decode
   ↓
UIImage
```

This decoding step costs CPU time.

When storing a ready `UIImage` in `NSCache`:

```text
UIImage
   ↓
Display immediately
```

Benefits:

- No network request
- No disk access
- No image decoding
- Faster scrolling

---

# What Is RAM?

RAM = Random Access Memory

Think of an iPhone as an office:

```text
SSD Storage = filing cabinet
RAM         = desk
CPU         = worker
```

When an app starts:

```text
SSD
 ↓
RAM
 ↓
CPU works with data
```

All active objects live in RAM:

- Views
- Images
- Models
- AI data
- Application state

---

# Why Images Consume So Much RAM

Example:

```text
JPEG file on disk:      2 MB
Decoded UIImage in RAM: 20–40 MB
```

A decoded image often occupies much more memory than the original file.

Large image feeds can easily consume hundreds of megabytes.

---

# Memory Pressure

Memory pressure occurs when iOS starts running low on available RAM.

The system asks components to free memory.

```text
Low RAM
   ↓
Memory Pressure
   ↓
Caches release objects
```

---

# Why NSCache Is Special

Normal dictionary:

```swift
var cache: [URL: UIImage] = [:]
```

Objects stay in memory until the developer removes them.

`NSCache`:

```swift
let cache = NSCache<NSURL, UIImage>()
```

can automatically evict objects when memory is needed.

Benefits:

- Automatic cleanup
- Safer memory usage
- Better system integration

---

# What Happens When RAM Runs Out?

iOS follows roughly this sequence:

```text
1. Clean system caches
2. Trigger memory pressure handling
3. NSCache evicts objects
4. Suspend background apps
5. Kill processes if necessary
```

The final step is known as:

**Jetsam**

Jetsam terminates applications to recover memory.

---

# UITableView and UICollectionView Reuse

UIKit's reuse system works very well with image caching.

```text
Cell appears
   ↓
Image downloaded
   ↓
Image cached
   ↓
Cell leaves screen
   ↓
Another cell requests same URL
   ↓
Image returned from cache
```

No additional download is required.

---

# Production-Level Image Pipeline

Most mature image libraries implement:

```text
Memory Cache (UIImage)
        ↓
Disk Cache
        ↓
URLCache
        ↓
Network
```

Examples:

- Kingfisher
- Nuke
- SDWebImage

Lookup order:

1. Memory cache
2. Disk cache
3. HTTP cache
4. Network

This minimizes latency and CPU usage.

---

# Why Developers Criticized AsyncImage

Developers expected:

```text
AsyncImage
      ↓
Memory Cache
      ↓
Disk Cache
      ↓
URLSession
```

Instead, early versions behaved more like a simple downloader and renderer.

Because of this, many production applications continued using third-party libraries despite the existence of `AsyncImage`.

---

# Key Takeaways

- UIKit never cached images automatically through `UIImageView`.
- `URLCache` stores HTTP responses and image bytes.
- `NSCache` stores ready-to-display `UIImage` objects in RAM.
- Developers are responsible for placing images into `NSCache`.
- Memory pressure occurs when available RAM becomes low.
- `NSCache` can automatically evict objects during memory pressure.
- Professional image pipelines use multiple cache layers:
  - Memory Cache
  - Disk Cache
  - URLCache
  - Network
- This architecture existed years before SwiftUI's `AsyncImage`.
