//
//  ViewController.swift
//  TestInAppPurchases
//
//  Created by Lena Vorontsova on 17.02.2023.
//

import UIKit
import StoreKit
import SnapKit

enum ConstViewController {
    static let bottomTable = 500
    static let topImage = 10
}

class ViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(TableViewCell.self,
                       forCellReuseIdentifier: TableViewCell.identifier)
        return table
    }()
    private lazy var imageAdd: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "add")
        return image
    }()
    
    private var models = [SKProduct]()
    private var images = [UIImage(named: "addBlock"),
                          UIImage(named: "benefits"),
                          UIImage(named: "gem")]

    override func viewDidLoad() {
        super.viewDidLoad()
        configureConstrains()
        tableView.delegate = self
        tableView.dataSource = self
        SKPaymentQueue.default().add(self)
        fetchProducts()
        view.backgroundColor = .white
    }
    
    private func configureConstrains() {
        view.addSubview(tableView)
        view.addSubview(imageAdd)
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(imageAdd.safeAreaLayoutGuide.snp.top).inset(ConstViewController.topImage)
        }
        imageAdd.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(0)
        }
    }
    
    private func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap({$0.rawValue})))
        request.delegate = self
        request.start()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier,
                                                       for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        let product = models[indexPath.row]
        cell.titleText.text = "\(product.localizedTitle): \(product.localizedDescription) - \((product.price))\(product.priceLocale.currencySymbol ?? "$")"
        cell.imageCell.image = images[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // show purchase
        let payment = SKPayment(product: models[indexPath.row])
        SKPaymentQueue.default().add(payment )
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            print("Count: \(response.products.count )")
            self.models = response.products
            self.tableView.reloadData()
        }
    }
    
    enum Product: String, CaseIterable {
        case removeAds = "com.myapp.remove"
        case unlockEverything = "com.myapp.everything"
        case getGems = "com.myapp.gems"
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        // no impl.
        transactions.forEach({
            switch $0.transactionState {
            case .purchasing:
                print("purchasing")
            case .purchased:
                print("purchased")
                SKPaymentQueue.default().finishTransaction($0)
            case .failed:
                print("did not purchase")
                SKPaymentQueue.default().finishTransaction($0)
            case .restored:
                break
            case .deferred:
                break
            @unknown default:
                break
            }
        })
    }
}

