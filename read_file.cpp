#include <fstream>
#include <iostream>
#include <sstream>

using namespace std;

int main (int argc, char *argv[]) {
  if (argc !=2) {
    cout << "usage: " << argv[0] << " <filename>\n";
  } else {
    ifstream the_file(argv[1]);

    if (!the_file.is_open()) {
      cout << "Could not open file\n";
    } else {
      string sentences;
      stringstream buffer;

      /* Read a text file */
      buffer << the_file.rdbuf();
      sentences = buffer.str();

      /* Print out the contents of the file */
      cout << sentences;

      /* Save string to file */
      ofstream out("output.txt");
      out << sentences;
      out.close();
    }
  }

  return 0;
}
