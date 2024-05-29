import random
from Character import Monster
from Store import *

def mon_generator(monster, level):
    mon_number = random.randint(1,3)
    print(mon_number)
    for i in range(mon_number):
        if mon_number == i :
            StopIteration
        yield Monster(monster, level)

def battle(player, monster):
    print("전투에 돌입합니다.")
    print(player)
    print(monster)
    while True:
        if player.hp < 0:
            print("패배하였습니다.")
            break

        if monster.hp < 0:
            경험치 = 10
            print(f"승리하였습니다. 경험치를 {경험치} 획득합니다.")
            player.gain_exp(경험치)
            break

        print("*"*30)
        player.attack_target(monster)
        player.take_damage(monster)

def stage_gen(person):

    monster_list = [["슬라임", 1], ["스켈레톤", 2],["마녀", 3], ["고스트",4], ["골렘", 5], ["가디언",6], ["좀비병사",7], ["좀비장군",8], ["쿠퍼",9], ["킹쿠퍼", 10]]

    for i in range(len(monster_list)):
        if person.hp < 0:
            break

        print(f"★☆★☆★☆★☆ stage level {i} ★☆★☆★☆★☆")
        stage = mon_generator(monster_list[i][0], monster_list[i][1])

        # 상점코드
        # s = Store()
        # s.display()
        # s.order(person)
        for j in stage:
            if person.hp < 0:
                print("종료합니다.")
                break
            battle(person, j)