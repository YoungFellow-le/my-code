#!/bin/python3

from shoe_app import shoe_app

low = shoe_app('And 1s', 30)
medium = shoe_app('Air Force 1s', 120)
high = shoe_app('Off whites', 400)

try:
    shoe_budget = float(input("Enter your budget: "))
except ValueError:
    exit("Please enter a number")
    
for shoes in [high, medium, low]:
    shoes.buy(shoe_budget)