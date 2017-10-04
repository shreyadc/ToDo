//
//  ViewController.swift
//  ToDo
//
//  Created by Shreya on 03/10/17.
//  Copyright © 2017 Self. All rights reserved.
//

import UIKit
import RealmSwift
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, EditListDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {

    var realm:Realm!
    
    var searchController: UISearchController = UISearchController()
    
    @IBOutlet weak var todoTableView: UITableView!
    
    @IBOutlet weak var pickerCancelHolderView: UIView!
    
    @IBOutlet weak var pickerVie: UIPickerView!
    
    @IBOutlet weak var maskView: UIView!
    var pickerData: [String] = [String]()
    
    var sortedData: [ToDoList] = [ToDoList]()
    
    var searchText: String? = nil
    
    var sortType = 0;
    
    var todoList: Results<ToDoList> {
        get {
            if(searchText != nil)
            {
                let searchPredicate = NSPredicate(format: " listTitle CONTAINS [c] %@", searchText!)
                return realm.objects(ToDoList.self).filter(searchPredicate)
            }
            if(sortType == 0){
                return realm.objects(ToDoList.self).sorted(byKeyPath: "listDate", ascending: false)
            }
            else if(sortType == 1)
            {
                return realm.objects(ToDoList.self).sorted(byKeyPath: "listPriority", ascending: false)
            }
            else 
            {
                return realm.objects(ToDoList.self).sorted(byKeyPath: "listTitle", ascending: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        realm = try! Realm()
        
        self.title = "To-Do List"
        
        pickerData = ["Sort By Date", "Sort By Priority", "Sort By Name"]
        hideSortPicker()
        
        self.searchController = UISearchController(searchResultsController:  nil)
        
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        
        self.navigationItem.titleView = searchController.searchBar
        
        self.definesPresentationContext = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateSearchResults(for searchController: UISearchController) {
        searchText = searchController.searchBar.text
        todoTableView.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        let todoItem = todoList[indexPath.row]
        let dateStr = self.stringFromDate(date: todoItem.listDate)
        var priorityString = ""
        switch todoItem.listPriority {
        case 1:
            priorityString = "Low"
            break
        case 2:
            priorityString = "Medium"
            break
        case 3:
            priorityString = "High"
            break
        default:
            break
        }
        
        cell.textLabel?.text = todoItem.listTitle
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        cell.detailTextLabel?.text = dateStr + "\t Priority: " + priorityString
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete){
            let item = todoList[indexPath.row]
            try! self.realm.write({
                self.realm.delete(item)
            })
            
            tableView.deleteRows(at:[indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editListVC = EditListViewController(nibName: "EditListViewController", bundle: nil)
        editListVC.delegate = self
        let todoItem = todoList[indexPath.row]
        editListVC.prepopulatedListItem = todoItem
        editListVC.index = indexPath.row
        self.navigationController?.pushViewController(editListVC, animated: true)
    }
    
    func stringFromDate(date:Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd HH:mm:ss"
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    
    @IBAction func AddButtonClicked(_ sender: UIBarButtonItem) {
        hideSortPicker()
        
        let editListVC = EditListViewController(nibName: "EditListViewController", bundle: nil)
        editListVC.delegate = self
        self.navigationController?.pushViewController(editListVC, animated: true)
    }
    
    func addedList(_ listItem:ToDoList, _ index: Int)
    {
        if(index == -1)
        {
            try! self.realm.write({
                self.realm.add(listItem)
            })
        }
        else
        {
            //self.realm.ed
            try! self.realm.write({
                let item = todoList[index]
                self.realm.delete(item)
                
                self.realm.add(listItem)
            })
        }
        
        todoTableView.reloadData()
    }
    
    @IBAction func sortAction(_ sender: Any) {
        self.pickerVie.isHidden = false
        self.pickerCancelHolderView.isHidden = false
        self.maskView.isHidden = false;
    }
    
    @IBAction func cancelPicker(_ sender: Any) {
        hideSortPicker()
    }
    
    func hideSortPicker() {
        self.pickerVie.isHidden = true
        self.pickerCancelHolderView.isHidden = true
        self.maskView.isHidden = true;
    }
    
    
    // The number of columns of data
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // The number of rows of data
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        hideSortPicker()
        
        sortType = row
        todoTableView.reloadData()
        
    }
    
    
    
}

