//
//  ViewController.swift
//  SNInterview
//
//  Copyright © 2019 ServiceNow. All rights reserved.
//

import UIKit

protocol CoffeeShopTapDelegate: NSObject {
    func didSelectItem(_ item: CoffeeShop)
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var data: [CoffeeShop] = [CoffeeShop]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavBar()
        readData()
        registerNotification()
    }
    
    private func readData(){
        do {
            self.data = try JsonUtils.shared.loadJson(fileName: "CoffeeShops")
        } catch {
            let alert = UIAlertController.init(title: error.localizedDescription,
                                               message: nil,
                                               preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.register(UINib.init(nibName: CoffeeShopItemTableViewCell.id,
                                      bundle: nil),
                           forCellReuseIdentifier: CoffeeShopItemTableViewCell.id)
        
    }
    
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
    }
    
    private func registerNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(appWillTerminate),
                                       name: UIApplication.willTerminateNotification,
                                       object: nil)
    }
    
    @objc
    private func addTapped(){
        let alert = UIAlertController.init(title: "Add Record", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Name (can't be empty)"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Review (can't be empty)"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Rating (Must be Number!!!!)"
            textField.keyboardType = .numberPad
        }
        alert.addAction(UIAlertAction.init(title: "Save", style: .default, handler: { (_) in
            if let name = alert.textFields?[0].text,
                let review = alert.textFields?[1].text,
                let rating = alert.textFields?[2].text,
                let num = Int(rating) {
                let cs = CoffeeShop.init(name: name, review: review, rating: num)
                self.data.insert(cs, at: 0)
                self.tableView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.tableView.setContentOffset(.zero, animated: true)
                }
            }else{
                
            }
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc
    private func appWillTerminate(){
        do {
            try JsonUtils.shared.saveJson(fileName: "CoffeeShops", data: data)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CoffeeShopItemTableViewCell.id,
                                                 for: indexPath) as! CoffeeShopItemTableViewCell
        let coffeeShop = data[indexPath.row]
        cell.itemView.nameLabel.text = coffeeShop.name ?? ""
        cell.itemView.reviewLabel.text = coffeeShop.review ?? ""
        cell.itemView.ratingLabel.text = coffeeShop.rating != nil ?  "\(coffeeShop.rating!)" : ""
        return cell
    }
}

//MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectItem(data[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController.init(title: "Confirm to delete",
                                               message: "Do you really want to delete",
                                               preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction.init(title: "Delete", style: .destructive, handler: { (_) in
                self.data.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

//CoffeeShopTapDelegate
extension ViewController: CoffeeShopTapDelegate {
    func didSelectItem(_ item: CoffeeShop){
        let name = "name: " + (item.name ?? "")
        let review = "\nreview: " + (item.review ?? "")
        let rating = "\nrating: " + (item.rating != nil ? "\(item.rating!)" : "")
        let alert = UIAlertController.init(title: "Deatil",
                                           message: name + review + rating,
                                           preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
