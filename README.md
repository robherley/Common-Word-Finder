# C++ Common Word Finder
---

This is a basic program that has the functionality to parse through a text file and storing the data in a red-black tree. The data is read from a file using [memory map](https://linux.die.net/man/3/mmap) and then placed into a red-black tree for fast lookup and key/value manipulation. The data is then extracted from the tree, and sorted using the built in C++ stable_sort algorithm. It then outputs the most common words, up to a specified limit (default is 10 words).

`Usage: ./commonwordfinder <filename> [limit]`

See `testcwf.sh` for various input tests.

---
Thanks to Professor Brian Borowski for the supporting files:
* `node.h`
* `tree.h`
