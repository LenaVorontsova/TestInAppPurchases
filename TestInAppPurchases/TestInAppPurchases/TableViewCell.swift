//
//  TableViewCell.swift
//  TestInAppPurchases
//
//  Created by Lena Vorontsova on 17.02.2023.
//

import UIKit
import SnapKit

enum ConstCells {
    static let topAndLeadCell = 20
    static let sizeImage = 80
}
protocol ReusableView: AnyObject {
    static var identifier: String { get }
}

final class TableViewCell: UITableViewCell {
    lazy var imageCell: UIImageView = {
        var image = UIImageView()
        return image
    }()
    lazy var titleText: UILabel = {
        var label = UILabel()
        label.numberOfLines = 4
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
            contentView.addSubview(imageCell)
            titleText.snp.makeConstraints {
                $0.top.equalToSuperview().inset(ConstCells.topAndLeadCell)
                $0.leading.equalTo(imageCell.safeAreaLayoutGuide.snp.trailing).offset(ConstCells.topAndLeadCell)
                $0.trailing.equalToSuperview().inset(ConstCells.topAndLeadCell)
            }
            imageCell.snp.makeConstraints {
                $0.height.width.equalTo(ConstCells.sizeImage)
                $0.top.equalToSuperview().inset(ConstCells.topAndLeadCell)
                $0.leading.equalToSuperview().inset(ConstCells.topAndLeadCell)
            }
        }
}

extension TableViewCell: ReusableView {
    static var identifier: String {
        return "TableViewCell"
    }
}
