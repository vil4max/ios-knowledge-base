# Snapshot testing — дисциплина

**Назначение:** когда снапшоты уместны на iOS; граница с unit и UI. В Apple SDK нет first-class snapshot API — сторонние библиотеки + дисциплина эталонов.

**Topic README:** [Testing](../README.md)

---

## TL;DR

_English summary — expand «По-русски» for full text (TL;DR)._

<details class="lang-ru">
<summary>По-русски</summary>

Snapshot сравнивает **эталон** (изображение или описание view) с текущим рендером. Уместен для **стабильных компонентов** при фиксированном device/OS. Не заменяет unit (логика) и не должен покрывать **весь экран** при живом дизайне.

---

</details>

## Когда да / когда нет

_English summary — expand «По-русски» for full text (Когда да / когда нет)._

<details class="lang-ru">
<summary>По-русски</summary>

| Делать | Не делать (пока) |
|--------|------------------|
| Кнопка, ячейка, card — изолированный компонент | Full-screen при частых redesign |
| Design system / shared UI kit | Динамический контент (ads, avatars URL) |
| Фиксированный simulator + OS в CI | Разные OS без отдельного эталона |
| Обновление эталона через code review | Snapshot ради coverage % |

**Альтернатива визуалу:** для DTO/моделей — `Codable` + JSON fixture; для layout-контракта — unit на view model state.

---

</details>

## Дисциплина эталонов

_English summary — expand «По-русски» for full text (Дисциплина эталонов)._

<details class="lang-ru">
<summary>По-русски</summary>

1. **Один** reference device (например iPhone 16, iOS 18.2) в CI и локально.
2. Эталоны в git; обновление — отдельный PR «update snapshots».
3. Компонент, не весь flow — меньше шума при смене навбара.
4. Тёмная тема — отдельный эталон или явный trait в тесте.
5. Dynamic Type — отдельные эталоны для `.accessibility3` если критично (дорого — осознанно).

---

</details>

## Место в пирамиде

_English summary — expand «По-русски» for full text (Место в пирамиде)._

<details class="lang-ru">
<summary>По-русски</summary>

```mermaid
flowchart TB
    UNIT[Unit — логика, VM]
    SNAP[Snapshot — компонент UI]
    UI[XCUITest — flow]
    UNIT --> SNAP
    SNAP --> UI
```

Snapshot **между** unit и UI: дороже unit, дешевле полного E2E по смыслу, но хрупче при смене пикселей.

---

</details>

## Сторонние библиотеки

_English summary — expand «По-русски» for full text (Сторонние библиотеки)._

<details class="lang-ru">
<summary>По-русски</summary>

Apple не поставляет snapshot testing в SDK. Команды выбирают OSS (например snapshot-библиотеки для UIView/SwiftUI) и **фиксируют политику** в README команды: что снимаем, где лежат эталоны, кто апрувит diff.

Не дублировать обзор библиотек здесь — меняется часто; важна **дисциплина**, не название пакета.

---

</details>

## Вопросы–ответы (собес)

_English summary — expand «По-русски» for full text (Вопросы–ответы (собес))._

<details class="lang-ru">
<summary>По-русски</summary>

**Q. Snapshot vs UI test?**  
**A.** Snapshot — пиксель/лейаут компонента; UI test — тапы, навигация, accessibility flow.

**Q. Почему snapshot флейкают?**  
**A.** Разный OS, шрифты, anti-aliasing, анимация не доиграла — фиксируй device, отключай анимации в тестовом режиме.

**Q. Когда без snapshot?**  
**A.** Часто меняющийся маркетинговый UI; достаточно unit на state.

---

</details>

## Связанное

_English summary — expand «По-русски» for full text (Связанное)._

<details class="lang-ru">
<summary>По-русски</summary>

- [XCUITest-Essentials-RU](XCUITest-Essentials.md)
- [Testing-Fundamentals-RU](Testing-Fundamentals.md) — пирамида
- [Testing README — Focus vs Defer](../README.md)

---

**Версия:** 1.0 · **Язык:** RU

</details>

