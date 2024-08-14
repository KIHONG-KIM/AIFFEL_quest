
- [o]  **1. 주어진 문제를 해결하는 완성된 코드가 제출되었나요? (완성도)**
    - 문제에서 요구하는 최종 결과물이 첨부되었는지 확인
    - 문제를 해결하는 완성된 코드란 프로젝트 루브릭 3개 중 2개, 
    퀘스트 문제 요구조건 등을 지칭
        - 해당 조건을 만족하는 부분의 코드 및 결과물을 캡쳐하여 사진으로 첨부
```
import numpy as np
from tensorflow.keras.preprocessing.sequence import pad_sequences

# text_max_len을 100으로 설정
text_max_len = 100

# 입력 데이터 패딩
def pad_input(input_seq, maxlen):
    return pad_sequences([input_seq], maxlen=maxlen, padding='post')[0]

# decode_sequence 
def decode_sequence(input_seq):
    e_out, e_h, e_c = encoder_model.predict(input_seq, verbose=0)
    
    target_seq = np.zeros((1,1))
    target_seq[0, 0] = tar_word_to_index['sostoken']
    
    stop_condition = False
    decoded_sentence = ''
    
    while not stop_condition:
        output_tokens, h, c = decoder_model.predict([target_seq, e_out, e_h, e_c], verbose=0)
        
        sampled_token_index = np.argmax(output_tokens[0, -1, :])
        sampled_token = tar_index_to_word[sampled_token_index]
        
        if (sampled_token != 'eostoken'):
            decoded_sentence += ' ' + sampled_token
        
        if (sampled_token == 'eostoken' or len(decoded_sentence.split()) >= (headline_max_len-1)):
            stop_condition = True
        
        target_seq = np.zeros((1,1))
        target_seq[0, 0] = sampled_token_index
        
        e_h, e_c = h, c
    
    return decoded_sentence

# 예측 실행
padded_input = pad_input(encoder_input_test[i], text_max_len)
print("예측 요약 :", decode_sequence(padded_input.reshape(1, text_max_len)))
```
![image](https://github.com/user-attachments/assets/d6f8907f-6d00-4936-b20c-c4edc99e3fff)

- [o]  **2. 프로젝트에서 핵심적인 부분에 대한 설명이 주석(닥스트링) 및 마크다운 형태로 잘 기록되어있나요? (설명)**
    - [ ]  모델 선정 이유
    - [ ]  하이퍼 파라미터 선정 이유
    - [ ]  데이터 전처리 이유 또는 방법 설명
```
# 바로 직전 타임스텝의 상태들을 저장하는 텐서
decoder_state_input_h = Input(shape=(hidden_size,))   # 히든 스테이트용
decoder_state_input_c = Input(shape=(hidden_size,))   # 셀 스테이트용

dec_emb2 = dec_emb_layer(decoder_inputs)

# 문장의 다음 단어를 예측하기 위해서 초기 상태(initial_state)를 이전 시점의 상태로 사용. 이는 뒤의 함수 decode_sequence()에 구현
# 훈련 과정에서와 달리 LSTM의 리턴하는 은닉 상태와 셀 상태인 state_h와 state_c를 버리지 않음.
# [참고] LMS의 원래 코드에서는 그냥 state_h2, state_c2 라고만 되어 있었는데, 앞에서 사용한 인코더 내 두 번째 LSTM의 출력값인 state_h2, state_c2와 구분하기 위해 변수명 앞에 dec_ 를 붙여 줌.
decoder_outputs2, dec_state_h2, dec_state_c2 = decoder_lstm(dec_emb2, initial_state=[decoder_state_input_h, decoder_state_input_c])

# 어텐션 함수
decoder_hidden_state_input = Input(shape=(text_max_len, hidden_size))
attn_out_inf = attn_layer([decoder_outputs2, decoder_hidden_state_input])
decoder_inf_concat = Concatenate(axis=-1, name='concat')([decoder_outputs2, attn_out_inf])

# 디코더의 출력층
decoder_outputs2 = decoder_softmax_layer(decoder_inf_concat)

# 최종 디코더 모델
decoder_model = Model(
    [decoder_inputs] + [decoder_hidden_state_input, decoder_state_input_h, decoder_state_input_c],
    # [참고] 여기에서도 LMS의 원래 코드에서는 그냥 state_h2, state_c2 였는데, 앞에서 변경한 변수명과 일치시키기 위해 변수명 앞에 dec_ 를 붙여줌.
    [decoder_outputs2] + [dec_state_h2, dec_state_c2])
```

- [o]  **3. 체크리스트에 해당하는 항목들을 수행하였나요? (문제 해결)**
    - [ ]  데이터를 분할하여 프로젝트를 진행했나요? (train, validation, test 데이터로 구분)
    - [ ]  하이퍼파라미터를 변경해가며 여러 시도를 했나요? (learning rate, dropout rate, unit, batch size, epoch 등)
    - [ ]  각 실험을 시각화하여 비교하였나요?
    - [ ]  모든 실험 결과가 기록되었나요?

- [o]  **4. 프로젝트에 대한 회고가 상세히 기록 되어 있나요? (회고, 정리)**
    - [ ]  배운 점
    - [ ]  아쉬운 점
    - [ ]  느낀 점
    - [ ]  어려웠던 점

- [ ]  **5.  앱으로 구현하였나요?**
    - [ ]  구현된 앱이 잘 동작한다.
    - [ ]  모델이 잘 동작한다.
