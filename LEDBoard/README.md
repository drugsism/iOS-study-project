### Segue(화면전환)
1.  ViewController에서 다른 ViewController 호출
 - 기존 ViewC위에 다른 viewC를 덮는 형식(<> 걷어내는)
 1) present 
	
```swift
func presnt(_ viewControllerToPresentL UIViewController, animated flag: Bool. comletion: (() -> void)? = nil)
```
 2) dismiss

```swift
func dismiss(animated flag: Bool. comletion: (() -> void)? = nil)
```

<br><br>

2. Navigation controller를 사용한 화면 전환
	- Navigation Stack에 lifo된다
	- 계층적인 화면 전환을 표현한다
```swift
func pushViewController(_ viewController: UIViewContoller, animated: Bool)
```

```swift
func popViewController(animated: Bool) -> UIViewContoller?
```
<br><br>

3. 화면전환용 객체 세그웨이(segue)를 사용하여 화면 전환
- ViewController사이의 화면 객체.
- 출발점과 목적지를 지정하여 화면을 전환, 스토리보드로 구현가능
	- Action Segueway - 버튼 등 액션 트리거를 통해 화면전환
   1) show - 가장 일반적으로 사용 NvigationC 사용가능
   2) show Detail - 아애패드에서는 스플릿구조로 사용
   3) present Modally - 이전 뷰컨트롤러를 덮는다
   4) Present As Popover - 아이패드에서 팝업
   5) Custom - 커스텀
<br><br>

### View간 데이터 전달
- ViewContoroller인스턴스 프로퍼티에 전달한 데이터를 set해주는 방법
1. 코드로 구현된 화면전환 방법에서 데이터 전달하기
	- instantiateViewController메소드를 이용해서 스토리보드에 있는 뷰컨트롤러가 인스턴스화 되면 프로퍼티에 접근햇서 데이터 전달
	```swift
	self.storyboard?.instantiateViewController(withIdentifier: "CodePresnentViewController") as? codePresentViewController else { return }
	``` 
2. 세그웨이로 구현된 화면 전환방법에서 데이터 전달하기
	- prepare메소드를 오버라이드하여 메소드안에서 전환하려는 뷰인스턴스르 ㄹ가져오고 프로퍼티에 접근해서 데이터 전달
	```swift
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let viewController = segue.destination as? SeguePushViewController {
		viewController.name = "Data transition to segue"
	}
	```
3. delegate패턴을 이용하여 이전 화면으로 데이터 전달하기
