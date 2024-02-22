ECE404 Assignment 1 
Author: Thang Le

Description: Report file and clarification for Assignment 1 of ECE404

Code Usage: 
    - In the compressed folder, I have provided the following: Assignment1.c, result.txt, go.exe, and README.txt (this file). 
    - Assignment1.c is the main C file for the assignment.
    - "result.txt" is the result from doing matrix multiplication. (4kx4k)
    - "go.exe" is a bash script for running the code. Since I am passing matrix as a parameter, C99 is the preferred version. 
       Compile engine is GCC, options are -pthread, -Wall, -std=c99.
    - Further explanation are commented in the code. 

Insights and Reports: 
    - Running multi-thread on the 200x200 matrix might result in a longer time than single-thread since the application is so short, it might be due to the efficient or performance cores.
    - However, multi-thread is consistently faster for a bigger matrix of 4000x4000.
        Specifically, in 2 runs: 
            + 1st: 16 multi: 19m19.318s; single: 27m1s.
            + 2nd: 32 multi: 25m42s; single: 27m16s.
    --> Running multi-thread is consistently faster than single-thread in heavy task.