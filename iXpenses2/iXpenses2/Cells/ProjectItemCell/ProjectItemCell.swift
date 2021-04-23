//
//  ProjectItemCell.swift
//  iXpenses2
//
//  Created by Pavel Lyskov on 21.03.2021.
//

import Reusable
import UIKit

final class ProjectItemCell: UITableViewCell, NibReusable {
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var balanceLabel: UILabel!
    
    var projectItem: ProjectItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(with item: ProjectItem) {
        
        self.projectItem = item
        
        let plusSum = item.plusSum
        let minusSum = item.minusSum
        
        self.titleLabel.text = item.name
        self.balanceLabel.attributedText = "􀃝 \(plusSum.asPretty)₽   􀃟 \(minusSum.asPretty)₽\n".at.attributed {
            $0.foreground(color: UIColor.secondaryLabel).font(UIFont(name: "SFProRounded-Regular", size: 15)!).lineSpacing(4)
        } + "Баланс: ".at.attributed {
            $0.foreground(color: UIColor.secondaryLabel).font(.systemFont(ofSize: 15)).lineSpacing(4)
        } + "\((plusSum - minusSum).asPretty)₽".at.attributed {
            $0.foreground(color: UIColor.label).font(UIFont(name: "SFProRounded-Semibold", size: 15)!).lineSpacing(4)
        }
        
        let imageWidth: CGFloat = 36
        
        let backImage = UIImage.size(width: imageWidth, height: imageWidth)
            .color(item.iconColor)
        .corner(radius: imageWidth / 2)
        .image
        
        let largeConfig = UIImage.SymbolConfiguration(textStyle: .caption1)
        let iconImage = UIImage(systemName: item.iconName, withConfiguration: largeConfig)?.with(color: .white)
        let newImage = backImage + iconImage!
        self.iconView.image = newImage
        self.iconView.contentMode = .scaleAspectFit
        
        
    }
    
    override func prepareForReuse() {
        self.projectItem = nil
        super.prepareForReuse()
    }
}
