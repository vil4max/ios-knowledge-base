# Interview answer depth

## In 30 seconds

Senior, Staff, Lead, and Architect loops rarely fail on definitions. They fail when you cannot **reason under constraints**: debug in production, name trade-offs, and show how you would **prevent whole classes of problems** at team scale.

Use the same topic README in this knowledge base for **mechanisms and code**. Use external playbooks for **staged answers, leadership tracks, and full interview process**.

## Candidate → Senior → Staff+

| Tier | Interviewer listens for | Move past definitions by… |
|------|-------------------------|---------------------------|
| **Candidate** | Correct vocabulary, basic mechanism | Stopping after "what it is" |
| **Senior** | Lifetime reasoning, real debugging, intentional trade-offs | Naming cycles, tools, when `weak` vs `unowned` |
| **Staff+** | Cost in hot paths, cross-cutting design, prevention at scale | Tying to concurrency, API ownership, conventions and tooling |

**Pattern for any topic:** one sentence of mechanism → one production story or pitfall → one architectural guardrail you would add on a large team.

## Worked example: ARC

**Candidate:** Reference counting; retain/release; ARC inserts calls at compile time.

**Senior:** Trace ownership through closures, delegates, and caches; break cycles with `weak`/`unowned`; use Memory Graph and Instruments when leaks are non-obvious; choose `weak` when the referent can deallocate, `unowned` only when lifetime is provably shorter.

**Staff+:** Question retain traffic in tight loops and async boundaries; model ownership in public APIs (who holds what across `Task` hops and actors); pair code review rules with CI/leak checks so the team does not rediscover the same cycles.

Deep dive in-repo: [Memory & ARC](/swift/memory-arc/).

## Leadership tracks (what books cover, KB does not)

Tech Lead, Architect, Engineering Manager, and Project Manager loops add **scope and influence**: system boundaries, hiring bar, delivery under ambiguity, stakeholder alignment. This site stays technical; treat those tracks as external reading.

## External resources

| Resource | Role |
|----------|------|
| [Mike Salari — Senior iOS Interview Playbook](https://leanpub.com/senior-ios-playbook) | Senior / staff / principal depth; companion to *The iOS Interview Blueprint* |
| [immh — Mobile System Design (glava 1)](/system-design/mobile/) | Mobile SD interview frame in-repo |
| Topic Q-cards (RU/EN) | Per-subject mechanisms — tier your answer using the table above |

*The iOS Interview Blueprint (Elite Edition 2026)* — author edition; no stable public URL in Curated yet. See [BACKLOG](../BACKLOG.md).

## Related topics

- [Mobile App Design](/system-design/mobile/) — system design umbrella
- [Memory & ARC](/swift/memory-arc/)
- [Concurrency](/swift/concurrency/)
- [Security](/quality/security/)
- [Scaling Teams](/system-design/scaling-teams/)
