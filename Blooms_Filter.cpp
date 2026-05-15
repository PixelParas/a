#include <iostream>
#include <vector>
#include <string>
#include <functional>
#include <algorithm>
#include <climits>

using namespace std;

// ==========================================
// Helper Function: Simulate Multiple Hashes
// ==========================================
// By appending an integer 'i' to the string, we can use the 
// standard C++ hash function to simulate 'k' different hash functions.
size_t getHash(const string& item, int i) {
    hash<string> hasher;
    return hasher(item + to_string(i));
}

// ==========================================
// 1. Bloom Filter Implementation
// ==========================================
class BloomFilter {
private:
    int m; // Size of the bit array
    int k; // Number of hash functions
    vector<bool> bitArray;

public:
    // Constructor initializes the bit array with all false (0)
    BloomFilter(int size, int numHashes) : m(size), k(numHashes) {
        bitArray.resize(m, false);
    }

    // Insert an item into the Bloom Filter
    void insert(const string& item) {
        for (int i = 0; i < k; ++i) {
            int index = getHash(item, i) % m;
            bitArray[index] = true;
        }
    }

    // Check if an item is possibly in the set
    bool possiblyContains(const string& item) {
        for (int i = 0; i < k; ++i) {
            int index = getHash(item, i) % m;
            // If any of the mapped bits is false, the item is DEFINITELY NOT in the set
            if (!bitArray[index]) {
                return false; 
            }
        }
        // If all mapped bits are true, the item is PROBABLY in the set
        return true; 
    }
};

// ==========================================
// 2. Count-Min Sketch Implementation
// ==========================================
class CountMinSketch {
private:
    int w; // Width of the sketch table (columns)
    int d; // Depth of the sketch table (rows / number of hash functions)
    vector<vector<int>> table;

public:
    // Constructor initializes the 2D array with zeros
    CountMinSketch(int width, int depth) : w(width), d(depth) {
        table.resize(d, vector<int>(w, 0));
    }

    // Insert an item, incrementing its frequency by 'count'
    void insert(const string& item, int count = 1) {
        for (int i = 0; i < d; ++i) {
            int index = getHash(item, i) % w;
            table[i][index] += count;
        }
    }

    // Estimate the frequency of a given item
    int estimateFrequency(const string& item) {
        int minFreq = INT_MAX;
        for (int i = 0; i < d; ++i) {
            int index = getHash(item, i) % w;
            // The estimate is the minimum value across all its hashed locations
            minFreq = min(minFreq, table[i][index]);
        }
        return minFreq;
    }
};

// ==========================================
// Driver Code (Sample Input Execution)
// ==========================================
int main() {
    cout << "======================================\n";
    cout << "   Probabilistic Data Structures Demo   \n";
    cout << "======================================\n\n";

    // --- Bloom Filter Demo ---
    cout << "--- 1. Bloom Filter (Membership) ---\n";
    // Initialize with an array size of 100 and 3 hash functions
    BloomFilter bf(100, 3); 
    
    // Sample Input for Bloom Filter
    vector<string> registeredUsers = {"alice", "bob", "charlie"};
    for (const string& user : registeredUsers) {
        bf.insert(user);
        cout << "Inserted user: " << user << "\n";
    }

    // Querying existing and non-existing items
    cout << "\nQueries:\n";
    cout << "Is 'alice' present?   " << (bf.possiblyContains("alice") ? "Yes (Probably)" : "No (Definitively)") << "\n";
    cout << "Is 'dave' present?    " << (bf.possiblyContains("dave") ? "Yes (Probably)" : "No (Definitively)") << "\n";
    cout << "Is 'charlie' present? " << (bf.possiblyContains("charlie") ? "Yes (Probably)" : "No (Definitively)") << "\n";


    // --- Count-Min Sketch Demo ---
    cout << "\n--- 2. Count-Min Sketch (Frequency) ---\n";
    // Initialize with width 50 and depth 5 (5 hash functions)
    CountMinSketch cms(50, 5); 

    // Sample Input Stream for CMS (representing web page clicks)
    cout << "Simulating web page clicks...\n";
    cms.insert("page_home", 10);  // Visited 10 times
    cms.insert("page_about", 3);  // Visited 3 times
    cms.insert("page_contact", 1); // Visited 1 time
    cms.insert("page_home", 5);   // Visited 5 more times (total 15)
    
    cout << "Added 15 clicks to 'page_home'\n";
    cout << "Added 3 clicks to 'page_about'\n";
    cout << "Added 1 click to 'page_contact'\n";

    // Querying estimated frequencies
    cout << "\nFrequency Estimations:\n";
    cout << "Estimated clicks for 'page_home':    " << cms.estimateFrequency("page_home") << "\n";
    cout << "Estimated clicks for 'page_about':   " << cms.estimateFrequency("page_about") << "\n";
    cout << "Estimated clicks for 'page_contact': " << cms.estimateFrequency("page_contact") << "\n";
    cout << "Estimated clicks for 'page_unknown': " << cms.estimateFrequency("page_unknown") << " (Never visited)\n";

    cout << "\n======================================\n";
    return 0;
}
