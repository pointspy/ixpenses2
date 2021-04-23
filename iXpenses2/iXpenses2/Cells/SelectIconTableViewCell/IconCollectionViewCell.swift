//
//  ColorCollectionViewCell.swift
//  iXpenses2
//
//  Created by Pavel Lyskov on 22.03.2021.
//

import Reusable
import UIKit

final class IconCollectionViewCell: UICollectionViewCell, NibReusable {
    var iconItem = IconItem(iconName: "star.fill")
    
    @IBOutlet weak var iconView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor(named: "checkImageColor")!.cgColor
        
        self.iconView.layer.masksToBounds = true
        self.layer.masksToBounds = true
    }
    

    
    func setIconItem(_ item: IconItem) {
        self.iconItem = item
        let w = self.bounds.height - 12
        let backImage = UIImage.size(width: w, height: w)
            .color(UIColor(named: "IconsBackColor")!)
            .corner(radius: (self.bounds.height - 12) / 2.0)
        .image
        
        let regConfig = UIImage.SymbolConfiguration(textStyle: .title3)
        
        let iconImage = UIImage(systemName: item.iconName, withConfiguration: regConfig)?.with(color: UIColor(named: "IconsTextColor")!)
        let newImage = backImage + iconImage!
        
        self.iconView.image = newImage
    }
    
    public func setCellChecked(_ value: Bool) {
        self.layer.borderWidth = value ? 2.5 : 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.bounds.height / 2
        self.iconView.layer.cornerRadius = (self.bounds.height - 12) / 2
    }
    
}
