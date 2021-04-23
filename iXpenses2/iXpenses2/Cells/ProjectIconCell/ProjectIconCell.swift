//
//  ProjectIconCell.swift
//  iXpenses2
//
//  Created by Pavel Lyskov on 22.03.2021.
//

import Reusable
import RxCocoa
import RxSwift
import UIKit

final class ProjectIconCell: UITableViewCell, NibReusable {
    @IBOutlet weak var iconView: UIImageView!
    
    var iconName: String = "star.fill"
    
    public private(set) var disposeBag = DisposeBag()
    
    public private(set) var colorItemRelay: BehaviorRelay<ColorItem> = .init(value: ColorItem(colorName: "blue"))
    
    public private(set) var iconItemRelay: BehaviorRelay<IconItem> = .init(value: IconItem(iconName: "star.fill"))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        Driver.combineLatest(self.colorItemRelay.asDriver(), self.iconItemRelay.asDriver())
            .drive(onNext: { [weak self] colorItem, iconItem in
                guard let self = self else { return }
                
                self.setIcon(iconItem.iconName, color: colorItem.color)
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setIcon(_ iconName: String, color: UIColor) {
        let backImage = UIImage.size(width: 100, height: 100)
            .color(color)
            .corner(radius: 50)
            .image
        
        let largeConfig = UIImage.SymbolConfiguration(textStyle: .largeTitle, scale: .large)
        
        let iconImage = UIImage(systemName: iconName, withConfiguration: largeConfig)?.with(color: .white)
        let newImage = backImage + iconImage!
        self.iconView.image = newImage
        self.iconView.contentMode = .scaleAspectFit
        self.iconName = iconName
    }
    
    public func setup(with projectItem: ProjectItem) {
        self.setIcon(projectItem.iconName, color: projectItem.iconColor)
    }
}
