//
//  AddressPickerViewController.swift
//  BeeTrader
//
//  Created by hladek on 20/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import UIKit

protocol AddressPickerViewDelegate: Delegate {
    func reloadTableView(addresses: [Address])
}

typealias ListingManager = UITableViewDataSource & UITableViewDelegate
class AddressPickerViewController: UIViewController {
    let viewModel = AddressPickerViewModel()
    var addressPickCompletion: ((Address) -> Void)?

    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.viewModelDidLoad()
    }

    @IBAction func onFilterChanged(_ sender: UITextField) {
        viewModel.onFilterChangedHandler(search: sender.text)
    }
}

extension AddressPickerViewController: ListingManager {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.addresses.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell") as! AddressCell
        cell.setData(data: viewModel.addresses[indexPath.row])
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        addressPickCompletion?(viewModel.addresses[indexPath.row])
        dismiss(animated: true)
    }
}

extension AddressPickerViewController: AddressPickerViewDelegate {
    func reloadTableView(addresses _: [Address]) {
        UIView.transition(with: tableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in self?.tableView.reloadData() })
    }
}