//
//  ViewController.swift
//  Diary
//
//  Created by Breeze on 2022/10/14.
//

import UIKit

class ViewController: UIViewController {

	
	//3-2) viewController에서 Diary 리스트 선언
	private var diaryList = [Diary]()
	
	@IBOutlet var collectinView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
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
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		//segue가 이동한 controller가 무었인지 알수 있도록 작성
		if let writeDiaryViewController = segue.destination as? WriteDiaryViewController {
			//delegate위임
			writeDiaryViewController.delegate = self
		}
	}
}

//protocol 채택
extension ViewController: WriteDiaryViewDelegate {
	// 작성된 내용이 담겨있는 diary객체를 전달받아 diaryList에 append
	func didSelectRegister(diary: Diary) {
		self.diaryList.append(diary)
	}
}
