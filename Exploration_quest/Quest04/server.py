from fastapi import FastAPI, HTTPException, Request, logger
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse, Response
import uvicorn
import traceback

import os, io, base64
import tensorflow as tf
from tensorflow.keras import layers
from IPython import display
import matplotlib.pyplot as plt

# FastAPI 앱 초기화
app = FastAPI()

# CORS 미들웨어 추가
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

checkpoint_dir = '/home/faith/workspace/cifar/training_checkpoints/'

generator_optimizer = tf.keras.optimizers.Adam(1e-4)
discriminator_optimizer = tf.keras.optimizers.Adam(1e-4)

# 생성자 모델 정의

def make_generator_model():
    noise_input = layers.Input(shape=(100,))
    label_input = layers.Input(shape=(10,))
    
    x = layers.Concatenate()([noise_input, label_input])
    x = layers.Dense(8*8*512, use_bias=False)(x)
    x = layers.BatchNormalization()(x)
    x = layers.LeakyReLU()(x)

    x = layers.Reshape((8, 8, 512))(x)
    
    x = layers.Conv2DTranspose(256, (4, 4), strides=(1, 1), padding='same', use_bias=False)(x)
    x = layers.BatchNormalization()(x)
    x = layers.LeakyReLU()(x)

    x = layers.Conv2DTranspose(128, (4, 4), strides=(2, 2), padding='same', use_bias=False)(x)
    x = layers.BatchNormalization()(x)
    x = layers.LeakyReLU()(x)

    x = layers.Conv2DTranspose(3, (4, 4), strides=(2, 2), padding='same', use_bias=False, activation='tanh')(x)

    model = tf.keras.Model([noise_input, label_input], x)
    return model


# 손실 함수 정의
cross_entropy = tf.keras.losses.BinaryCrossentropy(from_logits=True)


# 모델 생성
generator = make_generator_model()
generator.summary()

checkpoint_prefix = os.path.join(checkpoint_dir, "ckpt")
checkpoint = tf.train.Checkpoint(generator_optimizer=generator_optimizer,
                                 discriminator_optimizer=discriminator_optimizer,
                                 generator=generator)

checkpoint.restore(tf.train.latest_checkpoint(checkpoint_dir))

# 이미지 생성 함수
def generate_specific_class(class_num):
    noise = tf.random.normal([1, 100])
    one_hot_label = tf.one_hot([class_num], depth=10)
    generated_image = generator([noise, one_hot_label], training=False)
    
    plt.figure(figsize=(4, 4))
    plt.imshow((generated_image[0, :, :, :] + 1) / 2.0)
    plt.axis('off')
    plt.title(f'Generated image for class {class_num}')
    
    # 이미지를 바이트로 저장
    buf = io.BytesIO()
    plt.savefig(buf, format='png')
    buf.seek(0)
    
    # 바이트를 base64로 인코딩
    image_base64 = base64.b64encode(buf.getvalue()).decode('utf-8')
    
    plt.close()
    
    return image_base64


# 루트 엔드포인트
@app.get("/")
async def root():
    return {"message": "Hello from WSL FastAPI server!"}

# 이미지 세그멘테이션 엔드포인트
@app.post("/gan/")
async def generate_image(request: Request):
    print('안녕')
    try:
        data = await request.json()
        class_num = data.get('label')  # 기본값 2
        print(class_num)
        image_base64 = generate_specific_class(class_num)
        return JSONResponse(content={"image": image_base64}, status_code=200)
    except Exception as e:
        print(f"Error: {str(e)}")
        return JSONResponse(content={"error": str(e)}, status_code=500)

if __name__ == "__main__":
    try:
        logger.info("Starting server")
        uvicorn.run(app, host="0.0.0.0", port=8000) 
    except Exception as e:
        logger.error(f"Error during startup: {str(e)}")
        logger.error(traceback.format_exc())