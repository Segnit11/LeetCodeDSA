# hashing
# Example 3: Given an integer array nums, find all the unique numbers x in nums that satisfy the following: x + 1 is not in nums, and x - 1 is not in nums.
def find_numbers(nums):
    seen = set(nums)  # Convert the list to a set for O(1) lookups
    result = []  # To store unique numbers satisfying the condition
    
    for num in nums:
        # Check if neighbors do not exist
        if (num - 1) not in seen and (num + 1) not in seen:
            result.append(num)  # Add the number to the result
    
    return result



# First Letter to Appear Twice
# Given a string s, return the first character to appear twice. It is guaranteed that the input will have a duplicate character.
class Solution:
    def repeatedCharacter(self, s: str) -> str:
        seen = set()

        for c in s:
            # check if it exists in the set
            if c in seen:
                # return the char
                return c
            # if it doesn't add it to the set
            seen.add(c)
        return ""



# Two Sum
# Given an array of integers nums and an integer target, return indices of two numbers such that they add up to target. You cannot use the same index twice.
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        dic = {} # Initialize an empty dictionary

        for i in range(len(nums)): # Loop through each index in the nums list
            num = nums[i] # Current number
            diff = target - num  # Find the difference needed to reach the target
            if diff in dic:  # Check if this difference already exists in the dictionary
                return [i, dic[diff]]  # If it exists, return the indices
            dic[num] = i  # Otherwise, add the current number and its index to the dictionary



# Check if the Sentence Is Pangram
# A pangram is a sentence where every letter of the English alphabet appears at least once.

# Given a string sentence containing only lowercase English letters, return true if sentence is a pangram, or false otherwise.
# Example 1:
# Input: sentence = "thequickbrownfoxjumpsoverthelazydog"
# Output: true
# Explanation: sentence contains at least one of every letter of the English alphabet.
# Example 2:
# Input: sentence = "leetcode"
# Output: false

class Solution:
    def checkIfPangram(self, sentence: str) -> bool:
        # Step 1: Convert the sentence to a set of unique characters
        unique_chars = set(sentence)
        
        # Step 2: Check if the number of unique characters is equal to 26
        if len(unique_chars) == 26:
            return True
        else:
            return False


# Missing Number
# Given an array nums containing n distinct numbers in the range [0, n], return the only number in the range that is missing from the array.
# Example 1:
# Input: nums = [3,0,1]
# Output: 2
# Explanation: n = 3 since there are 3 numbers, so all numbers are in the range [0,3]. 2 is the missing number in the range since it does not appear in nums.

# Example 2:
# Input: nums = [0,1]
# Output: 2
# Explanation: n = 2 since there are 2 numbers, so all numbers are in the range [0,2]. 2 is the missing number in the range since it does not appear in nums.

# Example 3:
# Input: nums = [9,6,4,2,3,5,7,0,1]
# Output: 8
# Explanation: n = 9 since there are 9 numbers, so all numbers are in the range [0,9]. 8 is the missing number in the range since it does not appear in nums.

class Solution:
    def missingNumber(self, nums: List[int]) -> int:
        n = len(nums)
        expected_sum = n * (n + 1) // 2
        actual_sum = sum(nums)
        return expected_sum - actual_sum




# Counting Elements
# Given an integer array arr, count how many elements x there are, such that x + 1 is also in arr. If there are duplicates in arr, count them separately.

# Example 1:
# Input: arr = [1,2,3]
# Output: 2
# Explanation: 1 and 2 are counted cause 2 and 3 are in arr.

# Example 2:
# Input: arr = [1,1,3,3,5,5,7,7]
# Output: 0
# Explanation: No numbers are counted, cause there is no 2, 4, 6, or 8 in arr.
class Solution:
    def countElements(self, arr: List[int]) -> int:
        dic = set(arr)
        counter = 0

        for num in arr:
            if (num + 1) in dic:
                counter += 1

        return counter 
        


# You are given a string s and an integer k. Find the length of the longest substring that contains at most k distinct characters.
# For example, given s = "eceba" and k = 2, return 3. The longest substring with at most 2 distinct characters is "ece".
from collections import defaultdict

def find_longest_substring(s, k):
    counts = defaultdict(int) # use more sophisticated hashmap
    left = ans = 0

    for right in range(len(s)):
        counts[s[right]] += 1
        while len(counts) > k:
            counts[s[left]] -= 1
            if counts[s[left]] == 0:
                del counts[s[left]]
            left += 1 

        ans = max(anx, right - left + 1)
        
    return ans



# Intersection of Multiple Arrays
# Given a 2D array nums that contains n arrays of distinct integers, return a sorted array containing all the numbers that appear in all n arrays.
# For example, given nums = [[3,1,2,4,5],[1,2,3,4],[3,4,5,6]], return [3, 4]. 3 and 4 are the only numbers that are in all arrays.
from collections import defaultdict

class Solution:
    def intersection(self, nums: List[List[int]]) -> List[int]:
        counts = defaultdict(int)
        for arr in nums:
            for x in arr:
                counts[x] += 1

        n = len(nums)
        ans = []
        for key in counts:
            if counts[key] == n:
                ans.append(key)
        
        return sorted(ans)



# Check if All Characters Have Equal Number of Occurrences
# Given a string s, return true if s is a good string, or false otherwise.
# A string s is good if all the characters that appear in s have the same number of occurrences (i.e., the same frequency).

# Example 1:
# Input: s = "abacbc"
# Output: true
# Explanation: The characters that appear in s are 'a', 'b', and 'c'. All characters occur 2 times in s.

# Example 2:
# Input: s = "aaabb"
# Output: false
# Explanation: The characters that appear in s are 'a' and 'b'.
# 'a' occurs 3 times while 'b' occurs 2 times, which is not the same number of times.


from collections import defaultdict

class Solution:
    def areOccurrencesEqual(self, s: str) -> bool:
        counts = defaultdict(int)
        for char in s:
            counts[char] += 1
        
        feq = counts.values() # Have the values of the keys in counts be listed and then put it in a set to check if it is a duplicate which makes shows it is the same
        if len(set(feq)) == 1:
            return True
        else:
            return False


# Contiguous Array

# Given a binary array nums, return the maximum length of a contiguous subarray with an equal number of 0 and 1.

# Example 1:
# Input: nums = [0,1]
# Output: 2
# Explanation: [0, 1] is the longest contiguous subarray with an equal number of 0 and 1.

# Example 2:
# Input: nums = [0,1,0]
# Output: 2
# Explanation: [0, 1] (or [1, 0]) is a longest contiguous subarray with equal number of 0 and 1.

class Solution:
    def findMaxLength(self, nums: List[int]) -> int:
        zero, one = 0, 0
        max_len = 0

        diff_index = {} # diff -> index   # the diff is count[1] - count[0]
        
        # The enumerate() function in python is used to iterate over an iterable(like a list tuple, or string)
        for i, n in enumerate(nums):
            if n == 0:
                zero += 1
            else:
                one += 1
            
            diff = one - zero
            if diff not in diff_index:
                diff_index[diff] = i
            
            if one == zero:
                max_len = one + zero
            else:
                index = diff_index[diff]
                max_len = max(max_len, i - index)

        return max_len



# Largest Unique Number
# Given an integer array nums, return the largest integer that only occurs once. If no integer occurs once, return -1.

# Example 1:
# Input: nums = [5,7,3,9,4,9,8,3,1]
# Output: 8
# Explanation: The maximum integer in the array is 9 but it is repeated. The number 8 occurs only once, so it is the answer.

# Example 2:
# Input: nums = [9,9,8,8]
# Output: -1
# Explanation: There is no number that occurs only once.

from collections import defaultdict
class Solution:
    def largestUniqueNumber(self, nums: List[int]) -> int:
        count = defaultdict(int)
        
        for num in nums:
            count[num] += 1
        
        max_num = []
        # check the dict with the key that has a value one
        for num, value in count.items():
            if value == 1:
                max_num.append(num)
        # if no unqiue number exists, return -1
        if not max_num:
            return -1

        # find the maximum number from max_num arr
        max_value = max(max_num)
        return max_value



# Find Players With Zero or One Losses
# You are given an integer array matches where matches[i] = [winneri, loseri] indicates that the player winneri defeated player loseri in a match.

# Return a list answer of size 2 where:

# answer[0] is a list of all players that have not lost any matches.
# answer[1] is a list of all players that have lost exactly one match.
# The values in the two lists should be returned in increasing order.

# Note:

# You should only consider the players that have played at least one match.
# The testcases will be generated such that no two matches will have the same outcome.

# Example 1:
# Input: matches = [[1,3],[2,3],[3,6],[5,6],[5,7],[4,5],[4,8],[4,9],[10,4],[10,9]]
# Output: [[1,2,10],[4,5,7,8]]
# Explanation:
# Players 1, 2, and 10 have not lost any matches.
# Players 4, 5, 7, and 8 each have lost one match.
# Players 3, 6, and 9 each have lost two matches.
# Thus, answer[0] = [1,2,10] and answer[1] = [4,5,7,8].

# Example 2:
# Input: matches = [[2,3],[1,3],[5,4],[6,4]]
# Output: [[1,2,5,6],[]]
# Explanation:
# Players 1, 2, 5, and 6 have not lost any matches.
# Players 3 and 4 each have lost two matches.
# Thus, answer[0] = [1,2,5,6] and answer[1] = [].


from collections import defaultdict
class Solution:
    def findWinners(self, matches: List[List[int]]) -> List[List[int]]:
        count_loss = defaultdict(int)  # to store the how many times each players lost
        all_players = set() # to store the unique players

        for winner, loser in matches: # to iterate through each matach and each match has a winner and a loser
            count_loss[loser] += 1 # count the losers by adding the player and incrementing the loss by one
            all_players.add(winner) # add that player that played and won in the all_players set
            all_players.add(loser) # add that player that played and lost in the all_players set
        
        never_lost = [] # initalize an array for storing the players that have never lost a match
        lost_once = [] # initalize an array for storing the players that only have lost one match

        # now that each of the players and their number of losses are listed and stored
        # now lets start iterating thru and putting them to there repective array 

        # For the first test case
        # count_loss = {3: 2, 6: 2, 7: 1, 5: 1, 8: 1, 9: 2, 4: 1})
        # all_players = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

        # Players who have never lost
        for player in all_players:
            if count_loss[player] == 0:
                never_lost.append(player)
            
        # Players who have lost only once
        for player, losses in count_loss.items():
            if losses == 1:
                lost_once.append(player)

        # print('count_loss', count_loss)
        # print('all_players', all_players)
        return [sorted(never_lost), sorted(lost_once)]


# Group Anagrams
# Given an array of strings strs, group the anagrams together. You can return the answer in any order.

# Example 1:
# Input: strs = ["eat","tea","tan","ate","nat","bat"]
# Output: [["bat"],["nat","tan"],["ate","eat","tea"]]
# Explanation:
# There is no string in strs that can be rearranged to form "bat".
# The strings "nat" and "tan" are anagrams as they can be rearranged to form each other.
# The strings "ate", "eat", and "tea" are anagrams as they can be rearranged to form each other.

# Example 2:
# Input: strs = [""]
# Output: [[""]]

# Example 3:
# Input: strs = ["a"]
# Output: [["a"]]


from collections import defaultdict

class Solution:
    def groupAnagrams(self, strs: List[str]) -> List[List[str]]:
        group = defaultdict(list)
        for s in strs:
            key = "".join(sorted(s))
            group[key].append(s)
            
        return list(group.values())



# Minimum Consecutive Cards to Pick Up
# You are given an integer array cards where cards[i] represents the value of the ith card. A pair of cards are matching if the cards have the same value.

# Return the minimum number of consecutive cards you have to pick up to have a pair of matching cards among the picked cards. If it is impossible to have matching cards, return -1.

# Example 1:
# Input: cards = [3,4,2,3,4,7]
# Output: 4
# Explanation: We can pick up the cards [3,4,2,3] which contain a matching pair of cards with value 3. Note that picking up the cards [4,2,3,4] is also optimal.

# Example 2:
# Input: cards = [1,0,5,3]
# Output: -1
# Explanation: There is no way to pick up a set of consecutive cards that contain a pair of matching cards.


class Solution:
    def minimumCardPickup(self, cards: List[int]) -> int:
        last_seen = {}
        min_distance = float('inf')

        for i in range(len(cards)):
            if cards[i] in last_seen:
                distance = i - last_seen[cards[i]] + 1
                min_distance = min(min_distance, distance)
            last_seen[cards[i]] = i

        if min_distance == float('inf'):
            return -1
        else:
            return min_distance


# Max Sum of a Pair With Equal Sum of Digits
# You are given a 0-indexed array nums consisting of positive integers. You can choose two indices i and j, such that i != j, and the sum of digits of the number nums[i] is equal to that of nums[j].

# Return the maximum value of nums[i] + nums[j] that you can obtain over all possible indices i and j that satisfy the conditions.

# Example 1:
# Input: nums = [18,43,36,13,7]
# Output: 54
# Explanation: The pairs (i, j) that satisfy the conditions are:
# - (0, 2), both numbers have a sum of digits equal to 9, and their sum is 18 + 36 = 54.
# - (1, 4), both numbers have a sum of digits equal to 7, and their sum is 43 + 7 = 50.
# So the maximum sum that we can obtain is 54.

# Example 2:
# Input: nums = [10,12,19,14]
# Output: -1
# Explanation: There are no two numbers that satisfy the conditions, so we return -1.

from collections import defaultdict
class Solution:
    def maximumSum(self, nums: List[int]) -> int:
        count = defaultdict(list)

        for num in nums:
            digit_sum = 0
            for digit in str(num):
                digit_sum += int(digit)
            count[digit_sum].append(num)

        max_sum = -1

        for group in count.values():
            if len(group) > 1:
                # Sort the group and take the two largest numbers
                group.sort(reverse=True) # Descending the array
                first_two_sum = group[0] + group[1] # the question is just asking just to find the maximum number in the group that can give the highest sum
                max_sum = max(max_sum, first_two_sum)

        return max_sum



# Equal Row and Column Pairs

# Given a 0-indexed n x n integer matrix grid, return the number of pairs (ri, cj) such that row ri and column cj are equal.
# A row and column pair is considered equal if they contain the same elements in the same order (i.e., an equal array).

# Example 1:
# Input: grid = [[3,2,1],[1,7,6],[2,7,7]]
# Output: 1
# Explanation: There is 1 equal row and column pair:
# - (Row 2, Column 1): [2,7,7]

# Example 2:
# Input: grid = [[3,1,2,2],[1,4,4,5],[2,4,2,2],[2,4,2,2]]
# Output: 3
# Explanation: There are 3 equal row and column pairs:
# - (Row 0, Column 0): [3,1,2,2]
# - (Row 2, Column 2): [2,4,2,2]
# - (Row 3, Column 2): [2,4,2,2]

class Solution:
    def equalPairs(self, grid: List[List[int]]) -> int:
        n = len(grid)
        counter = 0

        for i in range(n):
            for j in range(n):
                row = grid[i]
                column = []
                for k in range(n):
                    column.append(grid[k][j])

                if row == column:
                    counter += 1
                    
        return counter

    
# Ransom Note
# Given two strings ransomNote and magazine, return true if ransomNote can be constructed by using the letters from magazine and false otherwise.

# Each letter in magazine can only be used once in ransomNote.

# Example 1:
# Input: ransomNote = "a", magazine = "b"
# Output: false

# Example 2:
# Input: ransomNote = "aa", magazine = "ab"
# Output: false

# Example 3:
# Input: ransomNote = "aa", magazine = "aab"
# Output: true


from collections import defaultdict
class Solution:
    def canConstruct(self, ransomNote: str, magazine: str) -> bool:
        ransom_counter = defaultdict(int)
        magazine_counter = defaultdict(int)

        for i in ransomNote:
            ransom_counter[i] += 1
        
        for j in magazine:
            magazine_counter[j] += 1

        for key, value in ransom_counter.items(): 
            if ransom_counter[key] > magazine_counter[key]:
                return False  
        return True


# Jewels and Stones

# You're given strings jewels representing the types of stones that are jewels, and stones representing the stones you have. Each character in stones is a type of stone you have. You want to know how many of the stones you have are also jewels.

# Letters are case sensitive, so "a" is considered a different type of stone from "A".

# Example 1:
# Input: jewels = "aA", stones = "aAAbbbb"
# Output: 3

# Example 2:
# Input: jewels = "z", stones = "ZZ"
# Output: 0


from collections import defaultdict
class Solution:
    def numJewelsInStones(self, jewels: str, stones: str) -> int:
        stones_counter = defaultdict(int)
        
        for stone in stones:
            stones_counter[stone] += 1
        
        result = 0
        for jewel in jewels:
            if jewel in stones_counter:
                result += stones_counter[jewel]
        return result


# Longest Substring Without Repeating Characters

# Given a string s, find the length of the longest 
# substring without repeating characters.

# Example 1:
# Input: s = "abcabcbb"
# Output: 3
# Explanation: The answer is "abc", with the length of 3.

# Example 2:
# Input: s = "bbbbb"
# Output: 1
# Explanation: The answer is "b", with the length of 1.

# Example 3:
# Input: s = "pwwkew"
# Output: 3
# Explanation: The answer is "wke", with the length of 3.
# Notice that the answer must be a substring, "pwke" is a subsequence and not a substring.

class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        char_index = {}
        max_length = 0
        left = 0

        for right in range(len(s)):
            if s[right] in char_index and char_index[s[right]] >= left:
                left = char_index[s[right]] + 1

            char_index[s[right]] = right

            max_length = max(max_length, right - left + 1)

        return max_length