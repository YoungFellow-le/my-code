user = {}
status = ""

def DisplayMenu ():
	print("Are you a registered user? y/n?, press 'q' to quit.")
	status = input()
	if status == "y" :
		oldUser()
	elif status == "n":
		newUser()
def newUser():
	print("Create UserName:")
	createLogin = input()

	if createLogin in users:
		print("\nUser name in use!\n")

	else:
		print("")
		createPassw = input()
