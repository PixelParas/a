#include <iostream>
#include <vector>

using namespace std;

// Helper function to maintain the heap property
// 'ascending' determines if we build a Max-Heap (true) or Min-Heap (false)
void heapify(vector<int>& arr, int n, int i, bool ascending) {
    int extreme = i; // Initialize extreme (largest or smallest) as root
    int left = 2 * i + 1; // Left child index
    int right = 2 * i + 2; // Right child index

    if (ascending) {
        // Max-Heap logic for Ascending sort
        if (left < n && arr[left] > arr[extreme])
            extreme = left;
        if (right < n && arr[right] > arr[extreme])
            extreme = right;
    } else {
        // Min-Heap logic for Descending sort
        if (left < n && arr[left] < arr[extreme])
            extreme = left;
        if (right < n && arr[right] < arr[extreme])
            extreme = right;
    }

    // If the extreme value is not the root, swap and continue heapifying
    if (extreme != i) {
        swap(arr[i], arr[extreme]);
        // Recursively heapify the affected sub-tree
        heapify(arr, n, extreme, ascending);
    }
}

// Main Heapsort function
void heapSort(vector<int>& arr, bool ascending) {
    int n = arr.size();

    // Step 1: Build the initial heap (rearrange array)
    // We start from the last non-leaf node and work our way up to the root
    for (int i = n / 2 - 1; i >= 0; i--) {
        heapify(arr, n, i, ascending);
    }

    // Step 2: Extract elements one by one from the heap
    for (int i = n - 1; i > 0; i--) {
        // Move current root (extreme value) to the end of the array
        swap(arr[0], arr[i]);
        
        // Call heapify on the reduced heap to restore the heap property
        heapify(arr, i, 0, ascending);
    }
}

// Helper function to print the array
void printArray(const vector<int>& arr) {
    for (int num : arr) {
        cout << num << " ";
    }
    cout << "\n";
}

int main() {
    // Sample input array
    vector<int> arr = {42, 11, 89, 23, 74, 5, 18, 91, 33};

    cout << "======================================\n";
    cout << "          Heapsort Algorithm          \n";
    cout << "======================================\n\n";

    cout << "Original Array: \n";
    printArray(arr);
    cout << "--------------------------------------\n";

    // Create copies for both sorting operations
    vector<int> arrAscending = arr;
    vector<int> arrDescending = arr;

    // 1. Sort in Ascending Order (Uses Max-Heap)
    heapSort(arrAscending, true);
    cout << "Array sorted in Ascending Order: \n";
    printArray(arrAscending);
    cout << "--------------------------------------\n";

    // 2. Sort in Descending Order (Uses Min-Heap)
    heapSort(arrDescending, false);
    cout << "Array sorted in Descending Order: \n";
    printArray(arrDescending);
    
    cout << "======================================\n";

    return 0;
}
