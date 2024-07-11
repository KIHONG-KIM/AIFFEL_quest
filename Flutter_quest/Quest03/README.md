## AIFFEL Campus Online Code Peer Review Templete
- 코더 : 김기홍
- 리뷰어 : 김주현


## PRT(Peer Review Template)

- [O]  **1. 주어진 문제를 해결하는 완성된 코드가 제출되었나요?**
    - 문제에서 요구하는 최종 결과물이 첨부되었는지 확인
    - 문제를 해결하는 완성된 코드란 프로젝트 루브릭 3개 중 2개, 퀘스트 문제 요구조건 등을 지칭
        - 네. 모든 동작이 요구 조건에 맞추어 깔끔하게 동작하였습니다.
        - 단, is_cat 변수를 출력하는 시점에 대한 혼동이 있었던 것만 아쉬운 부분이었으나, 그것마저도 결과적으로는 잘 동작하였습니다. 
<img src="Screenshot_1720510974.png" alt="스크린샷 1" style="width: 30%; height: 30%;"> <img src="Screenshot_1720510978.png" alt="스크린샷 2" style="width: 30%; height: 30%;">
        
- [O]  **2. 전체 코드에서 가장 핵심적이거나 가장 복잡하고 이해하기 어려운 부분에 작성된 
주석 또는 doc string을 보고 해당 코드가 잘 이해되었나요?**
    - 해당 코드 블럭에 doc string/annotation이 달려 있는지 확인
    - 해당 코드가 무슨 기능을 하는지, 왜 그렇게 짜여진건지, 작동 메커니즘이 뭔지 기술.
    - 주석을 보고 코드 이해가 잘 되었는지 확인
```Dart
                  Container(
                      margin: const EdgeInsets.all(20),
                      // Next 버튼 추가
                      child: ElevatedButton(
                          onPressed: () async {
                            // ps. pop()으로 데이터를 보내는데, 데이터가 출력되지 않아서 한참 헤매다가
                            // async 와 await으로 데이터 받은 부분 비동기 호출을 통해서 출력할 수 있는 것으로 해결!
                            //
                            is_cat = false; // is_cat false로 변경
                            // pushNamed로 두번째 페이지로 전환
                            final result = await Navigator.pushNamed(
                                context, '/second',
                                arguments:
                                    is_cat); // argument에 is_cat 변수 담아서 보내기
                            print('$result'); // 콘솔에 is_cat 출력
                          },
                          child: const Text("Next"))),
```
        
- [O]  **3. 에러가 난 부분을 디버깅하여 문제를 “해결한 기록을 남겼거나” 
”새로운 시도 또는 추가 실험을 수행”해봤나요?**
    - 문제 원인 및 해결 과정을 잘 기록하였는지 확인 또는
    - 문제에서 요구하는 조건에 더해 추가적으로 수행한 나만의 시도, 
    실험이 기록되어 있는지 확인
        - pushNamed 메소드의 결과를 리턴받는 코드에서 비동기 처리를 하지 않으면 결과값이 제대로 출력되지 않는다는 것을 이해하고 비동기 처리를 통해 해결함.
```Dart
                          onPressed: () async {
                            // ps. pop()으로 데이터를 보내는데, 데이터가 출력되지 않아서 한참 헤매다가
                            // async 와 await으로 데이터 받은 부분 비동기 호출을 통해서 출력할 수 있는 것으로 해결!
                            //
                            is_cat = false; // is_cat false로 변경
                            // pushNamed로 두번째 페이지로 전환
                            final result = await Navigator.pushNamed(
                                context, '/second',
                                arguments:
                                    is_cat); // argument에 is_cat 변수 담아서 보내기
                            print('$result'); // 콘솔에 is_cat 출력

```
        
- [O]  **4. 회고를 잘 작성했나요?**
    - 주어진 문제를 해결하는 완성된 코드 내지 프로젝트 결과물에 대해 배운점과 아쉬운점, 느낀점 등이 상세히 기록되어 있는지 확인
        - 네. 퀘스트를 진행하면서 접했던 문제 상황, 해결책, 익숙하게 사용할 수 있었던 기술, 전체적인 소회까지 포함해서 잘 작성되었습니다.
```Dart
// 김기홍
// quest를 하면서 flutter 실력이 조금씩 상승함을 느낍니다.
// async await을 써야 pop()에서 불러올 수 있다는 사실을 깨달았고,
// Icon, ImageNetwork 위젯, 이미지 속성의 Boxfit 옵션 설정들을 직접해보면서
// 부족한 부분들을 서로 보완하며 만들어가니, 재미있기도하고 도움이 많이 됩니다.
```

- [O]  **5. 코드가 간결하고 효율적인가요?**
    - 코드 중복을 최소화하고 범용적으로 사용할 수 있도록 모듈화(함수화) 했는지
        - 네. 군더더기 없이 깔끔하게 전체 코드가 작성되었습니다. 


## 참고 링크 및 코드 개선
```
# 코드 리뷰 시 참고한 링크가 있다면 링크와 간략한 설명을 첨부합니다.
# 코드 리뷰를 통해 개선한 코드가 있다면 코드와 간략한 설명을 첨부합니다.
```
