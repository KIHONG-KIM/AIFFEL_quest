# AIFFEL Campus Code Peer Review Templete
- 코더 : 김기홍
- 리뷰어 : 정권영

# PRT(Peer Review Template)
[X]  **1. 주어진 문제를 해결하는 완성된 코드가 제출되었나요?**
- 문제에서 요구하는 기능이 정상적으로 작동하는지?
##
def find_min_max(numbers):
    # min_value와 max_value 변수를 초기화
    # min_value는 양의 무한대(float('inf'))로 초기화하여 어떤 숫자보다도 큰 값으로 설정
    min_value = float('inf')
    # print("min_value:", min_value)
    # max_value는 음의 무한대(float('-inf'))로 초기화하여 어떤 숫자보다도 작은 값으로 설정
    max_value = float('-inf')

    def update_min_max(num):
        # 외부함수의 변수인 min_value, max_value 참조
        # 수정 : global  외부 변수에 접근 사용하여 오류 , nonlocal 내부 함수에서 외부 함수의 변수를 참조
        nonlocal  min_value,max_value
        # 만약 num 값이 min_value보다 작다면 min_value를 num 값으로 변경
        # print("num < min_value:", num)
        # print("num < min_value:", min_value)
        if num < min_value :
           min_value = num
          #  print("***:", min_value)
        # 만약 num 값이 max_value보다 크다면 max_value를 num 값으로 변경
        if num > max_value :
           max_value = num
          #  print("***@@@ :", max_value)
    # numbers 리스트의 모든 값을 순환하며 최댓값과 최솟값 업데이트
    for num in numbers:
        update_min_max(num)

    # 최솟값을 반환하는 내부함수
    def get_min():
        return min_value

    # 최댓값을 반환하는 내부함수
    def get_max():
        return max_value


    # 외부함수는 내부함수(get_min()과 get_max())를 반환
    # 수정 : 처음엔 get_min()과 get_max()를 호출하였지만, 하단의 오류 발생하여 () 를 제거하니 됨
    #
    #     TypeError                                 Traceback (most recent call last)
    #  in ()
    #      36 find_min, find_max = find_min_max(numbers)
    #      37
    # ---> 38 print("최솟값:", find_min())  # 3
    #      39 print("최댓값:", find_max())  # 12

    # TypeError: 'int' object is not callable
    # chatGpt 참조 : () 포함된 코드에서는 get_min()와 get_max() 함수를 호출하여 반환된 값을 반환하게 됩니다. 이는 실제로 최솟값과 최댓값을 반환하게 됩니다.
    #                () 제거된  코드는 get_min과 get_max 함수 객체를 반환합니다. 이를 통해 반환된 함수를 나중에 호출하여 최솟값과 최댓값을 얻을 수 있습니다.
    return get_min, get_max

numbers = [10, 5, 8, 12, 3, 7]
# 위의 return 오류를 해결하기 위하여 하단의 코드를 나눠서 수정하기도함
# find_min = find_min_max(numbers)
# find_min = find_min_max(numbers)
# TypeError: 'tuple' object is not callable 오류 발생
find_min, find_max = find_min_max(numbers)

print("최솟값:", find_min())  # 3
print("최댓값:", find_max())  # 12

     
  # -> 코드 요구하는 기능 정상적으로 잘 작동하고 완벽합니다.!!
    
[X]  **2. 핵심적이거나 복잡하고 이해하기 어려운 부분에 작성된 설명을 보고 해당 코드가 잘 이해되었나요?**
- 해당 코드 블럭에 doc string/annotation/markdown이 달려 있는지 확인
- 해당 코드가 무슨 기능을 하는지, 왜 그렇게 짜여진건지, 작동 메커니즘이 뭔지 기술.
- 주석을 보고 코드 이해가 잘 되었는지 확인
  # -> 코드 하나하나 주석처리로 설명이 잘되어있습니다.
        
[X]  **3. 에러가 난 부분을 디버깅하여 “문제를 해결한 기록”을 남겼나요? 또는 “새로운 시도 및 추가 실험”을 해봤나요?**
- 문제 원인 및 해결 과정을 잘 기록하였는지 확인
- 문제에서 요구하는 조건에 더해 추가적으로 수행한 나만의 시도, 실험이 기록되어 있는지 확인
    - 잘 작성되었다고 생각되는 부분을 캡쳐해 근거로 첨부합니다. 
        
[X]  **4. 회고를 잘 작성했나요?**
- 프로젝트 결과물에 대해 배운점과 아쉬운점, 느낀점 등이 상세히 기록 되어 있나요?
''' 회고 김기홍:

처음 클로저를 응용해서 사용하려고 할 때, 항상 생각이 들었던 것이 굳이 이렇게 사용해야할까? 하는 생각이 들었는데, 생각해보니 클래스를 만들면 모듈이 점점 커지고, 전역변수로 하자니 깔끔한 코드가 되지 못할 것 같다는 생각에 미쳤습니다. 클로저 개념을 잘 이해한다면 쉽게 변수와 함수를 연결시켜서 여러곳에서 사용할 수 있겠다는 생각과 장점이 더 많기에 사용한다는 말에 공감이 되었습니다.

클로저 장점 중 '함수 호출 사이의 상태를 유지'할 수 있는데 이는 함수를 여러 번 호출할 때 일부 정보를 보존하려는 경우 유용하고, 데이터를 캡슐화해서 숨길 수 있음. 등의 장점을 찾아 보며 - 두번째 예제에서 정보를 보존하는데 의미가 있을 것 같고, 첫번째 예제에서 캡슐화가 잘 되어있다 것을 연결시키면서 확인할 수 있었고, 예제를 진행하면서 배웠던 이론을 주석을 남기면서 확인하는 시간이 이론과 실제를 연결시킬 수 있었습니다.

또한 상운님의 질문을 통해, 이전에 배웠던 데코레이터도 클로저를 사용하는데 지역변수를 참조 하지 않고, 함수만 참조했었는데 클로저가 되기 위한 조건 2번에 외부함수의 지역변수를 참조한다는 항목을 통해 일급객체는 변수가 함수가 될 수 있다는 의미를 확인하면서 의미를 연결시킬 수 있었고,

함수를 정의하고 쉽게 참조하고, 정의해서 사용할 수 있다는 장점을 클로저 사용의 대표적인 예시인 데코레이터라는 사실을 질문과 검색을 통해 피어 프로그래밍을 더 몰입력있는 시간으로 사용할 수 있었습니다. '''
# -> 회고도 클로저에 대한 의문점 및 사용처등 생각을 많이 하셨다는 생각이 듭니다. 또한 데코레이터 및 일급객체의 의미등 많은 고민의 흔적이 보입니다.
# -> 저는 클로저 노드 학습 및 예제실습도 풀어보았지만 기홍님 회고를 읽어보니 많은 반성 및 더 노력해야 겠다는 생각이 듭니다.
참고 링크 및 코드 개선
