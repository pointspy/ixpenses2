//
//  
//  SelectIconTableViewCell.swift
//  iXpenses2
//
//  Created by Pavel Lyskov on 23.03.2021.
//
//
import Reusable
import RxCocoa
import RxSwift
import UIKit


final class SelectIconTableViewCell: UITableViewCell, NibReusable  {
    @IBOutlet weak var selectIconView: SelectIconView!
    
    // Bag
    public private(set) var disposeBag = DisposeBag()
    
    
    public private(set) var iconItemRelay: BehaviorRelay<IconItem> = .init(value: IconItem(iconName: "star.fill"))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setup(with projectItem: ProjectItem) {
        self.selectIconView.setup(with: projectItem)
        self.selectIconView.selectedIconItem.asDriver()
            .drive(self.iconItemRelay)
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
        self.selectIconView.collectionView.delegate = nil
        self.selectIconView.collectionView.dataSource = nil
        self.selectIconView.disposeBag = DisposeBag()
        
        self.selectIconView.uncheckOld()
        self.selectIconView.projectItem = nil
        super.prepareForReuse()
    }
    
    
}
