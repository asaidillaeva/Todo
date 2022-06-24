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
    
    @objc
    func add(){
        let detailsViewController = DetailsViewController()
        detailsViewController.delegate = self
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    @objc
    func edit(){
        tableView.isEditing.toggle()
        
        if tableView.isEditing {
            addButton.isHidden = true
            editButton.setBackgroundImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
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
        
        self.navigationItem.title = "Список задач"
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
        cell.setTodo(defaults.data[indexPath.row])
        cell.delegate = self
        cell.tappedIndex = indexPath.row

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell: TodoCell = tableView.cellForRow(at: indexPath) as? TodoCell{
            let item = defaults.data[indexPath.row]
            item.isDone.toggle()  
            defaults.remove(index: indexPath.row)
            defaults.insert(todo: item, index: indexPath.row)
            cell.cellSelected(isSelected: item.isDone)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("defaults.todoList.count =  \(defaults.count)")
        return defaults.count
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = defaults.data[sourceIndexPath.row]
        defaults.remove(index: sourceIndexPath.row)
        defaults.insert(todo: item, index:  destinationIndexPath.row)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            defaults.remove(index: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
        } else if editingStyle == .insert{
            
            let rowIndex = defaults.count - 1
            let indexPath = IndexPath(row: rowIndex, section: 0)
            tableView.beginUpdates()
            tableView.insertRows(at:  [indexPath], with: .left)
            tableView.endUpdates()
            
        }
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if tableView.isEditing {
            return
        }
        let detailsViewController = DetailsViewController()
        let item = defaults.data[indexPath.row]
        detailsViewController.itemToEdit = item
        detailsViewController.delegate = self
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
}

extension MainViewController: DetailViewControllerDelegate {
    
    func detailViewController(_ controller: DetailsViewController, edited item: Todo) {
        if let index = defaults.data.firstIndex(of: item){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? TodoCell{
                cell.setTodo(item)
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    func detailViewController(_ controller: DetailsViewController, added item: Todo) {
        defaults.updateList()
        let rowIndex = defaults.count - 1
        let indexPath = IndexPath(row: rowIndex, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at:  [indexPath], with: .left)
        tableView.endUpdates()
        
    }
}

extension MainViewController: TodoCellDelegate{
    func didTapCheckMark(index: Int) {
        if let cell: TodoCell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? TodoCell{
            let item = defaults.data[index]
            item.isDone.toggle()
            defaults.remove(index: index)
            defaults.insert(todo: item, index: index)
            cell.cellSelected(isSelected: item.isDone)
        }
    }
}
