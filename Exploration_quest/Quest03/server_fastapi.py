import logging
from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import Response
from pydantic import BaseModel
from typing import List
import uvicorn
import numpy as np
import torch
from PIL import Image
import io
import base64
import os
import sys
import traceback
from functions import *
import matplotlib.pyplot as plt


# Hydra 설정
from hydra import initialize, compose
from hydra.core.global_hydra import GlobalHydra

# 로깅 설정
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

# 환경 변수 설정
os.environ["PYTORCH_ENABLE_MPS_FALLBACK"] = "1"

# 프로젝트 경로 설정
PROJECT_ROOT = '/home/faith/workspace/sam2'
SAM2_DIR = os.path.join(PROJECT_ROOT, 'sam2')
sys.path.extend([PROJECT_ROOT, SAM2_DIR])

# SAM2 관련 import
from sam2.build_sam import build_sam2
# from sam2.sam2_image_predictor import SAM2ImagePredictor
# from sam2.build_sam import build_sam2
from sam2.automatic_mask_generator import SAM2AutomaticMaskGenerator

# Pydantic 모델
class SegmentationRequest(BaseModel):
    image: str  # base64 encoded image

class Mask(BaseModel):
    segmentation: List[List[float]]
    area: float
    bbox: List[float]

class SegmentationResponse(BaseModel):
    masks: List[Mask]

# Hydra 초기화 함수
def init_hydra():
    if not GlobalHydra().is_initialized():
        initialize(config_path="sam2/segment-anything-2/sam2_configs")

# SAM2 모델 초기화
def init_sam2_model():
    sam2_checkpoint = "sam2/segment-anything-2/checkpoints/sam2_hiera_large.pt"
    model_cfg = "sam2_hiera_l.yaml"
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    sam2 = build_sam2(model_cfg, sam2_checkpoint, device=device, apply_postprocessing=False)
    return SAM2AutomaticMaskGenerator(sam2)

# 이미지 세그먼트 함수
def show_anns(anns, borders=True):
    if len(anns) == 0:
        return
    sorted_anns = sorted(anns, key=(lambda x: x['area']), reverse=True)
    ax = plt.gca()
    ax.set_autoscale_on(False)

    img = np.ones((sorted_anns[0]['segmentation'].shape[0], sorted_anns[0]['segmentation'].shape[1], 4))
    img[:, :, 3] = 0
    for ann in sorted_anns:
        m = ann['segmentation']
        color_mask = np.concatenate([np.random.random(3), [0.5]])
        img[m] = color_mask 
        if borders:
            import cv2
            contours, _ = cv2.findContours(m.astype(np.uint8), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE) 
            # Try to smooth contours
            contours = [cv2.approxPolyDP(contour, epsilon=0.01, closed=True) for contour in contours]
            cv2.drawContours(img, contours, -1, (0, 0, 1, 0.4), thickness=1) 

    ax.imshow(img)

import numpy as np
import matplotlib.pyplot as plt
import cv2

def separate_segments(anns, original_image=None):
    if len(anns) == 0:
        return []

    sorted_anns = sorted(anns, key=(lambda x: x['area']), reverse=True)
    
    # 원본 이미지가 제공되지 않은 경우 빈 이미지 생성
    if original_image is None:
        original_image = np.zeros((sorted_anns[0]['segmentation'].shape[0], 
                                   sorted_anns[0]['segmentation'].shape[1], 3), 
                                  dtype=np.uint8)

    separated_images = []

    for i, ann in enumerate(sorted_anns):
        mask = ann['segmentation']
        
        # 마스크를 3채널로 확장
        mask_3channel = np.stack([mask] * 3, axis=2)
        
        # 세그먼트만 추출
        segment_image = np.where(mask_3channel, original_image, 0)
        
        # 외곽선 그리기
        contours, _ = cv2.findContours(mask.astype(np.uint8), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        contours = [cv2.approxPolyDP(contour, epsilon=0.01, closed=True) for contour in contours]
        cv2.drawContours(segment_image, contours, -1, (0, 255, 0), thickness=2)

        separated_images.append(segment_image)

    return separated_images

def display_separated_segments(separated_images):
    n = len(separated_images)
    cols = 3
    rows = (n + cols - 1) // cols

    fig, axes = plt.subplots(rows, cols, figsize=(15, 5 * rows))
    axes = axes.flatten() if n > 1 else [axes]

    for i, img in enumerate(separated_images):
        axes[i].imshow(img)
        axes[i].set_title(f'Segment {i+1}')
        axes[i].axis('off')

    # 남은 subplot 숨기기
    for i in range(n, len(axes)):
        axes[i].axis('off')

    plt.tight_layout()
    plt.show()

# 사용 예시:
# anns = [세그먼트 정보들...]
# original_image = 원본 이미지 (옵션)
# separated_images = separate_segments(anns, original_image)
# display_separated_segments(separated_images)


# FastAPI 앱 초기화
app = FastAPI()

# mask_generator를 전역 변수로 선언
mask_generator = None

# 앱 시작 시 실행될 이벤트
@app.on_event("startup")
async def startup_event():
    global mask_generator
    logger.info("Initializing Hydra")
    init_hydra()
    logger.info("Initializing SAM2 model")
    mask_generator = init_sam2_model()
    logger.info("SAM2 model initialized successfully")

# CORS 미들웨어 추가
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 요청 로깅 미들웨어
@app.middleware("http")
async def log_requests(request: Request, call_next):
    logger.info(f"Received request: {request.method} {request.url}")
    response = await call_next(request)
    return response

# 전역 예외 처리기
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    logger.error(f"Unhandled exception: {str(exc)}")
    logger.error(traceback.format_exc())
    return JSONResponse(
        status_code=500,
        content={"message": "Internal server error", "detail": str(exc)},
    )

# 루트 엔드포인트
@app.get("/")
async def root():
    return {"message": "Hello from WSL FastAPI server!"}

# 이미지 세그멘테이션 엔드포인트트
# @app.post("/sam2/", response_model=SegmentationResponse)
# async def segment2(request: SegmentationRequest):
    # print(request.image)

    # data = segmentation_to_image(request.image)

# 이미지 세그멘테이션 엔드포인트
@app.post("/segment/")
async def segment_image(request: SegmentationRequest):
    print("하이")
    global mask_generator
    if mask_generator is None:
        raise HTTPException(status_code=500, detail="SAM2 model not initialized")

    try:
        logger.debug("Decoding base64 image")
        image_data = base64.b64decode(request.image)
        logger.debug("Opening image")
        image = Image.open(io.BytesIO(image_data))
        logger.debug("Converting image to numpy array")
        image_np = np.array(image)

        logger.debug("Generating masks")
        masks = mask_generator.generate(image_np)
        print(masks[0])
        logger.debug(f"Generated {len(masks)} masks")

        plt.figure(figsize=(20, 20), dpi=300)
        plt.imshow(image)
        show_anns(masks)
        plt.axis('off')
        # plt.show() 

        
        # Convert masks to the format expected by the SegmentationResponse
        # response_masks = []
        # for mask in masks:
        #     response_masks.append(Mask(
        #         segmentation=mask['segmentation'].tolist(),
        #         area=float(mask['area']),
        #         bbox=mask['bbox']
        #     ))

        # 이미지를 바이트 스트림으로 저장
        img_byte_arr = io.BytesIO()
        plt.savefig(
            img_byte_arr,
            format='png',
            bbox_inches='tight',   # Minimize whitespace
            pad_inches=0,          # No extra padding
            dpi=300                # High resolution
        )
        img_byte_arr.seek(0)
        plt.close()

        return Response(content=img_byte_arr.getvalue(), media_type="image/png")

    except Exception as e:
        logger.error(f"Error in segment_image: {str(e)}")
        logger.error(traceback.format_exc())
        raise HTTPException(status_code=500, detail=str(e))
    
# 이미지 세그멘테이션 엔드포인트
@app.post("/segment2/")
async def segment_image(request: SegmentationRequest):
    print("하이")
    global mask_generator
    if mask_generator is None:
        raise HTTPException(status_code=500, detail="SAM2 model not initialized")

    try:
        logger.debug("Decoding base64 image")
        image_data = base64.b64decode(request.image)
        logger.debug("Opening image")
        image = Image.open(io.BytesIO(image_data))
        logger.debug("Converting image to numpy array")
        image_np = np.array(image)

        logger.debug("Generating masks")
        masks = mask_generator.generate(image_np)
        # print(masks[0])
        logger.debug(f"Generated {len(masks)} masks")

        plt.figure(figsize=(20, 20), dpi=300)
        plt.imshow(image)
        display_separated_segments(masks)
        plt.axis('off')


        masks = mask_generator.generate(image_np)
        separated_images = separate_segments(masks, image_np)
        display_separated_segments(separated_images)

        # 이미지를 바이트 스트림으로 저장
        img_byte_arr = io.BytesIO()
        plt.savefig(
            img_byte_arr,
            format='png',
            bbox_inches='tight',   # Minimize whitespace
            pad_inches=0,          # No extra padding
            dpi=300                # High resolution
        )
        img_byte_arr.seek(0)
        plt.close()

        return Response(content=img_byte_arr.getvalue(), media_type="image/png")

    except Exception as e:
        logger.error(f"Error in segment_image: {str(e)}")
        logger.error(traceback.format_exc())
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    try:
        logger.info("Starting server")
        uvicorn.run(app, host="0.0.0.0", port=8000) 
    except Exception as e:
        logger.error(f"Error during startup: {str(e)}")
        logger.error(traceback.format_exc())