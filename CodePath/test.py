"""
Problem 6: Counting Divisible Collections in the Gallery
You have a list of integers collection_sizes representing the sizes of different art collections in your gallery and 
are trying to determine how to group them to best fit in your space. Given an integer k write a function count_divisible_collections() 
that returns the number of non-empty subarrays (contiguous parts of the array) where the sum of the sizes is divisible by k.

Example Usage:

nums1 = [4, 5, 0, -2, -3, 1]
k1 = 5

nums2 = [5]
k2 = 9

print(count_divisible_collections(nums1, k1))  
print(count_divisible_collections(nums2, k2))  

Example Output:
7
Example 1 Explanation: There are 7 subarrays with a sum divisible by k = 5:
[4, 5, 0, -2, -3, 1], [5], [5, 0], [5, 0, -2, -3], [0], [0, -2, -3], [-2, -3]

0
"""

# def count_divisible_collections(collection_sizes, k):

    # count = 0
    # n = len(collection_sizes)

    # for i in range(n):
    #     subarry_sum = 0
    #     for j in range(i, n):
    #         subarry_sum += collection_sizes[j]
    #         if subarry_sum % k == 0:
    #             count += 1
    # return count

    # add the numbers as they come up
from collections import defaultdict

def count_divisible_collections(collection_sizes, k):
    remainder_count = defaultdict(int)
    remainder_count[0] = 1  # To account for subarrays that start from index 0
    prefix_sum = 0
    count = 0

    for num in collection_sizes:
        prefix_sum += num
        remainder = prefix_sum % k
        # Handle negative remainders to keep them in the range [0, k-1]
        remainder = (remainder + k) % k

        if remainder in remainder_count:
            count += remainder_count[remainder]

        remainder_count[remainder] += 1

    return count
        



# T-compexity = O(N^2)
# S-complexuty = O(1)
nums1 = [2, 3, 5, 1, 4]
k1 = 5
print(count_divisible_collections(nums1, k1))  