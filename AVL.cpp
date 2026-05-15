#include <iostream>
#include <stack> // Required for non-recursive traversals

using namespace std;

// Structure of AVL Tree Node
struct node {
  int element; // value stored in node
  node *left;  // pointer to left child
  node *right; // pointer to right child
  int height;  // height of node for AVL balancing
};

class AVL {
private:
  node *root;

  // Return height of node
  int height(node *n) {
    if (n == nullptr)
      return -1;

    return n->height;
  }

  // Return maximum of two integers
  int max(int a, int b) { return (a > b) ? a : b; }

  // Create a new node
  node *newNode(int x) {
    node *temp = new node;

    temp->element = x;
    temp->left = temp->right = nullptr;
    temp->height = 0;

    return temp;
  }

  // Right Rotation (LL case)
  node *rotateRight(node *y) {
    node *x = y->left;
    node *T2 = x->right;

    // Perform rotation
    x->right = y;
    y->left = T2;

    // Update heights
    y->height = max(height(y->left), height(y->right)) + 1;
    x->height = max(height(x->left), height(x->right)) + 1;

    return x;
  }

  // Left Rotation (RR case)
  node *rotateLeft(node *x) {
    node *y = x->right;
    node *T2 = y->left;

    // Perform rotation
    y->left = x;
    x->right = T2;

    // Update heights
    x->height = max(height(x->left), height(x->right)) + 1;
    y->height = max(height(y->left), height(y->right)) + 1;

    return y;
  }

  // Calculate balance factor
  int getBalance(node *n) {
    if (n == nullptr)
      return 0;

    return height(n->left) - height(n->right);
  }

  // Insert element into AVL tree
  node *insert(node *n, int x) {
    // Normal BST insertion
    if (n == nullptr)
      return newNode(x);

    if (x < n->element)
      n->left = insert(n->left, x);

    else if (x > n->element)
      n->right = insert(n->right, x);

    else
      return n; // Duplicate values not allowed

    // Update height
    n->height = 1 + max(height(n->left), height(n->right));

    int balance = getBalance(n);

    // LL Rotation
    if (balance > 1 && x < n->left->element)
      return rotateRight(n);

    // RR Rotation
    if (balance < -1 && x > n->right->element)
      return rotateLeft(n);

    // LR Rotation
    if (balance > 1 && x > n->left->element) {
      n->left = rotateLeft(n->left);
      return rotateRight(n);
    }

    // RL Rotation
    if (balance < -1 && x < n->right->element) {
      n->right = rotateRight(n->right);
      return rotateLeft(n);
    }

    return n;
  }

  // Find node with minimum value
  node *minValueNode(node *n) {
    node *current = n;

    while (current->left != nullptr)
      current = current->left;

    return current;
  }

  // Delete node from AVL tree
  node *deleteNode(node *root, int key) {
    if (root == nullptr)
      return root;

    if (key < root->element)
      root->left = deleteNode(root->left, key);

    else if (key > root->element)
      root->right = deleteNode(root->right, key);

    else {
      // Node with one child or no child
      if ((root->left == nullptr) || (root->right == nullptr)) {
        node *temp = root->left ? root->left : root->right;

        if (temp == nullptr) {
          temp = root;
          root = nullptr;
        } else
          root = temp;

        delete temp;
      } else {
        // Node with two children
        node *temp = minValueNode(root->right);

        root->element = temp->element;

        root->right = deleteNode(root->right, temp->element);
      }
    }

    if (root == nullptr)
      return root;

    // Update height
    root->height = 1 + max(height(root->left), height(root->right));

    int balance = getBalance(root);

    // Rebalancing

    // LL
    if (balance > 1 && getBalance(root->left) >= 0)
      return rotateRight(root);

    // LR
    if (balance > 1 && getBalance(root->left) < 0) {
      root->left = rotateLeft(root->left);
      return rotateRight(root);
    }

    // RR
    if (balance < -1 && getBalance(root->right) <= 0)
      return rotateLeft(root);

    // RL
    if (balance < -1 && getBalance(root->right) > 0) {
      root->right = rotateRight(root->right);
      return rotateLeft(root);
    }

    return root;
  }

  // Recursive inorder traversal
  void inorder(node *root) {
    if (root != nullptr) {
      inorder(root->left);
      cout << root->element << " ";
      inorder(root->right);
    }
  }

  // Recursive preorder traversal
  void preorder(node *root) {
    if (root != nullptr) {
      cout << root->element << " ";
      preorder(root->left);
      preorder(root->right);
    }
  }

  // Recursive postorder traversal
  void postorder(node *root) {
    if (root != nullptr) {
      postorder(root->left);
      postorder(root->right);
      cout << root->element << " ";
    }
  }

public:
  // Constructor
  AVL() { root = nullptr; }

  void insert(int x) { root = insert(root, x); }

  void remove(int x) { root = deleteNode(root, x); }

  void inorder() { inorder(root); }

  void preorder() { preorder(root); }

  void postorder() { postorder(root); }

  // Non-recursive inorder traversal
  void inorderNonRecursive() {
    stack<node *> st;
    node *curr = root;

    while (curr != nullptr || !st.empty()) {
      while (curr != nullptr) {
        st.push(curr);
        curr = curr->left;
      }

      curr = st.top();
      st.pop();

      cout << curr->element << " ";

      curr = curr->right;
    }
  }

  // Non-recursive preorder traversal
  void preorderNonRecursive() {
    if (root == nullptr)
      return;

    stack<node *> st;
    st.push(root);

    while (!st.empty()) {
      node *curr = st.top();
      st.pop();

      cout << curr->element << " ";

      if (curr->right)
        st.push(curr->right);

      if (curr->left)
        st.push(curr->left);
    }
  }

  // Non-recursive postorder traversal
  void postorderNonRecursive() {
    if (root == nullptr)
      return;

    stack<node *> s1, s2;
    s1.push(root);

    while (!s1.empty()) {
      node *curr = s1.top();
      s1.pop();

      s2.push(curr);

      if (curr->left)
        s1.push(curr->left);

      if (curr->right)
        s1.push(curr->right);
    }

    while (!s2.empty()) {
      cout << s2.top()->element << " ";
      s2.pop();
    }
  }
};

int main() {
  AVL tree;
  int choice, value;

  do {
    cout << "\n===== AVL TREE MENU =====\n";
    cout << "1. Insert Element\n";
    cout << "2. Delete Element\n";
    cout << "3. Show Recursive Traversals\n";
    cout << "4. Show Non-Recursive Traversals\n";
    cout << "5. Exit\n";

    cout << "\nEnter your choice: ";
    cin >> choice;

    switch (choice) {

    case 1:
      cout << "Enter element to insert: ";
      cin >> value;
      tree.insert(value);
      cout << "Element inserted.\n";
      break;

    case 2:
      cout << "Enter element to delete: ";
      cin >> value;
      tree.remove(value);
      cout << "Element deleted (if it existed).\n";
      break;

    case 3:
      cout << "\nRecursive Traversals\n";

      cout << "Inorder   : ";
      tree.inorder();
      cout << endl;

      cout << "Preorder  : ";
      tree.preorder();
      cout << endl;

      cout << "Postorder : ";
      tree.postorder();
      cout << endl;

      break;

    case 4:
      cout << "\nNon-Recursive Traversals\n";

      cout << "Inorder   : ";
      tree.inorderNonRecursive();
      cout << endl;

      cout << "Preorder  : ";
      tree.preorderNonRecursive();
      cout << endl;

      cout << "Postorder : ";
      tree.postorderNonRecursive();
      cout << endl;

      break;

    case 5:
      cout << "Exiting program...\n";
      break;

    default:
      cout << "Invalid choice. Try again.\n";
    }

  } while (choice != 5);

  return 0;
}
