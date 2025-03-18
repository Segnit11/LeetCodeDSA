def fn(root: TreeNode, x: int) -> int:
    if not root:
        return 0
    ans = 1 if root.val == x else 0 # A
    ans += fn(root.left, x)
    ans += fn(root.right, x)
    return ans


def bfs(root: TreeNode, x: int) -> int:
    if not root:
        return 0
    q = deque([root])
    ans = 0
    while q:
        node = q.popleft()
        if node.val == x:
            ans += 1
        if node.left:
            q.append(node.left)
            ans += 1
        if node.right:
            q.append(node.right)
            ans += 1
    return ans



Initialize a queue with the root node and the answer variable ans.
While queue is not empty:
Remove a node from the front of queue.
If node.val == x, increment ans.
Add the children of node to queue if they exist.
Return ans.

