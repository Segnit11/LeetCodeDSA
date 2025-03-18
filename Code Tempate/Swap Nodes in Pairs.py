# 24. Swap Nodes in Pairs

"""
Brute Force Solution:
Time Complexity = O(n)
Space Complexity = O(1), function uses a constant amount of extra space for the 
                 dummy, prev, first, and second pointers, regardless of the size of the input list.

"""

# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next


# from typing import List

# class Solution:
#     def swapPairs(self, head: Optional[ListNode]) -> Optional[ListNode]:
#         dummy = ListNode(0)
#         dummy.next = head
#         prev = dummy

#         while head and head.next:
#             first = head
#             second = head.next

#             # we can use the recursive cakk for the rest of the list with out swapping it like this => first.next = self.swapPairs(second.next)
#             # but we don't have to use a while loop
#             # at the end we can do sth like second.next = first
#             prev.next = second
#             second.next = first
#             first.next = second.next

#             prev = first
#             # head = first.next
#         return dummy.next

