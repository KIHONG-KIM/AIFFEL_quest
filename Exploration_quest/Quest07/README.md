## EXPLORATION 07

#### MLOps 


팀 : 김기홍, 신승우

- 기홍: Cifar-10 데이터 셋을 활용한 keras tensorflow_model_server돌리기

- 승우님: 

#### 회고

승우님

- 배운점: 모델을 앱에 임베딩이 가능하다는 점을 알았음
- 어려운점: 임베딩하기 위해서 모델을 튜닝하는 부분에서 모델이 제대로 작동하지 않고, 성능이 너무 안나와서 장기적으로 해결해야할 것 같음

기홍

- 배운점: MLOps의 파이프라인을 전부 이틀만에 구현해내지는 못했지만, 전체 파이프라인을 경험해보았고 케라스 튜닝으로 하이퍼 파라미터를 튜닝하고, 모델을 저장하는 방법 3가지(.keras, .pb, .tflite)방식을 경험해보고, 불러오며 tensorflow_model_server 를 구동하여 api 서버로 활용하여 예측하는 프로젝트를 진행해보았습니다.
- 어려운점:  tflite를 활용해서 플러터로 앱을 구현하려고 시도해보았지만, tflite 모듈이 오래된 버전이었음. (3년전 개발 만료) tflite_flutter란 패키지를 사용해야했고, android/build.gradle에 제대로된 정보를 넣어 줘야한다는 점을 깨달았음.


### 결과
- 승우님께서 제작하신 앱 사진

![alt text]([승우님]앱제작image.png)

- 기홍: tensorflow_model_server 작동 결과

![alt text](image.png)