#include <iomanip>
#include <iostream>
#include <limits>
#include <queue>
#include <vector>

using namespace std;

// Class representing the graph
class Graph {
private:
  int V; // Number of vertices
  // Advanced ADT: Adjacency list using vectors and pairs to map <weight,
  // adjacent_vertex>
  vector<vector<pair<int, int>>> adj;

public:
  // Constructor
  Graph(int V) {
    this->V = V;
    adj.resize(V);
  }

  // Adds an undirected edge to the graph
  void addEdge(int u, int v, int weight) {
    adj[u].push_back(make_pair(weight, v));
    adj[v].push_back(make_pair(weight, u));
  }

  // Displays the current adjacency list of the graph
  void displayGraph() {
    cout << "\n--- Current Graph Structure (Adjacency List) ---\n";
    for (int i = 0; i < V; ++i) {
      cout << "Vertex " << i << " -> ";
      for (auto edge : adj[i]) {
        cout << "[To: " << edge.second << ", Weight: " << edge.first << "] ";
      }
      cout << "\n";
    }
    cout << "------------------------------------------------\n";
  }

  // Prim's algorithm implementation using a Min-Priority Queue
  void primMST() {
    // Advanced ADT: Min-Priority Queue (Min-Heap) to fetch the lowest weight
    // edge efficiently. Stores elements as pairs of (weight, vertex)
    priority_queue<pair<int, int>, vector<pair<int, int>>,
                   greater<pair<int, int>>>
        pq;

    int src = 0; // Starting vertex

    // Vectors to track shortest path weights, parent nodes, and inclusion in
    // MST
    vector<int> key(V, numeric_limits<int>::max());
    vector<int> parent(V, -1);
    vector<bool> inMST(V, false);

    // Initialize the source node
    pq.push(make_pair(0, src));
    key[src] = 0;

    while (!pq.empty()) {
      // Extract the vertex with the minimum weight
      int u = pq.top().second;
      pq.pop();

      // If already included in MST, skip to prevent cycles
      if (inMST[u])
        continue;
      inMST[u] = true;

      // Check all adjacent vertices
      for (auto x : adj[u]) {
        int weight = x.first;
        int v = x.second;

        // If vertex v is not in MST and edge weight is smaller than current key
        if (!inMST[v] && weight < key[v]) {
          key[v] = weight;
          pq.push(make_pair(key[v], v));
          parent[v] = u;
        }
      }
    }

    // Beautifully formatted output for the MST
    cout << "\n============================================\n";
    cout << "           MINIMUM SPANNING TREE            \n";
    cout << "============================================\n";
    cout << setw(10) << "Edge" << " | " << "Weight\n";
    cout << "--------------------------------------------\n";
    int totalWeight = 0;
    for (int i = 1; i < V; ++i) {
      if (parent[i] != -1) {
        cout << setw(3) << parent[i] << " - " << setw(2) << i << " | " << key[i]
             << "\n";
        totalWeight += key[i];
      } else {
        cout << "Vertex " << i << " is unreachable from 0.\n";
      }
    }
    cout << "--------------------------------------------\n";
    cout << "Total MST Weight: " << totalWeight << "\n";
    cout << "============================================\n";
  }
};

// Function to print a clean, user-friendly menu
void displayMenu() {
  cout << "\n********************************************\n";
  cout << "* PRIM'S ALGORITHM MST TOOL       *\n";
  cout << "********************************************\n";
  cout << "1. Create New Graph (Set Vertices)\n";
  cout << "2. Add an Edge\n";
  cout << "3. Display Graph\n";
  cout << "4. Calculate Minimum Spanning Tree (Prim's)\n";
  cout << "5. Exit\n";
  cout << "********************************************\n";
  cout << "Enter your choice: ";
}

int main() {
  int choice, V = 0;
  Graph *g = nullptr;

  do {
    displayMenu();

    // Input validation: Prevents infinite loops if the user enters letters
    // instead of numbers
    if (!(cin >> choice)) {
      cout << "\n[!] Invalid input. Please enter a valid number.\n";
      cin.clear();
      cin.ignore(numeric_limits<streamsize>::max(), '\n');
      continue;
    }

    switch (choice) {
    case 1:
      cout << "\nEnter the number of vertices for the graph: ";
      cin >> V;
      if (V <= 0) {
        cout << "[!] Number of vertices must be greater than 0.\n";
        V = 0;
      } else {
        if (g != nullptr)
          delete g; // Clean up memory if graph already exists
        g = new Graph(V);
        cout << "[+] Graph successfully created with " << V
             << " vertices (Numbered 0 to " << V - 1 << ").\n";
      }
      break;

    case 2:
      if (g == nullptr) {
        cout << "\n[!] Please create a graph first (Option 1).\n";
      } else {
        int u, v, weight;
        cout << "\nEnter source vertex (0 to " << V - 1 << "): ";
        cin >> u;
        cout << "Enter destination vertex (0 to " << V - 1 << "): ";
        cin >> v;
        cout << "Enter edge weight: ";
        cin >> weight;

        if (u >= 0 && u < V && v >= 0 && v < V) {
          g->addEdge(u, v, weight);
          cout << "[+] Edge added successfully: " << u << " <---> " << v
               << " (Weight: " << weight << ")\n";
        } else {
          cout << "[!] Invalid vertices. Must be between 0 and " << V - 1
               << ".\n";
        }
      }
      break;

    case 3:
      if (g == nullptr) {
        cout << "\n[!] Please create a graph first (Option 1).\n";
      } else {
        g->displayGraph();
      }
      break;

    case 4:
      if (g == nullptr) {
        cout << "\n[!] Please create a graph first (Option 1).\n";
      } else {
        g->primMST();
      }
      break;

    case 5:
      cout << "\nExiting program. Freeing memory...\n";
      if (g != nullptr)
        delete g;
      break;

    default:
      cout << "\n[!] Invalid choice. Please select from the menu (1-5).\n";
    }
  } while (choice != 5);

  return 0;
}
