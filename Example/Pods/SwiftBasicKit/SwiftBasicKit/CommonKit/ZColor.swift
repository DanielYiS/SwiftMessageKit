
import UIKit
import BFKit

public struct ZColor {
    
    public static var shared = ZColor()
    
    /// 导航栏背景颜色
    public var NavBarTintColor: UIColor = UIColor.init(hex: "#FFFFFF")
    /// 导航栏分割线
    public var NavBarLineColor: UIColor = UIColor.init(hex: "#FFFFFF")
    /// 导航栏按钮颜色
    public var NavBarButtonColor: UIColor = UIColor.init(hex: "#000000")
    /// 导航栏文本颜色
    public var NavBarTitleColor: UIColor = UIColor.init(hex: "#000000")
    
    /// Tabbar背景颜色
    public var TabBarTintColor: UIColor = UIColor.init(hex: "#FFFFFF")
    /// Tabbar分割线
    public var TabBarLineColor: UIColor = UIColor.init(hex: "#FFFFFF")
    /// Tabbar按钮颜色 - 未选中
    public var TabBarButtonNormalColor: UIColor = UIColor.init(hex: "#D3D4ED")
    /// Tabbar按钮颜色 - 已选中
    public var TabBarButtonSelectColor: UIColor = UIColor.init(hex: "#000000")
    /// Tabbar文本颜色 - 未选中
    public var TabBarTitleNormalColor: UIColor = UIColor.init(hex: "#D3D4ED")
    /// Tabbar文本颜色 - 已选中
    public var TabBarTitleSelectColor: UIColor = UIColor.init(hex: "#000000")
    
    /// 默认背景颜色
    public var ViewBackgroundColor: UIColor = UIColor.init(hex: "#FFFFFF")
    /// view边框颜色
    public var ViewBorderColor: UIColor = UIColor.init(hex: "#CFCFCF")
    /// 标题颜色
    public var LabelTitleColor: UIColor = UIColor.init(hex: "#242424")
    /// 副标题颜色
    public var LabelDescColor: UIColor = UIColor.init(hex: "#8E8E8E")
    
    /// input 前景色
    public var InputBackgroundColor: UIColor = UIColor.init(hex: "#FFFFFF")
    /// input 边框颜色
    public var InputBorderColor: UIColor = UIColor.init(hex: "#FFFFFF")
    /// input 光标颜色
    public var InputCursorColor: UIColor = UIColor.init(hex: "#000000")
    /// input 文本颜色
    public var InputPromptColor: UIColor = UIColor.init(hex: "#CFCFCF")
    /// input 文本颜色
    public var InputTextColor: UIColor = UIColor.init(hex: "#000000")
    /// 键盘背景颜色
    public var KeyboardBackgroundColor: UIColor = UIColor.init(hex: "#EFF2F8")
    
    /// 配置导航栏颜色
    public func configNavColor(bg: String = "#FFFFFF", line: String = "#FFFFFF", btn: String = "#000000", title: String = "#000000") {
        ZColor.shared.NavBarTintColor = UIColor.init(hex: bg)
        ZColor.shared.NavBarLineColor = UIColor.init(hex: line)
        ZColor.shared.NavBarButtonColor = UIColor.init(hex: btn)
        ZColor.shared.NavBarTitleColor = UIColor.init(hex: title)
    }
    /// 配置Tabbar颜色
    public func configTabColor(bg: String = "#FFFFFF", line: String = "#FFFFFF", btnNormal: String = "#D3D4ED", btnSelect: String = "#000000", titleNormal: String = "#D3D4ED", titleSelect: String = "#000000") {
        ZColor.shared.TabBarTintColor = UIColor.init(hex: bg)
        ZColor.shared.TabBarLineColor = UIColor.init(hex: line)
        ZColor.shared.TabBarButtonNormalColor = UIColor.init(hex: btnNormal)
        ZColor.shared.TabBarButtonSelectColor = UIColor.init(hex: btnSelect)
        ZColor.shared.TabBarTitleNormalColor = UIColor.init(hex: titleNormal)
        ZColor.shared.TabBarTitleSelectColor = UIColor.init(hex: titleSelect)
    }
    /// 配置View颜色
    public func configViewColor(bg: String = "#FFFFFF", border: String = "#CFCFCF", title: String = "#242424", desc: String = "#8E8E8E") {
        ZColor.shared.ViewBackgroundColor = UIColor.init(hex: bg)
        ZColor.shared.ViewBorderColor = UIColor.init(hex: border)
        ZColor.shared.LabelTitleColor = UIColor.init(hex: title)
        ZColor.shared.LabelDescColor = UIColor.init(hex: desc)
    }
    /// 配置输入框颜色
    public func configInputColor(bg: String = "#FFFFFF", border: String = "#FFFFFF", cursor: String = "#000000", text: String = "#000000", prompt: String = "#CFCFCF", keybg: String = "#D6D6D6") {
        ZColor.shared.InputBackgroundColor = UIColor.init(hex: bg)
        ZColor.shared.InputBorderColor = UIColor.init(hex: border)
        ZColor.shared.InputCursorColor = UIColor.init(hex: cursor)
        ZColor.shared.InputTextColor = UIColor.init(hex: text)
        ZColor.shared.InputPromptColor = UIColor.init(hex: prompt)
        ZColor.shared.KeyboardBackgroundColor = UIColor.init(hex: keybg)
    }
}
