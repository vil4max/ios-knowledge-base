# Graphics & Metal

## За 30 секунд

**Core Graphics** (`CGContext`, paths, gradients) is the immediate-mode 2D API behind much of UIKit drawing and **`UIImage`** rendering. **`UIGraphicsImageRenderer`** (preferred over legacy `UIGraphicsBeginImageContext`) creates bitmap contexts with correct scale and wide-color format. **`UIImage`** drawing respects **`UIImage.RenderingMode`**, asset catalogs, and PDF/vector assets at target size. **Metal** is Apple's low-level GPU API for high-throughput shading — use **`MTKView`**, **`CAMetalLayer`**, or SwiftUI **`MeshGradient`** / custom render pipelines when Core Graphics or Core Animation cannot meet performance goals; most UI stays UIKit/SwiftUI. **`CADisplayLink`** drives frame-synced redraw loops for custom **`draw(_:)`** or Metal present. **Pixel formats** (`RGBA8`, `BGRA`, extended sRGB, **`prefersExtendedRange`**) affect memory and color accuracy. All **UIKit/AppKit drawing and view mutation** belongs on the **main thread** — mark custom drawing types **`@MainActor`** in Swift concurrency code.

## Apple docs

- [Core Graphics](https://developer.apple.com/documentation/coregraphics) — contexts, paths, images, transforms.
- [UIGraphicsImageRenderer](https://developer.apple.com/documentation/uikit/uigraphicsimagerenderer) — bitmap rendering with format control.
- [Drawing and printing guide (archive)](https://developer.apple.com/library/archive/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/GraphicsDrawingOverview/GraphicsDrawingOverview.html) — UIKit drawing model.
- [UIImage](https://developer.apple.com/documentation/uikit/uiimage) — initialization, rendering mode, scale.
- [Metal](https://developer.apple.com/documentation/metal) — devices, command queues, pipelines.
- [MetalKit](https://developer.apple.com/documentation/metalkit) — `MTKView`, texture loading.
- [CAMetalLayer](https://developer.apple.com/documentation/quartzcore/cametallayer) — Metal drawable surface.
- [CADisplayLink](https://developer.apple.com/documentation/quartzcore/cadisplaylink) — frame-synced updates for custom drawing.
- [CGColorSpace](https://developer.apple.com/documentation/coregraphics/cgcolorspace) — sRGB, extended range, display P3.
- [MainActor](https://developer.apple.com/documentation/swift/mainactor) — UI-isolated code in Swift concurrency.

## 🎯 Focus vs Defer

### Focus

- **When to draw:** `draw(_:)` in custom `UIView` / `draw(_:)` in SwiftUI `Canvas` — expensive if over-invalidated; prefer layers or pre-rendered images for static art.
- **UIGraphicsImageRenderer:** specify `format` (opaque, scale, wide gamut); closure receives `CGContext`.
- **UIImage pipeline:** asset catalog PDF preserves vector; `@2x/@3x` bitmaps; **`UIImage.SymbolConfiguration`** for SF Symbols; downscale off main before assign to `UIImageView`.
- **Pixel format basics:** bytes per pixel, premultiplied alpha, BGRA vs RGBA on Apple GPUs — affects `CGBitmapInfo` and renderer format.
- **Main thread / @MainActor:** `setNeedsDisplay`, `UIGraphicsImageRenderer`, `UIImageView.image` — main; decode large images on background **`CGImageSource`** then assign on main.
- **Metal overview:** device → command queue → command buffer → render/compute pipeline → drawable present; not required for every interview but know **when** (particles, filters, massive meshes, custom shaders).
- **Display link + draw:** custom chart refresh; throttle work; don't allocate full-screen buffer every frame without need.

### Defer

- **Raw Metal pipeline** for static icons and standard UI — SF Symbols and assets suffice.
- **Core Graphics for every list cell live** — cache rendered thumbnails, use `UIImageView` + proper reuse.
- **Legacy `UIGraphicsBeginImageContext`** — use renderer API.
- **CPU-side PDF parsing each frame** — rasterize once at needed size.
- **Drawing from background threads** — never mutate UIKit graphics state off main.

## Ключевые понятия

| Term | Meaning |
|------|---------|
| **CGContext** | Current graphics state: transform, clip, stroke/fill, text drawing. |
| **CGBitmapContext** | Raster backing store; width × height × bytesPerRow. |
| **UIGraphicsImageRenderer** | High-level API creating UIImage from drawing closure. |
| **Scale factor** | Points vs pixels (`UIScreen.main.scale`, trait-aware). |
| **Premultiplied alpha** | RGB already multiplied by alpha — standard for iOS bitmaps. |
| **Extended range / P3** | Wide color assets; renderer format must match display capability. |
| **Metal device** | `MTLDevice` — GPU representation. |
| **Drawable** | Texture presented to screen via `CAMetalLayer`. |
| **@MainActor** | Compiler-enforced main-thread isolation for UI types and drawing. |
| **setNeedsDisplay** | Marks view dirty; `draw(_:)` called on next layout/display cycle. |

### Rendering stack (simplified)

```
SwiftUI Canvas / Image
        ↓
UIKit UIImageView / draw(_:)
        ↓
UIGraphicsImageRenderer → CGContext
        ↓
Core Animation (CALayer contents)
        ↓
Metal / render server (GPU compositing)
```

**Metal vs Core Graphics:** Core Graphics is **CPU** 2D rasterization (may use GPU assist internally). **Metal** is explicit **GPU** programming (shaders, buffers). Choose CG for image generation, PDF-like drawing, moderate complexity; Metal for sustained GPU workloads (games, video filters, procedural graphics at 120fps).

### Pixel formats (practical)

| Format | Typical use |
|--------|-------------|
| **32-bit BGRA8** | Default UI bitmaps, `UIGraphicsImageRenderer` |
| **RGBA8** | Interchange, some CG contexts |
| **16-bit float (RGBA)** | HDR / extended range pipelines |
| **sRGB vs Display P3** | Color-managed assets in catalog |

Wrong `bitmapInfo` → tinted edges, washed colors, or extra memory. Always thread **`scale`** through renderer format on Retina devices.

## 🏋️ Exercises

1. **Renderer badge:** Draw rounded rect + centered text with `UIGraphicsImageRenderer`; verify crisp output on @3x simulator. **Expected:** set `format.opaque` correctly; explain points vs pixels.

2. **Off-main decode:** Load 4000×4000 JPEG on background using `CGImageSourceCreateThumbnailAtIndex`; assign to `UIImageView` on main. **Expected:** no main-thread hitch in Instruments.

3. **Custom `draw(_:)` chart:** Simple line chart in `UIView` subclass; drive updates with `CADisplayLink` throttled to 30fps. **Expected:** invalidate link; thin callback.

4. **PDF asset:** Vector PDF in asset catalog; render at 24 pt and 96 pt via `UIImage` — compare sharpness to single @3x PNG. **Expected:** when vector catalog wins.

5. **Wide color swatch:** P3 color drawn with extended range renderer format vs sRGB-only — view on P3 device/simulator. **Expected:** describe format + color space chain.

6. **Metal hello triangle:** `MTKView` + minimal render pipeline (vertex/fragment shader) — one rotating triangle. **Expected:** high-level Metal frame: device, queue, drawable, present.

7. **@MainActor drawer:** Swift class wrapping `UIGraphicsImageRenderer` marked `@MainActor`; call from `Task.detached` and fix isolation error. **Expected:** `await MainActor.run` or redesign API.

8. **Caching strategy:** List of 500 avatars — compare live `draw(_:)` per cell vs pre-rendered cache + reuse. **Expected:** quantify memory vs CPU trade-off.

## Ссылки

- [WWDC 2018 — Image and Graphics Best Practices](https://developer.apple.com/videos/play/wwdc2018/219/)
- [WWDC 2020 — Build a Metal renderer](https://developer.apple.com/videos/play/wwdc2020/10602/)
- [WWDC 2022 — Display EDR content with Core Image, Metal, and SwiftUI](https://developer.apple.com/videos/play/wwdc2022/10113/)
- [WWDC 2023 — Explore materials in SwiftUI](https://developer.apple.com/videos/play/wwdc2023/10202/) — rendering integration context
- [Drawing and Printing Guide for iOS (archive)](https://developer.apple.com/library/archive/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/Introduction/Introduction.html)

## Code patterns

### UIGraphicsImageRenderer

```swift
let renderer = UIGraphicsImageRenderer(size: CGSize(width: 120, height: 40))
let image = renderer.image { context in
    UIColor.systemBlue.setFill()
    UIBezierPath(roundedRect: CGRect(origin: .zero, size: renderer.format.bounds.size), cornerRadius: 8).fill()
    let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.white]
    ("Badge" as NSString).draw(at: CGPoint(x: 12, y: 10), withAttributes: attrs)
}
```

### Background thumbnail decode

```swift
func decodeThumbnail(url: URL, maxPixelSize: Int) async -> UIImage? {
    await Task.detached(priority: .userInitiated) {
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else { return nil }
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixelSize,
            kCGImageSourceCreateThumbnailWithTransform: true
        ]
        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else { return nil }
        return UIImage(cgImage: cgImage)
    }.value
}
```

### @MainActor drawing wrapper

```swift
@MainActor
enum BadgeRenderer {
    static func makeBadge(title: String) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 120, height: 40))
        return renderer.image { _ in
            // draw badge
        }
    }
}
```

---

## Карточки знаний (Q&A)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question (RU):** **`UIGraphicsImageRenderer`** vs legacy **`UIGraphicsBeginImageContext`** — что знать?
- **Question (EN):** UIGraphicsImageRenderer vs UIGraphicsBeginImageContext — what to know?
- **Answer (RU):** **Renderer** — preferred API: автоматический **scale**, **`UIGraphicsImageRendererFormat`** (opaque, wide color, **`preferredRange`**), без ручного `UIGraphicsGetCurrentContext` boilerplate. Legacy context легко получить неверный scale (blur) или non-opaque лишние альфа-blend. Рендер closure атомарен; результат **`UIImage`** для `UIImageView` / share sheet.

- **Answer (EN):** Renderer handles scale and format correctly; legacy context APIs are error-prone for Retina and alpha. Use renderer for all new bitmap generation.

- **Устная заготовка (RU):** renderer = scale + format из коробки; legacy — blur и alpha баги.

- **Устная заготовка (EN):** Renderer fixes scale/format; legacy causes blurry or wrong alpha.

- **Follow-up:** points vs pixels в renderer size?
- **Follow-up answer:** size в **points**; format.scale умножает на pixel grid — не hardcode pixel width.

### Q2
- **Question (RU):** **Core Graphics** drawing pipeline в UIKit — `draw(_:)`, **`setNeedsDisplay`**, layers?
- **Question (EN):** UIKit Core Graphics pipeline — draw(_:), setNeedsDisplay, layers?
- **Answer (RU):** **`setNeedsDisplay`** помечает view dirty → **`draw(_ rect:)`** на main в следующем cycle. Частые full redraw дороги — кеш **`UIImage`**, **`CALayer.contents`**, **`CATiledLayer`** для zoom. **`UIGraphicsImageRenderer`** — offscreen draw без subclass. **`shouldRasterize`** — trade memory for scroll perf. SwiftUI **`Canvas`** — declarative analogue для custom vector art.

- **Answer (EN):** Invalidation triggers draw(_:) on main; cache static art as images or layer contents; avoid heavy per-frame full view redraw.

- **Устная заготовка (RU):** setNeedsDisplay → draw на main; кешируй статику; не рисуй список каждый frame.

- **Устная заготовка (EN):** Invalidate sparingly; cache; main-thread draw.

- **Follow-up:** `draw(_:)` vs `CALayer` delegate?
- **Follow-up answer:** layer-backed views often draw into layer; direct layer contents skip some view draw path — know your hierarchy.

### Q3
- **Question (RU):** **Metal overview** — когда Metal, а когда Core Graphics / SwiftUI достаточно?
- **Question (EN):** Metal overview — when Metal vs Core Graphics / SwiftUI?
- **Answer (RU):** **Core Graphics / UIKit** — badges, PDF rasterization, moderate custom 2D, image processing на CPU. **SwiftUI** — product UI, `Canvas`, shaders limited. **Metal** — sustained GPU: games, camera filters, particle systems, large mesh, compute shaders. Stack: **`MTLDevice`** → command queue → encoders → **`CAMetalLayer`** drawable present. Большинству app-разработчиков достаточно знать **границу**, не писать pipeline каждый день.

- **Answer (EN):** CG for 2D image generation and moderate drawing; Metal for GPU-bound real-time graphics; most app UI never needs custom Metal.

- **Устная заготовка (RU):** CG — 2D картинки; Metal — GPU throughput; UI — UIKit/SwiftUI.

- **Устная заготовка (EN):** CG for bitmaps; Metal for GPU-heavy; standard UI elsewhere.

- **Follow-up:** `MTKView` vs raw `CAMetalLayer`?
- **Follow-up answer:** MTKView — loop, drawable size, delegate; CAMetalLayer — lower level embed in custom view hierarchy.

### Q4
- **Question (RU):** **Pixel formats**, color spaces, и **`@MainActor`** для drawing — собес?
- **Question (EN):** Pixel formats, color spaces, and @MainActor for drawing — interview topics?
- **Answer (RU):** **BGRA8 premultiplied** — типичный UI bitmap. **Display P3 / extended range** — нужны matching **`CGColorSpace`**, asset catalog wide color, renderer format. Неверный **`bitmapInfo`** → fringe и banding. **UIKit/AppKit mutation и graphics state — main thread**; decode/filter на background, **`UIImage` assign @MainActor**. Swift 6: custom renderer class **`@MainActor`**, иначе isolation errors из `Task.detached`.

- **Answer (EN):** Know default BGRA premultiplied; wide color needs end-to-end color space match; decode off main, assign on main; mark UI drawing types @MainActor.

- **Устная заготовка (RU):** P3 end-to-end; decode off main; UI draw @MainActor.

- **Устная заготовка (EN):** Color space chain matters; background decode; main for UI bitmap.

- **Follow-up:** **`CADisplayLink`** + custom draw — риски?
- **Follow-up answer:** per-frame allocation, main-thread overload — profile; throttle or move simulation off hot path.

<!-- knowledge-cards-canonical:end -->
