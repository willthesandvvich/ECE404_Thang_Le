/******************************************************************************
* FILE: mpi_hello.c
* DESCRIPTION:
*   MPI Matrix Multiplication
* AUTHOR: Thang Le
******************************************************************************/
#include <iostream>
#include <mpi.h>
#include <math.h>
#include <string.h>
#include <sys/time.h>
using namespace std;

//Global Constants
#define SIZE 4000

// Global Variables
int matrix[SIZE][SIZE];
int result[SIZE][SIZE];

//MPI-Specific Variables
MPI_Status status;

// Method for reading the input Matrix from cmd line arguments
int ReadMatrix(int dim, int mat[][SIZE], const char* filename)
{
    FILE *rf = fopen (filename, "r");
    if (rf == NULL){
        printf("Error opening file!\n");
        return 0;
    }

    int i,j; 
    for(i = 0; i < dim; i++)
    {
        for(j = 0; j < dim; j++){
            fscanf(rf, "%d ", &mat[i][j]);
        }
    }
    fclose (rf); 
    return 1;
}

// Method for writing onto an TXT file
int WriteMatrix(int dim, int mat[][SIZE], const char* filename){
    // Printing the output onto an external .txt file
    FILE *wf = fopen(filename, "w");
    if (wf == NULL)
    {
        printf("Error opening file!\n");
        return 0;
    }
    
    int i,j;
    for(i = 0; i < SIZE; i++)
    {
        for(j = 0; j < SIZE; j++){
            fprintf(wf, "%d ", mat[i][j]);
        }
        fprintf(wf, "\n");
    }
    fclose(wf);
    return 1;
}

void MultMatrix (int batch){
    // Matrix Mult
    for (int i = 0; i < SIZE; i++) {            
        for (int j = 0; j < batch; j++) {       
            result[j][i] = 0;                       
            for (int k = 0; k < SIZE; k++) {      
                result[j][i] += matrix[j][k] * matrix[k][i];             
            }
        }
    }

}

int main() {
    // Start of main

    string input_name = "";
    string output_name = "";

    // Initialize the MPI world
    MPI_Init(NULL, NULL);
    int source;
    // We devise into slave and master:
    // Where master is sending out request and slave will be doing calculations.
    // Our default configuration is that the first process being initiated is the MASTER,
    // the rest will be considered as SLAVE.
  
    // Get process rank
    int rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    // Get the number of processes
    int size;
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    
    int SlaveCount = size - 1; 
    int row_batch, start;
    row_batch = 0;
    // MASTER Process
    if (rank == 0){

        // Getting input from terminal
        cout << "This is Thang Le MPI Matrix Mult" << endl;
        cout << "Please input matrix file name: "; cin >> input_name;
        cout << "Please input matrix output file name: "; cin >> output_name;
        cout << "Thank you, see result in " << output_name << endl; 

        // Getting input Matrix
        ReadMatrix(SIZE, matrix, input_name.c_str());
        
        row_batch = SIZE / SlaveCount;
        start = 0;
        // Rows per batch
        // Sending command from MASTER
        for (int j = 1; j <= SlaveCount; j++)
        {
            // Sending starting point 
            MPI_Send(&start, 1, MPI_INT, j, 1, MPI_COMM_WORLD);
            // Sending number of batches 
            MPI_Send(&row_batch, 1, MPI_INT, j, 1, MPI_COMM_WORLD);
            // Sending divided input matrix for each batch 
            MPI_Send(&matrix[start][0], row_batch*SIZE, MPI_INT,j,1, MPI_COMM_WORLD);
            // Sending full input matrix
            MPI_Send(&matrix, SIZE*SIZE, MPI_INT, j, 1, MPI_COMM_WORLD);
            // Iterate to the next batch
            start += row_batch;
        }
        
        // Receiving result from SLAVE
        for (int i = 1; i <= SlaveCount; i++){
            
            // Setting souce to SlaveCount
            source = i;
            // Receive the start of particular slave process
            MPI_Recv(&start, 1, MPI_INT, source, 2, MPI_COMM_WORLD, &status);
            // Receive the number of row_batch that each slave process processed
            MPI_Recv(&row_batch, 1, MPI_INT, source, 2, MPI_COMM_WORLD, &status);
            // the processed number of row_batch
            MPI_Recv(&result[start][0], row_batch*SIZE, MPI_INT, source, 2, MPI_COMM_WORLD, &status);

        }

        WriteMatrix(SIZE, result, output_name.c_str());
        
    }

    // SLAVE Process
    if (rank > 0){

        // Reset source ID 
        source = 0;

        // Since we are sending from MASTER with tag 1, slave should be looking for tag 1
        // Receive starting point
        MPI_Recv(&start, 1, MPI_INT, source, 1, MPI_COMM_WORLD, &status);
        // Receive amount of row_batch per batch  
        MPI_Recv(&row_batch, 1, MPI_INT, source, 1, MPI_COMM_WORLD, &status);
        // Receive the divided input matrix
        MPI_Recv(&matrix, row_batch*SIZE, MPI_INT, source, 1, MPI_COMM_WORLD, &status);
        // Receive the full input matrix
        MPI_Recv(&matrix, SIZE*SIZE, MPI_INT, source, 1, MPI_COMM_WORLD, &status);
    
        //doing the calculation
        MultMatrix(row_batch);

        // Sending calculations back to MASTER
        // Sending starting point of each calculation
        MPI_Send(&start, 1, MPI_INT, 0, 2, MPI_COMM_WORLD);
        // Sending number of rows per batch
        MPI_Send(&row_batch, 1, MPI_INT, 0, 2, MPI_COMM_WORLD);
        // Sending the calculation result
        MPI_Send(&result, row_batch*SIZE, MPI_INT, 0, 2, MPI_COMM_WORLD);
    }

    // Finalize the MPI environment.
    MPI_Finalize();
}
