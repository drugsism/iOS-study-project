# Diary App

Date Finished: 2022.10.Tu
Author: James
Tags: #testnote
Aliases: [test]

---
### Step
1. StoryBoard상에서 UI구성
	1. tabbarViewContorller 생성
	2. NavigstionController 생성 및 연결
	3. ViewController에 CollectionView, CollectionViewCell, Label 구성하고 Layout Constraint 설정
	4. 각 화면의 File생성 및 연결
2. Diary작성 구현
	1. TextField border생성, DatePicker 연결 
	2. 각 입력 객체 validation 처리(주석참조:2-2)
		1. delegate 연결- Validation을 위해 Delegate연결 - extention에 선언
		2. Delegate 채택
		3. textView에 text가 입력 될때마다 실행되는 메소드를 선언
		4. validation 실행 함수 구현
		5. titleTextField체크
		6. title이 변경되면 validation 함수를 실행
		7. dateTextField체크
		8. dateTextField가 변경되면 Validation 함수를 실행
		9. viewDidLoad() - self.configureInputField()
		10. datePicker가 변경되어 textField가 변경되어도 .editingChanged가 발생되지 않는다 - self.dateTextField.sendActions(for: .editingChanged)
	3. collectionView에 보이도록 처리
		1. 모델 Diary.swift(struct) 구성 
		2. viewController에서 Diary 리스트 선언 
		3. writeDiaryViewController에서 Delegate정의 - Delegate를 통해서 DiaryList에 작성된 diary객체를 전달하기 위한 용도
			1. writeDiaryViewController에 Protocol 정의 - writeDiaryDelegate: AnyObject { func didSelectRegister(diary: Diary) }
			2. delegate 변수 선언 - weak var delgate: WriteDiaryDelegate? 
			3. tabConfirmButton이 호출 될때(등록버튼을 눌렀을때) Diary객체를 생성하고 Delegate에 정의한 didSelectRegister메소드를 호출해서 메서드 파라메터에 생성된 diary객체를 전달해준다
			4. Delegate를 통행 작성된 diary가 전달될 준비가 되었다면 ViewController에서 받을준비를 한다.
		4. ViewController에서 받을 준비
			1. diary작성 후 화면 이동은 segue통해서 이동하기 떄문에 prepare메서드를 override
				1. segue가 이동한 controller가 무었인지 알수 있도록 작성
				2. delegate위임, protocol 채택
					1. diaryList에 전달된 diary객체 추가
				3. diaryList에 추가된 diary를 collectionView에 표시되도록 구현
					1. collectionView의 속성을 구성하는 함수 작성 - configureCollectionView()
						1. delegate, dataSource = self
							1. delegate, dataSource에서 필수로 구현해야하는 메서드 (numberOfItemsInSection, cellForItemAt)
							2. numberOfItemsInSection -> self.diaryList.count
							3. cellForItemAt
						2. UICollectionViewDelegateFlowLayout를 채택하여 collectionView에 레이아웃 구성
		5. Userdefaults를 사용하여 일기 저장
			1. diary를 UserDefaults에 딕셔너리 형태로 저장하는 함수 작성
			2. diaryList didSet diaryList프로퍼티 옵저버로 변경시 업데이트 되도록 구현 - saveDiaryList()
			3. userDefaults에 저장된값을 가져오는 함수 구현 - loadDiaryList()
			4. viewDidLoad에서 호출
	4. Diary 상세보기
		1. 일기 상세보기화면 IBOutlet, IBAction 연결 - DiaryDetailViewController
		2. diaryList 에서 전달받을 프로퍼티 선언 - View(Outlet객체)에 초기화
		3. viewController에서 객체를 이동시키는 코드 작성 
			1. UICollectionViewDelegate 채택
			2. didSelectItemAt 구현 - 특정cell이 선택되었음을 알리는 메서드
				1. 델리게이트를 채택하고 storyboard의 identifier로 view를 연결해서 값을 넘기고 NavigationController에서 view를 push
	5. Diary 삭제 - Delegate를 통해서 일기장 상세 화면에서 삭제가 일어날때 메서드를 통해 일기장 리스트 화면의 indexpath를 전달하여 diaryList[], CollectionView에서 diary를 삭제
		1. protocol 선언 및  indexPath전달 메서드 선언
		2. delegate변수 선언
		3. 삭제버튼 Action함수에서 didSelectDelete메서드에 indexPath 할당 - NavigationController.popViewController로 전화면으로 이동
		4. DiaryDetailViewController의 delegate에 접근해서 self대입  - item을 선택했을때
		5. 삭제를 위한 delegate채택 및 didSelectDelete 구현
