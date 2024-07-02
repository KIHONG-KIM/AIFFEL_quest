import 'dart:async';
import 'dart:io';

class PomodoroTimer {
  int work_min = 25 * 60; // 일하는 시간 = 25분
  int rest_min = 5 * 60; // 쉬는 시간 = 5분

  int count = 0; // 업무 회차
  int total_sec = 0; // 총 시간
  int minutes = 0; // display 분
  int seconds = 0; // display 초

  // work 카운터
    // 작업 타이머 시작 함수
  void work_counter() {
    print("work타이머 시작합니다, $work_min초, $count회"); 

    // work 카운터 타이머
    Timer.periodic(const Duration(seconds: 1), (timer) {
      total_sec = work_min - timer.tick; // 총 시간
      minutes = total_sec ~/ 60; // 분 계산
      seconds = total_sec % 60; // 초 계산

      print('$minutes분 $seconds초'); // 분 초 출력

      if (total_sec <= 0) {  // work 타이머가 끝나면
        print('work 타이머를 종료합니다. rest 타이머를 시작합니다.'); // 안내
        timer.cancel(); // 타이머 종료 (종료하지 않으면 메모리에 계속 잡혀있다고 함.)

        count++; // 회수 증가

        if (count % 4 == 0) {
          rest_min = 15 * 60; // 4회차마다 긴 휴식
        } else {
          rest_min = 5 * 60; // 짧은 휴식 시간으로 재설정
        }

        rest_counter();  // 휴식 타이머 시작
      }
    });
  }

  // rest 카운터 시작 함수
  void rest_counter() {
    print("rest타이머 시작합니다. $work_min초, $count회");

    // rest 카운터 시작
    Timer.periodic(const Duration(seconds: 1), (timer) {
      total_sec = rest_min - timer.tick;
      minutes = total_sec ~/ 60;
      seconds = total_sec % 60;

      print('$minutes분 $seconds초'); // 출력

      if (total_sec <= 0) {
        print('rest 종료합니다. work 타이머를 시작합니다.');
        timer.cancel();

        work_counter(); // 작업 타이머 다시 시작
      }
    });
  }
}

void main() {
  PomodoroTimer pomodoroTimer = PomodoroTimer(); // 포모도로 타이머 클래스 생성
  pomodoroTimer.work_counter(); // 작업 타이머 시작
}


//회고

// - 이한나
// 이번 프로젝트를 통해 Dart와 타이머 관련 기능을 구현하는 법을 배웠습니다. 
// 특히 Timer.periodic을 사용하여 일정 시간 간격으로 작업을 반복하는 방법을 이해하게 되었습니다.  
// 개선할 점으로는, 기홍님이 작성하신것처럼 코드의 유지보수성을 높이기 위해 
// 더 구조화된 방법으로 클래스를 분리하는 것의 중요성을 배웠고, 
// 테스트 코드를 작성하는 연습이 필요하다는 점을 느꼈습니다. 

// - 김기홍
// 함께 타이머를 작성하면서 짧지만 처음 제대로 다트 언어를 사용해보았습니다.
// timer.periodic도 사용해보고, 다른 언어와 비슷한 점들도 많지만
// 다른 점들도 참 많은 것 같습니다. 특히 오류에 대해 일체 허용하지 않으려는 것이 인상깊었습니다.
// 그리고 무엇보다 함께 개발을 하면서 혼자는 보지 못할 것들도 집어주셔서 감사한 경험이었습니다.