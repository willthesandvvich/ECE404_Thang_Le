/******************************************************************************
* FILE: Assignment3.c
* DESCRIPTION:
*   ECE404 Assignment 3 Task 2
* AUTHOR: Thang LE

******************************************************************************/
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//Global Constants
#define SIZE 50

// Global Variables
int matrix[SIZE][SIZE];
int result[SIZE][SIZE];

// Start and end loop limit of the matrix
struct ThreadLim
{
    int start;
    int end;
};
// struct for each matrix
struct matrix {
    int rows;
    int cols;
    int **arr;
};

// struct to pass as argument
struct multiplication {
    int row;
    int col;
    struct matrix *A;
    struct matrix *B;
    struct matrix *result_mat;
};

void ReadMatrix(const char* filename, struct matrix *m) {   
    FILE *rf = fopen (filename, "r");
    if (rf == NULL){
        printf("Error opening file!\n");
        exit(-1);
    }

    int rows, cols, check;
    rows = SIZE;
    cols = SIZE;

    m->rows = rows;
    m->cols = cols;
    int **arr = (int **) malloc(rows * sizeof(int *));
    for (int i = 0; i < rows; i++) {
        arr[i] = (int *) malloc(cols * sizeof(int));
        for (int j = 0; j < cols; j++) {
            check = fscanf(rf, "%d", &arr[i][j]);
            if ( check != 1) {
                printf("Error reading the file: %s\n", filename);
                exit(-1);
            }
        }
    }
    m->arr = arr;

    fclose(rf);
}

// Method for writing onto an TXT file
void WriteMatrix(const char* filename, struct matrix *result_mat){
    // Printing the output onto an external .txt file
    FILE *wf = fopen(filename, "w");
    if (wf == NULL)
    {
        printf("Error opening file!\n");
        exit(-1);
    }
    
    int i,j;
    for(i = 0; i < result_mat->rows; i++)
    {
        for(j = 0; j < result_mat->cols; j++){
            fprintf(wf, "%d ", result_mat->arr[i][j]);
        }
        fprintf(wf, "\n");
    }
    fclose(wf);
}


// Method for Matrix Multiplication 
void *MultMatrix (void *args){
    struct multiplication *element;
    element = (struct multiplication *) args;
    int tmp = 0;
    for (int k = 0; k < element->B->rows; k++) {
        tmp += element->A->arr[element->row][k] * element->B->arr[k][element->col];
    }
    element->result_mat->arr[element->row][element->col] = tmp;
    free(element);
    pthread_exit(NULL);
}

// Main Method for execution
int main(int argc, char *argv[])
{
    // Variables
    int rc;
    int NumThreads = atoi(argv[1]);     
    pthread_t threads[NumThreads];
    struct matrix *A = malloc(sizeof(struct matrix));
    struct matrix *B = malloc(sizeof(struct matrix));
    struct matrix *result_mat = malloc(sizeof(struct matrix));

    ReadMatrix(argv[2], A);
    ReadMatrix(argv[2], B);

    int rows = A->rows, cols = B->cols;
    
    int **temprow = (int **) calloc(A->rows, sizeof(int *));
    for (int i = 0; i < A->rows; i++) {
        temprow[i] = (int *) calloc(B->cols, sizeof(int));
    }
    
    result_mat->rows = A->rows; result_mat->cols = B->cols; result_mat->arr = temprow;
    
    for (int i = 0; i < rows; i++) {
        for (int t=0; t < NumThreads; t++){
        for (int j = 0; j < cols; j++) {
            
                struct multiplication *element = malloc(sizeof(struct multiplication));
                element->row = i; element->col = j;
                element->A = A; element->B = B; element->result_mat = result_mat;
                rc = pthread_create(&threads[t], NULL, MultMatrix, (void *) element);
                if (rc) 
                {
                    printf("ERROR; return code from pthread_create() is %d\n", rc);
                    exit(1);
                }
            }
        }
    }
    
    for (int i = 0; i < rows; i++) {
        for (int t=0; t < NumThreads; t++){
        for (int j = 0; j < cols; j++) {
            
                pthread_join(threads[t], NULL);
            }
        }
    }

    WriteMatrix(argv[3], result_mat);

    /* Last thing that main() should do */
    pthread_exit(NULL);
}