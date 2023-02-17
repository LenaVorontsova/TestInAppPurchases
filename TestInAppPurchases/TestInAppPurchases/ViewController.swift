//
//  ViewController.swift
//  TestInAppPurchases
//
//  Created by Lena Vorontsova on 17.02.2023.
//

import UIKit
import StoreKit
import SnapKit

class ViewController: UIViewController{
    private var models = [SKProduct]()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(TableViewCell.self,
                       forCellReuseIdentifier: TableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureConstrains()
        tableView.delegate = self
        tableView.dataSource = self
        fetchProducts()
    }
    
    private func configureConstrains() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap({$0.rawValue})))
        request.delegate = self
        request.start()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, SKProductsRequestDelegate {
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // show purchase
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
}

