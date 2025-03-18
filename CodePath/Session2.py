# # Problem 1: Transpose Matrix

# # Write a function transpose() that accepts a 2D integer array matrix and returns the transpose of matrix. 
# # The transpose of a matrix is the matrix flipped over its main diagonal, swapping the rows and columns.

# def  transpose(matrix):
#     if not matrix:
#         return matrix

#     rows = len(matrix)
#     cols = len(matrix[0])

#     for r in range(rows):
#         for c in range(r + 1, cols):
#             matrix[c][r], matrix[r][c] = matrix[r][c], matrix[c]
#     return matrix


# matrix = [
#     [1, 2, 3],
#     [4, 5, 6],
#     [7, 8, 9]
# ]
# print(transpose(matrix))

# matrix = [
#     [1, 2, 3],
#     [4, 5, 6]
# ]
# print(transpose(matrix))




# def reverse_list(lst):
#     if not lst:
#         return None

#     left = 0
#     right = len(lst) - 1
    
#     while left < right:
#         lst[lst[left]], lst[lst[right]] = lst[lst[right]], lst[lst[left]]
#         left += 1
#         right -= 1
#     return lst




# Problem 3: Remove Duplicates
# Write a function remove_dupes() that accepts a sorted array items, and 
# removes the duplicates in-place such that each element appears only once. 
# Return the length of the modified array. You may not create another array; your implementation must modify the original input array items.

# def remove_dupes(items):
#     pass
# Example Usage

# items = ["extract of malt", "haycorns", "honey", "thistle", "thistle"]
# remove_dupes(items)

# items = ["extract of malt", "haycorns", "honey", "thistle"]
# remove_dupes(items)


# def remove_dupes(items):
#     if not items:
#         return None
    
#     count = 0
#     i = 0

#     while i < len(items):
#         if items[i] == items[i - 1]:
#             items.pop(i)
#         else:
#             count += 1
#             i += 1
#     return count


# items = ["extract of malt", "haycorns", "honey", "thistle", "thistle"]

# print(remove_dupes(items))

"""

Problem 4: Sort Array by Parity
Given an integer array nums, write a function sort_by_parity() that moves all the even integers 
at the beginning of the array followed by all the odd integers.

Return any array that satisfies this condition.

def sort_by_parity(nums):
    pass

Example Usage

nums = [3, 1, 2, 4]
sort_by_parity(nums)

nums = [0]
sort_by_parity(nums)

Example Output:

[2, 4, 3, 1]
[0]

"""

# def sort_by_parity(nums):
#     even_arr = []
#     odd_arr = []

#     for num in nums:
#         if num % 2 == 0:
#             even_arr.append(num)
#         elif num % 2 != 0:
#             odd_arr.append(num)
#     return even_arr + odd_arr
    
    
# nums = [3, 1, 2, 4]
# print(sort_by_parity(nums))



"""
Problem 6: Merge Intervals
Write a function merge_intervals() that accepts an array of intervals where intervals[i] = [starti, endi], 
merge all overlapping intervals, and return an array of the non-overlapping intervals that cover all the intervals in the input.

def merge_intervals(intervals):
	pass

Example Usage

intervals = [[1, 3], [2, 6], [8, 10], [15, 18]]
merge_intervals(intervals)

intervals = [[1, 4], [4, 5]]
merge_intervals(intervals)

Example Output:

[[1, 6], [8, 10], [15, 18]]
[[1, 5]]

"""

def merge_intervals(intervals):
	# iterate thu the intervals arr
        # if the closing interval is inside the the next interval
            # make the closing interval to be the consing of the next interval
        # return 
    
    merged = []

    for interval in intervals:
        if not merged or merged[-1][1] < interval[0]:
            merged.append(interval)
        else:
            merged[-1][1] = max(marged[-1][1], interval[1])
    return merged


intervals = [[1, 4], [4, 5]]
print(merge_intervals(intervals))