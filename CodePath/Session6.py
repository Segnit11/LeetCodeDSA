"""
Problem 1: Blueprint Approval Process
You are in charge of overseeing the blueprint approval process for various architectural designs. Each blueprint has a specific complexity level, 
represented by an integer. Due to the complex nature of the designs, the approval process follows a strict order:

Blueprints with lower complexity should be reviewed first.
If a blueprint with higher complexity is submitted, it must wait until all simpler blueprints have been approved.
Your task is to simulate the blueprint approval process using a queue. You will receive a list of blueprints, each represented by their complexity 
level in the order they are submitted. Process the blueprints such that the simpler designs (lower numbers) are approved before more complex ones.

Return the order in which the blueprints are approved.

Example Usage:
print(blueprint_approval([3, 5, 2, 1, 4])) 
print(blueprint_approval([7, 4, 6, 2, 5])) 

Example Output:
[1, 2, 3, 4, 5]
[2, 4, 5, 6, 7]

"""

# def blueprint_approval(blueprints):

#     stack = []
#     stack.append(blueprints[0])
    
#     for i in range(1, len(blueprints)):
#         popped = []
        
#         while stack and stack[-1] > blueprints[i]:
#             popped.append(stack.pop())
        
#         stack.append(blueprints[i])

#         while popped:
#             stack.append(popped.pop())
    
#     return stack



# print(blueprint_approval([3, 5, 2, 1, 4])) 
# print(blueprint_approval([7, 4, 6, 2, 5])) 






"""
Problem 2: Build the Tallest Skyscraper
You are given an array floors representing the heights of different building floors. Your task is to design a skyscraper using these floors, 
where each floor must be placed on top of a floor with equal or greater height. However, you can only start a new skyscraper when necessary, 
meaning when no more floors can be added to the current skyscraper according to the rules.

Return the number of skyscrapers you can build using the given floors.

Example Usage:
print(build_skyscrapers([10, 5, 8, 3, 7, 2, 9])) 
print(build_skyscrapers([7, 3, 7, 3, 5, 1, 6]))  
print(build_skyscrapers([8, 6, 4, 7, 5, 3, 2])) 

Example Output:
4
4
6
"""

# floors = [10, 5, 8, 3, 7, 2, 9]
#                  i

# stack =  [5]
# count = 1


# def build_skyscrapers(floors):

#     stack = []
#     stack.append(floors[0])

#     count = 0

#     for i in range(1, len(floors)):
#         if floors[i] < stack[-1]:
#             count += 1
#             stack.pop()
#             stack.append(floors[i])
#         else:
#             stack.append(floors[i])
#     return count + 1





# print(build_skyscrapers([10, 5, 8, 3, 7, 2, 9])) 
# print(build_skyscrapers([7, 3, 7, 3, 5, 1, 6]))  
# print(build_skyscrapers([8, 6, 4, 7, 5, 3, 2])) 



"""
Problem 3: Dream Corridor Design
You are an architect designing a corridor for a futuristic dream space. The corridor is represented by a list of integer values where each 
value represents the width of a segment of the corridor. Your goal is to find two segments such that the corridor formed between them (including 
the two segments) has the maximum possible area. The area is defined as the minimum width of the two segments multiplied by the distance between them.

You need to return the maximum possible area that can be achieved.

Example Usage:
print(max_corridor_area([1, 8, 6, 2, 5, 4, 8, 3, 7])) 
print(max_corridor_area([1, 1]))

Example Output:
49
1
min(8, 7) × (8 - 1) = 7 × 7 = 49
(minimum width of the two chosen segments) × (distance between them)
"""

# def max_corridor_area(segments):
#     left, right = 0, len(segments) - 1
#     max_area = float("-inf")

#     while left < right:
#         area = min(segments[left], segments[right]) * (right - left)
#         max_area = max(max_area, area)
        
#         if segments[left] < segments[right]:   
#             left += 1
#         else:
#             right -= 1
#     return max_area

# print(max_corridor_area([1, 8, 6, 2, 5, 4, 8, 3, 7])) 
# print(max_corridor_area([1, 1]))




"""
Problem 4: Dream Building Layout
You are an architect tasked with designing a dream building layout. The building layout is represented by a string s of even length n. 
The string consists of exactly n / 2 left walls '[' and n / 2 right walls ']'.

A layout is considered balanced if and only if:

It is an empty space, or
It can be divided into two separate balanced layouts, or
It can be surrounded by left and right walls that balance each other out.
You may swap the positions of any two walls any number of times.

Return the minimum number of swaps needed to make the building layout balanced.

Example Usage:
print(min_swaps("][][")) 
print(min_swaps("]]][[[")) 
print(min_swaps("[]"))  

Example Output:
1
2
0
"""

# def min_swaps(s):
#     balance = 0
#     max_imbalance = 0

#     for char in s:
#         if char == "[":
#             balance  -= 1
#         else: # char == "]"
#             balance += 1
        
#         max_imbalance = max(max_imbalance, balance)

#     return (max_imbalance + 1) // 2
    
# print(min_swaps("][][")) 
# print(min_swaps("]]][[[")) 
# print(min_swaps("[]"))  



"""
Problem 5: Designing a Balanced Room
You are designing a room layout represented by a string s consisting of walls '(', ')', and decorations in the form of lowercase English letters.

Your task is to remove the minimum number of walls '(' or ')' in any positions so that the resulting room layout is balanced and return any valid layout.

Formally, a room layout is considered balanced if and only if:

It is an empty room (an empty string), contains only decorations (lowercase letters), or
It can be represented as AB (A concatenated with B), where A and B are valid layouts, or
It can be represented as (A), where A is a valid layout.


Example Usage:
print(make_balanced_room("art(t(d)e)sign)")) 
print(make_balanced_room("d)e(s)ign")) 
print(make_balanced_room("))((")) 

Example Output:
art(t(d)e)sign
de(s)ign

"""

# create a stack
    # iterate thru s
        # check if the char is "(":
            # if it is append to stack
        # else: # ")"
            # check if we have a corresponding "(" in the stack:
                # if we do it means they are balanced remove so keep both of them 
            # else: # if there is no "("
                # it means it is imbalanced so remove it
    # return s 

def make_balanced_room(s):

    s_list = list(s)
    stack = []

    for i, char in enumerate(s_list) :
        if char == "(":
            stack.append((char, i))
        elif char == ")":
            if stack and stack[-1][0] == "(":
                stack.pop()
            else:
                s_list[i] = ""
   
    while stack:
        char, i = stack.pop()
        s_list[i] = ""

    return "".join(s_list)



print(make_balanced_room("art(t(d)e)sign)")) 
print(make_balanced_room("d)e(s)ign")) 
print(make_balanced_room("))((")) 


Longest Substring Without Repeat





