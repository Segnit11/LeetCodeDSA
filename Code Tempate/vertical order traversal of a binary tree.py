# 987. Vertical Order Traversal of a Binary Tree

"""
Brute Force Approach:


"""

class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

from typing import List

class Solution:
    def verticalTraversal(self, root: Optional[TreeNode]) -> List[List[int]]:

