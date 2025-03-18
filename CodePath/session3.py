""""
Problem 3: 
Find All Duplicate Treasure Chests in an Array
Captain Blackbeard has an integer array chests of length n where all the integers in chests are in the range [1, n] and each integer appears once or twice. 
Return an array of all the integers that appear twice, representing the treasure chests that have duplicates.

Example Usage:

chests1 = [4, 3, 2, 7, 8, 2, 3, 1]
chests2 = [1, 1, 2]
chests3 = [1]

print(find_duplicate_chests(chests1))
print(find_duplicate_chests(chests2))
print(find_duplicate_chests(chests3))
Example Output:

[2, 3]
[1]
[]

"""

from collections import Counter

def find_duplicate_chests(chests):
    
    counter = Counter(chests)
    result = []

    counter_sorted = sorted(counter.items(), key=lambda x: x[0]) # O(NlogN)

    for key, value in counter_sorted:# 0(N)
        if value == 2:
            result.append(key)

    return result


chests1 = [4, 3, 2, 7, 8, 2, 3, 1]
chests2 = [1, 1, 2]
chests3 = [1]

print(find_duplicate_chests(chests1))
print(find_duplicate_chests(chests2))
print(find_duplicate_chests(chests3))




def is_balanced(code):
    counter = dict{}

    tracker = 2

    for char in code:
        if char in counter:
            tracker -= 1
        counter[char] = counter.get(char, 0) + 1

        if tracker < 1:
            return False
