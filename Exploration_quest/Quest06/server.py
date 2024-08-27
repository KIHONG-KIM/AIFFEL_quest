
# fast api 모듈 임포트
from fastapi import FastAPI, HTTPException, Request, logger
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse, Response
import uvicorn
import traceback # 로그를 위한 모듈
import matplotlib.pyplot as plt
import random

from pydantic import BaseModel

from datetime import datetime
# tensorflow
# import tensorflow as tf
# import matplotlib.pyplot as plt
# import os

# FastAPI 앱 초기화
app = FastAPI()

# pydantic 사용
class CannyImageRequest(BaseModel):
    prompt: str
    count: int
    guidance_scale: float
    image_strength: float
    num_inference_steps: int = 20

# CORS 미들웨어 추가
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

### gemini for prompt ###

import google.generativeai as genai

with open('apikey.txt', 'r') as key:
  API_KEY = key.read()

genai.configure(api_key=API_KEY)
model = genai.GenerativeModel('gemini-1.5-flash')

### path, count 설정

save_path = 'image/second/'
count = 0

### 모듈 임포트

import torch
from diffusers import StableDiffusionControlNetPipeline
from diffusers.utils import load_image 

import cv2
from PIL import Image 
import numpy as np
import io
import requests


from diffusers import StableDiffusionControlNetPipeline, ControlNetModel
from diffusers import UniPCMultistepScheduler

from controlnet_aux import OpenposeDetector

from fastapi.responses import StreamingResponse

# ControlNet - Canny 모델 불러오기
canny_controlnet = ControlNetModel.from_pretrained("lllyasviel/sd-controlnet-canny", torch_dtype=torch.float16)
canny_pipe = StableDiffusionControlNetPipeline.from_pretrained("runwayml/stable-diffusion-v1-5", controlnet=canny_controlnet, torch_dtype=torch.float16)

canny_pipe.scheduler = UniPCMultistepScheduler.from_config(canny_pipe.scheduler.config)
canny_pipe = canny_pipe.to("cuda")

# 인체의 자세를 검출하는 사전 학습된 ControlNet 불러오기
openpose = OpenposeDetector.from_pretrained("lllyasviel/ControlNet")



### CV툴로 전처리
def load_from_image(url):
    image = load_image(url)
    print(image)
    # image.save(f'{save_path}basic_image_{count}.png')
    
    return image

# 이미지 로드
def load_from_image2(url):
    print('load_from_image2')
    try:
        response = requests.get(url)
        response.raise_for_status()  # HTTP 오류가 있으면 예외를 발생시킵니다.
        img_data = response.content
        img = Image.open(io.BytesIO(img_data))
        img.save(f'{save_path}basic_image_{count}.png')
        print(img)
        return img
    except requests.exceptions.RequestException as e:
        print(f"URL에서 이미지를 가져오는 중 오류 발생: {e}")
    except IOError as e:
        print(f"이미지를 여는 중 오류 발생: {e}")
    return None


### 외곽선 검출하기
def pre_process(image):
    print('pre_process')
    # 이미지를 NumPy 배열로 변환합니다. 
    image = np.array(image)
    # threshold를 지정합니다. 
    low_threshold = 100
    high_threshold = 200

    # 윤곽선을 검출합니다. ***
    image = cv2.Canny(image, low_threshold, high_threshold)
    image = image[:, :, None]
    image = np.concatenate([image, image, image], axis=2)
    canny_image = Image.fromarray(image)  # NumPy 배열을 PIL 이미지로 변환합니다. 
    current_time = datetime.now().strftime("%Y%m%d_%H%M%S")
    canny_image.save(f'{save_path}outlined_image_{current_time}.png')

    return canny_image

def generate_canny_image(canny_image, prompt, guidance_scale=7.5, image_strength=0.8, num_inference_steps = 20):
    print('generate_canny_image')
    generator = torch.manual_seed(0)
    canny_image = canny_pipe(
        prompt=prompt, # 프롬프트 
        num_inference_steps=num_inference_steps, 
        generator=generator,
        guidance_scale=guidance_scale,
        image_strength=image_strength, 
        image=canny_image
    ).images[0]
    current_time = datetime.now().strftime("%Y%m%d_%H%M%S")
    print(current_time)
    canny_image.save(f'{save_path}canny_image_{current_time}.png')
    return canny_image

def generate_pose_image(pose_image):
    print('generate_pose_image')
    url = 'https://blog.kakaocdn.net/dn/zucK8/btqAfTsBwtY/hZAJKMfoK1cxyeylDskkZk/img.jpg'

    openpose_image = openpose(pose_image)
    openpose_image.save(f'{save_path}pose_image_{count}.png')
    return openpose_image

def prompt_maker(artist):
    print("prompt maker")
    prompt1 = f"A pastel {artist} style painting of a sun-drenched meadow with wildflowers, soft, rolling hills, and a gentle breeze, impressionist, soft focus, vibrant yet calming colors."
    prompt2 = f"A pastel {artist} style painting with a calm and a distant horizon, soft, muted colors, vivid, lieful, peaceful atmosphere, impressionist."
    prompt3 = f"A pastel {artist} style painting of a foggy forest with a sunbeam breaking through the trees, soft, ethereal atmosphere, muted colors, peaceful."
    prompt4 = f"A pastel {artist} style painting garden with a stone path, blooming flowers, and a gentle breeze, soft focus, natural light, peaceful ambiance."
    prompt5 = f"A {artist} style lake with a small rowboat, surrounded by mountains and trees, soft, calming colors, peaceful atmosphere, impressionist."
    return prompt2

def display_image_processing_steps(url, guidance_scale, image_strength):
    print('display_image_processing_steps')
    fig, axes = plt.subplots(2, 2, figsize=(15, 15))
    
    # 1. 원본 이미지 로드
    original_image = load_from_image2(url)
    axes[0, 0].imshow(original_image)
    axes[0, 0].set_title("Original Image")
    axes[0, 0].axis('off')
    
    # 2. 외곽선 검출 이미지
    canny_image = pre_process(original_image)
    axes[0, 1].imshow(canny_image)
    axes[0, 1].set_title("Canny Edge Detection")
    axes[0, 1].axis('off')
    
    # 3. Canny 기반 생성 이미지
    prompt_monet = prompt_maker("Monet")
    print(prompt_monet)
    
    generated_image = generate_canny_image(canny_image, prompt_monet, guidance_scale, image_strength)
    axes[1, 0].imshow(generated_image)
    axes[1, 0].set_title("Monet style Image")
    axes[1, 0].axis('off')
    
    # 4. Pose 이미지 (옵션)
    prompt_gogh = prompt_maker("Van Gogh")
    picaso_image = generate_canny_image(canny_image, prompt_gogh, guidance_scale, image_strength)
    axes[1, 1].imshow(picaso_image)
    axes[1, 1].set_title("Van Gogh style Image")
    axes[1, 1].axis('off')
    plt.tight_layout()
    return fig

### 윤곽선으로 stable diffusion으로 처리한 이미지
### 컨트롤 넷 모델 불러오기 ###

# 루트 엔드포인트
@app.get("/")
async def root():
    return {"message": "Hello from WSL FastAPI server!"}

# 윤곽선 이미지 엔드포인트
@app.get("/canny/")
async def generate_image():
    global count

    print('안녕 count:', count)
    try:

        ###  이미지 불러오기  ###
        url = "https://hf.co/datasets/huggingface/documentation-images/resolve/main/diffusers/input_image_vermeer.png"
        url2 = "https://png.pngtree.com/thumb_back/fw800/background/20230515/pngtree-blue-clouds-in-the-sky-wallpaper-stock-videos-e-broll-footage-image_2541971.jpg"
        image = load_from_image2(url2)
        # image = load_from_image(url)
        canny_image = pre_process(image)

        # 동일한 이미지를 생성하기 위해 seed를 지정합니다. 
        generator = torch.manual_seed(count)

        # 이미지를 생성합니다. 
        generated_image = generate_canny_image(canny_image, "A starry night in the style of van Gogh" ,count)

        count = count + 1

        # PIL Image를 바이트 스트림으로 변환
        img_byte_arr = io.BytesIO()
        generated_image.save(img_byte_arr, format='PNG')
        img_byte_arr.seek(0)
        
        # 스트리밍 응답으로 이미지 반환
        return StreamingResponse(img_byte_arr, media_type="image/png")

    except Exception as e:
        print(f"Error: {str(e)}")
        return JSONResponse(content={"error": str(e)}, status_code=500)
    
@app.post("/generate_canny_image/")
async def generate_canny_image_endpoint(request: CannyImageRequest):
    try:
        print(request)
        url2 = ("https://picsum.photos/512")

        # guidance_scale: float
        # image_strength: float
        fig = display_image_processing_steps(url2, request.guidance_scale, request.image_strength )
    
        # 그래프를 이미지로 변환
        img_byte_arr = io.BytesIO()
        fig.savefig(img_byte_arr, format='PNG')
        img_byte_arr.seek(0)

        current_time = datetime.now().strftime("%Y%m%d_%H%M%S")
        filepath = f"image/result/my_plot_{current_time}.png"
        print(filepath)
        fig.savefig(filepath, format='PNG')
        
        # 스트리밍 응답으로 이미지 반환
        return StreamingResponse(img_byte_arr, media_type="image/png")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# 포즈 이미지 엔드포인트
@app.get("/pose/")
async def generate_pose(request: CannyImageRequest):
    try:
        url1 = ""
        url2 = "https://www.urbanbrush.net/web/wp-content/uploads/edd/2018/06/web-20180611183454324888.png"

        fig = display_image_processing_steps(url2)

        # 그래프를 이미지로 변환
        
        img_byte_arr = io.BytesIO()
        fig.savefig(img_byte_arr, format='PNG')
        img_byte_arr.seek(0)

        current_time = datetime.now().strftime("%Y%m%d_%H%M%S")
        fig.savefig(f'image/result/my_plot_{current_time}.png', format='PNG')
        
        # 스트리밍 응답으로 이미지 반환
        return StreamingResponse(img_byte_arr, media_type="image/png")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    try:
        logger.info("Starting server")
        uvicorn.run(app, host="172.17.88.227", port=8000) 
    except Exception as e:
        logger.error(f"Error during startup: {str(e)}")
        logger.error(traceback.format_exc())