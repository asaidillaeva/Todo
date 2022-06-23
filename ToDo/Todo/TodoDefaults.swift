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
    static let isDone = "isDone"
    static let todoList = "todoList"
}

class TodoDefaults {
    
    static let shared = TodoDefaults()
    let defaults = UserDefaults.standard
    
    private var todoList: [Todo] = []
    var count: Int {
        todoList.count
    }
    
    var data: [Todo]{
        todoList
    }
    
    init() {
        updateList()
    }
    
    func insert(todo: Todo, index: Int){
        todoList.insert(todo, at: index)
        updateData()
        updateList()
    }
    
    func remove(index: Int){
        todoList.remove(at: index)
        updateData()
        updateList()
    }
    
    func save(todo: Todo){
        todoList.append(todo)
        updateData()
        updateList()
    }
    
    func updateList() {
        if let data = defaults.object(forKey: Key.todoList) as? Data{
            todoList = (try? JSONDecoder().decode([Todo].self, from: data)) ?? []
        }
    }
    
    private func updateData(){
        if let data = try? JSONEncoder().encode(todoList){
            defaults.set(data, forKey: Key.todoList)
        }
    }
}
