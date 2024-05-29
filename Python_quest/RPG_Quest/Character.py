import random

class Character:
    def __init__(self, job):
        self.job = job

    def __str__(self):
        return f">>> {self.job}: 레벨 {self.level}, 체력 {self.hp}, 공격력 {self.att}, 방어력 {self.ac},"

    def is_alive(self):
        if self.hp > 0:
            return True
        else:
            return False

    def take_damage(self, monster):
        enemyAtt = random.randint(1, int(monster.att))
        # print("적 공격", enemyAtt, "내 방어", self.ac)
        
        # 공격력이 더 높을경우 데미지 계산
        damage = (enemyAtt - self.ac)

        # 방어력이 더 높을 경우 do nothing
        if damage <= 0:
            print("상대방의 공격력보다 내 방어력이 높아 데미지를 입지 않았습니다.")
            return

        # 데미지만큼 HP차감
        self.hp = self.hp - damage

        # 출력
        print(f"[알림] {monster.job}이 공격합니다.")
        print(f">>> 이번 적 데미지 {damage} 내 체력 {self.hp}")
        return self.hp

    def attack_target(self, enemy):
        # 데미지 계산
        myattack = random.randint(1, self.att)
        damage = myattack - enemy.ac
        
        # 적의 방어력이 더 높을 경우 do nothing
        if damage <= 0:
            print("내 공격력보다 적의 방어력이 높아 데미지를 입히지 못했습니다.")
            return

        # 결과
        result = enemy.hp - damage
        enemy.hp = result

        # 출력
        print(f"[알림] {enemy.job}을 공격합니다.")
        print(f">>> 이번 공격 데미지: {damage}, {enemy.job}의 남은 체력: {enemy.hp}")
        return enemy.hp

class Player(Character):
    # 레벨 1, 체력 100, 공격력 25, 방어력 5로 초기화 하기
    def __init__(self, *args):
        if len(args) == 1:
            self.job = args[0]
            self.hp = 100
            self.att = 25
            self.ac = 5
            self.level = 1
        elif len(args) == 5:
            self.job, self.hp, self.att, self.ac, self.level = args
        else:
            print("잘못 입력하셨습니다.")
        self.exp = 0

    # 경험치 획득 메서드 - 추가 경험치를 획득하고, 현재 경험치가 50이상이면 레벨을 1 올린다
    def gain_exp(self, amount):
        print(f"{self.job}이 경험치를 {amount} 획득하였습니다.")
        self.exp += amount
        print(self.exp)
        if self.exp >= 50:
            self.level_up()
            self.exp = self.exp % 50
            print("현재 경험치", self.exp)

    # 레벨이 1 오를때 - 공격력을 10, 방어력을 5씩 올리는 level_up 메서드
    def level_up(self):
        print("레벨이 증가하였습니다. 체력 + 30, 공격력 + 10, 방어력 + 5 ")
        self.level += 1
        self.hp += 30
        self.att += 10
        self.ac += 5

class Monster(Character):
    def __init__(self, job, level):
        self.job = job
        self.level = level
        self.hp = random.randint(21, 25) + (level * 3)
        self.att = random.randint(11,13) + (level * 2)
        self.ac = random.randint(2,4) + (level * 1.3)

