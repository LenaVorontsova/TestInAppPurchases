//
//  TableViewCell.swift
//  TestInAppPurchases
//
//  Created by Lena Vorontsova on 17.02.2023.
//

import UIKit
import SnapKit

protocol ReusableView: AnyObject {
    static var identifier: String { get }
}

final class TableViewCell: UITableViewCell {
    lazy var titleText: UILabel = {
            var label = UILabel()
            return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            contentView.backgroundColor = .clear
            configureConstraints()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func configureConstraints() {
            contentView.addSubview(titleText)
            titleText.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.leading.trailing.equalToSuperview()
            }
        }
}

extension TableViewCell: ReusableView {
    static var identifier: String {
        return "TableViewCell"
    }
}
