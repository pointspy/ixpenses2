//
//  BigTextFieldTableViewCell.swift
//  iXpenses2
//
//  Created by Pavel Lyskov on 22.03.2021.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa


final class BigTextFieldTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet weak var textField: UITextField!
    
    public private(set) var disposeBag = DisposeBag()
    
    public var colorRelay: BehaviorRelay<UIColor> = .init(value: .systemBlue)
    public var textRelay: BehaviorRelay<String?> = .init(value: nil)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.layer.borderColor = UIColor.clear.cgColor
        
        
        
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.layer.cornerCurve = .continuous
        
        colorRelay.bind(to: textField.rx.textColor)
            .disposed(by: disposeBag)
        
//        textRelay.bind(to: textField.rx.text)
//            .disposed(by: disposeBag)
        
        textField.rx.controlEvent(.editingDidBegin)
            .asDriver()
            .withUnretained(self)
            .drive(onNext: {(owner, _) in
                owner.textField.backgroundColor = UIColor(named: "textFieldBackgroundHighlighted")
                
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        textField.rx.controlEvent(.editingDidEnd)
            .asDriver()
            .withUnretained(self)
            .drive(onNext: {(owner, _) in
                owner.textField.backgroundColor = UIColor(named: "textFieldBackground")
                
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setup(with projectItem: ProjectItem) {
        
        self.colorRelay.accept(projectItem.iconColor)
        self.textRelay.accept(projectItem.name)
        
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
        colorRelay = .init(value: .systemBlue)
//        textRelay = .init(value: nil)
        super.prepareForReuse()
    }
    
}
