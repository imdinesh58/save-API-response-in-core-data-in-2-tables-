//
//  ThreadViewController.swift
//  CoreDataSampleApp
//
//  Created by Apple-1 on 13/12/17.
//  Copyright © 2017 Apple-1. All rights reserved.
//

import UIKit
import CoreData

class ThreadViewController: UIViewController,UITableViewDelegate,UITableViewDataSource  {

    @IBOutlet weak var tasksTblView: UITableView!
    var JAT: [NSManagedObject] = []
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var entity2:NSEntityDescription?
    let fetchRequest2 = NSFetchRequest<NSManagedObject>(entityName: "JsonAssignedTasks")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tasksTblView.delegate = self
        self.tasksTblView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //OperationQueue.main.addOperation{
        NotificationCenter.default.addObserver(self, selector: #selector(self.getFromCoreData), name: NSNotification.Name(rawValue: "refreshThread"), object: nil)
        entity2 = NSEntityDescription.entity(forEntityName: "JsonAssignedTasks", in: managedContext)
        self.getFromCoreData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func getFromCoreData() {
        print("ThreadViewController loaded")
        //2
        do {
            JAT = try managedContext.fetch(fetchRequest2)
            print("JAT.count  ", JAT.count)
            if JAT.count != 0 {
                for val in JAT {
                    let assignedTaskID = val.value(forKey: "assignedTaskID")
                    let employeeName = val.value(forKey: "employeeName")
                    //print("GET EmployeeID == " , assignedTaskID!)
                    //print("GET employeeName == " , employeeName!)
                    let location = val.value(forKey: "location")
                    //print("GET location", location!)
                }
                print("fetch success")
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        self.tasksTblView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return JAT.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tasksTblView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)
        let emp = JAT[indexPath.row]
        var AssignedTaskID: String?
        AssignedTaskID! = String(describing: emp.value(forKeyPath: "assignedTaskID") as? Int)
        
        Cell.textLabel?.text = "Assigned Task : " + AssignedTaskID!
        Cell.textLabel?.textColor = UIColor.blue

        return Cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //delete
        let shareAction =  UITableViewRowAction(style: .destructive, title : "Delete", handler: {
            (action:UITableViewRowAction, indexPath: IndexPath) -> Void in
            self.managedContext.delete(self.JAT[indexPath.row])
            do {
                try self.managedContext.save()
                print("delete success")
            } catch {
                print("Failed Saving")
            }
            self.JAT.remove(at: indexPath.row)
            self.tasksTblView?.deleteRows(at: [indexPath], with: .fade)
        })
        
        return [shareAction]
    }
    
}
