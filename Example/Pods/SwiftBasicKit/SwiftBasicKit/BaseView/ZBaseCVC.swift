
import UIKit

public class ZBaseCVC: UICollectionViewCell {
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.backgroundView?.backgroundColor = .clear
        self.contentView.isUserInteractionEnabled = true
    }
}
