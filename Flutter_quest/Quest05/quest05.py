# main.py
from fastapi.middleware.cors import CORSMiddleware
from fastapi import FastAPI, File, UploadFile
from fastapi.responses import HTMLResponse
from fastai.vision.all import *
import torchvision.models as models

import io
from PIL import Image
import numpy as np
import torch
import pathlib

# 학습되지 않은 모델 불러오기
vgg16_model = models.vgg16_bn(weights=models.VGG16_BN_Weights.IMAGENET1K_V1)
vgg16_model.eval()  # 모델을 평가 모드로 전환


# ImageNet 클래스 이름 로드
with open("imagenet_classes.txt") as f:
    imagenet_classes = [line.strip() for line in f.readlines()]

# 데이터 전처리 함수 설정
def preprocess_image(image_bytes):
    img = PILImage.create(io.BytesIO(image_bytes))
    img = img.resize((224, 224))
    img = np.array(img).astype(np.float32)  # 타입을 float32로 변환
    img = img / 255.0
    img = (img - np.array(imagenet_stats[0])) / np.array(imagenet_stats[1])
    img = np.transpose(img, (2, 0, 1))
    img = torch.tensor(img).unsqueeze(0)
    return img

# 이미지 예측 함수
def predict_image(image_bytes):
    img_tensor = preprocess_image(image_bytes)
    img_tensor = img_tensor.float()  # ensure tensor is float32
    with torch.no_grad():
        outputs = vgg16_model(img_tensor)
        probabilities = F.softmax(outputs, dim=1)  # 소프트맥스를 통해 확률로 변환
        percent, predicted = probabilities.max(1)
        percent = percent.item() * 100  # 확률을 퍼센트로 변환
        predicted = predicted.item()  # 텐서를 int 값으로 변환
    
    class_name = imagenet_classes[predicted]
    return percent, class_name

# FastAPI 애플리케이션 인스턴스 생성
app = FastAPI()

# cors 요청 리스트
origins = [
    "http://localhost",
    "http://localhost:53495",
    "http://127.0.0.1:8000",
]

# cors 요청 리스트 추가
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# predict_api로 접속하면 예측 후 결과값 반환 prediction, percent
@app.get("/predict_api/")
async def predict():
    # image path
    with open('jellyfish.jpg', 'rb') as f:
        image_bytes = f.read()
    percent, prediction = predict_image(image_bytes)
    print(prediction)
    return {"prediction": prediction, "percent": percent}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)