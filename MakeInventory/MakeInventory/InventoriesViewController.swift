//
//  ViewController.swift
//  MakeInventory
//
//  Created by Eliel A. Gordon on 11/12/17.
//  Copyright © 2017 Eliel Gordon. All rights reserved.
//

import UIKit
import CoreData

class InventoriesViewController: UIViewController {
    let stack = CoreDataStack.instance
    
    @IBOutlet weak var tableView: UITableView!
    var inventories = [Inventory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchFromCoredata()
    }
    
    func fetchFromCoredata()
    {
        let fetch = NSFetchRequest<Inventory>(entityName: "Inventory")
        do {
            let result = try stack.viewContext.fetch(fetch)
            self.inventories = result
            self.tableView.reloadData()
            
        }catch let error {
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "inventoriesToDetail" {
            let detailViewController = segue.destination as! DetailViewController
            
            detailViewController.item = sender as! Inventory
        }
    }
}

extension InventoriesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventories.count
    }
}

extension InventoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as! TableViewCell
        
        let item = inventories[indexPath.row]
        
        cell.nameLabel.text = item.name
        cell.quantityLabel.text = "x\(item.quantity)"
        cell.dateLabel.text = item.date
        cell.inventory = item
        cell.indexPath = indexPath
        cell.delegate = self
        cell.favoriteButton.isSelected = item.favorite

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedInventory = inventories[indexPath.row]
        performSegue(withIdentifier: "inventoriesToDetail", sender: selectedInventory)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            stack.viewContext.delete(inventories[indexPath.row])
            // Forgot to save need to do it in the viewContext because it's in the main thread
            // Works perfectly
            stack.saveTo(context: stack.viewContext)
            self.fetchFromCoredata()
            self.tableView.reloadData()
        }
    }
}


extension InventoriesViewController: stackDelegate {
    func updateFavorite(_ inventory: Inventory, _ indexPath: IndexPath) {
        if inventory.favorite == true{
            inventory.favorite = false
        } else {
            inventory.favorite = true
        }
        
        stack.saveTo(context: stack.viewContext)
        tableView.reloadRows(at: [indexPath], with: .fade)
        self.fetchFromCoredata()
    }
    
    
}



