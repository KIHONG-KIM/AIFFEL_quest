## AIFFEL Campus Online Code Peer Review Templete
- 코더 : 김기홍, 강대식
- 리뷰어 : 윤선웅, 김재이


노드대로도 완성해주시고, 어플도 완성해주셨습니다.
노드의 코드를 성공적으로 수행하시고 만드신 네온 컬러가 돋보이는 결과물이 인상적이었고,
Stable Diffusion을 응용해서 다양한 윤곽선에 유명 작화를 입혀 바로 출력하는 앱까지 구현하신 것이 인상깊었습니다.

---

## PRT(Peer Review Template)
- [o]  **1. 주어진 문제를 해결하는 완성된 코드가 제출되었나요?**
    - 문제에서 요구하는 최종 결과물이 첨부되었습니다
      * [배경 윤곽선 + 인물 포즈 합성 이미지](https://github.com/KIHONG-KIM/AIFFEL_quest/blob/main/Exploration_quest/Quest06/%5B%EB%8C%80%EC%8B%9D%EB%8B%98%5Dexp_06_chatgpt_quest06.ipynb)
      * [이미지 스타일을 바꿔주는 모델 + 앱](https://github.com/KIHONG-KIM/AIFFEL_quest/blob/main/Exploration_quest/Quest06/server.py)
    
- [o]  **2. 전체 코드에서 가장 핵심적이거나 가장 복잡하고 이해하기 어려운 부분에 작성된 
주석 또는 doc string을 보고 해당 코드가 잘 이해되었나요?**
    - 해당 코드 블럭에 doc string/annotation이 달려 있는지 확인
    - 해당 코드가 무슨 기능을 하는지, 왜 그렇게 짜여진건지, 작동 메커니즘이 뭔지 기술.
    - 주석을 보고 코드 이해가 잘 되었는지 확인
        - 잘 작성되었다고 생각되는 부분을 캡쳐해 근거로 첨부합니다.
     
        * 노드학습을 따른 노트북 파일은 물론
        * 앱 내 코드에서도 주석이 잘 달려 있어 이해하기 쉬웠습니다.

          ```
          class _SliderDemoState extends State<SliderDemo> {
          //  프롬프트의 영향력을 조절하는 파라미터
          // 이를 추가하여 이미지 생성의 창의성과 프롬프트 충실도 사이의 균형을 조절
          double guidance_scale = 7.5;
          // image_strength: 0 - 1 사이
          // 원본 Canny 이미지의 영향력을 조절하는 파라미터
          // 원본 이미지의 특징을 얼마나 유지할지 조절
          double image_strength = 0.8;
          ```
        
- [o]  **3. 에러가 난 부분을 디버깅하여 문제를 “해결한 기록을 남겼거나” 
”새로운 시도 또는 추가 실험을 수행”해봤나요?**
    - 문제 원인 및 해결 과정을 잘 기록하였는지 확인
    - 문제에서 요구하는 조건에 더해 추가적으로 수행한 나만의 시도, 
    실험이 기록되어 있는지 확인
        - 잘 작성되었다고 생각되는 부분을 캡쳐해 근거로 첨부합니다.

        * 회고에 문제 원인 및 해결과정이 잘 기록되어 있습니다.
      
- [o]  **4. 회고를 잘 작성했나요?**
    - 주어진 문제를 해결하는 완성된 코드 내지 프로젝트 결과물에 대해
    배운점과 아쉬운점, 느낀점 등이 기록되어 있는지 확인
    - 전체 코드 실행 플로우를 그래프로 그려서 이해를 돕고 있는지 확인
        - 잘 작성되었다고 생각되는 부분을 캡쳐해 근거로 첨부합니다.
        * 회고가 [README.md](https://github.com/KIHONG-KIM/AIFFEL_quest/blob/main/Exploration_quest/Quest06/README.md) 파일에 잘 작성되어 있습니다. 시도하신 것들과 결과물을 한 눈에 알 수 있었습니다.
        
- [o]  **5. 코드가 간결하고 효율적인가요?**
    - 파이썬 스타일 가이드 (PEP8) 를 준수하였는지 확인
    - 하드코딩을 하지않고 함수화, 모듈화가 가능한 부분은 함수를 만들거나 클래스로 짰는지
    - 코드 중복을 최소화하고 범용적으로 사용할 수 있도록 함수화했는지
        - 잘 작성되었다고 생각되는 부분을 캡쳐해 근거로 첨부합니다.

        * 모델이 함수화 되어 있어 보기에 깔끔했습니다!
          ```
            ### CV툴로 전처리
            def load_from_image(url):
                return image
            
            # 이미지 로드
            def load_from_image2(url):
                return None
            
            
            ### 외곽선 검출하기
            def pre_process(image):
                return canny_image
            
            def generate_canny_image(canny_image, prompt, guidance_scale=7.5, image_strength=0.8, num_inference_steps = 20):
                return canny_image
            
            def generate_pose_image(pose_image):
                return openpose_image
            
            def prompt_maker(artist):
                return prompt2
            
            def display_image_processing_steps(url, guidance_scale, image_strength):
                return fig
          ```

