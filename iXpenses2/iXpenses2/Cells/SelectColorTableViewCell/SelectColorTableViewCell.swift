//
//  SelectColorTableViewCell.swift
//  iXpenses2
//
//  Created by Pavel Lyskov on 22.03.2021.
//

import Reusable
import UIKit
import RxCocoa
import RxSwift

final class SelectColorTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet weak var selectColorView: SelectColorView!
    
    
    public private(set) var disposeBag = DisposeBag()
    
    public private(set) var colorItemRelay: BehaviorRelay<ColorItem> = .init(value: ColorItem.init(colorName: "blue"))

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         
        
        
//        self.heightHC.constant = SelectColorView.itemSize.height * 2 + 3 * 16
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func setup(with projectItem: ProjectItem) {
        
        self.selectColorView.setup(with: projectItem)
        self.selectColorView.selectedColorItem.asDriver()
            .drive(self.colorItemRelay)
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
        self.selectColorView.collectionView.delegate = nil
        self.selectColorView.collectionView.dataSource = nil
        self.selectColorView.disposeBag = DisposeBag()
        self.selectColorView.uncheckOld()
        self.selectColorView.projectItem = nil
        
        super.prepareForReuse()
    }
}
