"""
Desert Terrain Problem

Given a 2D matrix representing a desert terrain, determine if a car ("c") can reach an oasis ("o") 
from its starting position.

Terrain Features:
Empty spaces (".") that the car can drive through
Rocks ("r") that block the car's path
Gas stations ("x") that the car can drive through and refuel
Only one oasis ("o") in the matrix that the car has to reach

Car Movement:
The car can be located anywhere in the matrix
The car can move horizontally or vertically
The car starts with a full tank of gas that allows it to move up to 5 spaces
The car can refuel at gas stations to extend its range

Goal:
Write a function that takes the 2D matrix as input and returns a boolean value indicating whether 
the car can reach the oasis.

Example:
Input:
[
  ["c", ".", ".", ".", ".", "."],
  [".", "x", ".", "r", ".", "."],
  [".", ".", ".", ".", ".", "o"]
]

Output: True
"""


    # go thru the matrix to find the car's position
    # queue = (car position)
    # count = 0
    # seen = set() -> store the position(not to explore them again)
    # check the neightbour of the position
        # validate the boundaries of the neighbours 
        # check if the pisiton is gas station or osasis
            # if it a oasis
                # return true
            # if it is a gas station
                # count_step = 0
                # add to seen

        # else if it not either of them but if it empty space:
            # keep exploring the neigbour if it is not in seen
                #  add to seen
        # else if the position is rock
            # skip it 
    #return False

# car = c
# empty space = .
# rocks = r
# gas_stations = x
# oasis = o

from collections import deque

def desert_terrian(matrix):       
    # declaring rows and cols     
    rows, cols = len(matrix), len(matrix[0])
    
    # to store the unique position
    seen = set()

    # queue to stating position
    queue = deque()
    
    # search for the car's position
    for r in range(rows):
        for c in range(cols):
            if matrix[r][c] == "c":
                queue.append((r, c, 5)) # (row, col, fuel)
                seen.add((r, c))
                break
    
    # neigbour visiting vertically or horizontally
    count_steps = 0
    neighbours = [(1, 0), (-1, 0), (0, 1), (0, -1)]

    while queue:
        r, c, fuel = queue.popleft()
        if fuel < 0: # Out of fuel, skip this path
            continue
        # check the neigbours of that position
        for nr, nc in neighbours:
            dr, dc = r + nr, c + nc
            # check if the neigbours are inside the boundary
            # checking the niebours is not a rock and the step is not more than 5 because we don't have gas for it
            if 0 <= dr < rows and 0 <= dc < cols and 
            (dr, dc) not in seen and matrix[dr][dc] != "r" and count_steps < 6:
                if matrix[dr][dc] == "o":
                    return True
                elif matrix[dr][dc] == "x":
                    count_steps = 0
                    queue.append((dr, dc, 5))
                    seen.add((dr, dc))
                else: # empty space
                    queue.append((dr, dc, fuel - 1))
                    seen.add((dr, dc))
    return False


