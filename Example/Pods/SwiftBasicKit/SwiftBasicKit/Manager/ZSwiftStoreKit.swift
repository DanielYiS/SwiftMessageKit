
import UIKit
import StoreKit
import SwiftyStoreKit

public struct ZSwiftStoreKit {
    
    public var productIds: [String] = [String]()
    public var products: [SKProduct] = [SKProduct]()
    public static var shared = ZSwiftStoreKit()
    
    public static func configProductIds(key: String, ids: [Int]) {
        ids.forEach { (id) in
            ZSwiftStoreKit.shared.productIds.append(key + id.str)
        }
    }
    public static func completeTransactions(completion: (() -> Void)? = nil) {
        SwiftyStoreKit.completeTransactions(atomically: true, completion: { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    let downloads = purchase.transaction.downloads
                    if !downloads.isEmpty {
                        SwiftyStoreKit.start(downloads)
                    } else if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                case .failed, .purchasing, .deferred: break
                @unknown default: break
                }
            }
            completion?()
        })
        SwiftyStoreKit.updatedDownloadsHandler = { downloads in
            let contentURLs = downloads.compactMap { $0.contentURL }
            if contentURLs.count == downloads.count {
                SwiftyStoreKit.finishTransaction(downloads[0].transaction)
            }
        }
    }
    public static func retrieveProducts(completion: (() -> Void)?) {
        var sets = Set<String>()
        ZSwiftStoreKit.shared.productIds.forEach({ pid in sets.insert(pid) })
        SwiftyStoreKit.retrieveProductsInfo(sets, completion: { result in
            result.retrievedProducts.forEach { (product) in
                ZSwiftStoreKit.shared.products.append(product)
            }
            completion?()
        })
    }
    public static func purchaseProduct(productId: String, diamond: Double, completion: ((_ error: Error?) -> Void)?) {
        SwiftyStoreKit.purchaseProduct(productId, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                if let model = ZSettingKit.shared.user  {
                    model.balance += diamond
                    if let dic = model.toDictionary() {
                        ZSettingKit.shared.updateUser(dic)
                    }
                    ZSQLiteKit.setModel(model: model)
                }
                completion?(nil)
            case .error(let error):
                completion?(error)
            }
        }
    }
}
