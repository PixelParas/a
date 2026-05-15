// Paras Satpute 202401040027
#include <iostream>
#include <stack>
using namespace std;

// Node structure for Threaded Binary Tree
class Node {
public:
    int data;
    Node *left;
    Node *right;

    // Flags to indicate whether pointer is thread or child
    bool lthread;
    bool rthread;

    Node(int d) {
        data = d;
        left = nullptr;
        right = nullptr;
        lthread = true;
        rthread = true;
    }
};

class ThreadedBT {
public:
    Node *root;

    ThreadedBT() {
        root = nullptr;
    }

    // Insert Node
    void create(int val) {

        Node *ptr = root;
        Node *parent = nullptr;

        // Step 1: Find location to insert
        while (ptr != nullptr) {

            if (val == ptr->data) {
                cout << "Duplicate value!\n";
                return;
            }

            parent = ptr;

            if (val < ptr->data) {
                if (ptr->lthread == false)
                    ptr = ptr->left;
                else
                    break;
            }
            else {
                if (ptr->rthread == false)
                    ptr = ptr->right;
                else
                    break;
            }
        }

        Node *newNode = new Node(val);

        // Case 1: Tree empty
        if (parent == nullptr) {
            root = newNode;
            newNode->left = nullptr;
            newNode->right = nullptr;
        }

        // Case 2: Insert left
        else if (val < parent->data) {

            newNode->left = parent->left;
            newNode->right = parent;

            parent->lthread = false;
            parent->left = newNode;
        }

        // Case 3: Insert right
        else {

            newNode->left = parent;
            newNode->right = parent->right;

            parent->rthread = false;
            parent->right = newNode;
        }
    }

    // Find leftmost node (used for inorder traversal)
    Node* leftmost(Node *node) {

        if (node == nullptr)
            return nullptr;

        while (node->lthread == false)
            node = node->left;

        return node;
    }

    // --- INORDER NON-RECURSIVE USING THREADS ---
    void inorder_nonrecursive() {

        Node *curr = leftmost(root);

        while (curr != nullptr) {

            cout << curr->data << " ";

            // If thread exists move to inorder successor
            if (curr->rthread)
                curr = curr->right;

            else
                curr = leftmost(curr->right);
        }
    }

    // --- RECURSIVE TRAVERSALS ---

    // Inorder Recursive
    void inorder_recursive(Node *root) {

        if (root != nullptr) {

            if (root->lthread == false)
                inorder_recursive(root->left);

            cout << root->data << " ";

            if (root->rthread == false)
                inorder_recursive(root->right);
        }
    }

    // Preorder Recursive
    void preorder_recursive(Node *root) {

        if (root != nullptr) {

            cout << root->data << " ";

            if (root->lthread == false)
                preorder_recursive(root->left);

            if (root->rthread == false)
                preorder_recursive(root->right);
        }
    }

    // Postorder Recursive
    void postorder_recursive(Node *root) {

        if (root != nullptr) {

            if (root->lthread == false)
                postorder_recursive(root->left);

            if (root->rthread == false)
                postorder_recursive(root->right);

            cout << root->data << " ";
        }
    }

    // --- NON RECURSIVE TRAVERSALS (Using Stack) ---

    // Preorder Non-Recursive
    void preorder_nonrecursive() {

        if (root == nullptr) return;

        stack<Node*> s;
        s.push(root);

        while (!s.empty()) {

            Node *curr = s.top();
            s.pop();

            cout << curr->data << " ";

            if (curr->rthread == false)
                s.push(curr->right);

            if (curr->lthread == false)
                s.push(curr->left);
        }
    }

    // Postorder Non-Recursive (Two Stack Method)
    void postorder_nonrecursive() {

        if (root == nullptr) return;

        stack<Node*> s1, s2;

        s1.push(root);

        while (!s1.empty()) {

            Node *curr = s1.top();
            s1.pop();

            s2.push(curr);

            if (curr->lthread == false)
                s1.push(curr->left);

            if (curr->rthread == false)
                s1.push(curr->right);
        }

        while (!s2.empty()) {

            cout << s2.top()->data << " ";
            s2.pop();
        }
    }
};

int main() {

    ThreadedBT t;

    int choice, val;

    do {

        cout << "\n\n*** Threaded Binary Tree Menu ***";
        cout << "\n1. Create (Insert Node)";
        cout << "\n2. Recursive Traversals (In, Pre, Post)";
        cout << "\n3. Non-Recursive Traversals (In, Pre, Post)";
        cout << "\n4. Exit";

        cout << "\n\nEnter choice: ";
        cin >> choice;

        switch (choice) {

        case 1:
            cout << "Enter value: ";
            cin >> val;
            t.create(val);
            break;

        case 2:
            cout << "\nInorder: ";
            t.inorder_recursive(t.root);

            cout << "\nPreorder: ";
            t.preorder_recursive(t.root);

            cout << "\nPostorder: ";
            t.postorder_recursive(t.root);
            break;

        case 3:
            cout << "\nInorder (NR using Threads): ";
            t.inorder_nonrecursive();

            cout << "\nPreorder (NR): ";
            t.preorder_nonrecursive();

            cout << "\nPostorder (NR): ";
            t.postorder_nonrecursive();
            break;

        case 4:
            cout << "Exiting...";
            break;

        default:
            cout << "Invalid choice!";
        }

    } while (choice != 4);

    return 0;
}
