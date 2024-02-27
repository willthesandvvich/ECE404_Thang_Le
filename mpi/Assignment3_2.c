/******************************************************************************
* FILE: Assignment1.c
* DESCRIPTION:
*   ECE404 Assignment 1
* AUTHOR: Thang LE

******************************************************************************/
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//Global Constants
#define SIZE 200

// Global Variables
int matrix[SIZE][SIZE];
int result[SIZE][SIZE];

// Start and end loop limit of the matrix
struct ThreadLim
{
    int start;
    int end;
};


// Initialize mutex lock
pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;

// Method for reading the input Matrix from cmd line arguments
int ReadMatrix(int dim, int mat[][dim], const char* filename)
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
int WriteMatrix(int dim, int mat[][dim], const char* filename){
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

// Method for Matrix Multiplication 
void *MultMatrix (void *threadid){
    int i,j,k,tmp = 0;
    int *data = (int *) threadid;
    int x = data[0];

    // Matrix Mult
    //struct ThreadLim * range = (struct ThreadLim *) threadid;   // Initiaing the end and start of thread iterations
    for (i = 1; i <= x; i++) {            
            tmp += data[i]*data[i+x];        
    }
    int *p = (int*)malloc(sizeof(int));
    *p = k;
    pthread_exit(p); 
}

// Main Method for execution
int main(int argc, char *argv[])
{
    // Variables
    int rc, i, t;
    // Number of threads being run
    int NumThreads = atoi(argv[1]);     
    pthread_t threads[NumThreads];

    //Reading matrix from input TXT file
    ReadMatrix(SIZE, matrix, argv[2]);

    int* data = NULL;
    int j,k1,k2;
    // Creating threads and joining 
   
    for(t = 0; t < NumThreads; t++){
        printf("In main: creating thread %d\n", t);
        for (i = 0; i < SIZE; i++){
        for (j = 0; j < SIZE; j++){
            data[0] = SIZE;
            for(k1 = 0; k1 < SIZE; k1++){ data[k1+1] = matrix[i][k1]; }
            for(k2 = 0; k2 < SIZE; k2++){ data[k2+SIZE+1] = matrix[k2][j]; }
            rc = pthread_create(&threads[t], NULL, MultMatrix, (void*)(data));
            if (rc){
                printf("ERROR; return code from pthread_create() is %d\n", rc);
                exit(-1);
            }
        }

        }
        
    }
    for(t = 0; t < SIZE; t++){
        void *k;
        pthread_join(threads[t], &k);
    }

    // Writing to output TXT file
    WriteMatrix(SIZE, result, argv[3]);

    /* Last thing that main() should do */
    pthread_exit(NULL);
    return 0;
}