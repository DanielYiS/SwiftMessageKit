import UIKit
import BFKit.Swift
import CryptoSwift
import CoreLocation

public class ZSettingKit: NSObject {
    
    /// TOKEN
    public var token: String {
        return self.modelUser?.token ?? ""
    }
    /// 用户ID
    public var userId: String {
        return self.modelUser?.userid ?? ""
    }
    /// 用户余额
    public var balance: Double  {
        return self.modelUser?.balance ?? 0
    }
    /// 用户角色
    public var role: zUserRole  {
        return self.modelUser?.role ?? .user
    }
    /// 用户对象
    public var user: ZModelUserBase?  {
        return self.modelUser
    }
    /// 是否已经登录
    public var isLogin: Bool {
        return (self.token.count > 0)
    }
    public static let shared = ZSettingKit()
    private var modelUser: ZModelUserBase?
    
    public final func reloadUser() {
        if let dic = self.getLoginUser() {
            self.modelUser = ZModelUserBase.deserialize(from: dic)
            self.modelUser?.rawData = dic
        } else {
            self.modelUser = nil
        }
        BFLog.debug("reload user: \(self.modelUser?.toJSONString() ?? "")")
    }
    public final func login(_ dic: [String: Any]) {
        self.modelUser = ZModelUserBase.deserialize(from: dic)
        self.modelUser?.rawData = dic
        self.updateUser()
        if let email = self.modelUser?.email {
            let _ = SSKeychain.setPassword(email, forService: kLastEmailKey, account: kLastEmailKey)
        }
        BFLog.debug("login user: \(self.modelUser?.toJSONString() ?? "")")
    }
    public final func updateUser() {
        self.setLoginUser(self.modelUser?.rawData)
        if let email = self.modelUser?.email {
            let _ = SSKeychain.setPassword(email, forService: kLastEmailKey, account: kLastEmailKey)
        }
        BFLog.debug("update user: \(self.modelUser?.toJSONString() ?? "")")
    }
    public final func logout() {
        self.modelUser = nil
        UserDefaults.standard.removeObject(forKey: kLoginUserInfoKey)
    }
    public final func getLastEmail() -> String {
        guard let value = SSKeychain.password(forService: kLastEmailKey, account: kLastEmailKey) else {
            return ""
        }
        return value
    }
    public final func setUserConfig(key: String, value: Any) {
        var dic = [String: Any]()
        dic[key] = value
        do {
            let data = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)
            let str = String.init(data: data, encoding: String.Encoding.utf8)
            let _ = SSKeychain.setPassword(str, forService: kUserConfigKey, account: kUserConfigKey)
        } catch {
            BFLog.debug("set config error: \(error.localizedDescription)")
        }
    }
    public final func getUserConfig(key: String) -> Any? {
        guard let str = SSKeychain.password(forService: kUserConfigKey, account: kUserConfigKey) else {
            return nil
        }
        guard let data = str.data(using: String.Encoding.utf8) else {
            return nil
        }
        do {
            guard let dic = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] else {
                return nil
            }
            return dic[key]
        } catch {
            BFLog.debug("set config error: \(error.localizedDescription)")
        }
        return nil
    }
}
fileprivate let kUserConfigKey = "UserConfigKey".md5()
fileprivate let kLastEmailKey = "LastEmailKey".md5()
fileprivate let kLoginUserInfoKey = "LoginUserInfoKey".md5()
extension ZSettingKit {
    
    @discardableResult
    fileprivate func setLoginUser(_ dic: [String: Any]?) -> Bool {
        guard let value = dic else {
            return false
        }
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        let defaults = UserDefaults.standard
        defaults.set(data, forKey: kLoginUserInfoKey)
        return defaults.synchronize()
    }
    fileprivate func getLoginUser() -> [String: Any]? {
        guard let data = UserDefaults.standard.object(forKey: kLoginUserInfoKey) as? Data else {
            return nil
        }
        guard let value =  NSKeyedUnarchiver.unarchiveObject(with: data) as? [String: Any] else {
            return nil
        }
        return value
    }
}
