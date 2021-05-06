import UIKit
import BFKit.Swift
import CryptoSwift
import CoreLocation

fileprivate let kUDIDConfigKey = "kUDIDConfigKey".md5()
fileprivate let kUserConfigKey = "kUserConfigKey".md5()
fileprivate let kLastEmailKey = "kLastEmailKey".md5()
fileprivate let kLoginUserInfoKey = "kLoginUserInfoKey".md5()
fileprivate let kLoginApiTokenKey = "kLoginApiTokenKey".md5()
fileprivate let kLoginUserPhotosKey = "kLoginUserPhotosKey".md5()
public class ZSettingKit: NSObject {
    
    /// udid
    public var udid: String {
        var val = self.getUserConfig(key: kUDIDConfigKey) as? String
        if val == nil || val?.count == 0 {
            val = UIDevice.current.identifierForVendor?.uuidString ?? kRandomId
            self.setUserConfig(key: kUDIDConfigKey, value: val)
        }
        return val ?? kRandomId
    }
    /// TOKEN
    public var token: String {
        if self.apitoken.count == 0 {
            let dic = self.getLoginUser(key: kLoginApiTokenKey)
            self.apitoken = (dic?["token"] as? String) ?? ""
        }
        return self.apitoken
    }
    /// 用户ID
    public var userId: String {
        if self.ismainapp {
            return self.modelUser?.userid ?? ""
        }
        return self.modelUserLogin?.userid ?? ""
    }
    /// 用户余额
    public var balance: Double  {
        if self.ismainapp {
            return self.modelUser?.balance ?? 0
        }
        return self.modelUserLogin?.balance ?? 0
    }
    /// 用户角色
    public var role: zUserRole  {
        if self.ismainapp {
            return self.modelUser?.role ?? .user
        }
        return self.modelUserLogin?.role ?? .user
    }
    /// 用户对象
    public var user: ZModelUserInfo?  {
        return self.modelUser
    }
    /// 用户对象
    public var userLogin: ZModelUserLogin?  {
        return self.modelUserLogin
    }
    /// 用户头像
    public var photos: [String]? {
        return self.getLoginUser(key: kLoginUserPhotosKey)?["photos"] as? [String]
    }
    /// 是否已经登录
    public var isLogin: Bool {
        return (self.token.count > 0)
    }
    public static let shared = ZSettingKit()
    private var modelUser: ZModelUserInfo?
    private var modelUserLogin: ZModelUserLogin?
    private var apitoken: String = ""
    private var ismainapp: Bool = true
    private var userphotos: [String]?
    
    public final func reloadUser(_ isapp: Bool = true) {
        self.ismainapp = isapp
        if let dic = self.getLoginUser() {
            if self.ismainapp {
                self.modelUser = ZModelUserInfo.deserialize(from: dic)
                self.modelUser?.rawData = dic
                BFLog.debug("reload user: \(dic ?? [:])")
            } else {
                self.modelUserLogin = ZModelUserLogin.deserialize(from: dic)
                self.modelUserLogin?.rawData = dic
                BFLog.debug("reload user: \(dic ?? [:])")
            }
        }
    }
    public final func updatePhotos(array: [String]) {
        if array.count > 0 {
            var dic = [String: Any]()
            dic["photos"] = array
            dic["time"] = Date().timeIntervalSince1970
            self.setLoginUser(dic: dic, key: kLoginUserPhotosKey)
        } else {
            UserDefaults.standard.removeObject(forKey: kLoginUserPhotosKey)
        }
    }
    public final func updateToken(token: String) {
        if token.count > 0 {
            var dic = [String: Any]()
            dic["token"] = token
            dic["time"] = Date().timeIntervalSince1970
            self.setLoginUser(dic: dic, key: kLoginApiTokenKey)
        } else {
            UserDefaults.standard.removeObject(forKey: kLoginApiTokenKey)
        }
    }
    public final func updateUser(dic: [String: Any]) {
        if self.ismainapp {
            self.modelUser = ZModelUserInfo.deserialize(from: dic)
            self.modelUser?.rawData = dic
            self.setLoginUser(dic: dic, key: kLoginUserInfoKey)
            if let email = self.modelUser?.email, email.count > 0 {
                let _ = SSKeychain.setPassword(email, forService: kLastEmailKey, account: kLastEmailKey)
            }
        } else {
            self.modelUserLogin = ZModelUserLogin.deserialize(from: dic)
            self.modelUserLogin?.rawData = dic
            self.setLoginUser(dic: dic, key: kLoginUserInfoKey)
            if let email = self.modelUserLogin?.email, email.count > 0 {
                let _ = SSKeychain.setPassword(email, forService: kLastEmailKey, account: kLastEmailKey)
            }
        }
        BFLog.debug("update user: \(dic ?? [:])")
    }
    public final func logout() {
        self.modelUser = nil
        self.modelUserLogin = nil
        self.apitoken = ""
        UserDefaults.standard.removeObject(forKey: kLoginApiTokenKey)
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
        if let str = SSKeychain.password(forService: kUserConfigKey, account: kUserConfigKey),
           let data = str.data(using: String.Encoding.utf8),
           let old = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] {
            old.keys.forEach { (k) in dic[k] = old[k] }
        }
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
extension ZSettingKit {
    
    @discardableResult
    fileprivate func setLoginUser(dic: [String: Any]?, key: String = kLoginUserInfoKey) -> Bool {
        guard let value = dic else {
            return false
        }
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        let defaults = UserDefaults.standard
        defaults.set(data, forKey: key)
        return defaults.synchronize()
    }
    fileprivate func getLoginUser(key: String = kLoginUserInfoKey) -> [String: Any]? {
        guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
            return nil
        }
        guard let value =  NSKeyedUnarchiver.unarchiveObject(with: data) as? [String: Any] else {
            return nil
        }
        return value
    }
}
