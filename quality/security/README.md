# Security

## Apple docs

- [Keychain Services](https://developer.apple.com/documentation/security/keychain-services) — secure storage for secrets and credentials.
- [TN3137: On Mac keychain APIs and implementations](https://developer.apple.com/documentation/technotes/tn3137-on-mac-keychain-apis-and-implementations) — keychain behavior notes.
- [App Transport Security](https://developer.apple.com/documentation/bundleresources/information-property-list/nsapptransportsecurity) — ATS defaults and exceptions.
- [Preventing Insecure Network Connections](https://developer.apple.com/documentation/security/preventing-insecure-network-connections) — HTTPS requirements.
- [Privacy manifest files](https://developer.apple.com/documentation/bundleresources/privacy-manifest-files) — required reasons APIs, tracking domains.
- [Adding a privacy manifest to your app or third-party SDK](https://developer.apple.com/documentation/xcode/adding-a-privacy-manifest-to-your-app-or-third-party-sdk)
- [Entitlements](https://developer.apple.com/documentation/bundleresources/entitlements) — capabilities tied to provisioning.

## In 30 seconds

iOS security layers: **Keychain** for tokens and keys (not UserDefaults), **ATS** enforcing HTTPS by default, optional **certificate pinning** for high-threat apps, **privacy manifests** declaring sensitive API use, and **entitlements** gating capabilities (Keychain access groups, associated domains, push). **Jailbreak detection** is heuristic—useful for risk scoring, not as sole protection; assume secrets in the client can be extracted. Design: minimize stored secrets, short-lived tokens, server-side authorization, and no sensitive data in logs.

## 🎯 Focus vs Defer

### Focus

- **Keychain:** `SecItemAdd`/`SecItemCopyMatching`, access groups, `kSecAttrAccessible` choices (after first unlock vs when unlocked).
- **ATS:** default TLS; when `NSExceptionDomains` is acceptable vs fix server; no global `NSAllowsArbitraryLoads` in production.
- **Certificate pinning:** trust only known SPKI/public key; rotation plan; URLSession delegate challenge handling.
- **Privacy manifests:** `NSPrivacyAccessedAPITypes`, required reason codes, third-party SDK aggregation at archive.
- **App Transport / network:** TLS 1.2+, forward secrecy; validate redirects.

### Defer

- Custom crypto primitives—use CryptoKit and platform APIs.
- Aggressive anti-tampering that breaks TestFlight debugging without product requirement.
- Jailbreak block as hard kill switch unless legal/compliance mandates it.
- Pinning every endpoint before threat model says MITM is in scope.

## Key concepts

| Term | Meaning |
|------|---------|
| **Keychain** | Encrypted store; survives reinstall depending on accessibility; share via access group. |
| **ATS** | Info.plist policy; blocks cleartext HTTP unless narrow exceptions. |
| **Certificate pinning** | App trusts only specific cert/public key, not full system CA set. |
| **Privacy manifest** | Declares data collection and “required reason” API usage for App Store. |
| **Entitlement** | Signed capability (iCloud, push, associated domains)—must match provisioning profile. |
| **Jailbreak detection** | File path / sandbox / dyld checks—bypassable; treat as signal. |
| **Data Protection** | File/key accessibility tied to device lock state (`NSFileProtectionComplete`). |
| **Secure Enclave** | Hardware-backed keys via CryptoKit / Secure Enclave APIs for local crypto. |

**Storage decision tree**

```text
Secret token / key     → Keychain (appropriate accessibility)
User preference        → UserDefaults / SwiftData (non-secret)
PII cache              → encrypted or avoid; never log
```

**Pinning caveats**

- Must plan cert rotation (backup pins, update window).
- Breaks corporate SSL inspection unless excluded by design.

## 🏋️ Exercises

1. **Keychain wrapper:** Save/read/delete auth token with `kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly`. **Expected:** no token in UserDefaults; survives relaunch.
2. **ATS audit:** List all `NSAppTransportSecurity` keys in project; justify each exception or remove. **Expected:** no blanket arbitrary loads.
3. **Pinning spike:** URLSession delegate `didReceive challenge`—compare server cert to embedded pin (test env only). **Expected:** invalid proxy cert fails handshake.
4. **Privacy manifest:** Add entry for `UserDefaults` API if using required-reason APIs; validate with Xcode privacy report. **Expected:** archive report shows declared reasons.
5. **Threat sketch:** Document what attacker with jailbroken device can extract; move critical auth server-side. **Expected:** realistic client trust model.

## WWDC & resources

- [Secure your app with App Transport Security (WWDC16)](https://developer.apple.com/videos/play/wwdc2016/706/)
- [Get started with privacy manifests (WWDC23)](https://developer.apple.com/videos/play/wwdc2023/10060/)
- [What’s new in privacy (WWDC24)](https://developer.apple.com/videos/play/wwdc2024/10123/)

## Artifacts

- Notes: `notes/`
- Exercises: `exercises/`
- Assets: `assets/`
- Playgrounds: `playgrounds/`

---

## Interview Q&A (Knowledge cards)

### Q1
- **Question (RU):** Где хранить access token — UserDefaults или Keychain?
- **Question (EN):** Store access tokens in UserDefaults or Keychain?
- **Answer (RU):** **Keychain** для секретов и refresh/access tokens: шифрование, контроль доступности (`kSecAttrAccessible*`), опционально access group для extensions. UserDefaults — plist, бэкапится, читается на compromised device проще. Дополнительно: короткий TTL, refresh на сервере, не логировать token.
- **Answer (EN):** Keychain for secrets with appropriate accessibility; UserDefaults is not confidential. Pair with short-lived tokens and no logging.

### Q2
- **Question (RU):** Что такое ATS и когда нужны exceptions?
- **Question (EN):** What is ATS and when are exceptions justified?
- **Answer (RU):** **App Transport Security** требует безопасный TLS по умолчанию. Exceptions (`NSExceptionDomains`) — только для legacy/dev endpoints с планом миграции. `NSAllowsArbitraryLoads = true` в проде — red flag. Лучше поднять сервер до HTTPS, чем ослаблять ATS глобально.
- **Answer (EN):** ATS enforces secure connections by default; domain-specific exceptions should be temporary and documented—fix the server rather than disabling ATS globally.

### Q3
- **Question (RU):** Certificate pinning — плюсы и минусы?
- **Question (EN):** Pros and cons of certificate pinning?
- **Answer (RU):** **Плюс:** защита от MITM с подменой CA (корп. proxy, malicious cert). **Минусы:** операционная боль при ротации cert, риск outage, не заменяет server auth. Нужны backup pins и мониторинг expiry. Для многих consumer apps достаточно ATS + правильный TLS на сервере.
- **Answer (EN):** Pinning mitigates MITM with rogue CAs but complicates rotation and outages; use with backup pins and a clear threat model.

### Q4
- **Question (RU):** Privacy manifest — зачем Apple это требует?
- **Question (EN):** Why does Apple require privacy manifests?
- **Answer (RU):** Декларировать **Required Reason APIs** (UserDefaults, disk space, sysboottime, etc.) и сбор данных SDK — чтобы App Store и пользователи видели агрегированную картину. При archive Xcode merges manifests; missing reasons → rejection. Это не замена Privacy Nutrition Label, а технический аудит API use.
- **Answer (EN):** Manifests document sensitive API usage and SDK data practices; Xcode merges them at archive—missing required reasons cause rejection.
