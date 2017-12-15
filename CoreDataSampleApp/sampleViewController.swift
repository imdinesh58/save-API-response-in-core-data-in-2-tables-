//
//  sampleViewController.swift
//  CoreDataSampleApp
//
//  Created by Apple-1 on 07/12/17.
//  Copyright © 2017 Apple-1. All rights reserved.
//

import UIKit
import CoreData

class sampleViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableVIew: UITableView!
    
    var people: [NSManagedObject] = []
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var entity:NSEntityDescription?
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableVIew?.delegate = self
        self.tableVIew?.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)
        getFromCoreData()
    }
    
    @IBOutlet weak var imageVIew: UIImageView!
    
    func getFromCoreData() {
        do {
            people = try managedContext.fetch(fetchRequest)
            print("people from db \(String(describing: people.count))")
            for val in people {
                let unwrapped = val.value(forKeyPath: "name") ?? "none"
                let unwrapped2 = val.value(forKeyPath: "photo") ?? "no images"
            }
            print("fetch success")
            self.tableVIew.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func btnClick() {
        editTextField()
    }
    
    func editTextField() {
        let alert = UIAlertController(title: "New Name", message: "Add name", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            let textField = alert.textFields?.first
            let nameToSave = textField?.text
            if nameToSave?.isEmpty == false {
                self.save(name : nameToSave!)
                self.tableVIew.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel",style: .default)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func save(name : String) {
        let person = NSManagedObject(entity: entity!, insertInto : managedContext)
        person.setValue(name, forKeyPath: "name")
        let img = UIImage(named: "Screen Shot 2017-12-08 at 10.45.50 AM.png")
        let imgData = UIImagePNGRepresentation(img!) as NSData?
        person.setValue(imgData, forKeyPath: "photo")
        do {
            try managedContext.save()
            people.append(person)
            print("save success")
        } catch let error as NSError {
            print("not able to save. \(error), \(error.userInfo)")
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableVIew.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let person = people[indexPath.row]
        Cell.textLabel?.text = person.value(forKeyPath: "name") as? String
        
        if let imageData = person.value(forKey: "photo") as? NSData {
            if let img = UIImage(data: imageData as Data) {
                Cell.accessoryView = UIImageView(image: img)
            }
        }
        
        return Cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //delete
        
        let shareAction =  UITableViewRowAction(style: .destructive, title : "Delete", handler: {
            (action:UITableViewRowAction, indexPath: IndexPath) -> Void in
            self.managedContext.delete(self.people[indexPath.row])
            do {
                try self.managedContext.save()
                print("delete success")
            } catch {
                print("Failed Saving")
            }
            self.people.remove(at: indexPath.row)
            self.tableVIew?.deleteRows(at: [indexPath], with: .fade)
        })
        //edit
        let rateAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Edit" , handler: { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
            let objectUpdate = self.people[indexPath.row]
            let alert = UIAlertController(title: "Edit Name", message: "Add a new name", preferredStyle: .alert)
            let saveAction = UIAlertAction(title: "Save", style: .default) { action in
                let textField = alert.textFields?.first
                let nameToSave = textField?.text
                if nameToSave?.isEmpty == false {
                    objectUpdate.setValue(nameToSave!, forKey: "name")
                    do {
                        try self.managedContext.save()
                        print("update success")
                    } catch let error as NSError {
                        print("not able to save. \(error), \(error.userInfo)")
                    }
                }
                self.tableVIew?.reloadData()
            }
            let cancelAction = UIAlertAction(title: "Cancel",style: .default)
            alert.addTextField()
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true)
        })
        rateAction.backgroundColor = UIColor.blue
        return [shareAction,rateAction]
    }
    
} ///end main class



