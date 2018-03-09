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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
        
        switch(type){
            
        case.insert:
            if let indexPath = newIndexPath {
                table_view.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        case.delete:
            if let indexPath = indexPath {
                table_view.deleteRows(at: [indexPath], with: .fade)
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
}
