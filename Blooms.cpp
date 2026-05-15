#include <cstddef>
#include <cstdint>
#include <functional>
#include <iostream>
#include <ostream>
#include <string>
#include <vector>

using namespace std;

size_t getHash(const string &item, uint8_t i) {
  hash<string> hasher;
  return hasher(item + to_string(i));
}

class BloomsFilter {
public:
  uint8_t hash_functions;
  size_t bit_array_size;

  vector<bool> bit_array;
  BloomsFilter(uint8_t hash_functions, size_t bit_array_size)
      : hash_functions(hash_functions), bit_array_size(bit_array_size) {
    bit_array.resize(bit_array_size, 0);
  }

  void insert(const string &item) {
    for (uint8_t i = 0; i < hash_functions; i++) {
      size_t index = getHash(item, i) % bit_array_size;
      bit_array[index] = 1;
    }
  }

  void possiblyContains(const string &item) {
    for (uint8_t i = 0; i < hash_functions; i++) {
      size_t index = getHash(item, i) % bit_array_size;
      if (bit_array[index] == 0) {
        cout << item << ": Does not exist\n";
        return;
      }
    }
    cout << item << ": Possibly exists\n";
    return;
  }

  friend ostream &operator<<(ostream &os, const BloomsFilter &filter);
};

ostream &operator<<(ostream &os, const BloomsFilter &filter) {
  for (bool b : filter.bit_array)
    os << b;
  return os;
}

int main() {
  BloomsFilter filter = BloomsFilter(8, 16);

  for (int i = 0; i < 4; i++) {
    filter.insert(to_string(i));
  }

  cout << filter;

  for (int i = 0; i < 10; i++) {
    filter.possiblyContains(to_string(i));
  }
}
