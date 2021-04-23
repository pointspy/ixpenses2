//
//
//  TransactionTableViewCell.swift
//  iXpenses2
//
//  Created by Pavel Lyskov on 25.03.2021.
//
//
import Reusable
import RxCocoa
import RxSwift
import UIKit

final class TransactionTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var transaction: TransactionItem?

    // Bag
    public private(set) var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
        super.prepareForReuse()
    }

    func setup(with item: TransactionItem) {
        self.transaction = item
        let iconName = item.isPlus ? "ic_plus" : "ic_minus"
        let iconImage = UIImage(named: iconName)
        self.iconView.image = iconImage
        self.iconView.contentMode = .scaleAspectFit
        
        sumLabel.text = "\(item.sum.asPretty)₽"
        titleLabel.text = item.name
        
        dateLabel.text = TransactionItem.dateFormatter.string(from: item.date)
    }
}
