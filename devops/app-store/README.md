# App Store & TestFlight

## Apple docs

- [App Store Connect](https://developer.apple.com/app-store-connect/) — apps, builds, metadata, users.
- [TestFlight](https://developer.apple.com/testflight/) — beta distribution, internal/external testers.
- [Distributing your app for beta testing and releases](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/) — submission rules.
- [Phased release for App Store versions](https://developer.apple.com/help/app-store-connect/update-your-app/release-a-version-with-phased-release/) — gradual rollout.
- [Entitlements](https://developer.apple.com/documentation/bundleresources/entitlements) — capabilities in signed bundle.
- [Capability Requests](https://developer.apple.com/help/account/reference/capability-requests/) — enabling features in portal.

## In 30 seconds

**TestFlight** distributes signed builds to internal (App Store Connect users) and external testers (beta review for first build). **App Store Connect** manages versions, screenshots, compliance, and **phased release** (7-day gradual rollout). Submission must match **Review Guidelines** (privacy, payments, UGC moderation, accurate metadata). **Entitlements** in the app signature must align with provisioning (push, associated domains, Keychain groups)—missing or extra entitlement causes upload or runtime failures.

## 🎯 Focus vs Defer

### Focus

- **TestFlight flow:** archive → upload → processing → internal test → external group + beta review.
- **App Store Connect:** version train, build selection, export compliance, age rating questionnaire.
- **Phased release:** pause/resume, when to use vs feature flags for risky features.
- **Review guidelines basics:** 4.2 minimum functionality, 5.1 privacy, 3.1 payments (IAP), accurate screenshots.
- **Entitlements:** enable capability in Xcode → portal → profile; match extensions and app.

### Defer

- Custom enterprise MDM distribution until App Store process is mastered.
- Full localization of store listing before first TestFlight external beta.
- Promotional text A/B experiments before baseline metadata is stable.
- Alternate payment APIs outside Apple rules without legal/product sign-off.

## Key concepts

| Term | Meaning |
|------|---------|
| **TestFlight internal** | Up to 100 ASC users; no beta review; immediate after processing. |
| **TestFlight external** | Up to 10,000 testers; first build needs **Beta App Review**. |
| **Build processing** | Apple re-signs/IPA; dSYM for crash symbolication in Organizer. |
| **Phased release** | Auto-release to 1%→100% over 7 days; pause if crash rate spikes. |
| **App Review** | Human/automated checks; rejection with resolution center messages. |
| **Entitlement** | Key in signed `.app` (e.g. `aps-environment`, `com.apple.developer.associated-domains`). |
| **Provisioning profile** | Links team, bundle ID, devices/capabilities to certificate. |
| **Export compliance** | Encryption declaration (`ITSAppUsesNonExemptEncryption`) for upload. |

**Release path**

```text
Feature complete
  → Archive (Release) + upload
  → TestFlight internal QA
  → External beta (optional)
  → App Store version + metadata + review
  → Phased release or 100% manual release
```

**Common rejection themes**

- Broken login / placeholder content (4.2).
- Missing privacy policy or undisclosed data use (5.1).
- Digital goods without IAP where required (3.1).
- Misleading screenshots or hidden features.

## 🏋️ Exercises

1. **Internal TF:** Upload build; add internal group; install via TestFlight app. **Expected:** processing → ready to test < typical SLA; crashes symbolicated with dSYM uploaded.
2. **Entitlement audit:** List app + extension entitlements; compare to portal capabilities. **Expected:** no orphan `aps-environment` without push setup.
3. **Phased release plan:** Document go/no-go metrics (crash-free sessions, support tickets) for day 1 vs day 7. **Expected:** runbook to pause rollout.
4. **Review checklist:** Walk Guidelines 5.1 for your app’s data collection; align Privacy Nutrition Label. **Expected:** gaps list before submit.
5. **Beta review notes:** Write external testing instructions (demo account, feature flags). **Expected:** reviewer can reach core flow in ≤3 steps.

## WWDC & resources

- [Explore App Store Connect for developers (WWDC22)](https://developer.apple.com/videos/play/wwdc2022/10001/)
- [Get started with TestFlight (App Store Connect Help)](https://developer.apple.com/help/app-store-connect/test-a-beta-version/testflight-overview/)
- [App Store submission tips (Tech Talks)](https://developer.apple.com/news/?id=testflight-and-submission)

## Artifacts

- Notes: `notes/`
- Exercises: `exercises/`
- Assets: `assets/`
- Playgrounds: `playgrounds/`

---

## Interview Q&A (Knowledge cards)

### Q1
- **Question:** How does internal TestFlight differ from external?

- **Answer:** Internal is for ASC team members without beta review; external reaches wider testers and requires beta review on the first build, with expiry and compliance requirements.

### Q2
- **Question:** What is phased release and when do you use it?

- **Answer:** Phased release gradually rolls out an App Store version over seven days with pause control—good for risky releases, complementary to in-app feature flags.

### Q3
- **Question:** How are entitlements and capabilities related?

- **Answer:** Capabilities configure entitlements and portal settings; the signed app must match profiles—misalignment breaks upload or runtime features.

### Q4
- **Question:** What are common App Review rejection reasons?

- **Answer:** Crashes, broken demos, privacy/IAP violations, and misleading metadata dominate—provide test accounts, accurate disclosures, and stable review builds.
