#include <iostream>
#include <mpi.h>

using namespace std;
int main() {
  // Initialize the MPI world
  MPI_Init(NULL, NULL);

  // Get the number of processes
  int size;
  MPI_Comm_size(MPI_COMM_WORLD, &size);

  // Get process rank
  int rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  // Get processor name (if you are using only one processor, it will be
  // "localhost" or "your computer name")
  char processor_name[MPI_MAX_PROCESSOR_NAME];
  int name_length;
  MPI_Get_processor_name(processor_name, &name_length);

  // Print off a hello world message
  cout << "Hello world from " << processor_name << ", rank " << rank
       << " out of " << size << " processors" << endl;
  // Finalize the MPI environment.
  MPI_Finalize();
}
