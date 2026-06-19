import Foundation
import ObjectiveC

/*
 Apple docs:
 - MemoryLayout:
   https://developer.apple.com/documentation/swift/memorylayout
 - withUnsafeBytes:
   https://developer.apple.com/documentation/swift/withunsafebytes(of:_:)
 - class_getInstanceSize:
   https://developer.apple.com/documentation/objectivec/1418956-class_getinstancesize

 Article (конспектируем отсюда):
 - https://habr.com/en/companies/hh/articles/546856/

 Выжимка (ключевые понятия из статьи)
 - Память — упорядоченная последовательность байтов. У каждого байта есть адрес.
 - На 64‑битных устройствах “word” обычно = 8 байт (как размер указателя). CPU выгодно читать данные по словам.
 - `MemoryLayout<T>.size` — сколько байтов занимают поля `T` (с учётом внутренней раскладки).
 - `MemoryLayout<T>.alignment` — требование выравнивания: адрес начала значения должен быть кратен этому числу.
 - `MemoryLayout<T>.stride` — шаг между соседними значениями `T` в массиве. Обычно `stride >= size`,
   потому что `stride` округляет `size` вверх до ближайшего числа, кратного `alignment`.
 - Padding (пустые байты) появляется, чтобы соблюсти alignment и сделать чтение быстрее (меньше обращений к памяти).
 - В структурах порядок полей важен: неудачный порядок может увеличить padding ⇒ `size/stride` растут.
 - Для `class` `MemoryLayout<Class>.size == 8` (на 64‑битной машине), потому что это размер *ссылки*.
   Реальный размер объекта в куче можно посмотреть через Objective‑C runtime: `class_getInstanceSize(_:)`.
*/

// MARK: - Utilities

func printLayout<T>(_ type: T.Type, name: String) {
    print("\n— \(name)")
    print("  size:      \(MemoryLayout<T>.size)")
    print("  alignment: \(MemoryLayout<T>.alignment)")
    print("  stride:    \(MemoryLayout<T>.stride)")
}

func dumpBytes<T>(of value: inout T, bytesPerRow: Int = 8) {
    withUnsafeBytes(of: &value) { raw in
        for offset in stride(from: 0, to: raw.count, by: bytesPerRow) {
            let row = raw[offset ..< min(offset + bytesPerRow, raw.count)]
            let hex = row.map { String(format: "%02X", $0) }.joined(separator: " ")
            print(String(format: "  %02d: %@", offset, hex))
        }
    }
}

print("=== HH (habr) — MemoryLayout: size/alignment/stride ===")

// MARK: - Size: сумма полей vs реальная раскладка

struct FullResumeA {
    let id: String
    let age: Int
    let hasVehicle: Bool
}

struct FullResumeB {
    let hasVehicle: Bool
    let id: String
    let age: Int
}

printLayout(FullResumeA.self, name: "FullResumeA (String, Int, Bool)")
printLayout(FullResumeB.self, name: "FullResumeB (Bool, String, Int) — порядок полей")

var a = FullResumeA(id: "abc", age: 30, hasVehicle: true)
var b = FullResumeB(hasVehicle: true, id: "abc", age: 30)

print("\nBytes: FullResumeA")
dumpBytes(of: &a)

print("\nBytes: FullResumeB")
dumpBytes(of: &b)

// MARK: - Stride/Alignment на простом примере

struct ShortResume {
    let age: Int32
    let hasVehicle: Bool
}

printLayout(ShortResume.self, name: "ShortResume (Int32, Bool)")

let shortArray = [ShortResume(age: 10, hasVehicle: false), ShortResume(age: 11, hasVehicle: true)]
shortArray.withUnsafeBufferPointer { buffer in
    guard let base = buffer.baseAddress else { return }
    let p0 = UnsafeRawPointer(base)
    let p1 = UnsafeRawPointer(base.advanced(by: 1))
    print("\nPointers in [ShortResume] (distance == stride):")
    print("  p0: \(p0)")
    print("  p1: \(p1)")
    print("  diff bytes: \(Int(bitPattern: p1) - Int(bitPattern: p0))")
}

// MARK: - Проверь себя (из статьи)

struct Test {
    let firstBool: Bool
    let array: [Bool]
    let secondBool: Bool
    let smallInt: Int32
}

printLayout(Test.self, name: "Test (Bool, [Bool], Bool, Int32)")

// MARK: - Классы: MemoryLayout == размер ссылки, “реальный” размер в куче

final class PaidService {
    let id: String
    let name: String
    let isActive: Bool
    let expiresAt: Date?

    init(id: String, name: String, isActive: Bool, expiresAt: Date?) {
        self.id = id
        self.name = name
        self.isActive = isActive
        self.expiresAt = expiresAt
    }
}

printLayout(PaidService.self, name: "PaidService (class) — MemoryLayout показывает размер ссылки")

let instanceSize = class_getInstanceSize(PaidService.self)
print("\nclass_getInstanceSize(PaidService.self): \(instanceSize) bytes")

let obj = PaidService(id: "id", name: "name", isActive: true, expiresAt: Date())
print("Instance: \(obj)")

print("\n=== Done ===")

