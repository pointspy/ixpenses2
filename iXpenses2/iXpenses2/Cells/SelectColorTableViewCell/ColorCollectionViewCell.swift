//
//  ColorCollectionViewCell.swift
//  iXpenses2
//
//  Created by Pavel Lyskov on 22.03.2021.
//

import Reusable
import UIKit

final class ColorCollectionViewCell: UICollectionViewCell, NibReusable {
    var colorItem = ColorItem(colorName: "blue")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor(named: "checkImageColor")!.cgColor
        
        self.colorView.layer.masksToBounds = true
        self.layer.masksToBounds = true
    }
    
    @IBOutlet weak var colorView: UIView!
    
    func setColorItem(_ item: ColorItem) {
        self.colorItem = item
        self.colorView.backgroundColor = ProjectItem.Colors(rawValue: item.colorName)?.color
    }
    
    public func setCellChecked(_ value: Bool) {
        self.layer.borderWidth = value ? 2.5 : 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.bounds.height / 2
        self.colorView.layer.cornerRadius = (self.bounds.height - 12) / 2
    }
    
}
