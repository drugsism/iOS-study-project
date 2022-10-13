## Calculrator

### UIStackView
> 열 또는 행에 View들의 묶음을 배치할 수 있는 간소화된 인터페이스

1. Axis
	- stackView의 방향을 결정(가로 또는 세로) 하는 속성
2. Distribution
	- StackView안에 들어가는 뷰들의 사이즈를 어떻게 분배할지 설정하는 속성
		1. Fill: 서브뷰들의 크기를 재조정
		2. Fill Equally: 서브뷰들의 크기를 재조정
		3. Fill Propotionally
		4. Equal Spacing
		5. Eual Centering
3. Alignment
	- StackView의 서브뷰들을 어떤식으로 정렬할지 결정하는 속성
		1. Fill
		2. Leading
		3. Top
		4. First Baseline
		5. Center
		6. Trailing
		7. Bottom
		8. Last Baseline
4. Spaicing
	- StackView안의 서브뷰들간의 간격을 조정하는 속성

<br />
<image src="https://user-images.githubusercontent.com/16550019/195497551-b0ebee43-1231-47d3-b8c4-199e16f92192.png" width="500" />
<br />

### IBDesignables
>코드로 구현하여 컴파일 시점에서 적용될 속성을 실시간으로 스토리보드 상에 렌더링해준다.


### IBInspectable
>커스텀한 UIView컨포넌트에서 inspector창을 이용해서 보다 쉽게 속성을 적용하도록 하는 어노테이션
