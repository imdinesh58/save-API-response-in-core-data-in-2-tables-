//
//  SaveAPIResponseViewController.swift
//  CoreDataSampleApp
//
//  Created by Apple-1 on 12/12/17.
//  Copyright © 2017 Apple-1. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class SaveAPIResponseViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableVIew: UITableView!
    
    var JWED: [NSManagedObject] = []
    var JAT: [NSManagedObject] = []
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var entity:NSEntityDescription?
    var entity2:NSEntityDescription?
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "JsonWorkersEmployeeDetails")
    let fetchRequest2 = NSFetchRequest<NSManagedObject>(entityName: "JsonAssignedTasks")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableVIew.delegate = self
        self.tableVIew.dataSource = self
        //getListJSON()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        entity = NSEntityDescription.entity(forEntityName: "JsonWorkersEmployeeDetails", in: managedContext)
        entity2 = NSEntityDescription.entity(forEntityName: "JsonAssignedTasks", in: managedContext)
        self.getFromCoreData()
    }
    
    let defaults = UserDefaults.standard
    func getListJSON(){
        autoreleasepool {
            let ApiUrl = "http://192.168.1.200:8081/HouseKeeping/getjson/assignedtask&workers/82/1/1"
            let req = NSMutableURLRequest(url: NSURL(string: ApiUrl)! as URL)
            req.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: req as URLRequest) {
                data, response, error in
                // Check for error
                if error != nil {
                    print("error=\(error)")
                    return
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("StatusCode is === \(httpStatus.statusCode)")
                    OperationQueue.main.addOperation{
                        let alert = UIAlertController(title: "Alert", message: "Server Error... failed to load assigned tasks", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                    let responseString = String(data: data!, encoding: String.Encoding.utf8)
                    //print("API call done with ResponseString = \(responseString)")
                    print("StatusCode is === \(httpStatus.statusCode)")
                    //print("ResponseString = success status " +     responseString!)
                    _ = self.convertStringToDictionary(text: responseString!)
                }
            }  //close task
            task.resume()
        }
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        DispatchQueue.main.async(){
            if let data = text.data(using: String.Encoding.utf8) {
                do {
                    let jsonObj = try JSONSerialization.jsonObject(with: data, options: [])
                    let jsonArray = JSON(jsonObj)
                    
                    for (_, dict) in jsonArray["JsonAssignedTasks"] { //(key or index, element)
                        let dateString = dict["dateAssigned"].stringValue
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm.ss.SSS"
                        let dateObj = dateFormatter.date(from: dateString)
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                        
                        let person = NSManagedObject(entity: self.entity2!, insertInto : self.managedContext)
                        person.setValue(dict["assignedBY"].stringValue, forKeyPath: "assignedBY" )
                        person.setValue(dict["assignedByName"].stringValue, forKeyPath: "assignedByName")
                        person.setValue(dict["assignedByRole"].stringValue, forKeyPath: "assignedByRole")
                        person.setValue(dict["assignedTaskID"].intValue, forKeyPath: "assignedTaskID")
                        person.setValue(dict["assignedToRole"].stringValue, forKeyPath: "assignedToRole")
                        person.setValue(dict["belongsTo"].stringValue, forKeyPath: "belongsTo" )
                        person.setValue(dict["branchId"].stringValue, forKeyPath: "branchId")
                        person.setValue(dict["checkListIds"].stringValue, forKeyPath: "checkListIds")
                        person.setValue(dateFormatter.string(from: dateObj!), forKeyPath: "dateAssigned")
                        person.setValue(dict["descriptions"].stringValue, forKeyPath: "descriptions")
                        person.setValue(dict["distributedToId"].stringValue, forKeyPath: "distributedToId" )
                        person.setValue(dict["distributedToName"].stringValue, forKeyPath: "distributedToName")
                        person.setValue(dict["duration"].stringValue, forKeyPath: "duration")
                        person.setValue(dict["employeeId"].stringValue, forKeyPath: "employeeID")
                        person.setValue(dict["employeeName"].stringValue, forKeyPath: "employeeName")
                        person.setValue(dict["floorNumber"].stringValue, forKeyPath: "floorNumber")
                        person.setValue(dict["image"].stringValue, forKeyPath: "image")
                        person.setValue(dict["imageCount"].stringValue, forKeyPath: "imageCount")
                        person.setValue(dict["isDistributsed"].stringValue, forKeyPath: "isDistributsed")
                        person.setValue(dict["location"].stringValue, forKeyPath: "location")
                        person.setValue(dict["priorities"].stringValue, forKeyPath: "priorities" )
                        person.setValue(dict["taskListId"].stringValue, forKeyPath: "taskListId")
                        person.setValue(dict["taskStatusID"].stringValue, forKeyPath: "taskStatusID")
                        
                        do {
                            try self.managedContext.save()
                            self.JAT.append(person)
                            print("save success")
                        } catch let error as NSError {
                            print("not able to save. \(error), \(error.userInfo)")
                        }
                    }
                    
                    for (_, dict) in jsonArray["JsonWorkers"] {
                        let employeeLevelID = dict["employeeLevelID"].stringValue
                        let levelname = dict["levelName"].stringValue
                        let person = NSManagedObject(entity: self.entity!, insertInto : self.managedContext)
                        person.setValue(dict["ActiveYN"].stringValue, forKeyPath: "activeYN" )
                        person.setValue(dict["Address"].stringValue, forKeyPath: "address")
                        person.setValue(dict["Email"].stringValue, forKeyPath: "email")
                        person.setValue(dict["EmployeeID"].stringValue, forKeyPath: "employeeID")
                        person.setValue(dict["employeeLevelID"].stringValue, forKeyPath: "employeeLevelID")
                        person.setValue("admin", forKeyPath: "employeeStatus")
                        person.setValue(dict["FirstName"].stringValue, forKeyPath: "firstName")
                        person.setValue(dict["isEnabled"].stringValue, forKeyPath: "isEnabled")
                        person.setValue(dict["LastName"].stringValue, forKeyPath: "lastName")
                        person.setValue(dict["levelName"].stringValue, forKeyPath: "levelName")
                        person.setValue(dict["Phone"].stringValue, forKeyPath: "phone")
                        person.setValue(dict["UserMobileID"].stringValue, forKeyPath: "userMobileID")
                        let test:[String] = ["0","0","0","0"]
                        person.setValue(test, forKeyPath: "workDetails")
                        
                        do {
                            try self.managedContext.save()
                            self.JWED.append(person)
                            print("save success")
                        } catch let error as NSError {
                            print("not able to save. \(error), \(error.userInfo)")
                        }
                        
                        let employeeDetailsArray = dict["employeeDetails"]
                        for (_, dict) in employeeDetailsArray {
                            let person = NSManagedObject(entity: self.entity!, insertInto : self.managedContext)
                            person.setValue(dict["ActiveYN"].stringValue, forKeyPath: "activeYN" )
                            person.setValue(dict["Address"].stringValue, forKeyPath: "address")
                            person.setValue(dict["Email"].stringValue, forKeyPath: "email")
                            person.setValue(dict["EmployeeID"].stringValue, forKeyPath: "employeeID")
                            person.setValue(employeeLevelID, forKeyPath: "employeeLevelID")
                            person.setValue("employee", forKeyPath: "employeeStatus")
                            person.setValue(dict["FirstName"].stringValue, forKeyPath: "firstName")
                            person.setValue(dict["isEnabled"].stringValue, forKeyPath: "isEnabled")
                            person.setValue(dict["LastName"].stringValue, forKeyPath: "lastName")
                            person.setValue(levelname, forKeyPath: "levelName")
                            person.setValue(dict["Phone"].stringValue, forKeyPath: "phone")
                            person.setValue(dict["UserMobileID"].stringValue, forKeyPath: "userMobileID")
                            let test:[String] = ([dict["workDetails"][0].stringValue,dict["workDetails"][1].stringValue,dict["workDetails"][2].stringValue,dict["workDetails"][3].stringValue] as [String]?)!
                            person.setValue(test, forKeyPath: "workDetails")
                            
                            do {
                                try self.managedContext.save()
                                self.JWED.append(person)
                                print("save success")
                            } catch let error as NSError {
                                print("not able to save. \(error), \(error.userInfo)")
                            }
                        }
                    }
                    self.tableVIew.reloadData()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshThread"), object: nil)
                } catch {
                    // Catch any other errors
                }
            }
        }
        return nil
    }
    
    func getFromCoreData() {
        //1
        do {
            JWED = try managedContext.fetch(fetchRequest)
            print("JWED.count  ", JWED.count)
            if JWED.count != 0 {
                for val in JWED {
                    let EmployeeID = val.value(forKey: "employeeID")
                    let FirstName = val.value(forKey: "firstName")
                    //print("GET EmployeeID == " , EmployeeID!)
                    //print("GET FirstName == " , FirstName!)
                    let unwrapped : [String]?
                    unwrapped = val.value(forKey: "workDetails") as! [String]?
                    //print("GET workDetails", unwrapped!)
                }
                print("fetch success")
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        //2
        do {
            JAT = try managedContext.fetch(fetchRequest2)
            print("JAT.count  ", JAT.count)
            if JAT.count != 0 {
                for val in JAT {
                    let assignedTaskID = val.value(forKey: "assignedTaskID")
                    let employeeName = val.value(forKey: "employeeName")
                    print("GET EmployeeID == " , assignedTaskID!)
                    print("GET employeeName == " , employeeName!)
                    let location = val.value(forKey: "location")
                    print("GET location", location!)
                }
                print("fetch success")
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        self.tableVIew.reloadData()
    }
    
    @IBAction func btnClick() {
        getListJSON()
    }
    
    @IBAction func manual(_ sender: Any) {
        setSaveManualValues()
    }
    
    @IBAction func deleteDatas(_ sender: Any) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "JsonWorkersEmployeeDetails")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try self.managedContext.execute(deleteRequest)
            try self.managedContext.save()
            print("Deleted & reloaded")
        } catch {
            print ("There was an error")
        }
        
        let deleteFetch2 = NSFetchRequest<NSFetchRequestResult>(entityName: "JsonAssignedTasks")
        let deleteRequest2 = NSBatchDeleteRequest(fetchRequest: deleteFetch2)
        do {
            try self.managedContext.execute(deleteRequest2)
            try self.managedContext.save()
            print("Deleted 2 & reloaded 2")
        } catch {
            print ("There was an error")
        }
        self.getFromCoreData()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshThread"), object: nil)
    }
    
    func setSaveManualValues() {
        let randomNum:UInt32 = arc4random_uniform(100) // range is 0 to 99t
        let randomTime:TimeInterval = TimeInterval(randomNum)
        let someInt:Int = Int(randomNum)
        let someString:String = String(randomNum)
        
        let person = NSManagedObject(entity: entity!, insertInto : managedContext)
        person.setValue("true", forKeyPath: "activeYN")
        person.setValue("velachery", forKeyPath: "address")
        person.setValue("imdinesh.58@gmail.com", forKeyPath: "email")
        person.setValue(someString, forKeyPath: "employeeID")
        person.setValue("19", forKeyPath: "employeeLevelID")
        person.setValue("admin", forKeyPath: "employeeStatus")
        person.setValue("Daniel", forKeyPath: "firstName")
        person.setValue("true", forKeyPath: "isEnabled")
        person.setValue("Craig", forKeyPath: "lastName")
        person.setValue("Maintenance", forKeyPath: "levelName")
        person.setValue("9922233323", forKeyPath: "phone")
        person.setValue("XXXYYYZZZ", forKeyPath: "userMobileID")
        let test:[String] = (["1","1","0","0"] as [String]?)!
        person.setValue(test, forKeyPath: "workDetails")
        do {
            try managedContext.save()
            JWED.append(person)
            print("save success")
        } catch let error as NSError {
            print("not able to save. \(error), \(error.userInfo)")
        }
        self.tableVIew.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return JWED.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableVIew.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let emp = JWED[indexPath.row]
        Cell.textLabel?.text = emp.value(forKeyPath: "firstName") as? String
        
        //let WD = emp.value(forKeyPath: "workDetails")
        //print("WorkDetails ", WD! )
        
        return Cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //delete
        let shareAction =  UITableViewRowAction(style: .destructive, title : "Delete", handler: {
            (action:UITableViewRowAction, indexPath: IndexPath) -> Void in
            self.managedContext.delete(self.JWED[indexPath.row])
            do {
                try self.managedContext.save()
                print("delete success")
            } catch {
                print("Failed Saving")
            }
            self.JWED.remove(at: indexPath.row)
            self.tableVIew?.deleteRows(at: [indexPath], with: .fade)
        })
        
        return [shareAction]
    }
    
} ///end main class



