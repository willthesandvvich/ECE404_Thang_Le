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
    long tid = (long)threadid;
    int i,j,k, tmp;
    printf("It's me, thread #%ld!\n", tid);

    // Matrix Mult
    struct ThreadLim * range = (struct ThreadLim *) threadid;   // Initiaing the end and start of thread iterations
    for (i = 0; i < SIZE; i++) {            
        for (j = 0; j < SIZE; j++) {
            tmp = 0;                                        // If we were to implement line 86->88 here, 
             for (k = range->start; k < range->end; k++) {      // we would run into a problem where one thread is running faster,
                tmp += matrix[i][k] * matrix[k][j];             // which would lead to an incorrect matrix multiplication.
            }
            //pthread_mutex_lock(&lock);
            result[i][j] += tmp;
           // pthread_mutex_unlock(&lock);
        }
    }
    pthread_exit(NULL); 
}

// Main Method for execution
int main(int argc, char *argv[])
{
    // Variables
    int rc, i, t;
    // Number of threads being run
    int NumThreads = atoi(argv[1]);     
    pthread_t threads[NumThreads];
    struct ThreadLim limit[NumThreads];
    int Start, MaxRange = 0;
    // To split each thread into each rows
    MaxRange = SIZE / NumThreads;

    // Restart thread "starting point" on every line after x number of threads
    // For example, running 16 threads means that for every 16 rows,
    // we reset the range (thread iterations) in the following for loop at line 122
    for(i = 0; i < NumThreads; i++) {
        limit[i].start = Start;
        limit[i].end = Start + MaxRange;
        Start += MaxRange;
    }

    // Forcing the end limit of iterations
    limit[NumThreads - 1].end = SIZE;

    //Reading matrix from input TXT file
    ReadMatrix(SIZE, matrix, argv[2]);

    // Creating threads and joining 
    for(t = 0; t < NumThreads; t++){
        printf("In main: creating thread %d\n", t);
        rc = pthread_create(&threads[t], NULL, MultMatrix, &limit[t]);
        if (rc){
            printf("ERROR; return code from pthread_create() is %d\n", rc);
            exit(-1);
        }
    }
    for(t = 0; t < NumThreads; t++){
        printf("In main: joining thread %d\n", t);
        pthread_join(threads[t], NULL);
    }

    // Writing to output TXT file
    WriteMatrix(SIZE, result, argv[3]);

    /* Last thing that main() should do */
    pthread_exit(NULL);
}