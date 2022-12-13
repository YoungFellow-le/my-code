from time import *

while True:
    name = str(input("""What is your name?
> """))
    height = float(input("""What is your height in meters?
> """))
    weight = float(input("""What is your weight in kg?
> """))

    bmi = weight / (height ** 2)

    print("BMI: %s " %bmi)

    if bmi < 25 and bmi > 18.5:
        print("%s isn't over weight nor under weight! :)" %name)
    elif bmi > 25:
        print("%s is over weight. :(" %name)
    elif bmi < 18.5:
        print("%s is under weight. :|" %name)

    sleep(2)

    re = input("""

To continue type: cn
else type: no

> """)

    if re == 'cn':
        continue
    elif re == 'no':
        print("OK, bye then!")
        break
