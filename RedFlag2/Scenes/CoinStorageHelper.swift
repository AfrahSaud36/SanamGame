import Foundation

class CoinStorageHelper {
    
    static let shared = CoinStorageHelper()
    
    private let coinKey = "coinCount"
    
    /// حفظ عدد الكوينز في `UserDefaults` و `iCloud`
    func saveCoinCount(_ count: Int) {
        UserDefaults.standard.set(count, forKey: coinKey)
        NSUbiquitousKeyValueStore.default.set(count, forKey: coinKey)
        NSUbiquitousKeyValueStore.default.synchronize()
    }
    
    /// استرجاع عدد الكوينز عند تشغيل اللعبة
    func getCoinCount() -> Int {
        if let savedCount = NSUbiquitousKeyValueStore.default.object(forKey: coinKey) as? Int {
            return savedCount
        }
        return UserDefaults.standard.integer(forKey: coinKey)
    }
}
