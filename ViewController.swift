//
//  ViewController.swift
//  TitanProject
//
//  Created by Prameela Akkinapalli on 17/09/23.
//  Copyright © 2023 Prameela Akkinapalli. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var tasks: [String] = []
    var selectedTasks : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = true
        self.tasks = UserDefaults.standard.stringArray(forKey: "tasks") ?? []
        self.selectedTasks = UserDefaults.standard.stringArray(forKey: "selectedTasks") ?? []
        // Do any additional setup after loading the view.
    }
    
    @IBAction func plusButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Task", message: "Please enter the task name", preferredStyle: .alert)
        
        alert.addTextField { field in
            field.placeholder = "Enter text"
            }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] (_) in
            if let field = alert.textFields?.first {
                if let text = field.text, !text.isEmpty {
                    DispatchQueue.main.async {
                        var todoTasks = UserDefaults.standard.stringArray(forKey: "tasks") ?? []
                        todoTasks.append(text)
                        UserDefaults.standard.setValue(todoTasks, forKey: "tasks")
                        UserDefaults.standard.synchronize()
                        self?.tasks.append(text)
                        self?.tableView.reloadData()
                    }
                }
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    /* Table View Delegate methods */
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
          
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TaskTableViewCell
        cell?.taskTitle.text = tasks[indexPath.row]
        if selectedTasks.contains(tasks[indexPath.row]) {
            cell?.checkBox.image = UIImage(named: "checkbox.jpg")
        } else {
            cell?.checkBox.image = UIImage(named: "uncheck.jpg")
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell
        if self.selectedTasks.contains(tasks[indexPath.row]) {
            selectedTasks = selectedTasks.filter{$0 != tasks[indexPath.row]}
            cell?.checkBox.image = UIImage(named: "uncheck.jpg")
            UserDefaults.standard.setValue(selectedTasks, forKey: "selectedTasks")
            UserDefaults.standard.synchronize()
        } else {
            self.selectedTasks.append(tasks[indexPath.row])
            cell?.checkBox.image = UIImage(named: "checkbox.jpg")
            UserDefaults.standard.setValue(selectedTasks, forKey: "selectedTasks")
            UserDefaults.standard.synchronize()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
          
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            tasks.remove(at: indexPath.row)
            UserDefaults.standard.setValue(tasks, forKey: "tasks")
            UserDefaults.standard.synchronize()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
       
}

