//
//  EditViewController.swift
//  ToDo
//
//  Created by Aliia Saidillaeva  on 21/6/22.
//

import UIKit

class DetailsViewController: UIViewController {
    let defaults = TodoDefaults()

    private let titleTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Название"
        text.font = .systemFont(ofSize: 20)
        text.backgroundColor = UIColor.white
        text.borderStyle = .roundedRect
        text.textAlignment = .left
        text.contentVerticalAlignment = .top
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private let descriptionTextField: UITextField = {
        let text = UITextField()
        text.font = .systemFont(ofSize: 20)
        text.placeholder = "Описание"
        text.textAlignment = .left
        text.contentVerticalAlignment = .top
        text.backgroundColor = UIColor.white
        text.borderStyle = .roundedRect
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    //    private let saveButton: UIBarButtonItem = {
    //        let btn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(DetailsViewController.save))
    //        btn.tintColor = .systemBlue
    //        return btn
    //    }()
    //
    //    private let cancelButton: UIView = {
    //        let btn =  UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(DetailsViewController.cancel))
    //        btn.tintColor = .red
    //        return btn
    //    }()
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    private func setup(){
                setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        self.navigationItem.rightBarButtonItem = .init(title: "Сохранить",
                                                       style: .done,
                                                       target: self,
                                                       action: #selector(save))
        
        self.navigationItem.leftBarButtonItem = .init(title: "Отмена",
                                                      style: .plain,
                                                      target: self,
                                                      action: #selector(cancel))
        
        view.backgroundColor = .white
        view.addSubview(titleTextField)
        view.addSubview(descriptionTextField)
        titleTextField.becomeFirstResponder()
    }
    
    private func setupConstraints() {
        let constraints = [
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            titleTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            titleTextField.heightAnchor.constraint(equalToConstant: 70),
            
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            descriptionTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 15),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 350)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    @objc func cancel(){
        self.dismiss(animated: true )
    }
    
    @objc func save(){
        if titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            titleTextField.text = "Без названия"
        }
        
        if descriptionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            descriptionTextField.text = "Без описания"
        }
        
        let todo: Todo = .init(title: titleTextField.text ??  "Без названия" , desc: descriptionTextField.text ?? "Без описания", isDone: false)
        defaults.todoList.insert(todo, at: defaults.todoList.count)
        defaults.updateData()
        self.dismiss(animated: true)
        print("saved")
    }
    
}
