//
//  TodoDefaults.swift
//  ToDo
//
//  Created by Aliia Saidillaeva  on 23/6/22.
//

import Foundation
import UIKit

enum Key: String {
    case todoList
}

class TodoDefaults {
    
    let defaults = UserDefaults.standard
    private var todoList: [Todo] = []
    
    var count: Int {
        todoList.count
    }
    
    var data: [Todo] {
        todoList
    }
    
    init() {
        updateList()
    }
    
    func insert(todo: Todo, index: Int){
        todoList.insert(todo, at: index)
        updateData()
    }
    
    func remove(index: Int){
        todoList.remove(at: index)
        updateData()
    }
    
    func save(todo: Todo){
        todoList.append(todo)
        updateData()
    }
    
    func updateList() {
        if let data = defaults.object(forKey: Key.todoList.rawValue) as? Data{
            todoList = (try? JSONDecoder().decode([Todo].self, from: data)) ?? []
        }
    }
    
    private func updateData(){
        if let data = try? JSONEncoder().encode(todoList){
            defaults.set(data, forKey: Key.todoList.rawValue)
        }
    }
}
