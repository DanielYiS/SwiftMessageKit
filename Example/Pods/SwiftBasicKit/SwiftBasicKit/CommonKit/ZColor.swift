
import UIKit
import BFKit

public struct ZColor {
    
    public static var shared = ZColor()
    
    /// 导航栏背景颜色
    public var NavBarTintColor: UIColor = UIColor.init(hex: "#FFFFFF")
    /// 导航栏分割线
    public var NavBarLineColor: UIColor = UIColor.init(hex: "#FFFFFF")
    /// 导航栏按钮颜色
    public var NavBarButtonColor: UIColor = UIColor.init(hex: "#5B5963")
    /// 导航栏文本颜色
    public var NavBarTitleColor: UIColor = UIColor.init(hex: "#1E1E27")
    
    /// Tabbar背景颜色
    public var TabBarTintColor: UIColor = UIColor.init(hex: "#FFFFFF")
    /// Tabbar分割线
    public var TabBarLineColor: UIColor = UIColor.init(hex: "#F4F4F4")
    /// Tabbar按钮颜色 - 未选中
    public var TabBarButtonUnSelectColor: UIColor = UIColor.init(hex: "#F3365A")
    /// Tabbar按钮颜色 - 已选中
    public var TabBarButtonSelectColor: UIColor = UIColor.init(hex: "#F3365A")
    /// Tabbar文本颜色 - 未选中
    public var TabBarTitleUnSelectColor: UIColor = UIColor.init(hex: "#F3365A")
    /// Tabbar文本颜色 - 已选中
    public var TabBarTitleSelectColor: UIColor = UIColor.init(hex: "#F3365A")
    
    /// 默认背景颜色
    public var BackgroundColor: UIColor = UIColor.init(hex: "#FFFFFF")
    /// view边框颜色
    public var ViewBorderColor: UIColor = UIColor.init(hex: "#BCBCBC")
}
