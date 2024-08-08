# main.py
from fastapi.middleware.cors import CORSMiddleware
from fastapi import FastAPI, Query
import torch
from pydantic import BaseModel

#### 모델 로딩 ####
import torch
from transformers import BertTokenizer, BertModel
from torch import nn
import numpy as np

import time
# BERT 모델 클래스 정의
class BERTClassifier(nn.Module):
    def __init__(self, bert_model, num_classes, dropout_rate=0.3):
        super(BERTClassifier, self).__init__()
        self.bert = bert_model
        self.dropout = nn.Dropout(dropout_rate)
        self.classifier = nn.Linear(self.bert.config.hidden_size, num_classes)

        #  position_ids 추가
        self.bert.embeddings.register_buffer("position_ids", torch.arange(512).expand((1, -1)))
        
    def forward(self, input_ids, attention_mask):
        outputs = self.bert(input_ids=input_ids, attention_mask=attention_mask)
        pooled_output = outputs[1]
        pooled_output = self.dropout(pooled_output)
        logits = self.classifier(pooled_output)
        return logits

# 필요한 변수들 설정
model_name = "klue/bert-base"
tokenizer = BertTokenizer.from_pretrained(model_name)
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
num_classes = 6  # 감정 클래스의 수에 맞게 조정

# BERT 모델 로드
bert_model = BertModel.from_pretrained(model_name)

# 모델 초기화 및 가중치 로드
model = BERTClassifier(bert_model=bert_model, num_classes=num_classes)
model.load_state_dict(torch.load('bert_classifier_fold_dataset2_5.pth', map_location=device), strict=False)
model.to(device)
model.eval()

# 감정 레이블 (학습 시 사용한 레이블 순서와 일치해야 함)
emotion_labels = ['기쁨', '슬픔', '분노', '불안', '당황', '상처']

# 텍스트 감정 분류 함수
def classify_emotion(text):
    encoded_input = tokenizer(text, padding=True, truncation=True, max_length=128, return_tensors="pt")
    input_ids = encoded_input['input_ids'].to(device)
    attention_mask = encoded_input['attention_mask'].to(device)
    
    with torch.no_grad():
        outputs = model(input_ids, attention_mask)
        probabilities = torch.nn.functional.softmax(outputs, dim=1)
        predicted_class = torch.argmax(probabilities, dim=1).item()
    
    predicted_emotion = emotion_labels[predicted_class]
    confidence = probabilities[0][predicted_class].item()
    return predicted_emotion, confidence

#### 함수 ####
# FastAPI 애플리케이션 인스턴스 생성
app = FastAPI()

# cors 요청 리스트
origins = ["*"]

# cors 요청 리스트 추가
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def path_name():
    return 'hello DL_thon'

class Item(BaseModel):
    text: str

@app.post("/predict")
def test(item: Item):
    print(item.text)
    emotion, confidence = classify_emotion(item.text)
    return {'text': item.text, 'emotion': emotion, 'confidence': confidence}