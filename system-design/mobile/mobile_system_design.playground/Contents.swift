import Foundation

/*
 Q&A cards — Q40 complex decision (STAR narrative skeleton)

 STAR — Situation, Task, Action, Result: говорить контекст → цель → что сделал → измеримый эффект.
 Mobile system design — всегда фиксируй источник истины offline/online, конфликты версий,
 наблюдаемость (логи/метрики), и компромисс latency vs consistency.

 Example outline (replace with your production story):
 - Situation: рост ошибок синка при нестабильной сети.
 - Task: сделать офлайн-first без дубликатов записей.
 - Action: локальная очередь + idempotency keys + явная merge policy.
 - Result: −X% клиентских ошибок, стабильный UX без двойных созданий.
*/

print("STAR + trade-offs template loaded — plug in your real metrics.")
