"""
76. Minimum Window Substring

Given two strings s and t of lengths m and n respectively, return the minimum window substring of s such that every character in t 
(including duplicates) is included in the window. If there is no such substring, return the empty string "".

The testcases will be generated such that the answer is unique.


Example 1:

Input: s = "ADOBECODEBANC", t = "ABC"
Output: "BANC"
Explanation: The minimum window substring "BANC" includes 'A', 'B', and 'C' from string t.

Example 2:
Input: s = "a", t = "a"
Output: "a"
Explanation: The entire string s is the minimum window.

Example 3:
Input: s = "a", t = "aa"
Output: ""
Explanation: Both 'a's from t must be included in the window.
Since the largest window of s only has one 'a', return empty string.

"""

# class Solution:
#     def check_all_char(self, t, substring):
#         for char in t:
#             if char not in substring:
#                 return False
#         return True
    
#     def minWindow(self, s, t):
#         if len(t) > len(s):
#             return ""

#         shortest_substring = ""
#         min_length = float("inf")

#         for i in range(len(s)):
#             for j in range(i, len(s) + 1):
#                 substring = s[i:j]
#                 if self.check_all_char(t, substring):
#                     if len(substring) < min_length:
#                         shortest_substring = substring
#                         min_length = len(substring)
#         return shortest_substring





"""
735. Asteroid Collision

We are given an array asteroids of integers representing asteroids in a row. The indices of the asteriod in the array represent their 
relative position in space.

For each asteroid, the absolute value represents its size, and the sign represents its direction (positive meaning right, negative meaning left). 
Each asteroid moves at the same speed.

Find out the state of the asteroids after all collisions. If two asteroids meet, the smaller one will explode. If both are the same size, both will explode. 
Two asteroids moving in the same direction will never meet.

Example 1:
Input: asteroids = [5,10,-5]
Output: [5,10]
Explanation: The 10 and -5 collide resulting in 10. The 5 and 10 never collide.

Example 2:
Input: asteroids = [8,-8]
Output: []
Explanation: The 8 and -8 collide exploding each other.

Example 3:
Input: asteroids = [10,2,-5]
Output: [10]
Explanation: The 2 and -5 collide resulting in -5. The 10 and -5 collide resulting in 10.

"""
# class Solution:
#     def asteroidCollision(self, asteroids: List[int]) -> List[int]:
        # initalize a stack
        # iterate thru the asteroids
            # check if the stack exists and asteroid is positive and the top of the stack is negative:
                # check if the asteroid which is positive is greater than the top of the stack which is negative:
                    # if it is pop the top of the stack
                    # append the asteroid to the stack
                # else if the asteroid which is positive is less than the top of the stack:
                    # skip that asteroid
                # else: # if the numbers are equal but opposite
                    # skip that asteroid
                    # pop the top of the stack
            # check if the stack exists and  asteroid is negative and the top of the stack is positive:
                # check if the asteroid which is negative is greater in magnitude the top of the stack which is positive:
                    # if it is pop the top of the stack
                    # append the asteroid to the stack
                # else if the asteroid which is negative is less than the top of the stack:
                    # skip that asteroid
                # else =: # if the numbers are equal but opposite
                    # skip that asteroid
                    # pop the top of the stack
        # return stack


        # stack = []
        # for asteroid in asteroids:
        #     if stack and asteroid is postive and stack[-1] is negative:
        #         if abs(asteroid) > abs(stack[-1]:
        #             stack.pop()
        #             stack.append(asteroid)
        #         elif abs(asteroid) < abs(stack[-1]:
        #             continue
        #         else: # if they are equal they cancel themselves out
        #             stack.pop()
        #             continue
        #     elif stack and asteroid is negative and stack[-1] is positive:
        #         if abs(asteroid) > abs(stack[-1]:
        #             stack.pop()
        #             stack.append(asteroid)
        #         elif abs(asteroid) < abs(stack[-1]:
        #             continue
        #         else:
        #             stack.pop()
        #             continue
        # return stack

        # stack = []

        # for asteroid in asteroids:
        #     while True:
        #         # Add asteroid, if the stack is empty and if no collition is possible
        #         if not stack or asteroid > 0 or stack[-1] < 0:
        #             stack.append(asteroid)
        #             break
        #         # Collision cases:
        #         elif asteroid < 0 and stack[-1] > 0:
        #             # asteroid is larger
        #             if abs(asteroid) > abs(stack[-1]):
        #                 stack.pop()
        #                 if not stack:
        #                     stack.append(asteroid)
        #                     break
        #             # asteroid is smaller
        #             elif abs(asteroid) < abs(stack[-1]):
        #                 break # smaller asteroids explodes
        #             else: # Equal size
        #                 stack.pop()
        #                 break
        # return stack



"""
328. Odd Even Linked List

Given the head of a singly linked list, group all the nodes with odd indices together followed by the nodes with even indices, 
and return the reordered list.

The first node is considered odd, and the second node is even, and so on.

Note that the relative order inside both the even and odd groups should remain as it was in the input.

You must solve the problem in O(1) extra space complexity and O(n) time complexity.

Example 1:
Input: head = [1,2,3,4,5]
Output: [1,3,5,2,4]

Example 2:
Input: head = [2,1,3,5,6,4,7]
Output: [2,3,6,7,1,5,4]

"""
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
# class Solution:
#     def oddEvenList(self, head: Optional[ListNode]) -> Optional[ListNode]:
#         if not head or not head.next:
#             return head
        
#         odd_pointer = head
#         even_pointer = head.next
#         even_head = head.next
        
#         while even_pointer and even_pointer.next:
#             odd_pointer.next = even_pointer




"""
1    2     3     4   5 
o    
     e

"""





"""
104. Maximum Depth of Binary Tree

Given the root of a binary tree, return its maximum depth.

A binary tree's maximum depth is the number of nodes along the longest path from the root node down to the farthest leaf node.

 
Example 1:


Input: root = [3,9,20,null,null,15,7]
Output: 3
Example 2:

Input: root = [1,null,2]
Output: 2



# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):T
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def maxDepth(self, root: Optional[TreeNode]) -> int:
"""




"""
Sample Input/Output: 

calculate("6+9-12")
"""

def calculate(numberString):
    total = 0
    curr_num = ""

    for i in range(len(numberString)):
        char = numberString[i]
        if char != "+" and char != "-":
            curr_num += char
        
        if char == "+":
            total += int(numberString[i-1])
        elif char == "-":
            total -= int(numberString[i-1])
    return total


print(calculate("600+900-120"))
#1380