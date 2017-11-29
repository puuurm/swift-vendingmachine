## 음료수 자판기

### step 1

#### 요구사항

- 객체지향 프로그래밍 방식으로 예시 음료를 추상화하는 클래스를 설계한다
  - 예) 우유 - 딸기우유, 초코우유, 바나나우유/ 탄산음료 - 콜라, 사이다, 환타/ 커피 - TOP, 칸타타, 조지아
- 음료수 클래스를 출력하기 위해 CustomStringConvertible 프로토콜을 채택하고 구현한다.

#### 해결: 상속과 프로토콜 구현

- 클래스 상속
  - Drink 클래스를 만들고 Drink를 상속받는 Milk, SoftDrink, Fanta 클래스를 생성하였다.
  - 딸기우유, 초코우유, 바나나우유를 만들어 Milk를 상속받는다. 탄산음료, 환타도 동일.
- 프로토콜 구현
  - CustomStringConvertible의 프로퍼티인 description을 오버라이드 하여 구현.
  - 출력 형식은 String(format:)을 활용한다.

### step 2

#### 요구사항

- 상속받은 하위 클래스에 고유한 속성 혹은 메소드를 하나 이상 추가
- 음료수 클래스 인터페이스를 테스트하기 위한 테스트 코드 작성
- 객체 클래스 명이 출력되도록 개선

#### 해결

- 클래스에 고유한 속성과 메소드 추가
- 유통기한을 확인하는 메소드("20171117"을 Date 형식으로 변경하여 비교하하는 메소드)나 단위 스트링을 인트값으로 변경하는 메소드("200mg"을 200으로 변경하는 메소드)처럼 내부 계산 로직이 들어있는 인터페이스에 대한 테스트 코드 작성
- 객테 클래스 명을 출력하기 위해 NSObject의 className 활용

### step 3

#### 요구사항

- 자판기 구조체를 설계하고, 다음과 같은 동작을 위한 메소드 작성
  - 자판기 금액을 원하는 금액만큼 올리는 메소드
  - 특정 상품 인스턴스를 넘겨서 재고를 추가하는 메소드
  - 현재 금액으로 구매 가능한 음료수 목록을 리턴하는 메소드
  - 음료수를 구매하는 메소드
  - 잔액을 확인하는 메소드
  - 전체 상품 재고를 종류별로 리턴하는 메소드
  - 유통기한이 지난 재고만 리턴하는 메소드
  - 따뜻한 음료만 리턴하는 메소드
  - 시작 이후 구매 상품 이력을 배열로 리턴하는 메소드
- 입출력 구조체 구현
- 통합 테스트 시나리오를 가지고 동작 확인

#### 해결 및 피드백 내용

- 클래스나 구조체의 프로퍼티 타입 전부 변경
  - 클래스(or 구조체) 초기화 인자가 스트링 값이어도 스트링보다 데이터를 잘 표현해주는 데이터 타입이 있다면, 그것으로 변경해야 한다. 
  - 초기화 인자가 잘못된 스트링 값일 경우 인스턴스를 만들 수 없으므로 failable initializer를 사용한다.
- try 메소드 관련된 로직만 do 내부에 구현한다. 

### step 4

#### 요구사항

 - 자판기에 음료수를 관리하는 관리자 기능과 음료를 구매하는 사용자 기능을 담당하는 구조체를 분리

#### 해결 및 피드백 내용: 디자인 패턴 활용하기

- 입력받는 InputView에서는 VendingMachine에게 명령한다.

- facade pattern: VendingMachine 내부에서는 복잡한 자판기 액션을 수행하는 CoreVendingMachine을 감추고 있다.

- delegate pattern: 입력에 따라 Manager, User 모드가 결정이 되고, Manager와 User는 로직 수행을 CoreVendingMachine에게 위임한다.

  ~~~swift
  // 모드 할당, 모드에 따른 메뉴 생성, 액션 처리 등을 수행한다.
  struct VendingMachine {
      private var enableMode: EnableMode?
    	// 내부에 CoreVendingMachine을 갖고있다.
      private var core: CoreVendingMachine
      init() {
          core = CoreVendingMachine()
      }
    	...
  }
  ~~~

  ~~~swift
  // 관리자 모드에서 사용하는 로직
  protocol ManagerModeDelegate {
      func add(productIndex: Int) throws
    	func deleteInventory(index: Int) throws
  }
  // 유저 모드에서 사용하는 로직
  protocol UserModeDelegate {
    	func add(money: Int) throws
      func buyDrink(index: Int) throws
  }
  // 자판기 주요 로직 구현
  class CoreVendingMachine: ManagerModeDelegate, UserModeDelegate {...}
  ~~~

  ~~~swift
  protocol EnableMode {
      func makeMenu() -> MenuContents
    	func action(action: Action) throws
  }
  ~~~

  ~~~swift
  // 매니저와 유저 구조체에서 makeMenu, action 수행을 CoreVendingMachine에게 위임한다.
  struct Manager: EnableMode {
      var delegate: ManagerModeDelegate
    	init(target: ManagerModeDelegate) {
          delegate = target
      }
    	func makeMenu() -> MenuContents {...}
    	func action(action: Action) throws {...}
  }

  struct User: EnableMode {
      var delegate: UserModeDelegate
    	init(target: UserModeDelegate) {
          delegate = target
      }
    	func makeMenu() -> MenuContents {...}
    	func action(action: Action) throws {...}
  }
  ~~~

- 튜플 형태가 복잡하다면, 새로운 구조체로 생성한다. 

  - 변경 전: typeAlias InputFormat = (option: Int, detail: Int)

  - 변경 후

    ~~~swift
    struct Action {
        private var _option: Option
        enum Option: Int {
            case add = 1
            case delete, exit
        }
        private var _detail: Int
        var option: Option {
            return _option
        }
        var detail: Int {
            return _detail
        }
    }
    ~~~

- 자판기에 재고 프로퍼티를 갖고 있고, 재고 프로퍼티에 음료수 추가/삭제 할 때, 객체 단위로 생각한다.

  변경 전

  ~~~swift
  final class CoreVendingMachine {
      private var inventory: [Drink: Count]
      private var purchases: [Drink: Count]
  }
  ~~~

  변경 후

  ~~~swift
  final class CoreVendingMachine {
      private var inventory: [Drink]
      private var purchases: [Drink]
  }
  ~~~

