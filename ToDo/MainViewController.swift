//
//  ViewController.swift
//  ToDo
//
//  Created by Aliia Saidillaeva  on 21/6/22.
//

import UIKit

class MainViewController: UIViewController {
    
    
    var defaults: TodoDefaults = .init()
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.register(TodoCell.self, forCellReuseIdentifier: TodoCell.identifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let addButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        view.tintColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(add), for: .touchUpInside)
        
        return view
    }()
    
    private let editButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(systemName: "pencil.circle.fill"), for: .normal)
        view.tintColor = .systemGreen
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(edit), for: .touchUpInside)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc
    func add(){
        //open editViewController
        present(UINavigationController(rootViewController: DetailsViewController()), animated: true, completion: nil )
    }
    
    @objc
    func edit(){
        tableView.isEditing.toggle()
        
        if tableView.isEditing {
            addButton.isHidden = true
            editButton.setBackgroundImage(UIImage(systemName: "pencil.circle"), for: .normal)
            editButton.tintColor = .systemBlue
        } else {
            addButton.isHidden = false
            editButton.setBackgroundImage(UIImage(systemName: "pencil.circle.fill"), for: .normal)
            editButton.tintColor = .systemGreen
        }
    }
    
    private func setup(){
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        view.addSubview(tableView)
        view.addSubview(addButton)
        view.addSubview(editButton)
        
        self.navigationItem.title = "Todo List"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupConstraints() {
        let constraints = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            editButton.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant:  -15),
            editButton.widthAnchor.constraint(equalToConstant: 50),
            editButton.heightAnchor.constraint(equalToConstant: 50),
            
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant:  -25),
            addButton.widthAnchor.constraint(equalToConstant: 50),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.identifier, for: indexPath) as! TodoCell
        cell.setTodo(defaults.todoList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell: TodoCell = tableView.cellForRow(at: indexPath) as? TodoCell{
            var item = defaults.todoList[indexPath.row]
            item.isDone.toggle()
            defaults.todoList.remove(at: indexPath.row)
            defaults.todoList.insert(item, at: indexPath.row)
            cell.cellSelected(isSelected: item.isDone)
            defaults.updateData()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("defaults.todoList.count =  \(defaults.todoList.count)")
        return defaults.todoList.count
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = defaults.todoList[sourceIndexPath.row]
        defaults.todoList.remove(at: sourceIndexPath.row)
        defaults.todoList.insert(item, at:  destinationIndexPath.row)
        defaults.updateData()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            defaults.todoList.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            defaults.updateData()
        } else if editingStyle == .insert{
            tableView.insertRows(at: [indexPath], with: .none)
            tableView.reloadData()    // << May be needed
            
        }
    }
    
}
