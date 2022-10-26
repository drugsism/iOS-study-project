//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by Breeze on 2022/10/19.
//

import UIKit

//6-2)수정할 Diary객체를 받을수 있게 write화면에 enum을 선언
enum DiaryEditMode {
	case new
	case edit(IndexPath, Diary)
}

//3-3-1) Delegate를 통해서 작성된 diary객체를 DiaryList에 전달하기 위한 용도
protocol WriteDiaryViewDelegate: AnyObject {
	func didSelectRegister(diary: Diary)
}

class WriteDiaryViewController: UIViewController {

	@IBOutlet var titleTextField: UITextField!
	@IBOutlet var contentsTextView: UITextView!
	@IBOutlet var dateTextField: UITextField!
	@IBOutlet var confirmButton: UIBarButtonItem!
	
	//DatePicker 설정
	private let datePicker = UIDatePicker()
	private var diaryDate: Date?
	
	//6-2-1) 선언한 열거형값 초기화
	var diaryEditeMode: DiaryEditMode = .new
	
	//3-3-2)delegate 변수 선언
	weak var delegate: WriteDiaryViewDelegate?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.configureContentsTextView()
		self.configureDatePicker()
		
		//2-2-9)
		self.configureInputField()
		
		//
		self.confirmButton.isEnabled = false
		
		
		/*
		 diary상세화면에서 수정버튼을 눌렀을때
		 writeDiaryViewController로 이동하게 되고
		 textField, textView는 diaryDetailViewContorller에서 전달받은 diray 값이 표시되게 된다
		 */
		configureEditMode()
    }
	
	//6-2-3)수정버튼을 tap했을때 전달 받은 값을 열거형 switch 문으로 각 데이터를 diary 내용 표시
	private func configureEditMode() {
		switch self.diaryEditeMode {
		case let .edit(_, diary):
			self.titleTextField.text = diary.title
			self.contentsTextView.text = diary.contents
			self.dateTextField.text = self.dateToString(date: diary.date)
			self.diaryDate = diary.date
			self.confirmButton.title = "Edit"
			
		default:
			break
		}
	}
	
	//textField에 border생성
	private func configureContentsTextView() {
		//border color, width, cornerRadius
		let borderColor = UIColor(displayP3Red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
		self.contentsTextView.layer.borderColor = borderColor.cgColor
		self.contentsTextView.layer.borderWidth = 0.5
		self.contentsTextView.layer.cornerRadius = 5.0
	}
	
	private func configureDatePicker() {
		//선언한 datePicker변수에 날짜만 나오게 설정
		self.datePicker.datePickerMode = .date
		//datePicker 스타일설정
		self.datePicker.preferredDatePickerStyle = .wheels
		//날짜를 선택했을때 타겟 설정 - 해당ViewController에서, 실행함수, for(값이 변경되었을때)
		self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange), for: .valueChanged)
		
		//textField를 tab하면 datePicker가 실행된다
		self.dateTextField.inputView = self.datePicker
		
	}
	
	//2-2-1)Validation을 위해 Delegate연결 - extention에 선언
	private func configureInputField() {
		self.contentsTextView.delegate = self
		
		//2-2-5)titleTextField체크
		self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange), for: .editingChanged)
		
		//2-2-8)dateTextField체크
		self.dateTextField.addTarget(self, action: #selector(dateTextFieldDidChange), for: .editingChanged)
	}
	
	/*
	 3-3-3)tabConfirmButton이 호출 될때(등록버튼을 눌렀을때)
	 Diary객체를 생성하고
	 Delegate에 정의한 didSelectRegister메소드를 호출해서
	 메서드 파라메터에 생성된 diary객체를 전달해준다
	 */
	@IBAction func tabConfirmButton(_ sender: UIBarButtonItem) {
		guard let title = self.titleTextField.text else { return }
		guard let contents = self.contentsTextView.text else { return }
		guard let date = self.diaryDate else { return }
		
		//diary 객체를 생성
		let diary = Diary(title: title, contents: contents, date: date, isStar: false)
//		self.delegate?.didSelectRegister(diary: diary) //6-2-4) 구현시시 삭제
		
		/*
		 6-2-4)
		 notification center를 이용해서 수정이 일어나면
		 notification center에 수정된 diary객체를 전달하고
		 notification center를 구독하고 있는 화면에서 수정된 diary객체를 전달받고
		 View에도 수정된 내용이 갱신되도록 구현
		 
		 */
		switch self.diaryEditeMode {
		case .new: //diary 등록
			self.delegate?.didSelectRegister(diary: diary)
		
		case let .edit(indexPath, _)://수정
			NotificationCenter.default.post(
				name: NSNotification.Name("editDiary"),
				object: diary,
				userInfo: ["indexPath.row": indexPath.row]
			)
		}
		

		//ViewController로 이동
		self.navigationController?.popViewController(animated: true)
		
		
	}
	
	//datePicker에서 값이 변경되었을때 실행하는 함수구현
	@objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
		//날짜 포맷을 설정한다
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy.MM.dd(EEEEE)"
		formatter.locale = Locale(identifier: "ko_KR")
		self.diaryDate = datePicker.date
		self.dateTextField.text = formatter.string(from: datePicker.date)
		
		//2-2-10)datePicker가 변경되어 textField가 변경되어도 .editingChanged가 발생되지 않는다
		self.dateTextField.sendActions(for: .editingChanged)
	}
	
	//2-2-6)title이 변경되면 validation 함수를 실행
	@objc private func titleTextFieldDidChange(_ textFile: UITextField) {
		self.validateInputField()
	}
	
	//2-2-7)dateTextField가 변경되면 Validation 함수를 실행
	@objc private func dateTextFieldDidChange(_ textFile: UITextField) {
		self.validateInputField()
	}
	
	//사용자가 화면을 터치하면 실행되는 메서드
	//사용자가 빈화면을 터치하면 keyboard, datePicker를 닫는다(endEditing)
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	//2-2-4) validation 실행 함수 구현
	private func validateInputField() {
		self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !(self.dateTextField.text?.isEmpty ?? true) && !self.contentsTextView.text.isEmpty
	}
	
	private func dateToString(date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy.MM.dd(EEEEE)"
		formatter.locale = Locale(identifier: "ko_KR")
		return formatter.string(from: date)
	}
}

//2-2-2) Delegate 채택
extension WriteDiaryViewController: UITextViewDelegate {
	//2-2-3)textView에 text가 입력 될때마다 실행되는 메소드를 선언
	func textViewDidChange(_ textView: UITextView) {
		//validation
		validateInputField()
	}
	
}
