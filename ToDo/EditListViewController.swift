//
//  EditListViewController.swift
//  ToDo
//
//  Created by Shreya on 03/10/17.
//  Copyright © 2017 Self. All rights reserved.
//

import UIKit

protocol EditListDelegate {
    func addedList(_ listItem:ToDoList, _ index: Int)
}


class EditListViewController: UIViewController {

    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var listTextView: UITextView!
    
    var prepopulatedListItem: ToDoList? = nil
    
    var delegate:EditListDelegate?
    var index = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add/Edit To-Do List"

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        
        if(prepopulatedListItem != nil)
        {
            self.populateListForEditing(listItem: prepopulatedListItem!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doneButtonTapped()
    {
        let listItem = ToDoList()
        listItem.listTitle = listTextView.text
        listItem.listPriority = prioritySegmentedControl.selectedSegmentIndex+1
        listItem.listDate = Date()
        
        self.delegate?.addedList(listItem, index)
        
        self.navigationController?.popViewController(animated: true)
    }

    func populateListForEditing(listItem: ToDoList)  {
        self.listTextView.text = listItem.listTitle
        self.prioritySegmentedControl.selectedSegmentIndex = listItem.listPriority-1
    }
}
