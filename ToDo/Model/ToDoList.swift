//
//  ToDoList.swift
//  ToDo
//
//  Created by Shreya on 03/10/17.
//  Copyright © 2017 Self. All rights reserved.
//

import UIKit
import RealmSwift

enum EPriorities:Int{
    case ePriorityLow = 1
    case ePriorityMedium = 2
    case ePriorityHigh = 3
}

class ToDoList: Object {
    dynamic var listTitle:String = ""
    dynamic var listDate:Date = Date()
    dynamic var listPriority:Int = EPriorities.ePriorityLow.rawValue
}
