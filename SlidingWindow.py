// Array & String

# Sliding Window

# Let's say that we are given a positive integer array nums and an integer k. 
# We need to find the length of the longest subarray that has a sum less than or equal to k. 
# For this example, let nums = [3, 2, 1, 3, 1, 1] and k = 5.


def longest_subarray(nums, k):
    left = 0
    right = 0
    current_sum = 0
    max_length = 0

    while right < len(nums):
        current_sum += nums[right]
        while current_sum > k:    # while window is invalid
            current_sum -= nums[left]
            left += 1
            max_length = max(max_length, right - left + 1)

        return max_length



# You are given a binary string s (a string containing only "0" and "1"). 
# You may choose up to one "0" and flip it to a "1". What is the length of 
# the longest substring achievable that contains only "1"?

# For example, given s = "1101100111", the answer is 5. 
# If you perform the flip at index 2, the string becomes 1111100111.



def find_length(s):
    left = zero_count = max_length = 0

    for right in range(len(s)):
        if s[right] == "0":
            zero_count += 1

        # As long as the constraint is broken
            # As long as we have more than one zero in our window
        while zero_count > 1:
            # we need to shrink the window
            if s[left] == "0":
                zero_count -= 1
            left += 1

        max_length = max(max_length, right - left + 1)
    
    return max_length




# Subarray Product Less Than K.

# Given an array of positive integers nums and an integer k, return the number 
# of subarrays where the product of all the elements in the subarray is strictly 
# less than k.

class Solution:
    def numSubarrayProductLessThanK(self, nums: List[int], k: int) -> int:
        if k <= 1:
            return 0

        ans = left = 0
        curr = 1

        for right in range(len(nums)):
            curr *= nums[right]
            while curr >= k:
                curr //= nums[left]
                left += 1
                
            ans += right - left + 1

        return ans




# Given an integer array nums and an integer k, find the sum of the 
# subarray with the largest sum whose length is k.
def find_best_subarray(nums, k):
    left = 0
    right = 0
    current_sum = 0
    max_sum = 0

    while right < len(nums):
        current_sum += nums[right]
        if right - left + 1 < k:
            right += 1
        elif right - left + 1 == k:
            max_sum = max(max_sum, current_sum)
            current_sum -= nums[left]
            left += 1
            right += 1

    return max_sum




# You are given an integer array nums consisting of n elements, and an integer k.

# Find a contiguous subarray whose length is equal to k that has the maximum average
# value and return this value. Any answer with a calculation error less than 10-5 will be accepted.

def find_max_average(nums, k):
    left = 0
    curr_sum = 0
    max_sum = -float('inf')

    for right in range(len(nums)):
        curr_sum += nums[right]
        if right - left + 1 == k:
            max_sum = max(max_sum, curr_sum)
            curr_sum -= nums[left]
            left += 1

    return max_sum/k





# Prefix Sum
 
# Example 1: Given an integer array nums, an array queries where queries[i] = [x, y] 
# and an integer limit, return a boolean array that represents the answer to each query. 
# A query is true if the sum of the subarray from x to y is less than limit, or false otherwise.

# For example, given nums = [1, 6, 3, 2, 7, 2], queries = [[0, 3], [2, 5], [2, 4]], 
# and limit = 13, the answer is [true, false, true]. For each query, the subarray sums are [12, 14, 12].


def answer_queries(nums, queries, limit):
    # create our preefix sum array -> to store the sum of the subarray from 0 to i of nums arr
    prefix = [num[0]]
    # iterate through the nums array and append the sum of the subarray from 0 to i
    for i in range(1, len(nums)):
        prefix.append(nums[i] + prefix[i-1])

    # create an empty list to store the boolean results
    answer = []

    # iterate through the queries array
    # since the queries array is a 2D array, we need to iterate through each subarray
    for query in queries:
        # get the start and end indices of the subarray
        x,y = query
        # calculate the sum of the subarray from x to y
        # now that we have the prefix sum array, we can calculate the sum of the subarray from x to y
        # no need to think about the nums arr anymore
        # since the nums arr is used to build the sum inside the prefix array so just focus on the prefix array
        if x > 0:
            subarray_sum = prefix[y] - prefix[x - 1]
        else:
            subarray_sum = prefix[y]
        # check if the sum of the subarray is less than the limit
        if subarray_sum < limit:
            answer.append(True)
        else:
            answer.append(False)
    return answer





# Given an integer array nums, find the number of ways to split the array into two parts 
# so that the first section has a sum greater than or equal to the sum of the second section. 
# The second section should have at least one number.

def ways_to_split(nums):
    prefix = [nums[0]]
    for i in range(1, len(nums)):
        prefix.append(nums[i] + prefix[i-1])

    # declare a counter to store the number of ways to split the array
    answer = 0

    for i in range(len(nums) - 1):
        # calculate the sum of the subarray from 0 to i which is going to the left sum
        left_sum = prefix[i]
        # calculate the sum of the subarray from i to the end which is going to the right sum
        # we do this by subrtacting the left sum from the total sum of the array which will leave us with the right
        right_sum = prefix[-1] - prefix[i]
        # if the left sum is greater than or equal to the right sum, then we can't split the array
        if left_sum >= right_sum:
            answer += 1
    return answer





# Given an array of integers nums, you start with an initial positive value startValue.
# In each iteration, you calculate the step by step sum of startValue plus elements in 
# nums (from left to right).

# Return the minimum positive value of startValue such that the step by step sum is never less than 1.


def min_start_value(nums):
    prefix = [nums[0]]
    for i in range(1, len(nums)):
        prefix.append(nums[i] + prefix[i-1])
    
    # Find the minimum value in the prefix array
    min_value = min(prefix)
    # if the minimum value is negative, then we need to add 1 to the absolute value 
    # of the minimum value, but if the nums array is all positive, then the minimum value will be 1
    # and still be valid
    return max(1, 1 - min_value)






# 2090. K Radius Subarray Averages
# You are given a 0-indexed array nums of n integers, and an integer k.
# The k-radius average for a subarray of nums centered at some index i with the radius k is the average of all elements 
# in nums between the indices i - k and i + k (inclusive). If there are less than k elements before or after the index i, then the k-radius average is -1.
# Build and return an array avgs of length n where avgs[i] is the k-radius average for the subarray centered at index i.
# The average of x elements is the sum of the x elements divided by x, using integer division. The integer division truncates 
# toward zero, which means losing its fractional part.
# For example, the average of four elements 2, 3, 1, and 5 is (2 + 3 + 1 + 5) / 4 = 11 / 4 = 2.75, which truncates to 2.
 
# Example 1:

# Input: nums = [7,4,3,9,1,8,5,2,6], k = 3
# Output: [-1,-1,-1,5,4,4,-1,-1,-1]
# Explanation:
# - avg[0], avg[1], and avg[2] are -1 because there are less than k elements before each index.
# - The sum of the subarray centered at index 3 with radius 3 is: 7 + 4 + 3 + 9 + 1 + 8 + 5 = 37.
#   Using integer division, avg[3] = 37 / 7 = 5.
# - For the subarray centered at index 4, avg[4] = (4 + 3 + 9 + 1 + 8 + 5 + 2) / 7 = 4.
# - For the subarray centered at index 5, avg[5] = (3 + 9 + 1 + 8 + 5 + 2 + 6) / 7 = 4.
# - avg[6], avg[7], and avg[8] are -1 because there are less than k elements after each index.
# Example 2:

# Input: nums = [100000], k = 0
# Output: [100000]
# Explanation:
# - The sum of the subarray centered at index 0 with radius 0 is: 100000.
#   avg[0] = 100000 / 1 = 100000.
# Example 3:

# Input: nums = [8], k = 100000
# Output: [-1]
# Explanation: 
# - avg[0] is -1 because there are less than k elements before and after index 0.


class Solution:
    def getAverages(self, nums: List[int], k: int) -> List[int]:
        res = [-1] * len(nums)

        left = 0
        window_sum = 0
        diameter = 2 * k + 1

        for right in range(len(nums)):
            window_sum += nums[right]

            if right - left + 1 == diameter:
                res[left + k] = window_sum // diameter
                window_sum -= nums[left]      # subtract the left window index from the sum
                left += 1   # move the left pointer to the right
        return res
            
            