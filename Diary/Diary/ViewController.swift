//
//  ViewController.swift
//  Diary
//
//  Created by Breeze on 2022/10/14.
//

import UIKit

class ViewController: UIViewController {

	
	//3-2) viewController에서 Diary 리스트 선언
	private var diaryList = [Diary]() {
		//5-2)didSet diaryList프로퍼티 옵저버로 변경시 업데이트 되도록 구현
		didSet {
			self.saveDiaryList()
		}
	}
	
	@IBOutlet var collectinView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.configureCollectionView()
		self.loadDiaryList()
		
		//6-2-4-4) collrctionView에도 적용이되도록 ViewController Viewdidload()에 옵저빙을 구현한다
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(editDiaryNotification(_:)),
			name: NSNotification.Name("editDiary"),
			object: nil
		)
	}
	
	private func configureCollectionView() {
		//collectionView의 형태설정
		self.collectinView.collectionViewLayout = UICollectionViewFlowLayout()
		//cell의 padding 설정
		self.collectinView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		
		//
		self.collectinView.delegate = self
		self.collectinView.dataSource = self
	}
	
	@objc func editDiaryNotification(_ notification: Notification) {
		guard let diary = notification.object as? Diary else { return }
		guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
		self.diaryList[row] = diary
		self.diaryList = self.diaryList.sorted(by: {
			$0.date.compare($1.date) == .orderedDescending
		})
		self.collectinView.reloadData()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		//segue가 이동한 controller가 무었인지 알수 있도록 작성
		if let writeDiaryViewController = segue.destination as? WriteDiaryViewController {
			//delegate위임
			writeDiaryViewController.delegate = self
		}
	}
	
	//5-1) diary를 UserDefaults에 딕셔너리 형태로 저장하는 함수
	private func saveDiaryList() {
		let data = self.diaryList.map {
			[
				"title": $0.title,
				"contents": $0.contents,
				"date": $0.date,
				"isStar": $0.isStar
			]
		}
		
		let userDefaults = UserDefaults.standard
		userDefaults.set(data, forKey: "diaryList")
	}
	
	//5-3)userDefaults에 저장된값을 가져오는 함수 구현
	private func loadDiaryList() {
		let userDefaults = UserDefaults.standard
		//userDefaults.object는 Any타입이므로 딕셔너리로 캐스팅
		guard let data = userDefaults.object(forKey: "diaryList") as? [[String: Any]] else { return }
		//불러온 데이터를 diaryList에 넣는다
		self.diaryList = data.compactMap {
			guard let title = $0["title"] as? String else { return nil }
			guard let contents = $0["contents"] as? String else { return nil }
			guard let date = $0["date"] as? Date else { return nil }
			guard let isStar = $0["isStar"] as? Bool else { return nil }
			return Diary(title: title, contents: contents, date: date, isStar: isStar)
		}
		
		//날짜 내림차순으로 정렬
		self.diaryList = self.diaryList.sorted(by: {
			$0.date.compare($1.date) == .orderedDescending
		})
	}
	
	
	
	private func dateToString(date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy.MM.dd(EEEEE)"
		formatter.locale = Locale(identifier: "ko_KR")
		return formatter.string(from: date)
	}
}

extension ViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.diaryList.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		//스토리보드에서 구성한 커스텀cell을 가져온다
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else { return UICollectionViewCell() }//다운캐스팅이 실패하면 재사용 가능한 Cell을 가져온다
		
		let diary = self.diaryList[indexPath.row]
		cell.titleLabel.text = diary.title
		//date fomatter를 통해 문자열로 만든다
		cell.dateLabel.text = self.dateToString(date: diary.date)
		
		return cell
	}
}


//4-3-2)UICollectionViewDelegateFlowLayout를 채택하여 collectionView에 레이아웃 구성
extension ViewController: UICollectionViewDelegateFlowLayout {
	//표시할 cell의 사이즈를 설정
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: (UIScreen.main.bounds.width / 2) - 20 , height: 200)
	}
}

extension ViewController: UICollectionViewDelegate {
	//특정Cell이 선택되었음을 알리는 메서드
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		//스토리보드의 intantiate메서드로 viewController 타입변수를 선언하고
		//해당 Viewcomtroller의 선언된 변수에 값을 전달
		guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
		let diary = self.diaryList[indexPath.row]
		viewController.diary = diary
		viewController.indexPath = indexPath
		
		//5-4)DiaryDetailViewController의 delegate에 접근해서 self대입  - item을 선택했을때
		viewController.delegate = self
		
		self.navigationController?.pushViewController(viewController, animated: true)
	}
}

//protocol 채택
extension ViewController: WriteDiaryViewDelegate {
	// 작성된 내용이 담겨있는 diary객체를 전달받아 diaryList에 append
	func didSelectRegister(diary: Diary) {
		self.diaryList.append(diary)
		//날짜 내림차순으로 정렬
		self.diaryList = self.diaryList.sorted(by: {
			$0.date.compare($1.date) == .orderedDescending
		})
		
		self.collectinView.reloadData()
	}
}

//5-5)삭제를 위한 delegate채택 및 didSelectDelete 구현
extension ViewController: DiaryDeatilViewDelegate {
	func didSelectDelete(indexPath: IndexPath) {
		self.diaryList.remove(at: indexPath.row)
		self.collectinView.deleteItems(at: [indexPath])
	}
}
