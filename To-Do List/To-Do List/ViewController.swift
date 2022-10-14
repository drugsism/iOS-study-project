//
//  ViewController.swift
//  To-Do List
//
//  Created by Breeze on 2022/10/13.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	
	//변경했을때 메모리에서 지워지므로 weak->Strong
	@IBOutlet var editButton: UIBarButtonItem!
	var doneButton: UIBarButtonItem?
	
	
	var tasks = [ToDo]() {
		//task가 추가될 때 Userdefaults에 저장할 프로퍼티옵저버
		didSet {
			self.saveTasks()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//done버튼 생성?
		self.doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTab))
		
		self.tableView.dataSource = self
		self.tableView.delegate = self
		//UserDefaults의 데이터를 가져와 tasks에 매핑한다
		self.loadTasks()
		
	}

	@objc func doneButtonTab() {
		self.navigationItem.leftBarButtonItem = self.editButton
		self.tableView.setEditing(false, animated: true)
	}
	
	@IBAction func tabEditButton(_ sender: UIBarButtonItem) {
		guard !self.tasks.isEmpty else { return }
		self.navigationItem.leftBarButtonItem = self.doneButton
		self.tableView.setEditing(true, animated: true)
	}
	
	
	@IBAction func tabAddButton(_ sender: UIBarButtonItem) {
		let alert = UIAlertController(title: "Add To-Do", message: nil, preferredStyle: .alert)
		let registerButton = UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
			guard let title = alert.textFields?[0].text else { return }
			let task = ToDo(title: title, done: false)
			self?.tasks.append(task)
			self?.tableView.reloadData()
			
		})
		let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
		alert.addAction(cancelButton)
		alert.addAction(registerButton)
		alert.addTextField(configurationHandler: {textField in
			textField.placeholder = "Enter your work to do"
		})
		self.present(alert, animated: true)
	}
	
	func saveTasks() {
		//userDefaults에 dictionary 형태로 데이터 저장
		let data = self.tasks.map {
			[
				"title": $0.title,
				"done":	$0.done
			]
		}
		//UserDefaults에 접근하기위해 .standard
		let userDeafaults = UserDefaults.standard
		userDeafaults.set(data, forKey: "tasks")
	}
	
	func loadTasks() {
		//UserDefaults에 접근하기위해 .standard
		let userDefaults = UserDefaults.standard
		//저장된 데이터를 가져온다 .object
		/*
		 1. object는 Any? 타입으므로 저장했던 dictionary 타입으로 타입캐스팅을 해준다
		 2. 타입캐스팅이 실패하면 nil이될 수 있으므로 guard로 옵셔널바인딩 해준다
		 */
		guard let data = userDefaults.object(forKey: "tasks") as? [[String: Any]] else { return }
		
		//compactMap - nil제거, optional biding
		//data를 tasks배열에 매핑하기위해 compactMap으로 tasks타입으로 변경
		self.tasks = data.compactMap {
			//축약인자로 디셔너리에 접근을 하고 키로(title) value를 가져온다
			//디셔너리의 value가 Any타입이므로 String으로 타입캐스팅하고 guard로 옵셔널바인딩한다
			guard let title = $0["title"] as? String else { return nil }
			guard let done = $0["done"] as? Bool else { return nil }
			return ToDo(title: title, done: done)
		}
	}
	
}

extension ViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		self.tasks.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		//dequeueReusableCell - cell을 재사용 예)스크롤시 기존 Cell에 데이터를 교체하여 사용
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		let task = self.tasks[indexPath.row]
		cell.textLabel?.text = task.title
		
		if task.done {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		self.tasks.remove(at: indexPath.row)
		tableView.deleteRows(at: [indexPath], with: .automatic)
		
		if self.tasks.isEmpty {
			self.doneButtonTab()
		}
	}
	
	func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		var tasks = self.tasks
		let task = tasks[sourceIndexPath.row]
		tasks.remove(at: sourceIndexPath.row)
		tasks.insert(task, at: destinationIndexPath.row)
		self.tasks = tasks
	}
}

extension ViewController: UITableViewDelegate {
	//didSelectRowAt-어떤 cell에 접근했는지 알려준다
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		var task = self.tasks[indexPath.row]
		task.done = !task.done
		self.tasks[indexPath.row] = task
		//해당row reload
		self.tableView.reloadRows(at: [indexPath], with: .automatic)
	}
}
