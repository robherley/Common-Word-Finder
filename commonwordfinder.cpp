/*******************************************************************************
 * Name          : commonwordfinder.cpp
 * Author        : Robert Herley
 * Version       : 1.0
 * Date          : April 25, 2017
 * Description   : Program that counts words in a textfile using a RBT.
 ******************************************************************************/
#include "rbtree.h"
#include <iostream>
#include <sstream>
#include <iomanip>
#include <sstream>
#include <string>
#include <fstream>
#include <iterator>
#include <algorithm>
#include <iomanip>

// C Stuff
#include <fcntl.h>  // used for open
#include <unistd.h> // used for close
#include <sys/stat.h> // used for stats
#include <sys/mman.h> // used for mmap

using namespace std;

/**
 * Custom compare function of key value pairs so that when it has to be sorted,
 * the value is compared rather than the key.
 */
bool pair_compare(const pair<string, int> &firstPair,
                  const pair<string, int> &secondPair) {
  return firstPair.second > secondPair.second;
}

/**
 * Prints the output required for the assignment. It displays the total number
 * of uniqure words (nodes in rbt) as well as a list of the most common words
 * to a specified limit.
 */
void display_output(Tree *tree,
                    vector< pair<string,int> > word_vec,
                    unsigned int lim){
    cout << "Total unique words: " << tree->size() << "\n";
    if(lim > word_vec.size()){
      lim = word_vec.size();
    }
    int temp = lim;
    int max_digits = 0; while (temp != 0) { temp /= 10; max_digits++; }
    unsigned int max_word = 0;
    for(size_t i = 0; i < lim; ++i){
      if(word_vec[i].first.size() > max_word){
        max_word = word_vec[i].first.size();
      }
    }
    for(size_t i = 0; i < lim; ++i){
      cout << setw(max_digits) << right << i+1 << ". "
           << setw(max_word) << left << word_vec[i].first << " "
           << word_vec[i].second << "\n";
    }
}


int main(int argc, char *argv[]) {
    // Check number of arguments
    if(argc != 3 && argc != 2){
      cerr << "Usage: ./commonwordfinder <filename> [limit]\n";
      return 1;
    }

    int limit = 10; // Preset limit of 10 if unspecified.

    // If the limit is specified
    if (argc == 3) {
      istringstream ss(argv[2]);
      if(!(ss >> limit) || limit < 0){ // Check if integer and greater than 0
        cerr << "Error: Invalid limit '" << ss.str() << "' received.\n";
        return 1;
      }
    }

    const char *filepath = argv[1]; // Set file from args

    // Open the file: takes in filepath, file access(R/W)
    int textfile = open(filepath, O_RDONLY);

    // If the file cannot be read.
    if (textfile == -1){
      cerr << "Error: Cannot open file '" << argv[1] << "' for input.\n";
      return 1;
    }

    struct stat text_info = {0}; // Used to collect file stats

    // If file stats cannot be loaded...
    if (fstat(textfile, &text_info) == -1){
        cerr << "Error getting the file size\n";
        return 1;
    }

    // If file is empty...
    if (text_info.st_size == 0){
        cerr << "Error: File is empty, nothing to do\n";
        return 1;
    }

    // Create the mmap for the file
    char *map = (char*)mmap(0, text_info.st_size,
                                PROT_READ, MAP_SHARED, textfile, 0);

    // If file cannot be mapped...
    if ((void*)mmap == MAP_FAILED){
        close(textfile);
        cerr << "Error mapping file: " << argv[1] << "\n";
        return 1;
    }

    // RBT used to store the info
    RedBlackTree<string, int> *rbt = new RedBlackTree<string, int>();

    // Parse through textfiles and add to tree.
    char c;
    string word;
    for (off_t i = 0; i < text_info.st_size; i++){
      c = map[i];
      // Case for uppercase char
      if(c > 64 && c < 91){
        word += c^32;
      }
      // Case for a-z or ' or -
      else if((c > 96 && c < 123) || c == 39 || c == 45){
        word += c;
      }
      else{
        if(word.length() != 0){ //Make sure it isn't empty string
          RedBlackTree< string, int >::iterator it = rbt->find(word);
          if(it == rbt->end()){
            // If it's not found, make a new pair and insert it.
            pair<string, int> newpair(word,1);
            rbt->insert(it, newpair);
          }
          else{
            // If it's found, increment the value.
            ++it->second;
          }
        }
        word = ""; //Reset word
      }
    }

    // Create a vector full of string-int pairs
    vector< pair< string, int > > pair_vec;
    RedBlackTree<string, int>::iterator it = rbt->begin();
    while (it != rbt->end()) {
        pair_vec.push_back(make_pair((*it).first,(*it).second));
        ++it;
    }

    // Sorts the vector by the value (instead of key)
    // Takes approx 0.0184603 seconds.
    stable_sort(pair_vec.begin(), pair_vec.end(), pair_compare);

    // Displays all the output
    display_output(rbt, pair_vec, limit);

    // Unmmap the memory
    if (munmap(map, text_info.st_size) == -1){
        close(textfile);
        cerr << "Cannot unmmap the file. You are doomed.\n";
        return 1;
    }

    // Close the file (not sure if necessary)
    close(textfile);

    // Deletes RBT from heap
    delete rbt;

    return 0;
}
