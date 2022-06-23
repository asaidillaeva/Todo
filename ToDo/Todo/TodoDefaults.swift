//
//  TodoDefaults.swift
//  ToDo
//
//  Created by Aliia Saidillaeva  on 23/6/22.
//

import Foundation
import UIKit

var defaults = UserDefaults.standard

var titleDefaults = defaults.array(forKey: Key.title) as? [String] ?? [String]()
var descriptionDefaults = defaults.array(forKey: Key.desc) as? [String] ?? [String]()
var isDoneDefaults = defaults.array(forKey: Key.isDone) as? [Bool] ?? [Bool]()

struct Key {
    static let title = "title"
    static let desc = "description"
    static var isDone = "isDone"
}



class TodoDefaults {
    
    var todoList: [Todo] = []

    init() {
        updateList()
    }
    
    
    func save(todo: Todo){
        todoList.append(todo)
    }
    
    func updateList() {
        for i in 0..<titleDefaults.count {
            let item = Todo(title: titleDefaults[i],
                            desc: descriptionDefaults[i],
                            isDone: isDoneDefaults[i])
            todoList.append(item)
        }
    }
    
    func updateData() {
        titleDefaults = []
        descriptionDefaults = []
        isDoneDefaults = []
        for i in todoList {
            titleDefaults.append(i.title)
            descriptionDefaults.append(i.desc)
            isDoneDefaults.append(i.isDone)
        }
        defaults.removeObject(forKey: Key.title)
        defaults.removeObject(forKey: Key.desc)
        defaults.removeObject(forKey: Key.isDone)
        
        defaults.set(titleDefaults, forKey: Key.title)
        defaults.set(descriptionDefaults, forKey: Key.desc)
        defaults.set(isDoneDefaults, forKey: Key.isDone)
        
    }

    
}
