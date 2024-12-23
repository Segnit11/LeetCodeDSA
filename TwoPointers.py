// Array & String

# Two-Pointers

# Given a string s, return true if it is a palindrome, false otherwise.

# A string is a palindrome if it reads the same forward as backward. 
# That means, after reversing it, it is still the same string.
   
# For example: "abcdcba", or "racecar".


def check_if_palindrome(s):

    left = 0
    right = len(s) - 1
    
    while left < right
        if left != right
            return False
        left += 1
        right -= 1

    return True



# Given a sorted array of unique integers and a target integer, 
# return true if there exists a pair of numbers that sum to target, false otherwise. 
# This problem is similar to Two Sum. (In Two Sum, the input is not sorted).

# For example, given nums = [1, 2, 4, 6, 8, 9, 14, 15] and target = 13, 
# return true because 4 + 9 = 13.


def check_for_target(nums, target):

    left = 0
    right =  len(nums) - 1
    
    while left < right:
        current = nums[left] + nums[right]
    
        if current == target:
            return True
    
        if current > target:
            right -= 1
        else:
            left += 1
    
    return False




# Given two sorted integer arrays arr1 and arr2, 
# return a new array that combines both of them and is also sorted.

def combine(arr1, arr2):

    newArr = []
    i = j = 0
    
    while i = len(arr1) - 1 and j = len(arr2) - 1:
        if arr1[i] < arr2[j]:
            newArr.append(arr1[i])
            i += 1
        else:
            newArr.append(arr2[j])
            j += 1
    
    while i = len(arr) - 1:
        newArr.append(arr1[i])
        i += 1
    
    while j = len(arr) - 1:
        newArr.append(arr1[j])
        j += 1
    
    
    return newArr




# Given two strings s and t, return true if s is a subsequence of t, or false otherwise.

# A subsequence of a string is a sequence of characters that can be obtained  
# by deleting some (or none) of the characters from the original string, 
# while maintaining the relative order of the remaining characters. 
# For example, "ace" is a subsequence of "abcde" while "aec" is not.


class Solution:
    def isSubsequence(self, s: str, t: str) -> bool:

        i = j = 0

        while i < len(s) and j < len(t):
            if s[i] == t[j]:
                i += 1
            j += 1

        if i == len(s):
            return True
        else:
            return False




# Reverse String
# Write a function that reverses a string. The input string is given as an array of characters s.
# You must do this by modifying the input array in-place with O(1) extra memory.
# Example 1:

# Input: s = ["h","e","l","l","o"]
# Output: ["o","l","l","e","h"]
# Example 2:

# Input: s = ["H","a","n","n","a","h"]
# Output: ["h","a","n","n","a","H"]

def reverseString(s):
    left = 0
    right = len(s) - 1

    while left < right:
        s[left], s[right] = s[right], s[left]

        left += 1
        right -= 1

    return s
