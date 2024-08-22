## GAN 모델 생성 프로젝트

> 학습 노트북 : dcgan_cifar_LMS class.ipynb

> fastapi 서버 : server.py

> flutter app으로 요청 코드 : main.dart 

### 목적

- Cifar 데이터셋을 활용하여 GAN 모델을 생성하고 튜닝 프로젝트

- 생성만 아니라 라벨을 같이 학습시켜, 진행.

- 처음에는 50, 200, 700회까지 epochs 진행했을때 아래와 같은 결과 획득

    ![result](result.png)