# main.py
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse, PlainTextResponse
from fastapi import FastAPI
from pydantic import BaseModel

import json
import re

import google.generativeai as genai

from IPython.display import display
from IPython.display import Markdown

import os

with open('apikey.txt', 'r') as key:
  API_KEY = key.read()

genai.configure(api_key=API_KEY)
model = genai.GenerativeModel('gemini-1.5-flash')


# FastAPI 애플리케이션 인스턴스 생성
app = FastAPI()

# cors 요청 리스트
origins = [
    "http://localhost",
    "http://127.0.0.1:8000",
    "http://localhost:52144",
    "http://localhost:54366",
    "http://localhost:56081",
    "http://10.0.2.2:8000"
]

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
    response = model.generate_content(
    '''
    당신은 Flutter 전문가입니다. 마인드맵 생성을 위해 Flutter의 가장 중요한 5가지 핵심 개념을 선별해 주세요. 각 개념에 대해 초보자도 이해할 수 있는 간단한 설명을 10단어 이내로 제공해 주세요. 한글로 답변해주시고, 다음 형식으로 답변해 주세요:
    1. [개념1]: [간단한 설명]
    2. [개념2]: [간단한 설명]
    3. [개념3]: [간단한 설명]
    4. [개념4]: [간단한 설명]
    5. [개념5]: [간단한 설명]
    ''')

    a  = response.text
    return {"a": a}

# 요청 본문을 위한 Pydantic 모델
class Item(BaseModel):
    keyword: str

# 응답을 위한 Pydantic 모델
class Gemini(BaseModel):
    keyword: str
    description: str

@app.get("/data")
def path_name():
    
    response = model.generate_content(
    '''
    당신은 Flutter 전문가입니다. 마인드맵 생성을 위해 Flutter의 가장 중요한 5가지 핵심 개념을 선별해 주세요. 
    각 개념에 대해 초보자도 이해할 수 있는 간단한 설명을 10단어 이내로 제공해 주세요. 
    모든 개념을 한글로 답변해야한다. 영어도 한글로 번역해서 답변하라. 다음 형식으로 답변해 주세요:
    1. [개념1]: [간단한 설명]
    2. [개념2]: [간단한 설명]
    3. [개념3]: [간단한 설명]
    4. [개념4]: [간단한 설명]
    5. [개념5]: [간단한 설명]
    ''')

    data = response.text
    data = data.replace("**", "")

    # '1.'을 기준으로 앞 부분을 자르고, 나머지 부분을 추출
    _, concepts_part = data.split("1.", 1)

    # 개념 부분을 줄 단위로 분리
    lines = concepts_part.strip().split('\n')

    # 각 라인을 keyword와 description으로 분리하여 JSON 객체로 변환
    result = []
    for line in lines:
        # 숫자와 점을 제거하고, ':'를 기준으로 분리
        cleaned_line = re.sub(r'^\d+\.\s*', '', line).strip()
        print(cleaned_line)  # "Widget**: UI 요소의 기본 빌딩 블록"

        keyword, description = cleaned_line.split(':', 1)
        result.append({"keyword": keyword.strip(), "description": description.strip()})

    # 결과 출력
    return JSONResponse(content=result, media_type="application/json; charset=utf-8")


@app.post("/subdata")
async def create_items(item: Item):
    input = f'''
    당신은 Flutter 전문가입니다. 마인드맵 생성을 위해 플러터에서 가장 중요한 {item.keyword}에 대한 5가지 핵심 대표 키워드를 선별해 주세요. 
    각 개념에 대해 초보자도 이해할 수 있는 간단한 설명을 10단어 이내로 제공해 주세요. 
    모든 개념을 한글로 답변해야한다. 영어도 한글로 번역해서 답변하라. 그리고 다음 형식으로 답변해야한다:
    1. [개념1]: [간단한 설명]
    2. [개념2]: [간단한 설명]
    3. [개념3]: [간단한 설명]
    4. [개념4]: [간단한 설명]
    5. [개념5]: [간단한 설명]
    '''
    print(input)
    response = model.generate_content(input)

    data = response.text
    data = data.replace("**", "")


    # '1.'을 기준으로 앞 부분을 자르고, 나머지 부분을 추출
    _, concepts_part = data.split("1.", 1)

    # 개념 부분을 줄 단위로 분리
    lines = concepts_part.strip().split('\n')


    # 각 라인을 keyword와 description으로 분리하여 JSON 객체로 변환
    result = []
    for line in lines:
        # 숫자와 점을 제거하고, ':'를 기준으로 분리
        cleaned_line = re.sub(r'^\d+\.\s*', '', line).strip()
        print(cleaned_line)  # "Widget**: UI 요소의 기본 빌딩 블록"

        keyword, description = cleaned_line.split(':', 1)
        result.append({"keyword": keyword.strip(), "description": description.strip()})

    # 결과 출력
    return JSONResponse(content=result, media_type="application/json; charset=utf-8")


# Detail Page
@app.post("/detail", response_class=PlainTextResponse)
def detail_page(item: Item):
    print(item.keyword)
    contents = f'''
    당신은 Flutter 전문가입니다. 플러터 위젯 설명이 필요한 상황이고, 
    [{item.keyword}] 에 대한 전문가적인 설명이 필요해.
    어린 아이들도 이해할 수 있을 정도로 설명해서 이 글을 읽는 초심자도 쉽게 이해할 수 있게 설명한다.
    [{item.keyword}]에 대하여 간단한 용어로 설명하세요.
    이 설명을 보고 직관적인 이해가 되었으면 좋겠다.
    가능한 Step by step으로 설명한다.
    예시 코드를 첨부해야한다.
    답변을 할 때 편견이 없도록 하고 고정관념에 의존하지 않도록 유의해주세요.
    '''
    response = model.generate_content(contents)
    print(item.keyword, contents)

    text = response.text
    return PlainTextResponse(content=text, media_type="text/plain; charset=utf-8")