from Character import *

class Store:
    weapon_list = [["장난감 칼", 7, 300], ["청동기 검", 15, 600], ["강철 대검", 25, 1500]]
    armor_list = [["누더기 천",3,300], ["고철 갑옷",7, 600], ["강철 갑옷",12, 1500]]
    acc_list = [["이상한 링", 20,300], ["빛 목걸이", 40, 600], ["마법의 돌", 60, 1500]]
    
    def __init__(self):
        self.weapon = 0
        self.armor = 0
        self.acc = 0
        
    def display(self):
        print("안녕하신가! 없는것 빼고 다 있는 전투 상점에 오신 것을 환영하네. 돈만주면 무엇이든 줄테니 한번 골라보라해.")
        for i in range (len(self.weapon_list)):
            print(f"{i+1} {self.weapon_list[i][0]:<5}  {self.weapon_list[i][1]:>3}  {self.weapon_list[i][2]:>4} G")

    def order(self, balance):
        this = int(input("구입한다: "))
        print(f"{self.weapon_list[this-1][0]}을 구입하셨습니다.")

        if int(self.weapon_list[this-1][2]) < balance: #비교
            balance = balance - self.weapon_list[this-1][2]
            self.weapon = self.weapon_list[this-1][1]
            print(self.weapon_list)
            print(f"공격력이 {self.weapon}만큼 강화되었습니다.")
            return balance
        if int(self.weapon_list[this-1][2]) > balance: #비교
            print("금액이 부족합니다.")
            return


