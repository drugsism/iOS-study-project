//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by Breeze on 2022/10/18.
//

import UIKit
//Todo
/*
 5-1)Diary 삭제
 Delegate를 통해서 일기장 상세 화면에서 삭제가 일어날때
 메서드를 통해 일기장 리스트 화면의 indexpath를 전달하여
 diaryList[], CollectionView에서 diary를 삭제
 */

protocol DiaryDeatilViewDelegate: AnyObject {
	func didSelectDelete(indexPath: IndexPath)
}
class DiaryDetailViewController: UIViewController {

	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var contentsTextView: UITextView!
	@IBOutlet var dateLabel: UILabel!
	
	
	//5-2)delegate 변수 선언
	weak var delegate: DiaryDeatilViewDelegate?
	
	//diaryList화면에서 전달받을 프로퍼티 선언
	var diary: Diary?
	var indexPath: IndexPath?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.configureView()
    }
	
	//프로퍼티를 통해 전달받은 diary객체를 view에 초기화
	private func configureView() {
		guard let diary = self.diary else { return }
		self.titleLabel.text = diary.title
		self.contentsTextView.text = diary.contents
		self.dateLabel.text = self.dateToString(date: diary.date)
	}
	
	private func dateToString(date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy.MM.dd(EEEEE)"
		formatter.locale = Locale(identifier: "ko_KR")
		return formatter.string(from: date)
	}
	
	@IBAction func tapEditButton(_ sender: UIButton) {
		
	}
	
	@IBAction func tapDeleteButton(_ sender: UIButton) {
		guard let indexPath = self.indexPath else { return }
		self.delegate?.didSelectDelete(indexPath: indexPath)
		self.navigationController?.popViewController(animated: true)
	}

}
