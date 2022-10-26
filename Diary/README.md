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
	6. Diary 수정
		1. 수정버튼을 tap하면 write화면으로 이동
		2. 수정할 Diary객체를 받을수 있게 write화면에 enum을 선언  
			1. 선언한 열거형값 초기화
			2. 상세화면에서 값 전달 
			3. 수정버튼을 tap했을때 전달 받은 값을 열거형 switch 문으로 각 데이터를 diary 내용 표시
			4. 수정적용 - confirmButton함수안에서 노티피케이션 센터 구현
				1. notification center를 이용해서 수정이 일어나면 notification center에 수정된 diary객체를 전달하고 notification center를 구독하고 있는 화면에서 수정된 diary객체를 전달받고 View에도 수정된 내용이 갱신되도록 구현
				2. 상세화면에서 NotificationCenter를 구독하게 하고 View에 나타나도록 구현
				3. 인스턴스가 deinit 될때 removeObserver를 호출하여 해당 인스턴스에 추가된 옵저버가 모두 제거되게 한다.
				4. collrctionView에도 적용이되도록 ViewController Viewdidload()에 옵저빙을 구현한다
	7. 즐겨찾기
		1. 상세보기 화면에 barButtonItem을 추가하여 즐겨찾기 버튼을 구성한다
		2. 버튼을 눌렀을때 toggle하는 기능을 구현한다
		3. diary에 즐겨찾기가 적용되도록 구현한다 
			1. DuaryDeatilViewDelegate - didSelectStar
			2. ViewController - diaryList의 해당 diary의 isStar값을 업데이트 한다.
		4. 즐겨찾기 탭에 diary 리스트구현
			1. StarViewController에 outlet 변수 생성 및 연결
			2. diaryList 변수 생성
			3. loadStarDiaryList 함수 구현 - UserDefaults에서 값을 불러와서 DiaryList에 넣어준다
			4. viewWillApper()에 호출한다. -  즐겨찾기 탭을 누를때 가져온다.
			5. collectionView를 구성한다. - Layout구성, Delegate, Datasource 구현
		5. 즐겨찾기 리스트에서 diary를 tap하면 상세화면으로 이동하도록 구현
		6. ! 상세화면에서 삭제 또는 즐겨찾기 토글이 일어나게 되면 delegate를 통해 ViewController에 indexPath와 isStar를 전달하고 있는데
		   ViewController와 StarViewController에 각각 업데이트 되지 않는다. (즐겨찾기 화면에서 이동하면 ViewContorller에는 변경이 적용되지않는다)
		   delegate를 NotificationCenter로 변경하여 모두 전달되도록 변경한다
			1. 

