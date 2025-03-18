# 49. Group Anagrams
"""
Brute Force Approach:
Time Complexity: For iterating thru out the arr n strings and we are sorting them
                    -> For sorting each string it is O(k * log(k)) where k is the max length of the string
                    -> For going thru each string its 0(n)
                Total => 0(n * k*log(k))
Space Complexity: We are using a dictionary to store each string so it becomes
                Total => O(n*k)
                    where: n = number of strings in the input
                           k = max length of the string
"""

from collections import defaultdict

class Solution:
    def groupAnagrams(self, strs: List[str]) -> List[List[str]]:
        anagrams = defaultdict(int)

        for s in strs:
            sorted_str = "".join(sorted(s))
            anagrams[sorted_str].append(s)

        return list(anagrams.values())
