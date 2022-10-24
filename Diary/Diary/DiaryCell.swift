//
//  DiaryCell.swift
//  Diary
//
//  Created by Breeze on 2022/10/17.
//

import UIKit

class DiaryCell: UICollectionViewCell {
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var dateLabel: UILabel!

	//이 생성자는 UIView가 스토리보드에서 생성될때 이 생성자로부터 객체가 생성된다.
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.contentView.layer.cornerRadius = 5.0
		self.contentView.layer.borderWidth = 1.0
		self.contentView.layer.borderColor = UIColor.black.cgColor
	}
	
}
