from random import *
from time import sleep

tr = True
true = True

print("Hi!")
print("i'm the object choser!")
print("i'll use random")
sleep(1)
while true:
    print("""What do you want me to chose for you?""")
    ts = str(input("a "))
    lof = []
    num = 0
    print("How many " + ts + "s are there?")
    NOM = int(input("> "))
    for i in range (0, NOM):
        num +=1
        print("Type the " + ts + " number: ", num)
        print("")
        lof.append(str(input("> ")))
        cm = choice(lof)
    sleep(2)
    print("")
    print(cm + " is the " + ts + "!")
    print("")
    while tr:       
        re = input("""
If you want a redo with new choices then type: re

if you want to redo with the same %s type: rs

else if you want to exit then type: no

"""%ts)
        print("")
        if re == 're':
            break
        elif re == 'no':
            print("OK then, bye!")        
            tr = False
            true = False
        elif re == 'rs':
            cm = choice(lof)
            print(cm + " is the " + ts + "!" )
        else:
            print("What?!")
            continue
    






                   
