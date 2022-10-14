## To-Do List

### UITableView
> 데이터를 목록 형태로 보여줄 수 있는 기본적인 UI컴포넌트로 UIScrollView를 상속받아 스크롤을 할 수 있다 
	- Protocol : 
		- UITableViewDelegate - 테이블뷰의 표현을 설정, 행의 액션관리, 엑세서리뷰 지원, 개별행 편집
		- UITableViewDataSource - 데이터를 받아 view를 그려주는 역할

- UITableViewDataSource체택 시 반드시 구현해야하는 메소드
	- numberOfRowsInSection
	- cellForRowAt  

> Todo. 추가, 삭제, 재정렬 
### UIAlertController
> Todo. Alert, Confirm 메시지구현

### Userdefaults
>Todo. 로컬 데이터 저장소에 데이터 저장, 삭제

### review
1. navigationController추가
	- 기본 Root뷰 삭제
	- 진입점 contorolView로 지정(화살표)
	- 마우스로  ViewController와 연결 segue를 Root Controller로 지정
2. Navigation Tab bar Button Item추가
	- tab bar 왼쪽 상단에 위치	- inspector의 system Item을 'Edit'로 수정
	- 하나더 tab bar 오른쪽 상단에 위치 - inspector의 system Item을 'Add'로 수정
3. TableView 추가
	- Add new Constraints - spacing: 0, 0, 0, 0
	- inspector - prototype cells: 1
	- inspector - style: Basic
4. TableView Outlet변수 생성
5. Add버튼 tab시 할일 등록 alert 구현\
		- UIAlertController변수(let alert = UIAlertContrioller) 를 생성
		- UIAlertAction으로 Add, Cancel버튼 생성
		- UIAlertController변수에 addAction으로 버튼을 넣어준다
		-  UIAlertController변수에 addTextField 메소드로 텍스트필드를 넣어준다
			- configurationHandler 클로저에 placeholder를 넣어준다
			{textField in textField.placeholder = "Enter your work to do"}
		- self.present으로 화면에 표시한다
6. Task를 작성할 파일(Task,swift)을 추가하고 title, done(완료여부: Bool)을 속서으로 가지고있는 struct Task 를 생성한다
7. [VC] Task를 관리할 배열을 생성한다.
 ```swift
 let tasks[Task]()
```
8. Alert창에 할일을 입력하고 add버튼을 tab하면 tasks에 task를 추가 하는 로직을 UIAlertAction Add의 클로저로 구현한다.
	- 클로저의 self로 클래스 인스턴스를 참조할 경우 클로저의 캡쳐리스트 개념, 강한참조로 인한 메모리 누수, weak사용이유 확인.
9. viewDidLoad에  self.tableView.dataSource = self, UITableViewDelegate, UITableViewDataSource Protocol 채택
10. UITableViewDataSource의 필수 메서드 구현
```swift
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
	self.tasks.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//dequeueReusableCell - cell을 재사용 예)스크롤시 기존 Cell에 데이터를 교체하여 사용
	let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
	let task = self.tasks[indexPath.row]
	cell.textLabel?.text = task.title
	return cell
}
```

11. UserDefaults 저장 구현
> 런타임 환경에 동작하면서 앱이 실행하는동안 기본저장소에 접근에 데이터를 기록하고 가져오는 인터페이스
> 키값 쌍, 싱글톤, 기본 타입 -NS관련 타입 저장
