// Paras Satpute 202401040027

#include <iostream>
#include <queue>
#include <stack>
using namespace std;

// Standard Node structure for a Binary Search Tree
class Node {
public:
  int data;
  Node *left;
  Node *right;

  Node(int d) {
    data = d;
    left = nullptr;
    right = nullptr;
  }
};

class BST {
public:
  Node *root;

  BST() { root = nullptr; }

  // Insert
  void insert(int d) {
    Node *newNode = new Node(d);

    // Case 1: Tree is empty
    if (root == nullptr) {
      root = newNode;
      return;
    }

    Node *curr = root;
    Node *parent = nullptr;

    // Step 1: Traverse down to find the insertion point
    while (curr != nullptr) {
      parent = curr; // Keep track of parent to link the new node later
      if (d < curr->data)
        curr = curr->left;
      else if (d > curr->data)
        curr = curr->right;
      else {
        delete newNode; // Duplicate value, do not insert
        return;
      }
    }

    // Step 2: Attach the new node to the parent's left or right
    if (d < parent->data)
      parent->left = newNode;
    else
      parent->right = newNode;
  }

  // --- RECURSIVE TRAVERSALS ---

  // Inorder: Left Subtree -> Root -> Right Subtree
  void inorder_recursive(Node *root) {
    if (root != nullptr) {
      inorder_recursive(root->left);
      cout << root->data << " ";
      inorder_recursive(root->right);
    }
  }

  // Preorder: Root -> Left Subtree -> Right Subtree
  void preorder_recursive(Node *root) {
    if (root != nullptr) {
      cout << root->data << " ";
      preorder_recursive(root->left);
      preorder_recursive(root->right);
    }
  }

  // Postorder: Left Subtree -> Right Subtree -> Root
  void postorder_recursive(Node *root) {
    if (root != nullptr) {
      postorder_recursive(root->left);
      postorder_recursive(root->right);
      cout << root->data << " ";
    }
  }

  // --- NON-RECURSIVE TRAVERSALS (Using Stacks) ---

  // Inorder NR: Simulates recursion by diving left and "backtracking" using a
  // stack
  void inorder_nonrecursive() {
    stack<Node *> s;
    Node *curr = root;
    while (curr != nullptr || !s.empty()) {
      // Step 1: Reach the leftmost node of the current subtree
      while (curr != nullptr) {
        s.push(curr);
        curr = curr->left;
      }
      // Step 2: Process the node and move to the right child
      curr = s.top();
      s.pop();
      cout << curr->data << " ";
      curr = curr->right;
    }
  }

  // Preorder NR: Root first, then use stack to remember the right child for
  // later
  void preorder_nonrecursive() {
    if (root == nullptr)
      return;
    stack<Node *> s;
    s.push(root);
    while (!s.empty()) {
      Node *curr = s.top();
      s.pop();
      cout << curr->data << " ";
      // Push Right first so that Left is on top of the stack (processed first)
      if (curr->right != nullptr)
        s.push(curr->right);
      if (curr->left != nullptr)
        s.push(curr->left);
    }
  }

  // Postorder NR: Uses two stacks to reverse the Root-Right-Left order into
  // Left-Right-Root
  void postorder_nonrecursive() {
    if (root == nullptr)
      return;
    stack<Node *> s1, s2;
    s1.push(root);
    while (!s1.empty()) {
      Node *curr = s1.top();
      s1.pop();
      s2.push(curr); // s2 stores nodes in Root-Right-Left sequence
      if (curr->left != nullptr)
        s1.push(curr->left);
      if (curr->right != nullptr)
        s1.push(curr->right);
    }
    // Step 2: Popping s2 prints the reverse: Left-Right-Root
    while (!s2.empty()) {
      cout << s2.top()->data << " ";
      s2.pop();
    }
  }

  // Level Order (BFS): Visits nodes level by level using a Queue
  void level_order() {
    if (root == nullptr)
      return;
    queue<Node *> q;
    q.push(root);
    while (!q.empty()) {
      Node *curr = q.front();
      q.pop();
      cout << curr->data << " ";
      // Add children to the back of the queue to be processed after the current
      // level
      if (curr->left != nullptr)
        q.push(curr->left);
      if (curr->right != nullptr)
        q.push(curr->right);
    }
  }

  void delete_node(int d) {
    Node *curr = root;
    Node *parent = nullptr;

    // Step 1: Search for the node to delete
    while (curr != nullptr && curr->data != d) {
      parent = curr;
      if (d < curr->data)
        curr = curr->left;
      else
        curr = curr->right;
    }

    // If node was not found in the tree
    if (curr == nullptr)
      return;

    // Step 2: Handle Case A & B (Node has 0 or 1 child)
    if (curr->left == nullptr || curr->right == nullptr) {
      Node *newChild;
      if (curr->left == nullptr)
        newChild = curr->right;
      else
        newChild = curr->left;

      // If we are deleting the root node itself
      if (parent == nullptr) {
        root = newChild;
      }
      // Re-link parent to the child of the node being deleted
      else if (curr == parent->left) {
        parent->left = newChild;
      } else {
        parent->right = newChild;
      }
      delete curr;
    }
    // Step 3: Handle Case C (Node has 2 children)
    else {
      // Find Inorder Successor (smallest in the right subtree)
      Node *successorParent = curr;
      Node *successor = curr->right;

      while (successor->left != nullptr) {
        successorParent = successor;
        successor = successor->left;
      }

      // Copy successor's value to current node
      curr->data = successor->data;

      // Delete the successor node
      // Successor can only have a right child (or no child)
      if (successorParent != curr)
        successorParent->left = successor->right;
      else
        successorParent->right = successor->right;

      delete successor;
    }
  }
};

int main() {
  BST b;
  int choice, val;

  do {
    cout << "\n\n*** Binary Search Tree Menu ***";
    cout << "\n1. Insert Node";
    cout << "\n2. Recursive Traversals (In, Pre, Post)";
    cout << "\n3. Non-Recursive Traversals (In, Pre, Post)";
    cout << "\n4. Level Order Traversal";
    cout << "\n5. Delete Node";
    cout << "\n6. Exit";
    cout << "\n\nEnter choice: ";
    cin >> choice;

    switch (choice) {
    case 1:
      cout << "Enter value: ";
      cin >> val;
      b.insert(val);
      break;
    case 2:
      cout << "\nIn: ";
      b.inorder_recursive(b.root);
      cout << "\nPre: ";
      b.preorder_recursive(b.root);
      cout << "\nPost: ";
      b.postorder_recursive(b.root);
      break;
    case 3:
      cout << "\nIn(NR): ";
      b.inorder_nonrecursive();
      cout << "\nPre(NR): ";
      b.preorder_nonrecursive();
      cout << "\nPost(NR): ";
      b.postorder_nonrecursive();
      break;
    case 4:
      cout << "\nLevel Order: ";
      b.level_order();
      break;
    case 5:
      cout << "Enter value to delete: ";
      cin >> val;
      b.delete_node(val);
      break;
    case 6:
      cout << "Exiting...";
      break;
    default:
      cout << "Invalid choice!";
    }
  } while (choice != 6);

  return 0;
}
