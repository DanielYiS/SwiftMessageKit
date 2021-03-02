
import UIKit

public class ZBaseTVC: UITableViewCell {
    
    public var cellWidth: CGFloat = kScreenWidth
    public var cellHeight: CGFloat = 45.scale
    
    public override var backgroundColor: UIColor? {
        didSet {
            self.contentView.backgroundColor = self.backgroundColor
            self.backgroundView?.backgroundColor = self.backgroundColor
        }
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = UITableViewCell.AccessoryType.none
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        self.isMultipleTouchEnabled = true
        self.backgroundColor = .clear
    }
    
}
