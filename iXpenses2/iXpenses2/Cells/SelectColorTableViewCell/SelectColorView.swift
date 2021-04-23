//
//  SelectColorView.swift
//  iXpenses2
//
//  Created by Pavel Lyskov on 22.03.2021.
//

import Reusable
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

final class SelectColorView: UIView, NibOwnerLoadable {
    
    struct Configure {
        static let horizontalPadding: CGFloat = 12
        static let cellMarginV: CGFloat = 16
        static let cellMarginH: CGFloat = 0
        static var countInRow: CGFloat = 6
        static var spacing: CGFloat = 2
        
    }
    
    public var disposeBag = DisposeBag()
    
    var oldCheckedCell: ColorCollectionViewCell?
    var projectItem: ProjectItem?
    
    static var itemSize: CGSize {
        let widthNew: CGFloat = floor((UIScreen.main.bounds.width - 2.0 * (Configure.horizontalPadding + Configure.cellMarginH) - Configure.spacing * (CGFloat(ProjectItem.Colors.allCases.count - 1))) / Configure.countInRow) + 1
        
        return CGSize(width: widthNew, height: widthNew)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
//        layout.estimatedItemSize = SelectColorView.itemSize
        layout.itemSize = SelectColorView.itemSize
        layout.minimumInteritemSpacing = Configure.spacing
        layout.minimumLineSpacing = Configure.spacing
        
        return layout
    }()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.bounds.width, height: Configure.cellMarginV * 2 + SelectColorView.itemSize.height * 2 + Configure.spacing) 
    }
    
    private let itemsRelay: BehaviorRelay<[SectionOfColors]> = .init(value: SectionOfColors.defaultValues)
    public let selectedColorItem: BehaviorRelay<ColorItem> = .init(value: ColorItem(colorName: "blue"))
    
    lazy var animConfig: AnimationConfiguration = {
        let config = AnimationConfiguration(insertAnimation: .automatic, reloadAnimation: .automatic, deleteAnimation: .automatic)
        return config
    }()
    
    private lazy var dataSource: RxCollectionViewSectionedAnimatedDataSource<SectionOfColors> = RxCollectionViewSectionedAnimatedDataSource(animationConfiguration: animConfig) { [weak self] (_, collectionView, indexPath, item) -> UICollectionViewCell in
        guard let self = self else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ColorCollectionViewCell.self)
        
        if let projectitem = self.projectItem {
            if item.colorName == projectitem.colorName {
                cell.setCellChecked(true)
                self.oldCheckedCell = cell
                self.selectedColorItem.accept(ColorItem(colorName: projectitem.colorName))
                
            }
        }
        
        cell.setColorItem(item)
        
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNibContent()
         
        collectionView.contentInset = UIEdgeInsets(top: Configure.cellMarginV, left: Configure.horizontalPadding, bottom: Configure.cellMarginV, right: Configure.horizontalPadding)
        self.collectionView.setCollectionViewLayout(self.flowLayout, animated: false)
        self.collectionView.register(cellType: ColorCollectionViewCell.self)
        
        self.itemsRelay.accept(SectionOfColors.defaultValues)
    }
    
    func setup(with projectItem: ProjectItem?) {
        
        self.projectItem = projectItem
        self.collectionView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        self.itemsRelay.asObservable()
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }
}

extension SelectColorView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell else {
            return
        }
        cell.setCellChecked(true)
        self.selectedColorItem.accept(cell.colorItem)
        if let oldCell = self.oldCheckedCell {
            oldCell.setCellChecked(false)
            self.oldCheckedCell = cell
        }
    }
    
    public func uncheckOld() {
        if let oldCell = self.oldCheckedCell {
            oldCell.setCellChecked(false)
            self.oldCheckedCell = nil
        }
    }
}
