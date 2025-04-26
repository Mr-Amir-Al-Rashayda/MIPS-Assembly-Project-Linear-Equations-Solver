# MIPS Assembly Project: Linear Equations Solver

## Overview

This project implements a **Linear Equations Solver** in **MIPS Assembly language** using **Cramer's Rule**. The program is designed to run on the MARS simulator and solves systems of linear equations with either two variables (2x2 system) or three variables (3x3 system). It reads the equations from a user-specified input text file, calculates the solutions, and provides the user with the option to display the results on the screen or save them to an output file.

## Features

*   Solves 2x2 and 3x3 systems of linear equations using Cramer's Rule.
*   Reads linear equations from an external input text file.
*   Prompts the user to enter the name or path of the input file.
*   Handles multiple systems of equations within a single input file, separated by empty lines.
*   Parses equation coefficients and constant terms, including handling implicit coefficients of '1' and negative signs.
*   Performs determinant calculations for the main matrix and the matrices for X, Y, and Z.
*   Handles the case of a zero determinant (no unique solution).
*   Provides a menu-driven interface for the user to choose the output method:
    *   Display results on the screen.
    *   Save results to an output file (`output.txt`).
    *   Exit the program.
*   Implements basic input validation for the menu choice.
*   Writes results to the output file with a fixed precision.

## Files

*   `ProjectOneArchitecture.asm`: The MIPS assembly code containing the program logic. (Note: The provided file `ProjectOneArchitecture.asm.txt` should be renamed to `ProjectOneArchitecture.asm` for use in MARS).
*   `input.txt`: An example input file demonstrating the format for a 3x3 system of equations. You can create this file based on the example provided in the project description or other test cases.
*   (`Project+Advance+Comparator.txt`, `TB.txt`, `TestCases.txt`, `OS_Amir_Nour.py.txt`, `Multithreading_Approach.c.txt`, `Naive_Approach.c.txt`, `Multiprocessing_Approach.c.txt`): These are other project files and are not part of this Linear Equations Solver MIPS project.

## Input File Format

The input file (`input.txt` or the user-specified filename) should contain systems of linear equations.

*   Each equation should be on a new line.
*   Variables should be `x`, `y`, and `z`.
*   Coefficients should be integers. Implicit '1' coefficients (e.g., `x` instead of `1x`) and signs (e.g., `-x` instead of `-1x`) are handled.
*   Terms can be in any order within an equation.
*   Multiple systems of equations should be separated by an empty line.
*   The program is designed for 2x2 or 3x3 systems only.

Example (`input.txt` based on the provided file):
x + y + 2z = 6
x + 2y + z = -3
2x + y + z = -3


## How to Assemble and Run

1.  Save the assembly code as `ProjectOneArchitecture.asm`.
2.  Create your input file (e.g., `input.txt`) following the specified format.
3.  Open the MARS MIPS simulator.
4.  Open `ProjectOneArchitecture.asm` in MARS.
5.  Assemble the code (Run -> Assemble or F3).
6.  Run the program (Run -> Go or F5).
7.  The program will prompt you in the Run I/O window:
    *   "Welcome to Linear Equations Solver (Cramer's Rule)"
    *   "Please enter the input file name:" - Type the name of your input file (e.g., `input.txt`) and press Enter.
    *   After processing, a menu will appear:
        *   `f/F` - Save results to `output.txt`
        *   `s/S` - Display results on screen
        *   `e/E` - Exit program
    *   Enter your choice and press Enter.
    *   Repeat menu interaction until you choose 'e' or 'E'.

## Implementation Details

*   **Parsing:** The `parse_coefficients` subroutine reads the file content character by character, identifying coefficients and constant terms for x, y, and z, handling signs and implicit '1's. It stores them as integers in `.data` memory.
*   **Cramer's Rule:** The core calculation involves:
    *   Calculating the determinant of the coefficient matrix (D).
    *   Creating and calculating the determinants of matrices Dx, Dy, and Dz (by replacing the respective coefficient columns with the constant terms).
    *   Solving for x, y, and z using the formulas: x = Dx/D, y = Dy/D, z = Dz/D.
*   **Determinant Calculation:** The `calculate_determinant` subroutine calculates the determinant of a 3x3 matrix using the standard formula (expansion by minors). It uses temporary memory locations (`temp_matrix_a` through `temp_matrix_i`) to construct Dx, Dy, and Dz.
*   **Floating-Point Arithmetic:** The program uses MIPS floating-point coprocessor 1 instructions (`l.s`, `cvt.s.w`, `div.s`, `c.lt.s`, `neg.s`) to perform division and handle floating-point results.
*   **Output Formatting:** Results are converted back to ASCII strings for printing or writing to the file, handling signs and displaying two decimal places of precision.
*   **File Output:** The `print_x_to_file`, `print_y_to_file`, and `print_z_to_file` subroutines handle writing the results to `output.txt`, clearing the file for the first variable (x) and appending for subsequent variables (y, z).

## Authors

*   Name: Amir Al-Rashayda
