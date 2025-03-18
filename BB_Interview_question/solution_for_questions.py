# Question 1
class ListNode:
    def __int__(self, val, next=None):
        self.val = val
        self.next = None

def swap_adjacent(head):
    # create a dummy node
    dummy = ListNode(0)
    dummy.next = head
    current = dummy

    while current.next and current.next.next:
        first = current.next
        second = current.next.next

        # swapping the pointers
        first.next = second.next
        second.next = first
        current.next = second

        # update the current
        current = first
    
    return dummy.next




# Question 2
# { "AAABBB",     ""     },
def candy_crush(some_string):
    
    stack = []
    
    for char in some_string:
        if stack and stack[-1][0] == char:
            stack[-1][1] += 1
        else:
            stack.append([char, 1])

        if stack[-1][1] >= 3:
            stack.pop()
    
    result = ''

    for char, count in stack:
        result += char * count
    
    # return result if result == some_string else candy_crush(result)
        
    if result == some_string:
        return result
    else:
        return candy_crush(result)





# Question 3
from collections import deque
def number_of_island(grid):
    if not grid:
        return 0

    rows = len(grid)
    cols = len(grid[0])
    
    queue = deque()
    seen = set()
    num_island = 0
    
    # Directions for adjacent cells (right, left, down, up)
    neighbours = [(0, 1), (0, -1), (1, 0), (-1, 0)]

    # find the positon with a value one
    # First Find the ones you see increament by one then find there neigbour without increamenting anything. 
    for r in range(rows):
        for c in range(cols):
            if grid[r][c] == 1 and (r, c) not in seen:
                queue.append([[r][c]])
                seen.add([[r][c]])
                num_island += 1

                # BFS to mark all connected land cells
                while queue:
                    pr, pc = queue.popleft()
                    for nr, nc in neighbours:
                        dr = nr + pro
                        dc = nc + dc
                        if (0 <= dr < rows and 
                        0 <= dc < cols and 
                        grid[dr][dc] == 1 and 
                        (dr, dc) not in seen):
                            queue.append((dr, dc))
                            seen.add((dr, dc))
    return num_island




# Question 4:
from collections import Counter
def check_Anagram(s, t):
    if len(s) !=  len(t):
        return False
    
    s_count = Counter(s)
    t_count = Counter(t)

    return s_count == t_count




# Question 5:
def max_tickets(tickets, k):
    tickets.sort(reverse=True)
    sum_tickets = sum(tickets[:k])
    return sum_tickets



# Question 8:
# Definition for singly-linked list.
class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next
        
def remove_target(head, target):
    dummy = ListNode(None)
    dummy.next = head
    prev = dummy
    curr = head
    
    while curr:
        if curr.val == target:
            prev.next = curr.next
        else:
            prev = curr
        curr = curr.next
    return dummy.next
    



# Question 9:
from collections import Counter
class Solution:
    def topKFrequent(self, nums: List[int], k: int) -> List[int]:
        counter = Counter(nums) # O(N)

        # O(NLogN)
        sorted_items = sorted(counter.items(), key = lambda x: x[1], reverse=True)
        
        result = [] # O(N) => Space
        for keys, values in sorted_items[:k]: # O(N)
            result.append(keys)

        return result



# Question 10:
class Solution:
    def canAttendMeetings(self, intervals: List[List[int]]) -> bool:
        # sort the intervals using the starting time
        # iterate thru the intervals
            # compare the ending time of interval i > starting time of i+1
                # return false
        # return true

        # time compexity = iteration O(N), sorting O(NlogN) = O(NLogN)
        # space compecity = O(1)

        intervals.sort(key=lambda x: x[0])
        for i in range(len(intervals) - 1):
            if intervals[i][1] > intervals[i + 1][0]:
                return False
        return True




# Question 11:
class Solution:
    def isValid(self, s: str) -> bool:
        
        stack = []

        for c in s:
            if c in ["(", "[", "{"]:
                stack.append(c)
            elif c in [")", "]", "}"]:
                if not stack:
                    return False
                top = stack.pop()
                if (c == ")" and top != "(") or (c == "]" and top != "[") or (c == "}" and top != "{"):
                    return False
        return not stack


# Question 12:
# Question 13:

# Question 14:
import random

class LotterySystem:
    def __init__(self):
        self.contestants = {}

    def registerContestant(self, name: str):
        """Register a contestant with the given name."""
        if name not in self.contestants:
            self.contestants[name] = True
            print(f"Contestant '{name}' registered successfully.")
        else:
            print(f"Contestant '{name}' is already registered.")

    def unregisterContestant(self, name: str):
        """Unregister a contestant with the given name."""
        if name in self.contestants:
            del self.contestants[name]
            print(f"Contestant '{name}' unregistered successfully.")
        else:
            print(f"Contestant '{name}' is not registered.")

    def isRegistered(self, name: str):
        """Check if a contestant with the given name is registered."""
        return name in self.contestants

    def changeName(self, oldName: str, newName: str):
        """Change the name of a registered contestant."""
        if oldName in self.contestants:
            self.contestants[newName] = self.contestants.pop(oldName)
            print(f"Name changed from '{oldName}' to '{newName}' successfully.")
        else:
            print(f"Contestant '{oldName}' is not registered.")

    def drawWinner(self):
        """Draw a winner from the registered contestants."""
        if self.contestants:
            winner = random.choice(list(self.contestants.keys()))
            print(f"The winner is: {winner}")
        else:
            print("No contestants registered.")


# Example usage
lottery = LotterySystem()

lottery.registerContestant("John Doe")
lottery.registerContestant("Jane Doe")

print(lottery.isRegistered("John Doe"))  # Output: True

lottery.changeName("John Doe", "Johnny Doe")

lottery.drawWinner()




# Question 15:
class TreeNode:
    def __init__(self, val=0, left=None, right=None, next=None):
        self.val = val
        self.left = left
        self.right = right
        self.next = next

from collections import deque

class Solution:
    def connect(self, root: 'Optional[Node]') -> 'Optional[Node]':
        if not root:
            return None
        
        queue = deque([root])

        while queue:
            curr_level = len(queue)
            prev_node = None
            
            for i in range(curr_length):
                node = queue.popleft()
                
                if prev_node:
                    prev_node.next = node
                prev_node = node
                
                if node.left:
                    queue.append(node.left)
                if node.right:
                    queue.append(node.right)

        return root
    


# Question 16:
# Question 17:


# Question 18:

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
            (dr, dc) not in seen and matrix[dr][dc] != "r":
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

    


# Question 19:
# Question 20:


# Question 21:
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right
        self.link = None 

from collections import deque

def connect_levels(root: TreeNode) -> None:
    if not root:
        return None
        
    queue = deque([root])
    level = 0

    while queue:
        curr_length = len(queue)
        level += 1
        level_nodes = []
        for _ in range(curr_length):
            node = queue.popleft()
            level_node.append(node)

            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
        
        n = len(level_node)
        if level % 2 != 0: # if odd
            for i in range(n - 1):
                level_node[i].link = level_node[i+1]
            level_node[-1].link = None
        else: # if even
            for i in range(n-1, 0, -1):
                level_node[i].link = level_node[i-1]
            level_node[0].link = None
            
    return root


def numIslands_recursive(grid):
    if not grid:
        return 0
    
    rows = len(grid)
    cols = len(grid[0])

    island = 0

    def dfs(i, j):
        if 0 <= i < rows and 0 <= j < cols and grid[i][j] != "1":
            return
        grid[i][j] = "0" # sink the land
    
        # explore the neighbours
        dfs(i, j+1)
        dfs(i, j-1)
        dfs(i+1, j)
        dfs(i-1, j)

    for r in range(rows):
        for c in range(cols):
            if grid[r][c] == "1":
                dfs(r, c)
                island += 1
    return island




def numIslands_iterative(grid):
    if not grid:
        return 0
    
    rows = len(grid)
    cols = len(grid[0])

    island = 0
    stack = []

    directions = [(1, 0), (-1, 0), (0, 1), (0, -1)]

    for r in range(rows):
        for c in range(cols):
            if grid[r][c] == "1":
                stack.append((r, c))
                grid[r][c] = "0"
                island += 1
                
                while stack:
                    row, col = stack.pop()
                    for dr, dc in directions:
                        nr, nc = row + dr, col + dc
                        if 0 <= nr < rows and 0 <= nc < rows and grid[nr][nc] == "1":
                            stack.append((nr, nc))
                            grid[nr][nc] = "0"
    return island
