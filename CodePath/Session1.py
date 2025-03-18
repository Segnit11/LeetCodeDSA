"""
Problem 4: Non-decreasing Array
Given an array nums with n integers, write a function non_decreasing() that checks if nums could become 
non-decreasing by modifying at most one element.

We define an array is non-decreasing if nums[i] <= nums[i + 1] holds for every i (0-based) such that (0 <= i <= n - 2).

def non_decreasing(nums):
	pass

Example Usage:

nums = [4, 2, 3]
non_decreasing(nums)

nums = [4, 2, 1]
non_decreasing(nums)
Example Output:

True
False

"""

def non_decreasing(nums):
    count = 0
    for i in range(len(nums) - 1):
        if nums[i] <= nums[i+1]:
            continue
        count += 1
        
        if count > 1:
            return False

        # Still need some understanding to do here in the if condition Idk how this thing is working
        if i == 0 or nums[i - 1] <= nums[i + 1]:
            nums[i] = nums[i + 1]
        else:
            nums[i + 1] = nums[i]

    return True


# print(non_decreasing([4, 2, 1]))
print(non_decreasing([5, 7, 9, 2, 3]))



"""
Problem 5: Missing Clues
Christopher Robin set up a scavenger hunt for Pooh, but it's a blustery day and several hidden clues have blown away. 
Write a function find_missing_clues() to help Christopher Robin figure out which clues he needs to remake. 
The function accepts two integers lower and upper and a unique integer array clues. 
All elements in clues are within the inclusive range [lower, upper].

A clue x is considered missing if x is in the range [lower, upper] and x is not in clues.

Return the shortest sorted list of ranges that exactly covers all the missing numbers. 
That is, no element of clues is included in any of the ranges, and each missing number is covered by one of the ranges.

"""



