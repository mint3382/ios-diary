# 📖일기장

![](https://hackmd.io/_uploads/Bk88JsYTn.png)
> 프로젝트 기간: 23.08.28 ~ 23.09.15

## 📖 목차
1. [🍀 소개](#소개)
2. [💻 실행 화면](#실행-화면)
3. [🧨 트러블 슈팅](#트러블-슈팅)
4. [📚 참고 링크](#참고-링크)
5. [👥 팀](#팀)

</br>

<a id="소개"></a>

## 🍀 소개
일기를 작성, 수정, 삭제, 공유 할 수 있는 앱
> 지원 언어 : 한국어, English

</br>

<a id="실행-화면"></a>

## 💻 실행 화면

| 일기 목록 스크롤 | 일기 내용 보기 |
|:--------:|:--------:|
|<img src="https://github.com/bubblecocoa/storage/assets/67216784/df3191b2-fdda-46f0-9953-5ece1a232ba5" alt="diary_scroll" width="250">|<img src="https://github.com/bubblecocoa/storage/assets/67216784/771da24b-a121-48b7-ae43-5ed37a49be20" alt="diary_detail" width="250">|

| 키보드 영역 겹침 방지 | 일기 추가 |
|:--------:|:--------:|
|<img src="https://github.com/bubblecocoa/storage/assets/67216784/4b12fde6-a814-45a3-a3e1-7905a740fef9" alt="diary_keyboard" width="250">|<img src="https://github.com/bubblecocoa/storage/assets/67216784/9292db31-5391-46a6-85fe-4c72201937ae" alt="diary_push_add_diary_view" width="250">|

| 일기 삭제 | 일기 공유 |
|:--------:|:--------:|
|<img src="https://github.com/bubblecocoa/storage/assets/67216784/e4b5a412-357d-4da8-bb21-97aea0c67c5c" alt="diary_delete" width="250">|<img src="https://github.com/bubblecocoa/storage/assets/67216784/4395c0af-56af-43a1-8381-cff8a262beb4" alt="diary_share" width="250">|

| 일기 수정 |
|:--------:|
|<img src="https://github.com/bubblecocoa/storage/assets/67216784/f0102b0f-8618-447e-b87c-16c07bb4844c" alt="diary_edit" width="250">|

</br>

<a id="트러블-슈팅"></a>

## 🧨 트러블 슈팅
###### 핵심 트러블 슈팅위주로 작성하였습니다.
1️⃣ **Swift Lint 규칙변경** <br>
-
🔒 **문제점** <br>
`Pod`을 통해 `SwiftLint`를 설치하고 프로젝트에 적용했습니다. `Lint`는 프로젝트 빌드 시 코드 컨벤션에 대한 경고를 띄워주었고, 경고를 모두 없애면 전체적으로 읽기 좋은 코드가 되었습니다.
하지만 `Lint`를 모두 따르기에는 어색한 부분이 있었는데, 줄바꿈에 대한 부분이었습니다.
> `SwiftLint`가 경고를 띄우는 부분
```swift
struct 구조체 {
    let 프로퍼티1
    let 프로퍼티2
    // Trailing Whitespace Violation: Lines should not have trailing whitespace (trailing_whitespace) 
    func 메서드1() {}
    func 메서드2() {}
    // Trailing Whitespace Violation: Lines should not have trailing whitespace (trailing_whitespace)
    enum 열거형 {
        case 경우1
        case 경우2
    }
}
```
저희 팀은 줄바꿈은 `SwiftLint`의 제안을 받아들이기보다 저희의 컨벤션을 지키고 싶었으나, `XCode`의 `Issue Navigator`에 `Lint`로 인한 경고가 많이 누적되는것을 보고싶지 않았습니다.

🔑 **해결방법** <br>
`SwiftLint`의 기본 옵션을 변경할 수 있다는 것을 알게 되었습니다.
[SwiftLint Rule](https://realm.github.io/SwiftLint/rule-directory.html)에 따르면 경고에 계속 노출되었던 `trailing_whitespace`는  줄 뒤에 공백이 있어서는 안 됨을 의미합니다.
프로젝트 `root` 경로에 `.swiftlint.yml` 파일을 만들고 내부에 다음 내용을 작성했습니다.
```yml
# 기본 활성화된 룰 중에 비활성화할 룰을 지정
disabled_rules:
    - trailing_whitespace
```
`disabled_rules`에 `trailing_whitespace`를 추가함으로써 `Lint`가 줄바꿈 관련된 경고를 띄우지 않도록 변경했습니다.

<br>


2️⃣ **일기 작성 및 수정 시 textView 개수 선택** <br>
-
🔒 **문제점** <br>
제목과 본문의 구현을 어떻게 해야할지에 대한 고민이 있었습니다. 제목 `textView`와 본문 `textView`를 나누고 `stackView`에 넣어줄 경우 여러가지 문제점이 생겼습니다. 
1. 제목에 특정한 제약을 주지 않아 길어지게 되서 한 화면을 전부 차지하게 될 경우 본문 `textView`로 넘어갈 수가 없다.
2. 본문 `textView`를 스크롤 할 경우 제목은 올라가지 않고 계속 남아있게 된다.


🔑 **해결방법** <br>
`textView`를 제목과 본문으로 나누지 않고 `contentTextView`라는 하나의 `textView`에서 제목과 본문을 모두 입력받을 수 있게 변경하여 처리하였습니다.

<br>

3️⃣ **iOS 타겟 버전 변경 - UIKeyboardLayoutGuide** <br>
-
🔒 **문제점** <br>
키보드를 사용할 때 글자를 가리는 일이 생겨 `textView`도 같이 올려주는 방법에 대한 고민이 있었습니다. 그 중에서도 두가지 방법을 찾을 수 있었습니다.
1. `Notification`을 사용하여 키보드가 올라올 때마다 키보드의 `contentInset`을 빼주는 방법
2. `keyboardLayoutGuide`를 제약 조건에 적용하는 방법

간단하기는 2번이 간단했지만 `iOS 15.0` 부터 사용할 수 있어 고민이 있었습니다.


🔑 **해결방법** <br>
1번의 방법을 사용할 때 `keyboardFrameEndUserInfoKey`을 사용합니다. 그런데 [keyboardFrameEndUserInfoKey](https://developer.apple.com/documentation/uikit/uiresponder/1621578-keyboardframeenduserinfokey) 공식문서를 보면 다음 내용이 있었습니다.
> Important
>
> Instead of using this key to track the keyboard’s frame, consider using UIKeyboardLayoutGuide, which allows you to respond dynamically to keyboard movement in your app. For more information, see [Adjusting Your Layout with Keyboard Layout Guide](https://developer.apple.com/documentation/uikit/keyboards_and_input/adjusting_your_layout_with_keyboard_layout_guide).
> 
> 이 키를 사용하여 키보드 프레임을 추적하는 대신 앱의 키보드 움직임에 동적으로 반응할 수 있는 UIKeyboardLayoutGuide를 사용하는 것이 좋습니다. 자세한 내용은 [키보드 레이아웃 가이드로 레이아웃 조정](https://developer.apple.com/documentation/uikit/keyboards_and_input/adjusting_your_layout_with_keyboard_layout_guide)을 참조하세요.
 
[UIKeyboardLayoutGuide](https://developer.apple.com/documentation/uikit/uikeyboardlayoutguide)는 `iOS 15.0` 이후로 지원하기 때문에 2번의 방법을 선택하여 진행하였습니다.

<br>

4️⃣ **지역화 적용** <br>
-
🔒 **문제점** <br>
날짜 관련된 문자열을 출력하기 위해 `DateFormatter`의 확장에 다음 메서드를 추가했습니다.
```swift
func configureDiaryDateFormat() {
    dateStyle = .long
    timeStyle = .none
    locale = Locale(identifier: "ko_KR")
    dateFormat = "yyyy년 MM월 dd일"
}
```
하지만 이렇게 날짜 포맷을 지정할 경우 사용자가 어떠한 `Locale`을 선택하더라도 'XXXX년 XX월 XX일' 형태로 출력되게 됩니다.

🔑 **해결방법** <br>
```swift
func configureDiaryDateFormat() {
    dateStyle = .long
    timeStyle = .none
    locale = Locale(identifier: Locale.current.identifier)
}
```
`DateFormatter`의 `locale`을 현재의 `Locale.current.identifier`를 통해 인식하도록 했습니다. 이 값은 디바이스의 `설정` - `일반` - `언어 및 지역`의 정보를 가져오게 됩니다. 이것으로 사용자 각각의 `Locale`에 맞게 날짜가 포매팅 되어 출력됩니다.

<br>


5️⃣ **layoutMarginsGuide** <br>
-
🔒 **문제점** <br>
`tableView`의 `Custom Cell`을 설정할 때 제약조건을 `ContentView`에 맞췄더니 글자들이 `leading`에 딱 붙어서 표시되었습니다. 
``` swift
private func configureCellConstraint() {
    NSLayoutConstraint.activate([
        contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
        contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
}
```
이를 `seperate line`에 맞게 보기 좋은 간격을 주기 위한 고민이 있었습니다. 


🔑 **해결방법** <br>
`layoutMarginGuide`라는 여백 기준을 사용하여 간격을 맞춰주었습니다. 
```swift
private func configureCellConstraint() {
    NSLayoutConstraint.activate([
        contentStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
        contentStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
        contentStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        contentStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
    ])
}
```
`readableContentGuide`를 이용하여 간격을 줄 수도 있지만 넓은 아이패드 같은 화면에서 사용하게 되는 경우 퍼지는 것을 잡아주는 데에 사용하는 가이드인데 현재의 프로젝트에서는 `layoutMarginGuide`로도 충분할 것 같아서 이것을 사용하였습니다.

<br>

6️⃣ **UUID** <br>
-
🔒 **문제점** <br>
일기를 수정﹒삭제 하기 위해 `CoreData`로부터 일기를 구분하기 위한 `Identifier`가 필요했습니다.
일기 `Entity`의 `Attribute`에 있는 값은 `title: String`, `body: Stirng?`, `date: Date` 세가지 였는데, 이 중 무엇하나 식별자로 사용 가능한 값이 없었습니다. 일기 제목, 내용, 작성날짜 모두 같은 일기가 존재 할 수 있었기 때문입니다.

🔑 **해결방법** <br>
`Entity`의 `Attribute`에 `id: UUID`를 추가했습니다. `UUID`는 범용 고유 식별자로 단순히 이것을 추가하는 것만으로 각각의 일기를 명확하게 구분할 수 있게 됩니다. `UUID`를 가지고 있는 경우 해당 `Entity`의 `title`, `body`의 내용이 바뀌어도 새로운 객체나 다른 객체에 내용이 작성되는 것이 아닌 현재의 객체에 정확하게 내용이 작성﹒업데이트 되는 것을 확인할 수 있었습니다.

<br>

7️⃣ **UIContextualAction 커스텀** <br>
-
🔒 **문제점** <br>
`UIContextualAction`의 `activityItems`에 일기 제목, 일기 내용을 넣을 경우 공유 될 내용이 아래 이미지처럼 미리보기로 출력됩니다.
![](https://hackmd.io/_uploads/BJidTmuA3.png)
이 문제를 해결하기 위해 일기 제목과 일기 내용을 하나의 문자열로 합치고, 중간에 줄바꿈 기호 `\n`을 추가하는 방식을 적용 해봤습니다.
문자열은 원하는 형태로 출력되었으나 폰트 스타일은 여전히 저희가 원하는 형태가 아니었습니다.
|현재 출력 방식|내용 합치고 줄바꿈 적용 시|원하는 표현 방식|
|-|-|-|
|**일반 텍스트**<br>일기 제목 및 일기 내용|일기 제목<br>일기 내용|**일기 제목**<br>일기 내용|

🔑 **해결방법** <br>
**UIActivityItemSource 및 LinkPresentation 프레임워크를 이용**

기존 방법에서 출력되는 Activity Items는 실제로 공유할 내용에 대한 것들만 미리보기로 출력할 수 있었습니다. 때문에 UIActivityItemSource로는 공유할 내용을 따로 지정하고 LinkPresentation 프레임워크는 원하는 표현 방식으로 미리보기를 구현하는 과정에서 필요를 느껴 import 해주었습니다.

![](https://hackmd.io/_uploads/H1Q3W4uC3.png)

먼저 UIActivityItemSource 프로토콜을 채택하면 공유할 개체가 데이터 공급자가 되어 항목에 대한 액세스 권한을 View Controller에 제공합니다.

- 공유할 데이터에 대해 placeHolder로 사용할 수 있는, 실제 데이터는 아니지만 그에 가깝게 표시하는 값을 return 합니다.

    ```swift
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return diary.title
    }
    ```
- 공유하고자 하는 데이터를 리턴합니다.

    ```swift
    func activityViewController(
        _ activityViewController: UIActivityViewController,
        itemForActivityType activityType: UIActivity.ActivityType?
    ) -> Any? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.configureDiaryDateFormat()
        
        let formattedDate = dateFormatter.string(from: diary.date)
        let sharedData = "\(formattedDate)\n\n\(diary.title)\n\n\(diary.body ?? "")"
        
        return sharedData
    }
    ````
- LinkPresentation 프레임워크가 기본 컴포넌트로 존재하고 있어서 사용해보았습니다. 해당 프레임워크는 메타 데이터를 활용하여 원하는 데이터를 유저에게 표시하며 쉽게 공유할 수 있게 만들어 줍니다. 이를 UIActivityItemSource에 구현되어 있는 메서드와 함께 사용하면 공유할 때 커스텀한 미리보기를 사용할 수 있습니다.

    ```swift
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        
        metadata.title = diary.title
        metadata.originalURL = URL(fileURLWithPath: (diary.body ?? ""))
        
        return metadata
    }
    ```

<br>

8️⃣ **Background 전환시 일기 자동 저장** <br>
-
🔒 **문제점** <br>
일기 작성 중 홈으로 나가는 경우 메모리 부족으로 인해 앱이 종료되어 현재 작성중인 텍스트가 모두 사라질 수 있습니다. 이 경우를 대비하기 위해 앱이 백그라운드로 전환되기 전 일기를 저장하는 로직이 필요했습니다. 해당 `ViewController`에서 백그라운드로 전환되는 것을 인식할 수 있나 싶었으나, 일기가 저장되는 것은 `DiaryViewController`만의 문제가 아니기 때문에 다른 방식으로 백그라운드 전환을 인식할 수 있어야 했습니다.

🔑 **해결방법** <br>
`SceneDelegate`의 `sceneDidEnterBackground(_:)`메서드를 활용했습니다. 저희는 기존 `SceneDelegate`내에 `NSPersistentContainer`를 이미 구현해두었고, 모든 `ViewController`가 해당 `PersistentContainer`를 의존성 주입받아 사용하고 있기 때문에 현재 `PersistentContainer`의 `viewContext.save()`를 해주어 손쉽게 변경 내용을 저장할 수 있었습니다.

<br>

9️⃣ **weak self** <br>
-
🔒 **문제점** <br>
```swift
private func configureNavigationItem() {
    let action = UIAction { _ in
        self.showActionSheet()
    }
    let barButtonItem = UIBarButtonItem.init(
        image: UIImage.init(systemName: "ellipsis.circle"),
        primaryAction: action
    )
    
    navigationItem.rightBarButtonItem = barButtonItem
}
```
```swift
private func showActionSheet() {
    let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let shareAction = UIAlertAction(title: String(localized: "Share"), style: .default) { _ in
        self.shareDiary(data: self.diary)
    }
    let deleteAction = UIAlertAction(title: String(localized: "Delete"), style: .destructive) { _ in
        self.presentDeleteConfirmAlert(by: { self.deleteDiary()})
    }
    let cancelAction = UIAlertAction(title: String(localized: "Cancel"), style: .cancel)
    
    sheet.addAction(shareAction)
    sheet.addAction(deleteAction)
    sheet.addAction(cancelAction)
    
    present(sheet, animated: true)
}
```
메서드 내 `closure capture`에는 반복적으로 `self`가 호출되고 있습니다. 코드를 계속 타고 들어가면 언젠가는 순환참조인지 아닌지 확인할 수 있겠지만, 코드 파악이 어려워 어느 순간 순환참조임을 놓칠 수 있습니다.


🔑 **해결방법** <br>
해결 방법에 앞서 저희가 순환참조가 일어나는지 알아보기 위해 사용한 방법입니다.
1. `ViewController`의 `deinit` 호출 확인
    - `ViewController`가 화면에서 사라졌을 때 `deinit`이 호출되지 않으면 순환참조일 수 있습니다.
2. `Debug Memory Graph` 메뉴를 이용해 시각적으로 순환참조가 발생하고 있는지 확인
    - 도형과 화살표로 표기되는 관계 중 순환적으로 보이는 부분이 있다면 순환참조입니다.
3. `lldb`에서 `CFGetRetainCount`를 이용해 참조 카운트 확인
    - 메서드가 종료된 후에도 카운트에 변화가 없다면 순환참조일 수 있습니다.
4. `self`를 캡쳐하고 있는 함수를 반복적으로 호출하여 메모리 사용량 증가 확인
    - 메모리가 증가하기만 하고 일정수치까지 내려오는 과정이 없다면 순환참조일 수 있습니다.

위 방법들 중 가장 명확한 방법은 4번 이었습니다. 1~3번 방법에는 휴먼에러로 놓칠 수 있는 부분이 있지만, 4번의 경우 메모리 증가가 명확하기 때문입니다. 저희는 분명 순환참조가 발생하고 있었지만 2번으로 순환점을 찾는것에는 실패했습니다.

```swift
private func configureNavigationItem() {
    let action = UIAction { [weak self] _ in
        guard let self else {
            return
        }
        
        self.showActionSheet()
    }
    let barButtonItem = UIBarButtonItem.init(
        image: UIImage.init(systemName: "ellipsis.circle"),
        primaryAction: action
    )
    
    navigationItem.rightBarButtonItem = barButtonItem
}
```
```swift
private func showActionSheet() {
    let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let shareAction = UIAlertAction(title: String(localized: "Share"), style: .default) { [weak self] _ in
        guard let self else {
            return
        }
        
        self.shareDiary(data: self.diary)
    }
    let deleteAction = UIAlertAction(title: String(localized: "Delete"), style: .destructive) { [weak self] _ in
        guard let self else {
            return
        }
        
        self.presentDeleteConfirmAlert(by: { self.deleteDiary()})
    }
    let cancelAction = UIAlertAction(title: String(localized: "Cancel"), style: .cancel)
    
    sheet.addAction(shareAction)
    sheet.addAction(deleteAction)
    sheet.addAction(cancelAction)
    
    present(sheet, animated: true)
}
```
결론적으로 `self`를 캡쳐하고 있는 모든 부분에 `[weak self]` 를 추가해주는 것으로 반복적인 메소드 호출에도 메모리가 더이상 증가하지 않고 일정수치를 유지하는 것을 확인했습니다.
순환참조가 발생하지 않는다고 확신한다면 `[weak self]`를 붙이지 않아도 상관없지만, 사용되는 메서드 내부적으로 언제 `self`를 필요로 할지, 또 그것이 순환참조를 발생시킬 지 알 수 없기 때문에 `self`를 사용 할 일이 생긴다면 항상 `[weak self]`를 붙여주는 것으로 결론지었습니다.

<br>

1️⃣0️⃣ **CoreDataManageable** <br>
-
🔒 **문제점** <br>
처음에는 `CoreData`가 `SceneDelegate`에서 직접 `container`가 생성되는 구조였습니다. 그러나 `SceneDelegate`가 그러한 역할을 한다는 점이 어색하여 객체로 분리하기 위한 과정이 필요했습니다. 이때 두 가지 주의점이 있었습니다.
>1. `CoreData Manager`는 `CoreData`를 사용한다면 필요한 관리 객체는 전부 사용할 수 있게 해야 한다.
>2. `Diary`는 `CoreDataManager`를 사용해 `Diary`를 생성, 저장, 삭제하는 `Diary` 전용 `Manager`가 필요하다.

🔑 **해결방법** <br>
때문에 저희는 `CoreDataManageable Protocol`과 `DiaryService` 객체를 만들었습니다. `DiaryService`는 `CoreDataManageable`을 채택하고 있어 `CoreDataManage`와 같은 역할을 수행하면서도 `Diary` 전용 `Manager`의 역할을 수행할 수 있습니다. 또한 처음 `SceneDelegate`에서 이 `DiaryService`를 한번 만든 후 그대로 `ViewController`들은 주입 받아서 사용하기 때문에 의존성 방향을 일관적으로 주입할 수 있었습니다. 추가로 수정사항이 필요한 경우도 `DiaryService`만 수정하면 되기에 개방 폐쇄의 원칙을 지킬 수 있었습니다.


<br>

1️⃣1️⃣ **API Key 은닉화** <br>
-
🔒 **문제점** <br>
`API KEY`는 외부에 노출이 되어서는 안되는 키입니다. 때문에 이를 은닉화 하기 위해 `info.plist` 파일을 새로 생성하는 방법을 선택하였습니다. 그런데 이를 가져와서 사용할 때 필요한 `NSDictionary`의 기존 초기화 방법이 `deprecated`되어 더는 사용할 수 없게 된 문제가 있었습니다. 

[deprecated된 초기화](https://developer.apple.com/documentation/foundation/nsdictionary/1414949-init)


🔑 **해결방법** <br>
새롭게 제공되어 있는 초기화 방법을 이용해 해결하였습니다.

[새롭게 제공된 초기화](https://developer.apple.com/documentation/foundation/nsdictionary/2879140-init)

<br>

1️⃣2️⃣ **where Self: Type** <br>
-
🔒 **문제점** <br>
protocol을 사용할 때 특정한 Type에서만 채택할 수 있게 해주고 싶었습니다. 그래야 extension에서 함수를 구현할 때도 가능한 동작이 있었고 때문에 매개변수로 항상 타입을 받아와야 했습니다.

```swift
protocol DiaryAlertPresentable { }

extension DiaryAlertPresentable {
    func showDeleteConfirmAlert(in viewController: UIViewController, by action: @escaping () -> Void) {
    }
}
```

🔑 **해결방법** <br>
where Self: Type으로 채택할 수 있는 Type을 제한해 줌으로서 해결하였습니다.

```swift
protocol DiaryAlertPresentable where Self: UIViewController { }

extension DiaryAlertPresentable {
func presentDeleteConfirmAlert(by action: @escaping () -> Void) {
    }
}
```

<br>

<a id="참고-링크"></a>

## 📚 참고 링크
- [🍎Apple Docs: keyboardFrameEndUserInfoKey](https://developer.apple.com/documentation/uikit/uiresponder/1621578-keyboardframeenduserinfokey)
- [🍎Apple Docs: Adjusting Your Layout with Keyboard Layout Guide](https://developer.apple.com/documentation/uikit/keyboards_and_input/adjusting_your_layout_with_keyboard_layout_guide)
- [🍎Apple Docs: UIKeyboardLayoutGuide](https://developer.apple.com/documentation/uikit/uikeyboardlayoutguide)
- [🍎Apple Docs: Metatdata](https://developer.apple.com/documentation/avfoundation/avcapturephotosettings/2875951-metadata)
- [🍎Apple Docs: UUID](https://developer.apple.com/documentation/foundation/uuid)
- [🍎Apple Docs: Link Presentation](https://developer.apple.com/documentation/linkpresentation)
- [🍎Apple Docs: sceneDidEnterBackground(_:)](https://developer.apple.com/documentation/uikit/uiscenedelegate/3197917-scenedidenterbackground)
- [🍎Apple Docs: UIActivityItemSource](https://developer.apple.com/documentation/uikit/uiactivityitemsource)
- [🍎Apple Docs: init(contentsOf:error:)](https://developer.apple.com/documentation/foundation/nsdictionary/2879140-init)
- [🍎Apple Docs: Core Location](https://developer.apple.com/documentation/corelocation)
- [🍎Apple Docs: CFGetRetainCount(_:)](https://developer.apple.com/documentation/corefoundation/1521288-cfgetretaincount)
- <Img src = "https://github.com/mint3382/ios-calculator-app/assets/124643545/56986ab4-dc23-4e29-bdda-f00ec1db809b" width="20"/> [야곰닷넷: Swift Lint 써보기](https://yagom.net/forums/topic/swift-lint-%EC%8D%A8%EB%B3%B4%EA%B8%B0/)
- <Img src = "https://github.com/mint3382/ios-calculator-app/assets/124643545/56986ab4-dc23-4e29-bdda-f00ec1db809b" width="20"/> [야곰닷넷: LinkPresentation](https://yagom.net/forums/topic/linkpresentation/)
- <Img src = "https://hackmd.io/_uploads/ByTEsGUv3.png" width="20"/> [blog: [iOS] Swiftlint 룰 적용하기](https://velog.io/@whitehyun/iOS-Swiftlint-%EB%A3%B0-%EC%A0%81%EC%9A%A9%ED%95%98%EA%B8%B0)

</br>

<a id="팀"></a>

## 👥 팀

### 👨‍💻 팀원
| 🤖BMO🤖 | 😈MINT😈 |
| :--------: | :--------: |
| <img src="https://hackmd.io/_uploads/BJdXmAAph.jpg" width="200" height="200"> | <img src="https://hackmd.io/_uploads/ByLbQ0RT2.jpg"  width="200" height="200"> |
|[Github Profile](https://github.com/bubblecocoa) |[Github Profile](https://github.com/mint3382) |

</br>

- [팀 회고 링크](https://github.com/mint3382/ios-diary/wiki)