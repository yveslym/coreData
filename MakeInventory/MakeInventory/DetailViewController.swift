//
//  DetailViewController.swift
//  MakeInventory
//
//  Created by Erik Perez on 11/14/17.
//  Copyright © 2017 Eliel Gordon. All rights reserved.
//

import UIKit
import CoreData



class DetailViewController: UIViewController {
    let stack = CoreDataStack.instance
    var item: Inventory!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
    self.updateItem()
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem){
        self.deleteIem()
    }
    
    
    func fetchRecordsForEntity(_ entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> [NSManagedObject] {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        // Helpers
        var result = [NSManagedObject]()
        
        do {
            // Execute Fetch Request
            let records = try managedObjectContext.fetch(fetchRequest)
            
            if let records = records as? [NSManagedObject] {
                result = records
            }
            
        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }
        
        return result
    }
    
    func updateItem(){
        
        // fetch a list of object managed (Inventory for this case)
        let list = fetchRecordsForEntity("Inventory", inManagedObjectContext: stack.viewContext)
        
        let matchedItem = list.filter { (object) -> Bool in
            return object.value(forKey: "name") as? String  == self.item.name && object.value(forKey: "date") as? String == self.item.date && object.value(forKey: "quantity") as? Int64 == self.item.quantity
        }
        
        matchedItem[0].setValue(nameTextField.text!, forKey: "name")
        matchedItem[0].setValue(Int64(quantityTextField.text!), forKey: "quantity")
        
        print(matchedItem, "maybe updated")
        
        stack.saveTo(context: stack.privateContext)
        self.navigationController?.popViewController(animated: true)
    }
    
    func deleteIem(){
        
        let list = fetchRecordsForEntity("Inventory", inManagedObjectContext: stack.viewContext)
        let matchedItem = list.filter { (object) -> Bool in
            return object.value(forKey: "name") as? String == self.item.name && object.value(forKey: "date") as? String == self.item.date && object.value(forKey: "quantity") as? Int64 == self.item.quantity
        }
        stack.privateContext.delete(matchedItem[0])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = item.name
        nameTextField.text = item.name
        quantityTextField.text = String(item.quantity)
        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}

