
import UIKit
import BFKit
import CryptoSwift

/// 密钥
fileprivate let key = "app"+".live"+".content".md5()

public class ZCryptoContentManager: NSObject {
    
    /// 加密
    public static func encrypt(_ str: String) -> String {
        do {
            //使用AES-128-ECB加密模式
            let aes = try AES(key: Padding.zeroPadding.add(to: key.bytes, blockSize: AES.blockSize), blockMode: ECB())
            
            //开始加密
            let encrypted = try aes.encrypt(str.bytes)
            //将加密结果转成base64形式
            guard let encryptedBase64 = encrypted.toBase64() else {
                return str
            }
            return encryptedBase64
        } catch let error {
            BFLog.debug("error: \(error.localizedDescription)")
        }
        return str
    }
    /// 解密
    public static func decrypt(_ encryptedBase64: String) -> String {
        do {
            //使用AES-128-ECB加密模式
            let aes = try AES(key: Padding.zeroPadding.add(to: key.bytes, blockSize: AES.blockSize), blockMode: ECB())
            
            //开始解密（从加密后的base64字符串解密）
            let decrypted = try encryptedBase64.decryptBase64ToString(cipher: aes)
            return decrypted
        } catch let error {
            BFLog.debug("error: \(error.localizedDescription)")
        }
        return encryptedBase64
    }
}
