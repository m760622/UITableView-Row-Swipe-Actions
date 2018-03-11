//Created by Yusif Aliyev
//March 10, 2018

import UIKit
import CoreData

class Main_VC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var table_view: UITableView!
    
    var controller: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table_view.delegate = self
        self.table_view.dataSource = self
        
        generate_data(number: 5)
        
        attempt_fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.table_view.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let my_cell = table_view.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        configure_cell(my_cell, indexPath: (indexPath as NSIndexPath) as IndexPath)
        return my_cell
    }
    
    func configure_cell(_ cell: CustomCell, indexPath: IndexPath) {
        let item: Item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favorite = UIContextualAction(style: .normal, title: "Favorite") { (action, view, nil) in
            print("Favorite")
            if let objects = self.controller.fetchedObjects, objects.count > 0 {
                let item = objects[indexPath.row]
                if item.is_favorite == false {
                    item.is_favorite = true
                }else{
                    item.is_favorite = false
                }
            }
            self.table_view.isEditing = false
        }
        favorite.backgroundColor = UIColor(red:0.95, green:0.65, blue:0.21, alpha:1.00)
        let config =  UISwipeActionsConfiguration(actions: [favorite])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, nil) in
//            print("Delete")
//            self.table_view.isEditing = false
//            if let objects = self.controller.fetchedObjects, objects.count > 0 {
//                let item = objects[indexPath.row]
//                context.delete(item)
//                app_delegate.saveContext()
//            }
//        }
//        delete.backgroundColor = .red
//        let config =  UISwipeActionsConfiguration(actions: [delete])
//        config.performsFirstActionWithFullSwipe = false
//        return config
//    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if let objects = self.controller.fetchedObjects, objects.count > 0 {
                let item = objects[indexPath.row]
                context.delete(item)
                app_delegate.saveContext()
            }
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func attempt_fetch() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let name_sort = NSSortDescriptor(key: "item_name", ascending: true)
        
        fetchRequest.sortDescriptors = [name_sort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        self.controller = controller
        
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        table_view.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        table_view.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type) {
            case.insert:
            if let indexPath = newIndexPath {
                table_view.insertRows(at: [indexPath], with: .fade)
            }
            break
            
            case.delete:
            if let indexPath = indexPath {
                table_view.deleteRows(at: [indexPath], with: .automatic)
            }
            break
            
            case.update:
            if let indexPath = indexPath {
                let cell = table_view.cellForRow(at: indexPath) as! CustomCell
                configure_cell(cell, indexPath: (indexPath as NSIndexPath) as IndexPath)
            }
            break
            
            case.move:
            if let indexPath = indexPath {
                table_view.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                table_view.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let objects = controller.fetchedObjects, objects.count > 0 {
//            let item = objects[indexPath.row]
//            performSegue(withIdentifier: "to_Item_Details_VC", sender: item)
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "to_Item_Details_VC" {
//            if let destination = segue.destination as? Item_Details_VC {
//                if let item = sender as? Item {
//                    destination.item_to_see = item
//                }
//            }
//        }
    }
    
    @IBAction func refresh_button_pressed(_ sender: Any) {
        self.table_view.reloadData()
    }
    
    func generate_data(number: Int) {
        resetAllRecords(in: "Item")
        for i in 1...number{
            let item = Item(context: context)
            if i<10{
                item.item_name = "Item_Number_00\(i)"
            }else if i<100{
                item.item_name = "Item_Number_0\(i)"
            }else{
                item.item_name = "Item_Number_\(i)"
            }
            item.is_favorite = false
            app_delegate.saveContext()
        }
    }
    
    func resetAllRecords(in entity : String) {
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch
        {
            print ("There was an ERROR when reseting the records.")
        }
    }
}
