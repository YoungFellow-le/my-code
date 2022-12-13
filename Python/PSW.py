from time import *

acs = []

info = []

psw = []

true = True

while true:
    print("""
To add an account type: add
To login type: login
To remove an account type: remove
To exit type: exit
""")
    ans = str(input())

    if ans == 'add':

        print("type your username:")
        acs.append(str(input()))
        sleep(2)
        print("Type your password:")
        psw.append(str(input()))

        print("""
    To read your information type: info.
    To add info type: add.
    To exit type: exit.
    """)
        ans = str(input())

        if ans == 'info':
            print(info)
    
    elif ans == 'login':


    elif ans == 'remove':


    elif ans == 'exit':
