## AIFFEL Campus Online Code Peer Review Templete
- 코더 : 김기홍
- 리뷰어 : 김재이


## PRT(Peer Review Template)

- [O]  **1. 주어진 문제를 해결하는 완성된 코드가 제출되었나요?**
    - 문제에서 요구하는 최종 결과물이 첨부되었는지 확인
    - 문제를 해결하는 완성된 코드란 프로젝트 루브릭 3개 중 2개, 
    퀘스트 문제 요구조건 등을 지칭
        - 해당 조건을 만족하는 부분의 코드 및 결과물을 근거로 첨부
```
class MyAppState extends State<MyApp> {
  int _selectedIndex = 1;

  // Navigator 키 생성
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  final List<Widget> _widgetOptions = <Widget>[
    const Text(
      'First Screen',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    ),
    const Text(
      'Second Screen',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    ),
    const Text(
      'Third Screen',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    ),
    const Text(
      'Fourth Screen',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
```
...
가장 중요한 부분이었던 화면 전환이 잘 동작했습니다.
화면 구성도 모두 완성되어 있었습니다.
    
- [O]  **2. 전체 코드에서 가장 핵심적이거나 가장 복잡하고 이해하기 어려운 부분에 작성된 
주석 또는 doc string을 보고 해당 코드가 잘 이해되었나요?**
    - 해당 코드 블럭에 doc string/annotation이 달려 있는지 확인
    - 해당 코드가 무슨 기능을 하는지, 왜 그렇게 짜여진건지, 작동 메커니즘이 뭔지 기술.
    - 주석을 보고 코드 이해가 잘 되었는지 확인

     잘 이해가 되었습니다.
        
- [O]  **3. 에러가 난 부분을 디버깅하여 문제를 “해결한 기록을 남겼거나” 
”새로운 시도 또는 추가 실험을 수행”해봤나요?**
    - 문제 원인 및 해결 과정을 잘 기록하였는지 확인 또는
    - 문제에서 요구하는 조건에 더해 추가적으로 수행한 나만의 시도, 
    실험이 기록되어 있는지 확인
        - 잘 작성되었다고 생각되는 부분을 근거로 첨부합니다.

```
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            //fixed, shifting
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'First',
                  backgroundColor: Colors.lightBlue),
...
```

        
- [O]  **4. 회고를 잘 작성했나요?**
    - 주어진 문제를 해결하는 완성된 코드 내지 프로젝트 결과물에 대해
    배운점과 아쉬운점, 느낀점 등이 상세히 기록되어 있는지 확인

https://github.com/KIHONG-KIM/AIFFEL_quest/blob/main/Flutter_quest/Quest04/%EA%B8%B0%ED%99%8D_QUEST04.md
회고도 잘 작성되어 있었고, 따로 정리도 해 주셨습니다.
    ```
textAlign: TextAlign.center,       // 텍스트 정렬
textDirection: TextDirection.ltr,  // 텍스트 방향
locale: Locale('en', 'US'),        // 텍스트의 로케일
softWrap: true,                    // 텍스트가 화면에 맞추어 줄바꿈되는지 여부
overflow: TextOverflow.ellipsis,   // 텍스트 오버플로우 처리 방식
textScaleFactor: 1.0,              // 텍스트의 크기 배율
maxLines: 1,                       // 최대 줄 수
    ```

- [O]  **5. 코드가 간결하고 효율적인가요?**
    - 코드 중복을 최소화하고 범용적으로 사용할 수 있도록 모듈화(함수화) 했는지
        - 잘 작성되었다고 생각되는 부분을 근거로 첨부합니다.

위젯들을 객체화하셔서 메인 실행코드가 간결하도록 작성해주셨습니다.


구현하고자 하시는 앱의 목적이 잘 성취되도록 작성된 코드였습니다! 알아보기 쉽게 작성해주셔서 감사합니다. : )
