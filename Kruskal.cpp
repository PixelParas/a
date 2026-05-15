#include <iostream>
#include <vector>
#include <algorithm>
#include <limits>
#include <iomanip>

using namespace std;

// --- Data Structures ---

// Structure to represent a weighted edge
struct Edge {
    int u, v, weight;
    
    // Overloading the < operator to easily sort edges by weight
    bool operator<(Edge const& other) const {
        return weight < other.weight;
    }
};

// Advanced ADT: Disjoint Set Union (DSU) / Union-Find
// Optimized with Path Compression and Union by Rank
class DSU {
private:
    vector<int> parent;
    vector<int> rank;

public:
    // Initialize DSU with 'n' elements
    DSU(int n) {
        parent.resize(n);
        rank.resize(n, 0);
        for (int i = 0; i < n; i++) {
            parent[i] = i;
        }
    }

    // Find parent of a node (with Path Compression)
    int findParent(int node) {
        if (node == parent[node])
            return node;
        // Path compression: attach node directly to the root
        return parent[node] = findParent(parent[node]);
    }

    // Union of two sets (with Union by Rank)
    void unionSets(int u, int v) {
        int rootU = findParent(u);
        int rootV = findParent(v);

        if (rootU != rootV) {
            // Attach smaller rank tree under root of higher rank tree
            if (rank[rootU] < rank[rootV]) {
                parent[rootU] = rootV;
            } else if (rank[rootU] > rank[rootV]) {
                parent[rootV] = rootU;
            } else {
                parent[rootV] = rootU;
                rank[rootU]++; // Increase rank if both were equal
            }
        }
    }
};

// --- Core Algorithm ---

class Graph {
private:
    int V; // Number of vertices
    vector<Edge> edges;

public:
    Graph(int V) : V(V) {}

    void addEdge(int u, int v, int weight) {
        // Validate vertices
        if (u >= 0 && u < V && v >= 0 && v < V) {
            edges.push_back({u, v, weight});
        } else {
            cout << "  [Error] Invalid vertices! Vertices must be between 0 and " << V - 1 << ".\n";
        }
    }

    void displayEdges() const {
        if (edges.empty()) {
            cout << "  [Info] No edges in the graph currently.\n";
            return;
        }
        cout << "\n  --- Current Graph Edges ---\n";
        cout << "  " << left << setw(10) << "Source" << setw(15) << "Destination" << "Weight\n";
        cout << "  -----------------------------------\n";
        for (const auto& edge : edges) {
            cout << "  " << left << setw(10) << edge.u << setw(15) << edge.v << edge.weight << "\n";
        }
        cout << "  -----------------------------------\n";
    }

    void kruskalMST() {
        if (V <= 1) {
            cout << "  [Info] Graph must have at least 2 vertices to form a spanning tree.\n";
            return;
        }

        // 1. Sort all edges in non-decreasing order of their weight
        sort(edges.begin(), edges.end());

        DSU dsu(V);
        vector<Edge> mstEdges;
        int minCost = 0;

        // 2. Iterate through sorted edges
        for (const auto& edge : edges) {
            // If including this edge does not cause a cycle
            if (dsu.findParent(edge.u) != dsu.findParent(edge.v)) {
                dsu.unionSets(edge.u, edge.v);
                mstEdges.push_back(edge);
                minCost += edge.weight;
            }
            // Optimization: Stop early if we have V-1 edges
            if (mstEdges.size() == V - 1) {
                break;
            }
        }

        // 3. Verification: Check if a complete spanning tree was formed
        if (mstEdges.size() != V - 1) {
            cout << "\n  [Warning] Graph is disconnected! A Minimum Spanning Forest was found instead.\n";
        }

        // 4. Output the results cleanly
        cout << "\n  --- Minimum Spanning Tree (Kruskal's) ---\n";
        cout << "  " << left << setw(10) << "Source" << setw(15) << "Destination" << "Weight\n";
        cout << "  ------------------------------------------\n";
        for (const auto& edge : mstEdges) {
             cout << "  " << left << setw(10) << edge.u << setw(15) << edge.v << edge.weight << "\n";
        }
        cout << "  ------------------------------------------\n";
        cout << "  Total Minimum Cost: " << minCost << "\n";
    }
};

// --- User-Friendly I/O Functions ---

// Helper to safely read integers and handle bad input gracefully
int getValidInt(const string& prompt) {
    int value;
    while (true) {
        cout << prompt;
        if (cin >> value) {
            return value;
        } else {
            cout << "  [Error] Invalid input. Please enter a valid integer.\n";
            cin.clear();
            cin.ignore(numeric_limits<streamsize>::max(), '\n');
        }
    }
}

int main() {
    cout << "===========================================\n";
    cout << "       Kruskal's Algorithm Simulator       \n";
    cout << "===========================================\n";

    int V = getValidInt("Enter the total number of vertices (e.g., 0 to V-1): ");
    while (V <= 0) {
        cout << "  [Error] Graph must have at least 1 vertex.\n";
        V = getValidInt("Enter the total number of vertices: ");
    }

    Graph graph(V);
    bool running = true;

    while (running) {
        cout << "\n================ MENU ================\n";
        cout << "  1. Add an Edge\n";
        cout << "  2. Display All Edges\n";
        cout << "  3. Calculate Minimum Spanning Tree\n";
        cout << "  4. Exit\n";
        cout << "======================================\n";
        
        int choice = getValidInt("Select an option (1-4): ");

        switch (choice) {
            case 1: {
                cout << "\n  [Note] Vertices are zero-indexed (0 to " << V - 1 << ")\n";
                int u = getValidInt("  Enter Source Vertex: ");
                int v = getValidInt("  Enter Destination Vertex: ");
                int weight = getValidInt("  Enter Edge Weight: ");
                graph.addEdge(u, v, weight);
                cout << "  [Success] Edge added successfully!\n";
                break;
            }
            case 2:
                graph.displayEdges();
                break;
            case 3:
                graph.kruskalMST();
                break;
            case 4:
                cout << "\nExiting Program. Goodbye!\n";
                running = false;
                break;
            default:
                cout << "  [Error] Invalid choice. Please select an option from 1 to 4.\n";
        }
    }
    return 0;
}
