import Foundation
import Security

/*
 Q&A cards — Q30 (tokens in Keychain, not UserDefaults)

 Keychain Services:
 https://developer.apple.com/documentation/security/keychain_services
*/

enum KeychainStoreError: Error {
    case unexpectedStatus(OSStatus)
}

enum KeychainStore {
    static func save(password: String, account: String, service: String) throws {
        let data = Data(password.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
        ]
        SecItemDelete(query as CFDictionary)
        var attrs = query
        attrs[kSecValueData as String] = data
        let status = SecItemAdd(attrs as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainStoreError.unexpectedStatus(status)
        }
    }

    static func readPassword(account: String, service: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecItemNotFound {
            return nil
        }
        guard status == errSecSuccess, let data = item as? Data else {
            throw KeychainStoreError.unexpectedStatus(status)
        }
        return String(data: data, encoding: .utf8)
    }
}

let service = "careerStudyKeychain"
try KeychainStore.save(password: "refresh-token-sample", account: "user", service: service)
let roundTrip = try KeychainStore.readPassword(account: "user", service: service)
print("Keychain round-trip:", roundTrip ?? "nil")
