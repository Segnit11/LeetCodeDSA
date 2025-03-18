"""
Problem 1: Extra Treats
In a pet adoption center, there are two groups of volunteers: the "Cat Lovers" and the "Dog Lovers."

The center is deciding on which type of pet should be receive extra treats that week, and the voting takes place in a round-based procedure. 
In each round, each volunteer can exercise one of the two rights:

Ban one volunteer's vote: A volunteer can make another volunteer from the opposite group lose all their rights in this and all the following rounds.

Announce the victory: If a volunteer finds that all the remaining volunteers with the right to vote are from the same group, they can announce the 
victory for their group and prioritize their preferred pet for extra treats.

Given a string votes representing each volunteer's group affiliation. The character 'C' represents "Cat Lovers" and 'D' represents "Dog Lovers". 
The length of the given string represents the number of volunteers.

Predict which group will finally announce the victory and prioritize their preferred pet for extra treats. The output should be "Cat Lovers" or "Dog Lovers".


"""
"""
from collections import deque

def predictAdoption_victory(votes):
    # store the votes
    queue = deque(votes)
    cat_bans, dog_bans = 0, 0

    cats = len([ele for ele in votes if ele == "C"])
    dogs = len([ele for ele in votes if ele == "D"])

    while cats != 0 and dogs != 0:
        voter = queue.popleft()

        if voter == "C":
            if cat_bans > 0:
                cat_bans -= 1
                cats -= 1
            else:
                dog_bans += 1
                queue.append("C")
        else:
            if dog_bans > 0:
                dog_bans -= 1
                dogs -= 1
            else:
                cat_bans += 1
                queue.append("D")

    return "Cat Lover" if cats > 0 else "Dog Lover"
            

print(predictAdoption_victory("CD")) 
print(predictAdoption_victory("CDD")) 
print(predictAdoption_victory("CCCDDD"))

"""


"""
Remove All Adjacent Duplicate Shows
You are given a string schedule representing the lineup of shows on a streaming platform, where each character in the 
string represents a different show. A duplicate removal consists of choosing two adjacent and equal shows and removing them from the schedule.

We repeatedly make duplicate removals on schedule until no further removals can be made.

Return the final schedule after all such duplicate removals have been made. The answer is guaranteed to be unique.

Example Usage:
print(remove_duplicate_shows("abbaca")) 
print(remove_duplicate_shows("azxxzy")) 

Example Output:
ca
ay

"""

def remove_duplicate_shows(schedule):
    if len(schedule) < 1:
        return None
    
    stack = []

    for i in range(len(schedule)):
        if stack and stack[-1] == schedule[i]:
            stack.pop()
        else:
            stack.append(schedule[i])
    return "".join(stack)

print(remove_duplicate_shows("abbaca")) 
print(remove_duplicate_shows("azxxzy")) 
