
# -----------------------------------------------------------
# MIPS Assembly Project: System of Linear Equations Solver.
# Done by: Joud Thaher 1221381 and Amir Al-Rashayda 1222596.
# Date: November 22, 2024.
# Description: Solves 2x2 and 3x3 systems of linear equations using Cramer's Rule.
# -----------------------------------------------------------


.data

zero:                               .float  0.0                                                                                                                                         
filename_buffer:                    .space  100                                                                                                                                         
newline:                            .asciiz "\n"                                                                                                                                        # Allocates space for a null-terminated string containing just a newline character
buffer:                             .space  1024                                                                                                                                        # Allocates 1024 bytes of space to store the contents read from file
prompt:                             .asciiz "Enter the filename: "                                                                                                                      # Allocates space for a null-terminated string for the filename prompt
error_message:                      .asciiz "Error: Unable to open file.\n"                                                                                                             # Allocates space for a null-terminated string for error message
coeff_output:                       .asciiz "Coefficients:\n"                                                                                                                           # Allocates space for a null-terminated string for coefficient header
x_coeff_output:                     .asciiz "Coefficients of x are: "                                                                                                                   # Allocates space for a null-terminated string for x coefficients label
y_coeff_output:                     .asciiz "Coefficients of y are: "                                                                                                                   # Allocates space for a null-terminated string for y coefficients label
z_coeff_output:                     .asciiz "Coefficients of z are: "                                                                                                                   # Allocates space for a null-terminated string for z coefficients label
constant_output:                    .asciiz "Constant terms: "                                                                                                                          # Allocates space for a null-terminated string for constant terms label
det_output:                         .asciiz "\nMatrix Determinant: "                                                                                                                    # Allocates space for a null-terminated string for determinant output
matrix_values:                      .space  36                                                                                                                                          # Allocates 36 bytes (9 words 4 bytes) for storing matrix values
space:                              .asciiz " "                                                                                                                                         # Allocates space for a null-terminated string containing a single space character
temp_matrix_a:                      .word   0                                                                                                                                           # Allocates 4 bytes for temporary storage for Dx calculation, initialized to 0
temp_matrix_b:                      .word   0                                                                                                                                           # Allocates 4 bytes for temporary storage, initialized to 0
temp_matrix_c:                      .word   0                                                                                                                                           # Allocates 4 bytes for temporary storage, initialized to 0
temp_matrix_d:                      .word   0                                                                                                                                           # Allocates 4 bytes for temporary storage, initialized to 0
temp_matrix_e:                      .word   0                                                                                                                                           # Allocates 4 bytes for temporary storage, initialized to 0
temp_matrix_f:                      .word   0                                                                                                                                           # Allocates 4 bytes for temporary storage, initialized to 0
temp_matrix_g:                      .word   0                                                                                                                                           # Allocates 4 bytes for temporary storage, initialized to 0
temp_matrix_h:                      .word   0                                                                                                                                           # Allocates 4 bytes for temporary storage, initialized to 0
temp_matrix_i:                      .word   0                                                                                                                                           # Allocates 4 bytes for temporary storage, initialized to 0
y_output:                           .asciiz "y = "                                                                                                                                      # Allocates space for a null-terminated string for output of y
z_output:                           .asciiz "z = "                                                                                                                                      # Allocates space for a null-terminated string for output of z
x_output:                           .asciiz "x = "                                                                                                                                      # Allocates space for a null-terminated string for output of x
div_zero_msg:                       .asciiz "Error: System has no unique solution (determinant is zero)\n"                                                                              # Allocates space for a null-terminated string for division by zero error message
buffer1:                            .space  32                                                                                                                                          # Allocates 32 bytes for a buffer to store number strings
temp_buffer:                        .space  32                                                                                                                                          # Allocates 32 bytes for a temporary buffer for conversion
output_file:                        .asciiz "output.txt"                                                                                                                                # Allocates space for a null-terminated string for the output filename
hundred:                            .float  100.0                                                                                                                                       # Allocates 4 bytes for a floating-point variable initialized to 100.0
ten_thousand:                       .float  10000.0                                                                                                                                     # Allocates 4 bytes for a floating-point variable initialized to 10000.0 for 4 decimal places

    # Coefficient buffers
coefficient_x:                      .space  400                                                                                                                                         # Allocates 400 bytes for storing x coefficients
coefficient_y:                      .space  400                                                                                                                                         # Allocates 400 bytes for storing y coefficients
coefficient_z:                      .space  400                                                                                                                                         # Allocates 400 bytes for storing z coefficients
constant_term:                      .space  400                                                                                                                                         # Allocates 400 bytes for storing constant terms

    # Index trackers
index_const:                        .word   0                                                                                                                                           # Allocates 4 bytes (word) initialized to 0 for constant term index
index_x:                            .word   0                                                                                                                                           # Allocates 4 bytes (word) initialized to 0 for x coefficient index
index_y:                            .word   0                                                                                                                                           # Allocates 4 bytes (word) initialized to 0 for y coefficient index
index_z:                            .word   0                                                                                                                                           # Allocates 4 bytes (word) initialized to 0 for z coefficient index

    # Matrix values for 3x3 system
matrix_a:                           .word   0                                                                                                                                           # Allocates 4 bytes (word) initialized to 0 for matrix element a11
matrix_b:                           .word   0                                                                                                                                           # Allocates 4 bytes (word) initialized to 0 for matrix element a12
matrix_c:                           .word   0                                                                                                                                           # Allocates 4 bytes (word) initialized to 0 for matrix element a13
matrix_d:                           .word   0                                                                                                                                           # Allocates 4 bytes (word) initialized to 0 for matrix element a21
matrix_e:                           .word   0                                                                                                                                           # Allocates 4 bytes (word) initialized to 0 for matrix element a22
matrix_f:                           .word   0                                                                                                                                           # Allocates 4 bytes (word) initialized to 0 for matrix element a23
matrix_g:                           .word   0                                                                                                                                           # Allocates 4 bytes (word) initialized to 0 for matrix element a31
matrix_h:                           .word   0                                                                                                                                           # Allocates 4 bytes (word) initialized to 0 for matrix element a32
matrix_i:                           .word   0                                                                                                                                           # Allocates 4 bytes (word) initialized to 0 for matrix element a33

    # Constant terms
constant_term_1:                    .word   0                                                                                                                                           # Allocates 4 bytes (word) initialized to 0 for first constant term
constant_term_2:                    .word   0                                                                                                                                           # Allocates 4 bytes (word) initialized to 0 for second constant term
constant_term_3:                    .word   0                                                                                                                                           # Allocates 4 bytes (word) initialized to 0 for third constant term

    # New menu-related data segments
menu_prompt:                        .asciiz "\nLinear Equation Solver Menu:\nf/F - Save results to a file\ns/S - Display results on screen\ne/E - Exit program\nEnter your choice: "    # Allocates space for a null-terminated string for menu prompt
output_prompt:                      .asciiz "Enter output filename: "                                                                                                                   # Allocates space for a null-terminated string for output filename prompt
invalid_input:                      .asciiz "Invalid input! Please enter 'f', 's', or 'e'\n"                                                                                            # Allocates space for a null-terminated string for invalid input message
results_saved:                      .asciiz "\nResults have been saved to file.\n"                                                                                                        # Allocates space for a null-terminated string for results saved message
results_screen:                     .asciiz "\nResults displayed on screen:\n"                                                                                                            # Allocates space for a null-terminated string for results displayed message
program_exit:                       .asciiz "Program terminated.\n"                                                                                                                     # Allocates space for a null-terminated string for program exit message
output_buffer:                      .space  100                                                                                                                                         # Allocates 100 bytes for output filename buffer
welcome_msg1:   .asciiz "\n====================================================\n"
welcome_msg2:   .asciiz "   Welcome to Linear Equations Solver (Cramer's Rule)\n"
welcome_msg3:   .asciiz "====================================================\n"
input_prompt:   .asciiz "\nPlease enter the input file name: "
invalid_msg:    .asciiz "\nError: Invalid input! Please enter S, F, or E.\n"
processing_msg: .asciiz "\nProcessing equations...\n"
goodbye_msg:    .asciiz "\nThank you for using our Linear Equations Solver!\n"



.text
                                    .globl  main                                                                                                                                        # Makes main label globally accessible

main:                                                                                                                                                                                   # Main function entry point
    sw      $zero,                              index_const                                                                                                                             # Store word: Saves 0 from $zero register to index_const memory location
    sw      $zero,                              index_x                                                                                                                                 # Store word: Saves 0 from $zero register to index_x memory location
    sw      $zero,                              index_y                                                                                                                                 # Store word: Saves 0 from $zero register to index_y memory location
    sw      $zero,                              index_z                                                                                                                                 # Store word: Saves 0 from $zero register to index_z memory location

    # Display welcome banner
    li $v0, 4
    la $a0, welcome_msg1
    syscall
    la $a0, welcome_msg2
    syscall
    la $a0, welcome_msg3
    syscall
    
    # Get input file name
    li $v0, 4
    la $a0, input_prompt
    syscall
    
    # Call function to handle file input
    jal get_file_input

menu_loop:
    # Display menu options
    li $v0, 4
    la $a0, menu_prompt
    syscall
    
    # Read user choice
    li $v0, 12        # Read single character
    syscall
    move $t0, $v0     # Store input in $t0
    
    # Print newline for formatting
    li $v0, 4
    la $a0, newline
    syscall
    
    # Convert lowercase to uppercase for easier comparison
    blt $t0, 'a', check_input    # If it's already uppercase, skip conversion
    bgt $t0, 'z', check_input    # If it's not a letter, skip conversion
    sub $t0, $t0, 32             # Convert to uppercase
    
check_input:
    beq $t0, 'S', handle_screen
    beq $t0, 'F', handle_file
    beq $t0, 'E', exit_program
    
    # Invalid input
    li $v0, 4
    la $a0, invalid_msg
    syscall
    j menu_loop

handle_screen:
    # Show processing message
    li $v0, 4
    la $a0, processing_msg
    syscall
    
    # Show done message
    li $v0, 4
    la $a0, results_screen
    syscall
    
    # Call calculation functions
    jal calculate_x
    jal calculate_y
    jal calculate_z
   
    j menu_loop

handle_file:
    # Show processing message
    li $v0, 4
    la $a0, processing_msg
    syscall
    
    # Call file output functions
    jal calculate_x_file
    jal calculate_y_file
    jal calculate_z_file
    
    # Show done message
    li $v0, 4
    la $a0, results_saved
    syscall
    
    j menu_loop

exit_program:
    # Display goodbye message
    li $v0, 4
    la $a0, welcome_msg1
    syscall
    la $a0, goodbye_msg
    syscall
    la $a0, welcome_msg1
    syscall
    
    # Exit program
    li $v0, 10
    syscall                                                                                                                                                                      # System call: Executes the exit program syscall

get_file_input:                                                                                                                                                                         # Subroutine to get file input from user
    addi    $sp,                                $sp,                        -4                                                                                                          # Add immediate: Decrements stack pointer by 4 bytes to make space for one word
    sw      $ra,                                0($sp)                                                                                                                                  # Store word: Saves return address from $ra to top of stack

file_input_loop:                                                                                                                                                                        # Loop to get file input
    li      $v0,                                4                                                                                                                                       # Load immediate: Loads print string syscall code (4) into $v0
    la      $a0,                                prompt                                                                                                                                  # Load address: Loads address of prompt string into $a0
    syscall                                                                                                                                                                             # System call: Prints the prompt string

    li      $v0,                                8                                                                                                                                       # Load immediate: Loads read string syscall code (8) into $v0
    la      $a0,                                filename_buffer                                                                                                                         # Load address: Loads address of filename_buffer into $a0
    li      $a1,                                100                                                                                                                                     # Load immediate: Loads maximum string length (100) into $a1
    syscall                                                                                                                                                                             # System call: Reads user input string

    li      $t0,                                0                                                                                                                                       # Load immediate: Initializes counter $t0 to 0

newline_check:                                                                                                                                                                          # Loop to check for newline characters
    lb      $t1,                                filename_buffer($t0)                                                                                                                    # Load byte: Loads byte at index $t0 from filename_buffer into $t1
    beqz    $t1,                                end_check                                                                                                                               # Branch if equal to zero: Jumps to end_check if character is null terminator
    li      $t2,                                0x0A                                                                                                                                    # Load immediate: Loads ASCII code for newline (0x0A) into $t2
    beq     $t1,                                $t2,                        remove_newline                                                                                              # Branch if equal: Jumps to remove_newline if character is newline
    addi    $t0,                                $t0,                        1                                                                                                           # Add immediate: Increments counter $t0 by 1
    j       newline_check                                                                                                                                                               # Jump: Continues checking next character
    #########################################Remove Newline Subroutine#########################################
remove_newline:                                                                                                                                                                         # Subroutine to remove newline character
    sb      $zero,                              filename_buffer($t0)

    #########################################End Check#########################################
end_check:                                                                                                                                                                              # End of newline check
    li      $v0,                                13                                                                                                                                      # Load immediate: Loads open file syscall code (13) into $v0
    la      $a0,                                filename_buffer                                                                                                                         # Load address: Loads address of filename string into $a0
    li      $a1,                                0                                                                                                                                       # Load immediate: Loads read mode flag (0) into $a1
    li      $a2,                                0                                                                                                                                       # Load immediate: Loads mode parameter (0) into $a2
    syscall                                                                                                                                                                             # System call: Opens the file
    move    $s0,                                $v0                                                                                                                                     # Move: Copies file descriptor from $v0 to $s0

    bltz    $s0,                                file_error                                                                                                                              # Branch if less than zero: Jumps to file_error if file descriptor is negative

    li      $v0,                                14                                                                                                                                      # Load immediate: Loads read file syscall code (14) into $v0
    move    $a0,                                $s0                                                                                                                                     # Move: Copies file descriptor to $a0
    la      $a1,                                buffer                                                                                                                                  # Load address: Loads buffer address into $a1
    li      $a2,                                1024                                                                                                                                    # Load immediate: Loads maximum bytes to read (1024) into $a2
    syscall                                                                                                                                                                             # System call: Reads from file into buffer

    li      $v0,                                16                                                                                                                                      # Load immediate: Loads close file syscall code (16) into $v0
    move    $a0,                                $s0                                                                                                                                     # Move: Copies file descriptor to $a0
    syscall                                                                                                                                                                             # System call: Closes the file

    #########################################Parse Coefficients Subroutine#########################################
    jal     parse_coefficients                                                                                                                                                          # Jump and link: Jumps to parse_coefficients subroutine, saves return address

    lw      $ra,                                0($sp)                                                                                                                                  # Load word: Restores return address from stack
    addi    $sp,                                $sp,                        4                                                                                                           # Add immediate: Adjusts stack pointer back up by 4 bytes
    jr      $ra                                                                                                                                                                         # Jump register: Returns to calling function

parse_coefficients:                                                                                                                                                                     # Subroutine to parse coefficients from the buffer
    addi    $sp,                                $sp,                        -4                                                                                                          # Add immediate: Makes space on stack for return address
    sw      $ra,                                0($sp)                                                                                                                                  # Store word: Saves return address on stack

    la      $t0,                                buffer                                                                                                                                  # Load address: Loads address of input buffer into $t0
    li      $t3,                                0                                                                                                                                       # Load immediate: Initializes index to 0
    li      $t9,                                0                                                                                                                                       # Load immediate: Initializes equals sign flag to 0

parse_loop:                                                                                                                                                                             # Loop to parse coefficients
    lb      $t1,                                0($t0)                                                                                                                                  # Load byte: Loads current character from buffer into $t1
    beqz    $t1,                                print_coeffs                                                                                                                            # Branch if equal to zero: Jumps to print_coeffs if end of string
    li      $t2,                                0x0A                                                                                                                                    # Load immediate: Loads ASCII newline into $t2
    beq     $t1,                                $t2,                        reset_equals                                                                                                # Branch if equal: Jumps to reset_equals if newline found

    li      $t2,                                '='                                                                                                                                     # Load immediate: Loads ASCII equals sign into $t2
    beq     $t1,                                $t2,                        handle_equals                                                                                               # Branch if equal: Jumps to handle_equals if equals sign found

    bnez    $t9,                                check_negative_constant                                                                                                                 # Branch to new handler for constants after equals sign

    # Check if current character is a digit
    li      $t2,                                '0'                                                                                                                                     # Load immediate: ASCII '0'
    li      $t4,                                '9'                                                                                                                                     # Load immediate: ASCII '9'
    blt     $t1,                                $t2,                        check_variables                                                                                             # If not a digit, check for variables
    bgt     $t1,                                $t4,                        check_variables                                                                                             # If not a digit, check for variables

    # Store digit and check next character for variable
    move    $t5,                                $t1                                                                                                                                     # Save current digit
    addi    $t0,                                $t0,                        1                                                                                                           # Move to next character
    lb      $t1,                                0($t0)                                                                                                                                  # Load next character

    # Check which variable follows the digit
    li      $t2,                                'x'                                                                                                                                     # Load immediate: ASCII 'x'
    beq     $t1,                                $t2,                        store_x                                                                                                     # Branch if equal: Jumps to store_x if 'x' found
    li      $t2,                                'y'                                                                                                                                     # Load immediate: ASCII 'y'
    beq     $t1,                                $t2,                        store_y                                                                                                     # Branch if equal: Jumps to store_y if 'y' found
    li      $t2,                                'z'                                                                                                                                     # Load immediate: ASCII 'z'
    beq     $t1,                                $t2,                        store_z                                                                                                     # Branch if equal: Jumps to store_z if 'z' found

    # If no variable follows, move back and continue
    addi    $t0,                                $t0,                        -1                                                                                                          # Add immediate: Decrements buffer pointer by 1
    j       next_char                                                                                                                                                                   # Jump: Continues to next character

check_variables:                                                                                                                                                                        # Check for variable characters
    li      $t2,                                'x'                                                                                                                                     # Load immediate: ASCII 'x'
    beq     $t1,                                $t2,                        handle_implicit_one_x                                                                                       # Branch if equal: Jumps to handle_implicit_one_x if 'x' found
    li      $t2,                                'y'                                                                                                                                     # Load immediate: ASCII 'y'
    beq     $t1,                                $t2,                        handle_implicit_one_y                                                                                       # Branch if equal: Jumps to handle_implicit_one_y if 'y' found
    li      $t2,                                'z'                                                                                                                                     # Load immediate: ASCII 'z'
    beq     $t1,                                $t2,                        handle_implicit_one_z                                                                                       # Branch if equal: Jumps to handle_implicit_one_z if 'z' found
    j       next_char                                                                                                                                                                   # Jump: Continues to next character

    # New section to handle negative constants
check_negative_constant:                                                                                                                                                                # Check for negative constants
    li      $t2,                                '-'                                                                                                                                     # Load immediate: Load ASCII minus sign
    beq     $t1,                                $t2,                        handle_negative                                                                                             # If minus sign found, handle negative number
    j       handle_constant                                                                                                                                                             # If not minus sign, handle as regular constant

handle_negative:                                                                                                                                                                        # Handle negative constant
    lw      $t8,                                index_const                                                                                                                             # Load current constant index
    sb      $t1,                                constant_term($t8)                                                                                                                      # Store the minus sign
    addi    $t8,                                $t8,                        1                                                                                                           # Increment index
    sw      $t8,                                index_const                                                                                                                             # Save updated index
    addi    $t0,                                $t0,                        1                                                                                                           # Move to next character
    lb      $t1,                                0($t0)                                                                                                                                  # Load the next character

    # Check if next character is a digit
    li      $t2,                                '0'                                                                                                                                     # Load ASCII '0'
    li      $t4,                                '9'                                                                                                                                     # Load ASCII '9'
    blt     $t1,                                $t2,                        next_char                                                                                                   # Skip if not a digit
    bgt     $t1,                                $t4,                        next_char                                                                                                   # Skip if not a digit

    # Store the digit after the minus sign
    lw      $t8,                                index_const                                                                                                                             # Load current index
    sb      $t1,                                constant_term($t8)                                                                                                                      # Store the digit
    addi    $t8,                                $t8,                        1                                                                                                           # Increment index
    sb      $zero,                              constant_term($t8)                                                                                                                      # Store null terminator
    sw      $t8,                                index_const                                                                                                                             # Save updated index
    j       next_char                                                                                                                                                                   # Continue to next character

handle_constant:                                                                                                                                                                        # Handle regular constant
    li      $t2,                                '0'                                                                                                                                     # Load immediate: Loads ASCII value for '0' into $t2 for comparison
    li      $t4,                                '9'                                                                                                                                     # Load immediate: Loads ASCII value for '9' into $t4 for comparison
    blt     $t1,                                $t2,                        next_char                                                                                                   # Branch if less than: Skips if not a digit
    bgt     $t1,                                $t4,                        next_char                                                                                                   # Branch if greater than: Skips if not a digit

    lw      $t8,                                index_const                                                                                                                             # Load current constant index
    sb      $t1,                                constant_term($t8)                                                                                                                      # Store the digit
    addi    $t8,                                $t8,                        1                                                                                                           # Increment index
    sb      $zero,                              constant_term($t8)                                                                                                                      # Store null terminator
    sw      $t8,                                index_const                                                                                                                             # Save updated index
    j       next_char                                                                                                                                                                   # Continue to next character

handle_implicit_one_x:                                                                                                                                                                  # Handle implicit coefficient of 1 for x
    lw      $t8,                                index_x                                                                                                                                 # Load current index for x coefficients
    li      $t7,                                '1'                                                                                                                                     # Load immediate: ASCII '1'
    sb      $t7,                                coefficient_x($t8)                                                                                                                      # Store '1' in coefficient_x
    addi    $t8,                                $t8,                        1                                                                                                           # Increment index
    sb      $zero,                              coefficient_x($t8)                                                                                                                      # Add null terminator
    sw      $t8,                                index_x                                                                                                                                 # Save updated index
    j       next_char                                                                                                                                                                   # Continue to next character

handle_implicit_one_y:                                                                                                                                                                  # Handle implicit coefficient of 1 for y
    lw      $t8,                                index_y                                                                                                                                 # Load current index for y coefficients
    li      $t7,                                '1'                                                                                                                                     # Load immediate: ASCII '1'
    sb      $t7,                                coefficient_y($t8)                                                                                                                      # Store '1' in coefficient_y
    addi    $t8,                                $t8,                        1                                                                                                           # Increment index
    sb      $zero,                              coefficient_y($t8)                                                                                                                      # Add null terminator
    sw      $t8,                                index_y                                                                                                                                 # Save updated index
    j       next_char                                                                                                                                                                   # Continue to next character

handle_implicit_one_z:                                                                                                                                                                  # Handle implicit coefficient of 1 for z
    lw      $t8,                                index_z                                                                                                                                 # Load current index for z coefficients
    li      $t7,                                '1'                                                                                                                                     # Load immediate: ASCII '1'
    sb      $t7,                                coefficient_z($t8)                                                                                                                      # Store '1' in coefficient_z
    addi    $t8,                                $t8,                        1                                                                                                           # Increment index
    sb      $zero,                              coefficient_z($t8)                                                                                                                      # Add null terminator
    sw      $t8,                                index_z                                                                                                                                 # Save updated index
    j       next_char                                                                                                                                                                   # Continue to next character

store_x:                                                                                                                                                                                # Store x coefficient
    lw      $t8,                                index_x                                                                                                                                 # Load current index for x coefficients
    sb      $t5,                                coefficient_x($t8)                                                                                                                      # Store the digit in coefficient_x
    addi    $t8,                                $t8,                        1                                                                                                           # Increment index
    sb      $zero,                              coefficient_x($t8)                                                                                                                      # Add null terminator
    sw      $t8,                                index_x                                                                                                                                 # Save updated index
    j       next_char                                                                                                                                                                   # Continue to next character

store_y:                                                                                                                                                                                # Store y coefficient
    lw      $t8,                                index_y                                                                                                                                 # Load current index for y coefficients
    sb      $t5,                                coefficient_y($t8)                                                                                                                      # Store the digit in coefficient_y
    addi    $t8,                                $t8,                        1                                                                                                           # Increment index
    sb      $zero,                              coefficient_y($t8)                                                                                                                      # Add null terminator
    sw      $t8,                                index_y                                                                                                                                 # Save updated index
    j       next_char                                                                                                                                                                   # Continue to next character

store_z:                                                                                                                                                                                # Store z coefficient
    lw      $t8,                                index_z                                                                                                                                 # Load current index for z coefficients
    sb      $t5,                                coefficient_z($t8)                                                                                                                      # Store the digit in coefficient_z
    addi    $t8,                                $t8,                        1                                                                                                           # Increment index
    sb      $zero,                              coefficient_z($t8)                                                                                                                      # Add null terminator
    sw      $t8,                                index_z                                                                                                                                 # Save updated index
    j       next_char                                                                                                                                                                   # Continue to next character

handle_equals:                                                                                                                                                                          # Handle equals sign
    li      $t9,                                1                                                                                                                                       # Load immediate: Loads value 1 into $t9 register to set flag indicating equals sign was found
    j       next_char                                                                                                                                                                   # Jump: Unconditionally jumps to next_char label to process next character

reset_equals:                                                                                                                                                                           # Reset equals sign flag
    li      $t9,                                0                                                                                                                                       # Load immediate: Loads 0 into $t9 to reset equals sign flag
    addi    $t0,                                $t0,                        1                                                                                                           # Add immediate: Increments buffer pointer by 1 to skip newline
    j       parse_loop                                                                                                                                                                  # Jump: Returns to main parsing loop

next_char:                                                                                                                                                                              # Move to the next character
    addi    $t0,                                $t0,                        1                                                                                                           # Add immediate: Increments buffer pointer by 1 to move to next character
    j       parse_loop                                                                                                                                                                  # Jump: Returns to main parsing loop

    #########################################Print Coefficients Subroutine#########################################
print_coeffs:                                                                                                                                                                           # Subroutine to print coefficients
    li      $v0,                                4                                                                                                                                       # Load immediate: Loads syscall code 4 (print string) into $v0
    la      $a0,                                x_coeff_output                                                                                                                          # Load address: Loads address of x coefficient output string into $a0
    syscall                                                                                                                                                                             # System call: Prints the x coefficient label

    li      $t0,                                0                                                                                                                                       # Load immediate: Initializes counter $t0 to 0

print_x_loop:                                                                                                                                                                           # Loop to print x coefficients
    lb      $t1,                                coefficient_x($t0)                                                                                                                      # Load byte: Loads byte from coefficient_x array at index $t0 into $t1
    beqz    $t1,                                done_x                                                                                                                                  # Branch if equal to zero: Jumps to done_x if null terminator found
    li      $v0,                                11                                                                                                                                      # Load immediate: Loads syscall code 11 (print character) into $v0
    move    $a0,                                $t1                                                                                                                                     # Move: Copies character from $t1 to $a0 for printing
    syscall                                                                                                                                                                             # System call: Prints the character
    li      $v0,                                4                                                                                                                                       # Load immediate: Loads syscall code 4 (print string) into $v0
    la      $a0,                                space                                                                                                                                   # Load address: Loads address of space string into $a0
    syscall                                                                                                                                                                             # System call: Prints a space
    addi    $t0,                                $t0,                        1                                                                                                           # Add immediate: Increments counter by 1
    j       print_x_loop                                                                                                                                                                # Jump: Continues printing loop

done_x:                                                                                                                                                                                 # End of x printing
    li      $v0,                                4                                                                                                                                       # Load immediate: Loads syscall code 4 (print string) into $v0
    la      $a0,                                newline                                                                                                                                 # Load address: Loads address of newline string into $a0
    syscall                                                                                                                                                                             # System call: Prints newline character
    # Print y coefficients
    li      $v0,                                4                                                                                                                                       # Load immediate: Loads syscall code 4 (print string) into $v0
    la      $a0,                                y_coeff_output                                                                                                                          # Load address: Loads address of y coefficient output string into $a0
    syscall                                                                                                                                                                             # System call: Prints the y coefficient label

    li      $t0,                                0                                                                                                                                       # Load immediate: Initializes counter $t0 to 0

print_y_loop:                                                                                                                                                                           # Loop to print y coefficients
    lb      $t1,                                coefficient_y($t0)                                                                                                                      # Load byte: Loads byte from coefficient_y array at index $t0 into $t1
    beqz    $t1,                                done_y                                                                                                                                  # Branch if equal to zero: Jumps to done_y if null terminator found
    li      $v0,                                11                                                                                                                                      # Load immediate: Loads syscall code 11 (print character) into $v0
    move    $a0,                                $t1                                                                                                                                     # Move: Copies character from $t1 to $a0 for printing
    syscall                                                                                                                                                                             # System call: Prints the character
    li      $v0,                                4                                                                                                                                       # Load immediate: Loads syscall code 4 (print string) into $v0
    la      $a0,                                space                                                                                                                                   # Load address: Loads address of space string into $a0
    syscall                                                                                                                                                                             # System call: Prints a space
    addi    $t0,                                $t0,                        1                                                                                                           # Add immediate: Increments counter by 1
    j       print_y_loop                                                                                                                                                                # Jump: Continues printing loop

done_y:                                                                                                                                                                                 # End of y printing
    li      $v0,                                4                                                                                                                                       # Load immediate: Loads syscall code 4 (print string) into $v0
    la      $a0,                                newline                                                                                                                                 # Load address: Loads address of newline string into $a0
    syscall                                                                                                                                                                             # System call: Prints newline character

    li      $v0,                                4                                                                                                                                       # Load immediate: Loads syscall code 4 (print string) into $v0
    la      $a0,                                z_coeff_output                                                                                                                          # Load address: Loads address of z coefficient output string into $a0
    syscall                                                                                                                                                                             # System call: Prints the z coefficient label
    li      $t0,                                0                                                                                                                                       # Load immediate: Initializes counter $t0 to 0

print_z_loop:                                                                                                                                                                           # Loop to print z coefficients
    lb      $t1,                                coefficient_z($t0)                                                                                                                      # Load byte: Loads byte from coefficient_z array at index $t0 into $t1
    beqz    $t1,                                done_z                                                                                                                                  # Branch if equal to zero: Jumps to done_z if null terminator found
    li      $v0,                                11                                                                                                                                      # Load immediate: Loads syscall code 11 (print character) into $v0
    move    $a0,                                $t1                                                                                                                                     # Move: Copies character from $t1 to $a0 for printing
    syscall                                                                                                                                                                             # System call: Prints the character
    li      $v0,                                4                                                                                                                                       # Load immediate: Loads syscall code 4 (print string) into $v0
    la      $a0,                                space                                                                                                                                   # Load address: Loads address of space string into $a0
    syscall                                                                                                                                                                             # System call: Prints a space
    addi    $t0,                                $t0,                        1                                                                                                           # Add immediate: Increments counter by 1
    j       print_z_loop                                                                                                                                                                # Jump: Continues printing loop

done_z:                                                                                                                                                                                 # End of z printing
    li      $v0,                                4                                                                                                                                       # Load immediate: Loads syscall code 4 (print string) into $v0
    la      $a0,                                newline                                                                                                                                 # Load address: Loads address of newline string into $a0
    syscall                                                                                                                                                                             # System call: Prints newline character

    li      $v0,                                4                                                                                                                                       # Load immediate: Loads syscall code 4 (print string) into $v0
    la      $a0,                                constant_output                                                                                                                         # Load address: Loads address of constant output string into $a0
    syscall                                                                                                                                                                             # System call: Prints the constant term label

    li      $t0,                                0                                                                                                                                       # Load immediate: Initializes counter $t0 to 0

print_constant_loop:                                                                                                                                                                    # Loop to print constant terms
    lb      $t1,                                constant_term($t0)                                                                                                                      # Load byte: Loads byte from constant_term array at index $t0 into $t1
    beqz    $t1,                                end_print                                                                                                                               # Branch if equal to zero: Jumps to end_print if null terminator found
    li      $v0,                                11                                                                                                                                      # Load immediate: Loads syscall code 11 (print character) into $v0
    move    $a0,                                $t1                                                                                                                                     # Move: Copies character from $t1 to $a0 for printing
    syscall                                                                                                                                                                             # System call: Prints the character
    li      $v0,                                4                                                                                                                                       # Load immediate: Loads syscall code 4 (print string) into $v0
    la      $a0,                                space                                                                                                                                   # Load address: Loads address of space string into $a0
    syscall                                                                                                                                                                             # System call: Prints a space
    addi    $t0,                                $t0,                        1                                                                                                           # Add immediate: Increments counter by 1
    j       print_constant_loop                                                                                                                                                         # Jump: Continues printing loop

end_print:                                                                                                                                                                              # End of constant printing
    li      $v0,                                4                                                                                                                                       # Load immediate: Loads syscall code 4 (print string) into $v0
    la      $a0,                                newline                                                                                                                                 # Load address: Loads address of newline string into $a0
    syscall                                                                                                                                                                             # System call: Prints newline character

    lw      $ra,                                0($sp)                                                                                                                                  # Load word: Restores return address from stack
    addi    $sp,                                $sp,                        4                                                                                                           # Add immediate: Adjusts stack pointer to deallocate space
    jr      $ra                                                                                                                                                                         # Jump register: Returns to calling function

    #########################################Store Coefficients and Constants Subroutine#########################################
store_coefficients_and_constants:                                                                                                                                                       # Subroutine to store coefficients and constants
    addi    $sp,                                $sp,                        -4                                                                                                          # Add immediate: Makes space on stack for return address
    sw      $ra,                                0($sp)                                                                                                                                  # Store word: Saves return address on stack

    # [Previous coefficient code remains unchanged - x, y, z coefficients]
    la      $t7,                                coefficient_x                                                                                                                           # Load address: Loads address of coefficient_x into $t7
    lb      $t1,                                0($t7)                                                                                                                                  # Load byte: Loads first byte from coefficient_x into $t1
    subi    $t1,                                $t1,                        48                                                                                                          # Subtract immediate: Converts ASCII to integer
    sw      $t1,                                matrix_a                                                                                                                                # Store word: Saves value to matrix_a

    lb      $t1,                                1($t7)                                                                                                                                  # Load byte: Loads second byte from coefficient_x into $t1
    subi    $t1,                                $t1,                        48                                                                                                          # Subtract immediate: Converts ASCII to integer
    sw      $t1,                                matrix_d                                                                                                                                # Store word: Saves value to matrix_d

    lb      $t1,                                2($t7)                                                                                                                                  # Load byte: Loads third byte from coefficient_x into $t1
    subi    $t1,                                $t1,                        48                                                                                                          # Subtract immediate: Converts ASCII to integer
    sw      $t1,                                matrix_g                                                                                                                                # Store word: Saves value to matrix_g

    la      $t7,                                coefficient_y                                                                                                                           # Load address: Loads address of coefficient_y into $t7
    lb      $t1,                                0($t7)                                                                                                                                  # Load byte: Loads first byte from coefficient_y into $t1
    subi    $t1,                                $t1,                        48                                                                                                          # Subtract immediate: Converts ASCII to integer
    sw      $t1,                                matrix_b                                                                                                                                # Store word: Saves value to matrix_b

    lb      $t1,                                1($t7)                                                                                                                                  # Load byte: Loads second byte from coefficient_y into $t1
    subi    $t1,                                $t1,                        48                                                                                                          # Subtract immediate: Converts ASCII to integer
    sw      $t1,                                matrix_e                                                                                                                                # Store word: Saves value to matrix_e

    lb      $t1,                                2($t7)                                                                                                                                  # Load byte: Loads third byte from coefficient_y into $t1
    subi    $t1,                                $t1,                        48                                                                                                          # Subtract immediate: Converts ASCII to integer
    sw      $t1,                                matrix_h                                                                                                                                # Store word: Saves value to matrix_h

    la      $t7,                                coefficient_z                                                                                                                           # Load address: Loads address of coefficient_z into $t7
    lb      $t1,                                0($t7)                                                                                                                                  # Load byte: Loads first byte from coefficient_z into $t1
    subi    $t1,                                $t1,                        48                                                                                                          # Subtract immediate: Converts ASCII to integer
    sw      $t1,                                matrix_c                                                                                                                                # Store word: Saves value to matrix_c

    lb      $t1,                                1($t7)                                                                                                                                  # Load byte: Loads second byte from coefficient_z into $t1
    subi    $t1,                                $t1,                        48                                                                                                          # Subtract immediate: Converts ASCII to integer
    sw      $t1,                                matrix_f                                                                                                                                # Store word: Saves value to matrix_f

    lb      $t1,                                2($t7)                                                                                                                                  # Load byte: Loads third byte from coefficient_z into $t1
    subi    $t1,                                $t1,                        48                                                                                                          # Subtract immediate: Converts ASCII to integer
    sw      $t1,                                matrix_i                                                                                                                                # Store word: Saves value to matrix_i

    # Handle constants
    la      $t7,                                constant_term                                                                                                                           # Load address: Loads address of constant_term into $t7

    # First constant
    lb      $t1,                                0($t7)                                                                                                                                  # Load byte: Loads first byte from constant_term into $t1
    li      $t2,                                '-'                                                                                                                                     # Load immediate: Load ASCII minus sign
    bne     $t1,                                $t2,                        store_const1                                                                                                # Branch if not equal: Jumps to store_const1 if not a negative constant
    # Handle negative first constant
    lb      $t1,                                1($t7)                                                                                                                                  # Load byte: Loads second byte from constant_term into $t1
    subi    $t1,                                $t1,                        48                                                                                                          # Subtract immediate: Converts ASCII to integer
    neg     $t1,                                $t1                                                                                                                                     # Negate: Makes the value negative
    addi    $t7,                                $t7,                        1                                                                                                           # Add immediate: Skip the minus sign for next read
    j       save_const1                                                                                                                                                                 # Jump: Jumps to save_const1

store_const1:                                                                                                                                                                           # Store first constant
    subi    $t1,                                $t1,                        48                                                                                                          # Subtract immediate: Converts ASCII to integer

save_const1:                                                                                                                                                                            # Save first constant
    sw      $t1,                                constant_term_1                                                                                                                         # Store word: Saves value to constant_term_1
    addi    $t7,                                $t7,                        1                                                                                                           # Add immediate: Move to next character

    # Second constant
    lb      $t1,                                0($t7)                                                                                                                                  # Load byte: Loads first byte from constant_term into $t1
    li      $t2,                                '-'                                                                                                                                     # Load immediate: Load ASCII minus sign
    bne     $t1,                                $t2,                        store_const2                                                                                                # Branch if not equal: Jumps to store_const2 if not a negative constant
    # Handle negative second constant
    lb      $t1,                                1($t7)                                                                                                                                  # Load byte: Loads second byte from constant_term into $t1
    subi    $t1,                                $t1,                        48                                                                                                          # Subtract immediate: Converts ASCII to integer
    neg     $t1,                                $t1                                                                                                                                     # Negate: Makes the value negative
    addi    $t7,                                $t7,                        1                                                                                                           # Add immediate: Skip the minus sign for next read
    j       save_const2                                                                                                                                                                 # Jump: Jumps to save_const2

store_const2:                                                                                                                                                                           # Store second constant
    subi    $t1,                                $t1,                        48                                                                                                          # Subtract immediate: Converts ASCII to integer

save_const2:                                                                                                                                                                            # Save second constant
    sw      $t1,                                constant_term_2                                                                                                                         # Store word: Saves value to constant_term_2
    addi    $t7,                                $t7,                        1                                                                                                           # Add immediate: Move to next character

    # Third constant
    lb      $t1,                                0($t7)                                                                                                                                  # Load byte: Loads first byte from constant_term into $t1
    li      $t2,                                '-'                                                                                                                                     # Load immediate: Load ASCII minus sign
    bne     $t1,                                $t2,                        store_const3                                                                                                # Branch if not equal: Jumps to store_const3 if not a negative constant
    # Handle negative third constant
    lb      $t1,                                1($t7)                                                                                                                                  # Load byte: Loads second byte from constant_term into $t1
    subi    $t1,                                $t1,                        48                                                                                                          # Subtract immediate: Converts ASCII to integer
    neg     $t1,                                $t1                                                                                                                                     # Negate: Makes the value negative
    j       save_const3                                                                                                                                                                 # Jump: Jumps to save_const3

store_const3:                                                                                                                                                                           # Store third constant
    subi    $t1,                                $t1,                        48                                                                                                          # Subtract immediate: Converts ASCII to integer

save_const3:                                                                                                                                                                            # Save third constant
    sw      $t1,                                constant_term_3                                                                                                                         # Store word: Saves value to constant_term_3
    jr      $ra                                                                                                                                                                      # Return to caller

    #########################################Calculate Determinant Subroutine#########################################
calculate_determinant:                                                                                                                                                                  # Subroutine to calculate the determinant
    addi    $sp,                                $sp,                        -4                                                                                                          # Instruction: Add Immediate - Subtracts 4 from stack pointer to allocate space for return address
    sw      $ra,                                0($sp)                                                                                                                                  # Instruction: Store Word - Saves return address to stack (word)

    jal     store_coefficients_and_constants                                                                                                                                            # Instruction: Jump and Link - Calls store_coefficients_and_constants subroutine, saves return address

    # Load matrix values
    lw      $t1,                                matrix_a                                                                                                                                # Instruction: Load Word - Loads value from matrix_a into $t1 (word)
    lw      $t2,                                matrix_b                                                                                                                                # Instruction: Load Word - Loads value from matrix_b into $t2 (word)
    lw      $t3,                                matrix_c                                                                                                                                # Instruction: Load Word - Loads value from matrix_c into $t3 (word)
    lw      $t4,                                matrix_d                                                                                                                                # Instruction: Load Word - Loads value from matrix_d into $t4 (word)
    lw      $t5,                                matrix_e                                                                                                                                # Instruction: Load Word - Loads value from matrix_e into $t5 (word)
    lw      $t6,                                matrix_f                                                                                                                                # Instruction: Load Word - Loads value from matrix_f into $t6 (word)
    lw      $t7,                                matrix_g                                                                                                                                # Instruction: Load Word - Loads value from matrix_g into $t7 (word)
    lw      $t8,                                matrix_h                                                                                                                                # Instruction: Load Word - Loads value from matrix_h into $t8 (word)
    lw      $t9,                                matrix_i                                                                                                                                # Instruction: Load Word - Loads value from matrix_i into $t9 (word)

    # Calculate (ei - fh)
    mul     $s0,                                $t5,                        $t9                                                                                                         # Instruction: Multiply - Multiplies e and i, stores result in $s0
    mul     $s1,                                $t6,                        $t8                                                                                                         # Instruction: Multiply - Multiplies f and h, stores result in $s1
    sub     $s2,                                $s0,                        $s1                                                                                                         # Instruction: Subtract - Subtracts fh from ei, stores result in $s2

    # Calculate (di - fg)
    mul     $s3,                                $t4,                        $t9                                                                                                         # Instruction: Multiply - Multiplies d and i, stores result in $s3
    mul     $s4,                                $t6,                        $t7                                                                                                         # Instruction: Multiply - Multiplies f and g, stores result in $s4
    sub     $s5,                                $s3,                        $s4                                                                                                         # Instruction: Subtract - Subtracts fg from di, stores result in $s5

    # Calculate (dh - eg)
    mul     $s6,                                $t4,                        $t8                                                                                                         # Instruction: Multiply - Multiplies d and h, stores result in $s6
    mul     $s7,                                $t5,                        $t7                                                                                                         # Instruction: Multiply - Multiplies e and g, stores result in $s7
    sub     $t0,                                $s6,                        $s7                                                                                                         # Instruction: Subtract - Subtracts eg from dh, stores result in $t0

    # Final determinant calculation
    mul     $s0,                                $t1,                        $s2                                                                                                         # Instruction: Multiply - Multiplies a by (ei-fh), stores in $s0
    mul     $s1,                                $t2,                        $s5                                                                                                         # Instruction: Multiply - Multiplies b by (di-fg), stores in $s1
    mul     $s2,                                $t3,                        $t0                                                                                                         # Instruction: Multiply - Multiplies c by (dh-eg), stores in $s2

    sub     $s3,                                $s0,                        $s1                                                                                                         # Instruction: Subtract - Subtracts b(di-fg) from a(ei-fh)
    add     $s4,                                $s3,                        $s2                                                                                                         # Instruction: Add - Adds c(dh-eg) to complete determinant calculation

    # Restore return address and return
    lw      $ra,                                0($sp)                                                                                                                                  # Instruction: Load Word - Restores return address from stack (word)
    addi    $sp,                                $sp,                        4                                                                                                           # Instruction: Add Immediate - Adds 4 to stack pointer to deallocate stack space
    jr      $ra                                                                                                                                                                         # Instruction: Jump Register - Returns to calling function

    #########################################Calculate X Subroutine#########################################
calculate_x:                                                                                                                                                                            # Subroutine to calculate x
    # Save return address and any registers we'll use
    addi    $sp,                                $sp,                        -24                                                                                                         # Add immediate: Decrements stack pointer by 24 bytes to make space for saved registers
    sw      $ra,                                0($sp)                                                                                                                                  # Store word: Saves return address to stack
    sw      $s0,                                4($sp)                                                                                                                                  # Store word: Saves $s0 register to stack
    sw      $s1,                                8($sp)                                                                                                                                  # Store word: Saves $s1 register to stack
    sw      $s2,                                12($sp)                                                                                                                                 # Store word: Saves $s2 register to stack
    sw      $s3,                                16($sp)                                                                                                                                 # Store word: Saves $s3 register to stack
    sw      $s4,                                20($sp)                                                                                                                                 # Store word: Saves $s4 register to stack

    # First calculate original determinant (D)
    jal     calculate_determinant                                                                                                                                                       # Jump and link: Calls calculate_determinant subroutine, saves return address
    move    $s2,                                $s4                                                                                                                                     # Move: Saves original determinant in $s2

    # Copy all original matrix values to temp matrix
    lw      $t0,                                matrix_b                                                                                                                                # Load word: Loads value from matrix_b into $t0
    sw      $t0,                                temp_matrix_b                                                                                                                           # Store word: Saves value to temp_matrix_b
    lw      $t0,                                matrix_c                                                                                                                                # Load word: Loads value from matrix_c into $t0
    sw      $t0,                                temp_matrix_c                                                                                                                           # Store word: Saves value to temp_matrix_c
    lw      $t0,                                matrix_e                                                                                                                                # Load word: Loads value from matrix_e into $t0
    sw      $t0,                                temp_matrix_e                                                                                                                           # Store word: Saves value to temp_matrix_e
    lw      $t0,                                matrix_f                                                                                                                                # Load word: Loads value from matrix_f into $t0
    sw      $t0,                                temp_matrix_f                                                                                                                           # Store word: Saves value to temp_matrix_f
    lw      $t0,                                matrix_h                                                                                                                                # Load word: Loads value from matrix_h into $t0
    sw      $t0,                                temp_matrix_h                                                                                                                           # Store word: Saves value to temp_matrix_h
    lw      $t0,                                matrix_i                                                                                                                                # Load word: Loads value from matrix_i into $t0
    sw      $t0,                                temp_matrix_i                                                                                                                           # Store word: Saves value to temp_matrix_i

    # Replace first column with constants
    lw      $t0,                                constant_term_1                                                                                                                         # Load word: Loads first constant term into $t0
    sw      $t0,                                temp_matrix_a                                                                                                                           # Store word: Saves value to temp_matrix_a
    lw      $t0,                                constant_term_2                                                                                                                         # Load word: Loads second constant term into $t0
    sw      $t0,                                temp_matrix_d                                                                                                                           # Store word: Saves value to temp_matrix_d
    lw      $t0,                                constant_term_3                                                                                                                         # Load word: Loads third constant term into $t0
    sw      $t0,                                temp_matrix_g                                                                                                                           # Store word: Saves value to temp_matrix_g

    # Calculate Dx using temp matrix
    # First term: a(ei-fh)
    lw      $t5,                                temp_matrix_e                                                                                                                           # Load word: Loads value from temp_matrix_e into $t5 (e)
    lw      $t9,                                temp_matrix_i                                                                                                                           # Load word: Loads value from temp_matrix_i into $t9 (i)
    mul     $s0,                                $t5,                        $t9                                                                                                         # Multiply: Calculates ei and stores in $s0
    lw      $t6,                                temp_matrix_f                                                                                                                           # Load word: Loads value from temp_matrix_f into $t6 (f)
    lw      $t8,                                temp_matrix_h                                                                                                                           # Load word: Loads value from temp_matrix_h into $t8 (h)
    mul     $s1,                                $t6,                        $t8                                                                                                         # Multiply: Calculates fh and stores in $s1
    sub     $s0,                                $s0,                        $s1                                                                                                         # Subtract: Calculates ei - fh and stores in $s0
    lw      $t1,                                temp_matrix_a                                                                                                                           # Load word: Loads value from temp_matrix_a into $t1 (a)
    mul     $s0,                                $t1,                        $s0                                                                                                         # Multiply: Calculates a(ei-fh) and stores in $s0

    # Second term: b(di-fg)
    lw      $t4,                                temp_matrix_d                                                                                                                           # Load word: Loads value from temp_matrix_d into $t4 (d)
    mul     $s1,                                $t4,                        $t9                                                                                                         # Multiply: Calculates di and stores in $s1
    lw      $t7,                                temp_matrix_g                                                                                                                           # Load word: Loads value from temp_matrix_g into $t7 (g)
    mul     $s3,                                $t6,                        $t7                                                                                                         # Multiply: Calculates fg and stores in $s3
    sub     $s1,                                $s1,                        $s3                                                                                                         # Subtract: Calculates di - fg and stores in $s1
    lw      $t2,                                temp_matrix_b                                                                                                                           # Load word: Loads value from temp_matrix_b into $t2 (b)
    mul     $s1,                                $t2,                        $s1                                                                                                         # Multiply: Calculates b(di-fg) and stores in $s1

    # Third term: c(dh-eg)
    mul     $s3,                                $t4,                        $t8                                                                                                         # Multiply: Calculates dh and stores in $s3
    mul     $s4,                                $t5,                        $t7                                                                                                         # Multiply: Calculates eg and stores in $s4
    sub     $s3,                                $s3,                        $s4                                                                                                         # Subtract: Calculates dh - eg and stores in $s3
    lw      $t3,                                temp_matrix_c                                                                                                                           # Load word: Loads value from temp_matrix_c into $t3 (c)
    mul     $s3,                                $t3,                        $s3                                                                                                         # Multiply: Calculates c(dh-eg) and stores in $s3

    # Final Dx calculation: a(ei-fh) - b(di-fg) + c(dh-eg)
    sub     $s4,                                $s0,                        $s1                                                                                                         # Subtract: Calculates a(ei-fh) - b(di-fg) and stores in $s4
    add     $s4,                                $s4,                        $s3                                                                                                         # Add: Calculates final Dx value and stores in $s4
    move    $s1,                                $s4                                                                                                                                     # Move: Saves Dx value in $s1

    # Check for division by zero
    beqz    $s2,                                division_by_zero                                                                                                                        # Branch if equal to zero: Jumps to division_by_zero if original determinant is zero

    # Convert to float and divide
    mtc1    $s1,                                $f2                                                                                                                                     # Move to coprocessor: Moves Dx value to floating-point register $f2
    cvt.s.w $f2,                                $f2                                                                                                                                     # Convert: Converts integer in $f2 to single precision float
    mtc1    $s2,                                $f4                                                                                                                                     # Move to coprocessor: Moves original determinant value to floating-point register $f4
    cvt.s.w $f4,                                $f4                                                                                                                                     # Convert: Converts integer in $f4 to single precision float

    # Calculate x = Dx/D
    div.s   $f12,                               $f2,                        $f4                                                                                                         # Divide: Divides Dx by D and stores result in $f12

    # Print result
    li      $v0,                                4                                                                                                                                       # Load immediate: Loads syscall code 4 (print string) into $v0
    la      $a0,                                x_output                                                                                                                                # Load address: Loads address of x_output string into $a0
    syscall                                                                                                                                                                             # System call: Prints x output label
    li      $v0,                                2                                                                                                                                       # Load immediate: Loads syscall code 2 (print float) into $v0
    syscall                                                                                                                                                                             # System call: Prints x value
    li      $v0,                                4                                                                                                                                       # Load immediate: Loads syscall code 4 (print string) into $v0
    la      $a0,                                newline                                                                                                                                 # Load address: Loads address of newline string into $a0
    syscall                                                                                                                                                                             # System call: Prints newline character

    #jal     print_x_to_file                                                                                                                                                             # Jump and link: Calls print_x_to_file subroutine
    j       exit_x_calculation                                                                                                                                                          # Jump: Jumps to exit_x_calculation

division_by_zero:                                                                                                                                                                       # Handle division by zero case
    li      $v0,                                4                                                                                                                                       # Load immediate: Loads syscall code 4 (print string) into $v0
    la      $a0,                                div_zero_msg                                                                                                                            # Load address: Loads address of div_zero_msg string into $a0
    syscall                                                                                                                                                                             # System call: Prints division by zero error message

exit_x_calculation:                                                                                                                                                                     # Exit point for x calculation
    # Restore registers
    lw      $ra,                                0($sp)                                                                                                                                  # Load word: Restores return address from stack
    lw      $s0,                                4($sp)                                                                                                                                  # Load word: Restores $s0 register from stack
    lw      $s1,                                8($sp)                                                                                                                                  # Load word: Restores $s1 register from stack
    lw      $s2,                                12($sp)                                                                                                                                 # Load word: Restores $s2 register from stack
    lw      $s3,                                16($sp)                                                                                                                                 # Load word: Restores $s3 register from stack
    lw      $s4,                                20($sp)                                                                                                                                 # Load word: Restores $s4 register from stack
    addi    $sp,                                $sp,                        24                                                                                                          # Add immediate: Adjusts stack pointer back up by 24 bytes
    jr      $ra                                                                                                                                                                         # Jump register: Returns to calling function


#Calculate X for file 
calculate_x_file:                                                                                                                                                                            # Subroutine to calculate x
    # Save return address and any registers we'll use
    addi    $sp,                                $sp,                        -24                                                                                                         # Add immediate: Decrements stack pointer by 24 bytes to make space for saved registers
    sw      $ra,                                0($sp)                                                                                                                                  # Store word: Saves return address to stack
    sw      $s0,                                4($sp)                                                                                                                                  # Store word: Saves $s0 register to stack
    sw      $s1,                                8($sp)                                                                                                                                  # Store word: Saves $s1 register to stack
    sw      $s2,                                12($sp)                                                                                                                                 # Store word: Saves $s2 register to stack
    sw      $s3,                                16($sp)                                                                                                                                 # Store word: Saves $s3 register to stack
    sw      $s4,                                20($sp)                                                                                                                                 # Store word: Saves $s4 register to stack

    # First calculate original determinant (D)
    jal     calculate_determinant                                                                                                                                                       # Jump and link: Calls calculate_determinant subroutine, saves return address
    move    $s2,                                $s4                                                                                                                                     # Move: Saves original determinant in $s2

    # Copy all original matrix values to temp matrix
    lw      $t0,                                matrix_b                                                                                                                                # Load word: Loads value from matrix_b into $t0
    sw      $t0,                                temp_matrix_b                                                                                                                           # Store word: Saves value to temp_matrix_b
    lw      $t0,                                matrix_c                                                                                                                                # Load word: Loads value from matrix_c into $t0
    sw      $t0,                                temp_matrix_c                                                                                                                           # Store word: Saves value to temp_matrix_c
    lw      $t0,                                matrix_e                                                                                                                                # Load word: Loads value from matrix_e into $t0
    sw      $t0,                                temp_matrix_e                                                                                                                           # Store word: Saves value to temp_matrix_e
    lw      $t0,                                matrix_f                                                                                                                                # Load word: Loads value from matrix_f into $t0
    sw      $t0,                                temp_matrix_f                                                                                                                           # Store word: Saves value to temp_matrix_f
    lw      $t0,                                matrix_h                                                                                                                                # Load word: Loads value from matrix_h into $t0
    sw      $t0,                                temp_matrix_h                                                                                                                           # Store word: Saves value to temp_matrix_h
    lw      $t0,                                matrix_i                                                                                                                                # Load word: Loads value from matrix_i into $t0
    sw      $t0,                                temp_matrix_i                                                                                                                           # Store word: Saves value to temp_matrix_i

    # Replace first column with constants
    lw      $t0,                                constant_term_1                                                                                                                         # Load word: Loads first constant term into $t0
    sw      $t0,                                temp_matrix_a                                                                                                                           # Store word: Saves value to temp_matrix_a
    lw      $t0,                                constant_term_2                                                                                                                         # Load word: Loads second constant term into $t0
    sw      $t0,                                temp_matrix_d                                                                                                                           # Store word: Saves value to temp_matrix_d
    lw      $t0,                                constant_term_3                                                                                                                         # Load word: Loads third constant term into $t0
    sw      $t0,                                temp_matrix_g                                                                                                                           # Store word: Saves value to temp_matrix_g

    # Calculate Dx using temp matrix
    # First term: a(ei-fh)
    lw      $t5,                                temp_matrix_e                                                                                                                           # Load word: Loads value from temp_matrix_e into $t5 (e)
    lw      $t9,                                temp_matrix_i                                                                                                                           # Load word: Loads value from temp_matrix_i into $t9 (i)
    mul     $s0,                                $t5,                        $t9                                                                                                         # Multiply: Calculates ei and stores in $s0
    lw      $t6,                                temp_matrix_f                                                                                                                           # Load word: Loads value from temp_matrix_f into $t6 (f)
    lw      $t8,                                temp_matrix_h                                                                                                                           # Load word: Loads value from temp_matrix_h into $t8 (h)
    mul     $s1,                                $t6,                        $t8                                                                                                         # Multiply: Calculates fh and stores in $s1
    sub     $s0,                                $s0,                        $s1                                                                                                         # Subtract: Calculates ei - fh and stores in $s0
    lw      $t1,                                temp_matrix_a                                                                                                                           # Load word: Loads value from temp_matrix_a into $t1 (a)
    mul     $s0,                                $t1,                        $s0                                                                                                         # Multiply: Calculates a(ei-fh) and stores in $s0

    # Second term: b(di-fg)
    lw      $t4,                                temp_matrix_d                                                                                                                           # Load word: Loads value from temp_matrix_d into $t4 (d)
    mul     $s1,                                $t4,                        $t9                                                                                                         # Multiply: Calculates di and stores in $s1
    lw      $t7,                                temp_matrix_g                                                                                                                           # Load word: Loads value from temp_matrix_g into $t7 (g)
    mul     $s3,                                $t6,                        $t7                                                                                                         # Multiply: Calculates fg and stores in $s3
    sub     $s1,                                $s1,                        $s3                                                                                                         # Subtract: Calculates di - fg and stores in $s1
    lw      $t2,                                temp_matrix_b                                                                                                                           # Load word: Loads value from temp_matrix_b into $t2 (b)
    mul     $s1,                                $t2,                        $s1                                                                                                         # Multiply: Calculates b(di-fg) and stores in $s1

    # Third term: c(dh-eg)
    mul     $s3,                                $t4,                        $t8                                                                                                         # Multiply: Calculates dh and stores in $s3
    mul     $s4,                                $t5,                        $t7                                                                                                         # Multiply: Calculates eg and stores in $s4
    sub     $s3,                                $s3,                        $s4                                                                                                         # Subtract: Calculates dh - eg and stores in $s3
    lw      $t3,                                temp_matrix_c                                                                                                                           # Load word: Loads value from temp_matrix_c into $t3 (c)
    mul     $s3,                                $t3,                        $s3                                                                                                         # Multiply: Calculates c(dh-eg) and stores in $s3

    # Final Dx calculation: a(ei-fh) - b(di-fg) + c(dh-eg)
    sub     $s4,                                $s0,                        $s1                                                                                                         # Subtract: Calculates a(ei-fh) - b(di-fg) and stores in $s4
    add     $s4,                                $s4,                        $s3                                                                                                         # Add: Calculates final Dx value and stores in $s4
    move    $s1,                                $s4                                                                                                                                     # Move: Saves Dx value in $s1

    # Check for division by zero
    beqz    $s2,                                division_by_zero_file                                                                                                                        # Branch if equal to zero: Jumps to division_by_zero if original determinant is zero

    # Convert to float and divide
    mtc1    $s1,                                $f2                                                                                                                                     # Move to coprocessor: Moves Dx value to floating-point register $f2
    cvt.s.w $f2,                                $f2                                                                                                                                     # Convert: Converts integer in $f2 to single precision float
    mtc1    $s2,                                $f4                                                                                                                                     # Move to coprocessor: Moves original determinant value to floating-point register $f4
    cvt.s.w $f4,                                $f4                                                                                                                                     # Convert: Converts integer in $f4 to single precision float

    # Calculate x = Dx/D
    div.s   $f12,                               $f2,                        $f4                                                                                                         # Divide: Divides Dx by D and stores result in $f12

    jal     print_x_to_file                                                                                                                                                             # Jump and link: Calls print_x_to_file subroutine
    j       exit_x_calculation_file                                                                                                                                                         # Jump: Jumps to exit_x_calculation

division_by_zero_file:                                                                                                                                                                       # Handle division by zero case
    li      $v0,                                4                                                                                                                                       # Load immediate: Loads syscall code 4 (print string) into $v0
    la      $a0,                                div_zero_msg                                                                                                                            # Load address: Loads address of div_zero_msg string into $a0
    syscall                                                                                                                                                                             # System call: Prints division by zero error message

exit_x_calculation_file:                                                                                                                                                                     # Exit point for x calculation
    # Restore registers
    lw      $ra,                                0($sp)                                                                                                                                  # Load word: Restores return address from stack
    lw      $s0,                                4($sp)                                                                                                                                  # Load word: Restores $s0 register from stack
    lw      $s1,                                8($sp)                                                                                                                                  # Load word: Restores $s1 register from stack
    lw      $s2,                                12($sp)                                                                                                                                 # Load word: Restores $s2 register from stack
    lw      $s3,                                16($sp)                                                                                                                                 # Load word: Restores $s3 register from stack
    lw      $s4,                                20($sp)                                                                                                                                 # Load word: Restores $s4 register from stack
    addi    $sp,                                $sp,                        24                                                                                                          # Add immediate: Adjusts stack pointer back up by 24 bytes
    jr      $ra                                                                                                                                                                         # Jump register: Returns to calling function

    #########################################Calculate Y Subroutine#########################################
calculate_y:                                                                                                                                                                            # Subroutine to calculate y
    # Save return address and any registers we'll use
    addi    $sp,                                $sp,                        -24                                                                                                         # Add immediate: Decrements stack pointer by 24 bytes to make space for saved registers
    sw      $ra,                                0($sp)                                                                                                                                  # Store word: Saves return address to stack
    sw      $s0,                                4($sp)                                                                                                                                  # Store word: Saves $s0 register to stack
    sw      $s1,                                8($sp)                                                                                                                                  # Store word: Saves $s1 register to stack
    sw      $s2,                                12($sp)                                                                                                                                 # Store word: Saves $s2 register to stack
    sw      $s3,                                16($sp)                                                                                                                                 # Store word: Saves $s3 register to stack
    sw      $s4,                                20($sp)                                                                                                                                 # Store word: Saves $s4 register to stack

    # First calculate original determinant (D)
    jal     calculate_determinant                                                                                                                                                       # Jump and link: Calls calculate_determinant subroutine, saves return address
    move    $s2,                                $s4                                                                                                                                     # Move: Saves original determinant in $s2

    # Copy all original matrix values to temp matrix
    lw      $t0,                                matrix_a                                                                                                                                # Load word: Loads value from matrix_a into $t0
    sw      $t0,                                temp_matrix_a                                                                                                                           # Store word: Saves value to temp_matrix_a
    lw      $t0,                                matrix_c                                                                                                                                # Load word: Loads value from matrix_c into $t0
    sw      $t0,                                temp_matrix_c                                                                                                                           # Store word: Saves value to temp_matrix_c
    lw      $t0,                                matrix_d                                                                                                                                # Load word: Loads value from matrix_d into $t0
    sw      $t0,                                temp_matrix_d                                                                                                                           # Store word: Saves value to temp_matrix_d
    lw      $t0,                                matrix_f                                                                                                                                # Load word: Loads value from matrix_f into $t0
    sw      $t0,                                temp_matrix_f                                                                                                                           # Store word: Saves value to temp_matrix_f
    lw      $t0,                                matrix_g                                                                                                                                # Load word: Loads value from matrix_g into $t0
    sw      $t0,                                temp_matrix_g                                                                                                                           # Store word: Saves value to temp_matrix_g
    lw      $t0,                                matrix_i                                                                                                                                # Load word: Loads value from matrix_i into $t0
    sw      $t0,                                temp_matrix_i                                                                                                                           # Store word: Saves value to temp_matrix_i

    # Replace second column with constants
    lw      $t0,                                constant_term_1                                                                                                                         # Load word: Loads first constant term into $t0
    sw      $t0,                                temp_matrix_b                                                                                                                           # Store word: Saves value to temp_matrix_b
    lw      $t0,                                constant_term_2                                                                                                                         # Load word: Loads second constant term into $t0
    sw      $t0,                                temp_matrix_e                                                                                                                           # Store word: Saves value to temp_matrix_e
    lw      $t0,                                constant_term_3                                                                                                                         # Load word: Loads third constant term into $t0
    sw      $t0,                                temp_matrix_h                                                                                                                           # Store word: Saves value to temp_matrix_h

    # Calculate Dy using temp matrix
    # First term: a(ei-fh)
    lw      $t1,                                temp_matrix_a                                                                                                                           # Load word: Loads value from temp_matrix_a into $t1 (a)
    lw      $t5,                                temp_matrix_e                                                                                                                           # Load word: Loads value from temp_matrix_e into $t5 (e)
    lw      $t9,                                temp_matrix_i                                                                                                                           # Load word: Loads value from temp_matrix_i into $t9 (i)
    mul     $s0,                                $t5,                        $t9                                                                                                         # Multiply: Calculates ei and stores in $s0
    lw      $t6,                                temp_matrix_f                                                                                                                           # Load word: Loads value from temp_matrix_f into $t6 (f)
    lw      $t8,                                temp_matrix_h                                                                                                                           # Load word: Loads value from temp_matrix_h into $t8 (h)
    mul     $s1,                                $t6,                        $t8                                                                                                         # Multiply: Calculates fh and stores in $s1
    sub     $s0,                                $s0,                        $s1                                                                                                         # Subtract: Calculates ei - fh and stores in $s0
    mul     $s0,                                $t1,                        $s0                                                                                                         # Multiply: Calculates a(ei-fh) and stores in $s0

    # Second term: b(di-fg)
    lw      $t2,                                temp_matrix_b                                                                                                                           # Load word: Loads value from temp_matrix_b into $t2 (b)
    lw      $t4,                                temp_matrix_d                                                                                                                           # Load word: Loads value from temp_matrix_d into $t4 (d)
    mul     $s1,                                $t4,                        $t9                                                                                                         # Multiply: Calculates di and stores in $s1
    lw      $t7,                                temp_matrix_g                                                                                                                           # Load word: Loads value from temp_matrix_g into $t7 (g)
    mul     $s3,                                $t6,                        $t7                                                                                                         # Multiply: Calculates fg and stores in $s3
    sub     $s1,                                $s1,                        $s3                                                                                                         # Subtract: Calculates di - fg and stores in $s1
    mul     $s1,                                $t2,                        $s1                                                                                                         # Multiply: Calculates b(di-fg) and stores in $s1

    # Third term: c(dh-eg)
    lw      $t3,                                temp_matrix_c                                                                                                                           # Load word: Loads value from temp_matrix_c into $t3 (c)
    mul     $s3,                                $t4,                        $t8                                                                                                         # Multiply: Calculates dh and stores in $s3
    mul     $s4,                                $t5,                        $t7                                                                                                         # Multiply: Calculates eg and stores in $s4
    sub     $s3,                                $s3,                        $s4                                                                                                         # Subtract: Calculates dh - eg and stores in $s3
    mul     $s3,                                $t3,                        $s3                                                                                                         # Multiply: Calculates c(dh-eg) and stores in $s3

    # Final Dy calculation: a(ei-fh) - b(di-fg) + c(dh-eg)
    sub     $s4,                                $s0,                        $s1                                                                                                         # Subtract: Calculates a(ei-fh) - b(di-fg) and stores in $s4
    add     $s4,                                $s4,                        $s3                                                                                                         # Add: Calculates final Dy value and stores in $s4
    move    $s1,                                $s4                                                                                                                                     # Move: Saves Dy value in $s1

    # Check for division by zero
    beqz    $s2,                                division_by_zero                                                                                                                        # Branch if equal to zero: Jumps to division_by_zero if original determinant is zero

    # Convert to float and divide
    mtc1    $s1,                                $f2                                                                                                                                     # Move to coprocessor: Moves Dy value to floating-point register $f2
    cvt.s.w $f2,                                $f2                                                                                                                                     # Convert: Converts integer in $f2 to single precision float
    mtc1    $s2,                                $f4                                                                                                                                     # Move to coprocessor: Moves original determinant value to floating-point register $f4
    cvt.s.w $f4,                                $f4                                                                                                                                     # Convert: Converts integer in $f4 to single precision float

    # Calculate y = Dy/D
    div.s   $f12,                               $f2,                        $f4                                                                                                         # Divide: Divides Dy by D and stores result in $f12

    # Print result
    li      $v0,                                4                                                                                                                                       # Load immediate: Loads syscall code 4 (print string) into $v0
    la      $a0,                                y_output                                                                                                                                # Load address: Loads address of y_output string into $a0
    syscall                                                                                                                                                                             # System call: Prints y output label
    li      $v0,                                2                                                                                                                                       # Load immediate: Loads syscall code 2 (print float) into $v0
    syscall                                                                                                                                                                             # System call: Prints y value
    li      $v0,                                4                                                                                                                                       # Load immediate: Loads syscall code 4 (print string) into $v0
    la      $a0,                                newline                                                                                                                                 # Load address: Loads address of newline string into $a0
    syscall                                                                                                                                                                             # System call: Prints newline character

    #jal     print_y_to_file                                                                                                                                                             # Jump and link: Calls print_y_to_file subroutine
    j       exit_y_calculation                                                                                                                                                          # Jump: Jumps to exit_y_calculation

exit_y_calculation:                                                                                                                                                                     # Exit point for y calculation
    # Restore registers
    lw      $ra,                                0($sp)                                                                                                                                  # Load word: Restores return address from stack
    lw      $s0,                                4($sp)                                                                                                                                  # Load word: Restores $s0 register from stack
    lw      $s1,                                8($sp)                                                                                                                                  # Load word: Restores $s1 register from stack
    lw      $s2,                                12($sp)                                                                                                                                 # Load word: Restores $s2 register from stack
    lw      $s3,                                16($sp)                                                                                                                                 # Load word: Restores $s3 register from stack
    lw      $s4,                                20($sp)                                                                                                                                 # Load word: Restores $s4 register from stack
    addi    $sp,                                $sp,                        24                                                                                                          # Add immediate: Adjusts stack pointer back up by 24 bytes
    jr      $ra                                                                                                                                                                         # Jump register: Returns to calling function

#Calculate Y for file 
calculate_y_file:                                                                                                                                                                            # Subroutine to calculate y
    # Save return address and any registers we'll use
    addi    $sp,                                $sp,                        -24                                                                                                         # Add immediate: Decrements stack pointer by 24 bytes to make space for saved registers
    sw      $ra,                                0($sp)                                                                                                                                  # Store word: Saves return address to stack
    sw      $s0,                                4($sp)                                                                                                                                  # Store word: Saves $s0 register to stack
    sw      $s1,                                8($sp)                                                                                                                                  # Store word: Saves $s1 register to stack
    sw      $s2,                                12($sp)                                                                                                                                 # Store word: Saves $s2 register to stack
    sw      $s3,                                16($sp)                                                                                                                                 # Store word: Saves $s3 register to stack
    sw      $s4,                                20($sp)                                                                                                                                 # Store word: Saves $s4 register to stack

    # First calculate original determinant (D)
    jal     calculate_determinant                                                                                                                                                       # Jump and link: Calls calculate_determinant subroutine, saves return address
    move    $s2,                                $s4                                                                                                                                     # Move: Saves original determinant in $s2

    # Copy all original matrix values to temp matrix
    lw      $t0,                                matrix_a                                                                                                                                # Load word: Loads value from matrix_a into $t0
    sw      $t0,                                temp_matrix_a                                                                                                                           # Store word: Saves value to temp_matrix_a
    lw      $t0,                                matrix_c                                                                                                                                # Load word: Loads value from matrix_c into $t0
    sw      $t0,                                temp_matrix_c                                                                                                                           # Store word: Saves value to temp_matrix_c
    lw      $t0,                                matrix_d                                                                                                                                # Load word: Loads value from matrix_d into $t0
    sw      $t0,                                temp_matrix_d                                                                                                                           # Store word: Saves value to temp_matrix_d
    lw      $t0,                                matrix_f                                                                                                                                # Load word: Loads value from matrix_f into $t0
    sw      $t0,                                temp_matrix_f                                                                                                                           # Store word: Saves value to temp_matrix_f
    lw      $t0,                                matrix_g                                                                                                                                # Load word: Loads value from matrix_g into $t0
    sw      $t0,                                temp_matrix_g                                                                                                                           # Store word: Saves value to temp_matrix_g
    lw      $t0,                                matrix_i                                                                                                                                # Load word: Loads value from matrix_i into $t0
    sw      $t0,                                temp_matrix_i                                                                                                                           # Store word: Saves value to temp_matrix_i

    # Replace second column with constants
    lw      $t0,                                constant_term_1                                                                                                                         # Load word: Loads first constant term into $t0
    sw      $t0,                                temp_matrix_b                                                                                                                           # Store word: Saves value to temp_matrix_b
    lw      $t0,                                constant_term_2                                                                                                                         # Load word: Loads second constant term into $t0
    sw      $t0,                                temp_matrix_e                                                                                                                           # Store word: Saves value to temp_matrix_e
    lw      $t0,                                constant_term_3                                                                                                                         # Load word: Loads third constant term into $t0
    sw      $t0,                                temp_matrix_h                                                                                                                           # Store word: Saves value to temp_matrix_h

    # Calculate Dy using temp matrix
    # First term: a(ei-fh)
    lw      $t1,                                temp_matrix_a                                                                                                                           # Load word: Loads value from temp_matrix_a into $t1 (a)
    lw      $t5,                                temp_matrix_e                                                                                                                           # Load word: Loads value from temp_matrix_e into $t5 (e)
    lw      $t9,                                temp_matrix_i                                                                                                                           # Load word: Loads value from temp_matrix_i into $t9 (i)
    mul     $s0,                                $t5,                        $t9                                                                                                         # Multiply: Calculates ei and stores in $s0
    lw      $t6,                                temp_matrix_f                                                                                                                           # Load word: Loads value from temp_matrix_f into $t6 (f)
    lw      $t8,                                temp_matrix_h                                                                                                                           # Load word: Loads value from temp_matrix_h into $t8 (h)
    mul     $s1,                                $t6,                        $t8                                                                                                         # Multiply: Calculates fh and stores in $s1
    sub     $s0,                                $s0,                        $s1                                                                                                         # Subtract: Calculates ei - fh and stores in $s0
    mul     $s0,                                $t1,                        $s0                                                                                                         # Multiply: Calculates a(ei-fh) and stores in $s0

    # Second term: b(di-fg)
    lw      $t2,                                temp_matrix_b                                                                                                                           # Load word: Loads value from temp_matrix_b into $t2 (b)
    lw      $t4,                                temp_matrix_d                                                                                                                           # Load word: Loads value from temp_matrix_d into $t4 (d)
    mul     $s1,                                $t4,                        $t9                                                                                                         # Multiply: Calculates di and stores in $s1
    lw      $t7,                                temp_matrix_g                                                                                                                           # Load word: Loads value from temp_matrix_g into $t7 (g)
    mul     $s3,                                $t6,                        $t7                                                                                                         # Multiply: Calculates fg and stores in $s3
    sub     $s1,                                $s1,                        $s3                                                                                                         # Subtract: Calculates di - fg and stores in $s1
    mul     $s1,                                $t2,                        $s1                                                                                                         # Multiply: Calculates b(di-fg) and stores in $s1

    # Third term: c(dh-eg)
    lw      $t3,                                temp_matrix_c                                                                                                                           # Load word: Loads value from temp_matrix_c into $t3 (c)
    mul     $s3,                                $t4,                        $t8                                                                                                         # Multiply: Calculates dh and stores in $s3
    mul     $s4,                                $t5,                        $t7                                                                                                         # Multiply: Calculates eg and stores in $s4
    sub     $s3,                                $s3,                        $s4                                                                                                         # Subtract: Calculates dh - eg and stores in $s3
    mul     $s3,                                $t3,                        $s3                                                                                                         # Multiply: Calculates c(dh-eg) and stores in $s3

    # Final Dy calculation: a(ei-fh) - b(di-fg) + c(dh-eg)
    sub     $s4,                                $s0,                        $s1                                                                                                         # Subtract: Calculates a(ei-fh) - b(di-fg) and stores in $s4
    add     $s4,                                $s4,                        $s3                                                                                                         # Add: Calculates final Dy value and stores in $s4
    move    $s1,                                $s4                                                                                                                                     # Move: Saves Dy value in $s1

    # Check for division by zero
    beqz    $s2,                                division_by_zero                                                                                                                        # Branch if equal to zero: Jumps to division_by_zero if original determinant is zero

    # Convert to float and divide
    mtc1    $s1,                                $f2                                                                                                                                     # Move to coprocessor: Moves Dy value to floating-point register $f2
    cvt.s.w $f2,                                $f2                                                                                                                                     # Convert: Converts integer in $f2 to single precision float
    mtc1    $s2,                                $f4                                                                                                                                     # Move to coprocessor: Moves original determinant value to floating-point register $f4
    cvt.s.w $f4,                                $f4                                                                                                                                     # Convert: Converts integer in $f4 to single precision float

    # Calculate y = Dy/D
    div.s   $f12,                               $f2,                        $f4                                                                                                         # Divide: Divides Dy by D and stores result in $f12

    jal     print_y_to_file                                                                                                                                                             # Jump and link: Calls print_y_to_file subroutine
    j       exit_y_calculation_file                                                                                                                                                          # Jump: Jumps to exit_y_calculation

exit_y_calculation_file:                                                                                                                                                                     # Exit point for y calculation
    # Restore registers
    lw      $ra,                                0($sp)                                                                                                                                  # Load word: Restores return address from stack
    lw      $s0,                                4($sp)                                                                                                                                  # Load word: Restores $s0 register from stack
    lw      $s1,                                8($sp)                                                                                                                                  # Load word: Restores $s1 register from stack
    lw      $s2,                                12($sp)                                                                                                                                 # Load word: Restores $s2 register from stack
    lw      $s3,                                16($sp)                                                                                                                                 # Load word: Restores $s3 register from stack
    lw      $s4,                                20($sp)                                                                                                                                 # Load word: Restores $s4 register from stack
    addi    $sp,                                $sp,                        24                                                                                                          # Add immediate: Adjusts stack pointer back up by 24 bytes
    jr      $ra                                                                                                                                                                         # Jump register: Returns to calling function

    #########################################Calculate Z Subroutine#########################################
calculate_z:                                                                                                                                                                            # Subroutine to calculate z
    # Save return address and any registers we'll use
    addi    $sp,                                $sp,                        -24                                                                                                         # Add immediate: Decrements stack pointer by 24 bytes to make space for saved registers
    sw      $ra,                                0($sp)                                                                                                                                  # Store word: Saves return address to stack
    sw      $s0,                                4($sp)                                                                                                                                  # Store word: Saves $s0 register to stack
    sw      $s1,                                8($sp)                                                                                                                                  # Store word: Saves $s1 register to stack
    sw      $s2,                                12($sp)                                                                                                                                 # Store word: Saves $s2 register to stack
    sw      $s3,                                16($sp)                                                                                                                                 # Store word: Saves $s3 register to stack
    sw      $s4,                                20($sp)                                                                                                                                 # Store word: Saves $s4 register to stack

    # First calculate original determinant (D)
    jal     calculate_determinant                                                                                                                                                       # Jump and link: Calls calculate_determinant subroutine, saves return address
    move    $s2,                                $s4                                                                                                                                     # Move: Saves original determinant in $s2

    # Copy all original matrix values to temp matrix
    lw      $t0,                                matrix_a                                                                                                                                # Load word: Loads value from matrix_a into $t0
    sw      $t0,                                temp_matrix_a                                                                                                                           # Store word: Saves value to temp_matrix_a
    lw      $t0,                                matrix_b                                                                                                                                # Load word: Loads value from matrix_b into $t0
    sw      $t0,                                temp_matrix_b                                                                                                                           # Store word: Saves value to temp_matrix_b
    lw      $t0,                                matrix_d                                                                                                                                # Load word: Loads value from matrix_d into $t0
    sw      $t0,                                temp_matrix_d                                                                                                                           # Store word: Saves value to temp_matrix_d
    lw      $t0,                                matrix_e                                                                                                                                # Load word: Loads value from matrix_e into $t0
    sw      $t0,                                temp_matrix_e                                                                                                                           # Store word: Saves value to temp_matrix_e
    lw      $t0,                                matrix_g                                                                                                                                # Load word: Loads value from matrix_g into $t0
    sw      $t0,                                temp_matrix_g                                                                                                                           # Store word: Saves value to temp_matrix_g
    lw      $t0,                                matrix_h                                                                                                                                # Load word: Loads value from matrix_h into $t0
    sw      $t0,                                temp_matrix_h                                                                                                                           # Store word: Saves value to temp_matrix_h
    lw      $t0,                                matrix_i                                                                                                                                # Load word: Loads value from matrix_i into $t0
    sw      $t0,                                temp_matrix_i                                                                                                                           # Store word: Saves value to temp_matrix_i

    # Replace third column with constants
    lw      $t0,                                constant_term_1                                                                                                                         # Load word: Loads first constant term into $t0
    sw      $t0,                                temp_matrix_c                                                                                                                           # Store word: Saves value to temp_matrix_c
    lw      $t0,                                constant_term_2                                                                                                                         # Load word: Loads second constant term into $t0
    sw      $t0,                                temp_matrix_f                                                                                                                           # Store word: Saves value to temp_matrix_f
    lw      $t0,                                constant_term_3                                                                                                                         # Load word: Loads third constant term into $t0
    sw      $t0,                                temp_matrix_i                                                                                                                           # Store word: Saves value to temp_matrix_i

    # Calculate Dz using temp matrix
    # First term: a(ei-fh)
    lw      $t1,                                temp_matrix_a                                                                                                                           # Load word: Loads value from temp_matrix_a into $t1 (a)
    lw      $t5,                                temp_matrix_e                                                                                                                           # Load word: Loads value from temp_matrix_e into $t5 (e)
    lw      $t9,                                temp_matrix_i                                                                                                                           # Load word: Loads value from temp_matrix_i into $t9 (i)
    mul     $s0,                                $t5,                        $t9                                                                                                         # Multiply: Calculates ei and stores in $s0
    lw      $t6,                                temp_matrix_f                                                                                                                           # Load word: Loads value from temp_matrix_f into $t6 (f)
    lw      $t8,                                temp_matrix_h                                                                                                                           # Load word: Loads value from temp_matrix_h into $t8 (h)
    mul     $s1,                                $t6,                        $t8                                                                                                         # Multiply: Calculates fh and stores in $s1
    sub     $s0,                                $s0,                        $s1                                                                                                         # Subtract: Calculates ei - fh and stores in $s0
    mul     $s0,                                $t1,                        $s0                                                                                                         # Multiply: Calculates a(ei-fh) and stores in $s0

    # Second term: b(di-fg)
    lw      $t2,                                temp_matrix_b                                                                                                                           # Load word: Loads value from temp_matrix_b into $t2 (b)
    lw      $t4,                                temp_matrix_d                                                                                                                           # Load word: Loads value from temp_matrix_d into $t4 (d)
    mul     $s1,                                $t4,                        $t9                                                                                                         # Multiply: Calculates di and stores in $s1
    lw      $t7,                                temp_matrix_g                                                                                                                           # Load word: Loads value from temp_matrix_g into $t7 (g)
    mul     $s3,                                $t6,                        $t7                                                                                                         # Multiply: Calculates fg and stores in $s3
    sub     $s1,                                $s1,                        $s3                                                                                                         # Subtract: Calculates di - fg and stores in $s1
    mul     $s1,                                $t2,                        $s1                                                                                                         # Multiply: Calculates b(di-fg) and stores in $s1

    # Third term: c(dh-eg)
    lw      $t3,                                temp_matrix_c                                                                                                                           # Load word: Loads value from temp_matrix_c into $t3 (c)
    mul     $s3,                                $t4,                        $t8                                                                                                         # Multiply: Calculates dh and stores in $s3
    mul     $s4,                                $t5,                        $t7                                                                                                         # Multiply: Calculates eg and stores in $s4
    sub     $s3,                                $s3,                        $s4                                                                                                         # Subtract: Calculates dh - eg and stores in $s3
    mul     $s3,                                $t3,                        $s3                                                                                                         # Multiply: Calculates c(dh-eg) and stores in $s3

    # Final Dz calculation: a(ei-fh) - b(di-fg) + c(dh-eg)
    sub     $s4,                                $s0,                        $s1                                                                                                         # Subtract: Calculates a(ei-fh) - b(di-fg) and stores in $s4
    add     $s4,                                $s4,                        $s3                                                                                                         # Add: Calculates final Dz value and stores in $s4
    move    $s1,                                $s4                                                                                                                                     # Move: Saves Dz value in $s1

    # Check for division by zero
    beqz    $s2,                                division_by_zero                                                                                                                        # Branch if equal to zero: Jumps to division_by_zero if original determinant is zero

    # Convert to float and divide
    mtc1    $s1,                                $f2                                                                                                                                     # Move to coprocessor: Moves Dz value to floating-point register $f2
    cvt.s.w $f2,                                $f2                                                                                                                                     # Convert: Converts integer in $f2 to single precision float
    mtc1    $s2,                                $f4                                                                                                                                     # Move to coprocessor: Moves original determinant value to floating-point register $f4
    cvt.s.w $f4,                                $f4                                                                                                                                     # Convert: Converts integer in $f4 to single precision float

    # Calculate z = Dz/D
    div.s   $f12,                               $f2,                        $f4                                                                                                         # Divide: Divides Dz by D and stores result in $f12

    # Print result
    li      $v0,                                4                                                                                                                                       # Load immediate: Loads syscall code 4 (print string) into $v0
    la      $a0,                                z_output                                                                                                                                # Load address: Loads address of z_output string into $a0
    syscall                                                                                                                                                                             # System call: Prints z output label
    li      $v0,                                2                                                                                                                                       # Load immediate: Loads syscall code 2 (print float) into $v0
    syscall                                                                                                                                                                             # System call: Prints z value
    li      $v0,                                4                                                                                                                                       # Load immediate: Loads syscall code 4 (print string) into $v0
    la      $a0,                                newline                                                                                                                                 # Load address: Loads address of newline string into $a0
    syscall                                                                                                                                                                             # System call: Prints newline character

    #jal     print_z_to_file                                                                                                                                                             # Jump and link: Calls print_z_to_file subroutine
    j       exit_z_calculation_file                                                                                                                                                         # Jump: Jumps to exit_z_calculation

exit_z_calculation_file:                                                                                                                                                                     # Exit point for z calculation
    # Restore registers
    lw      $ra,                                0($sp)                                                                                                                                  # Load word: Restores return address from stack
    lw      $s0,                                4($sp)                                                                                                                                  # Load word: Restores $s0 register from stack
    lw      $s1,                                8($sp)                                                                                                                                  # Load word: Restores $s1 register from stack
    lw      $s2,                                12($sp)                                                                                                                                 # Load word: Restores $s2 register from stack
    lw      $s3,                                16($sp)                                                                                                                                 # Load word: Restores $s3 register from stack
    lw      $s4,                                20($sp)                                                                                                                                 # Load word: Restores $s4 register from stack
    addi    $sp,                                $sp,                        24                                                                                                          # Add immediate: Adjusts stack pointer back up by 24 bytes
    jr      $ra                                                                                                                                                                         # Jump register: Returns to calling function

#Calculate Z for file 
calculate_z_file:                                                                                                                                                                            # Subroutine to calculate z
    # Save return address and any registers we'll use
    addi    $sp,                                $sp,                        -24                                                                                                         # Add immediate: Decrements stack pointer by 24 bytes to make space for saved registers
    sw      $ra,                                0($sp)                                                                                                                                  # Store word: Saves return address to stack
    sw      $s0,                                4($sp)                                                                                                                                  # Store word: Saves $s0 register to stack
    sw      $s1,                                8($sp)                                                                                                                                  # Store word: Saves $s1 register to stack
    sw      $s2,                                12($sp)                                                                                                                                 # Store word: Saves $s2 register to stack
    sw      $s3,                                16($sp)                                                                                                                                 # Store word: Saves $s3 register to stack
    sw      $s4,                                20($sp)                                                                                                                                 # Store word: Saves $s4 register to stack

    # First calculate original determinant (D)
    jal     calculate_determinant                                                                                                                                                       # Jump and link: Calls calculate_determinant subroutine, saves return address
    move    $s2,                                $s4                                                                                                                                     # Move: Saves original determinant in $s2

    # Copy all original matrix values to temp matrix
    lw      $t0,                                matrix_a                                                                                                                                # Load word: Loads value from matrix_a into $t0
    sw      $t0,                                temp_matrix_a                                                                                                                           # Store word: Saves value to temp_matrix_a
    lw      $t0,                                matrix_b                                                                                                                                # Load word: Loads value from matrix_b into $t0
    sw      $t0,                                temp_matrix_b                                                                                                                           # Store word: Saves value to temp_matrix_b
    lw      $t0,                                matrix_d                                                                                                                                # Load word: Loads value from matrix_d into $t0
    sw      $t0,                                temp_matrix_d                                                                                                                           # Store word: Saves value to temp_matrix_d
    lw      $t0,                                matrix_e                                                                                                                                # Load word: Loads value from matrix_e into $t0
    sw      $t0,                                temp_matrix_e                                                                                                                           # Store word: Saves value to temp_matrix_e
    lw      $t0,                                matrix_g                                                                                                                                # Load word: Loads value from matrix_g into $t0
    sw      $t0,                                temp_matrix_g                                                                                                                           # Store word: Saves value to temp_matrix_g
    lw      $t0,                                matrix_h                                                                                                                                # Load word: Loads value from matrix_h into $t0
    sw      $t0,                                temp_matrix_h                                                                                                                           # Store word: Saves value to temp_matrix_h
    lw      $t0,                                matrix_i                                                                                                                                # Load word: Loads value from matrix_i into $t0
    sw      $t0,                                temp_matrix_i                                                                                                                           # Store word: Saves value to temp_matrix_i

    # Replace third column with constants
    lw      $t0,                                constant_term_1                                                                                                                         # Load word: Loads first constant term into $t0
    sw      $t0,                                temp_matrix_c                                                                                                                           # Store word: Saves value to temp_matrix_c
    lw      $t0,                                constant_term_2                                                                                                                         # Load word: Loads second constant term into $t0
    sw      $t0,                                temp_matrix_f                                                                                                                           # Store word: Saves value to temp_matrix_f
    lw      $t0,                                constant_term_3                                                                                                                         # Load word: Loads third constant term into $t0
    sw      $t0,                                temp_matrix_i                                                                                                                           # Store word: Saves value to temp_matrix_i

    # Calculate Dz using temp matrix
    # First term: a(ei-fh)
    lw      $t1,                                temp_matrix_a                                                                                                                           # Load word: Loads value from temp_matrix_a into $t1 (a)
    lw      $t5,                                temp_matrix_e                                                                                                                           # Load word: Loads value from temp_matrix_e into $t5 (e)
    lw      $t9,                                temp_matrix_i                                                                                                                           # Load word: Loads value from temp_matrix_i into $t9 (i)
    mul     $s0,                                $t5,                        $t9                                                                                                         # Multiply: Calculates ei and stores in $s0
    lw      $t6,                                temp_matrix_f                                                                                                                           # Load word: Loads value from temp_matrix_f into $t6 (f)
    lw      $t8,                                temp_matrix_h                                                                                                                           # Load word: Loads value from temp_matrix_h into $t8 (h)
    mul     $s1,                                $t6,                        $t8                                                                                                         # Multiply: Calculates fh and stores in $s1
    sub     $s0,                                $s0,                        $s1                                                                                                         # Subtract: Calculates ei - fh and stores in $s0
    mul     $s0,                                $t1,                        $s0                                                                                                         # Multiply: Calculates a(ei-fh) and stores in $s0

    # Second term: b(di-fg)
    lw      $t2,                                temp_matrix_b                                                                                                                           # Load word: Loads value from temp_matrix_b into $t2 (b)
    lw      $t4,                                temp_matrix_d                                                                                                                           # Load word: Loads value from temp_matrix_d into $t4 (d)
    mul     $s1,                                $t4,                        $t9                                                                                                         # Multiply: Calculates di and stores in $s1
    lw      $t7,                                temp_matrix_g                                                                                                                           # Load word: Loads value from temp_matrix_g into $t7 (g)
    mul     $s3,                                $t6,                        $t7                                                                                                         # Multiply: Calculates fg and stores in $s3
    sub     $s1,                                $s1,                        $s3                                                                                                         # Subtract: Calculates di - fg and stores in $s1
    mul     $s1,                                $t2,                        $s1                                                                                                         # Multiply: Calculates b(di-fg) and stores in $s1

    # Third term: c(dh-eg)
    lw      $t3,                                temp_matrix_c                                                                                                                           # Load word: Loads value from temp_matrix_c into $t3 (c)
    mul     $s3,                                $t4,                        $t8                                                                                                         # Multiply: Calculates dh and stores in $s3
    mul     $s4,                                $t5,                        $t7                                                                                                         # Multiply: Calculates eg and stores in $s4
    sub     $s3,                                $s3,                        $s4                                                                                                         # Subtract: Calculates dh - eg and stores in $s3
    mul     $s3,                                $t3,                        $s3                                                                                                         # Multiply: Calculates c(dh-eg) and stores in $s3

    # Final Dz calculation: a(ei-fh) - b(di-fg) + c(dh-eg)
    sub     $s4,                                $s0,                        $s1                                                                                                         # Subtract: Calculates a(ei-fh) - b(di-fg) and stores in $s4
    add     $s4,                                $s4,                        $s3                                                                                                         # Add: Calculates final Dz value and stores in $s4
    move    $s1,                                $s4                                                                                                                                     # Move: Saves Dz value in $s1

    # Check for division by zero
    beqz    $s2,                                division_by_zero                                                                                                                        # Branch if equal to zero: Jumps to division_by_zero if original determinant is zero

    # Convert to float and divide
    mtc1    $s1,                                $f2                                                                                                                                     # Move to coprocessor: Moves Dz value to floating-point register $f2
    cvt.s.w $f2,                                $f2                                                                                                                                     # Convert: Converts integer in $f2 to single precision float
    mtc1    $s2,                                $f4                                                                                                                                     # Move to coprocessor: Moves original determinant value to floating-point register $f4
    cvt.s.w $f4,                                $f4                                                                                                                                     # Convert: Converts integer in $f4 to single precision float

    # Calculate z = Dz/D
    div.s   $f12,                               $f2,                        $f4                                                                                                         # Divide: Divides Dz by D and stores result in $f12

    jal     print_z_to_file                                                                                                                                                             # Jump and link: Calls print_z_to_file subroutine
    j       exit_z_calculation                                                                                                                                                          # Jump: Jumps to exit_z_calculation

exit_z_calculation:                                                                                                                                                                     # Exit point for z calculation
    # Restore registers
    lw      $ra,                                0($sp)                                                                                                                                  # Load word: Restores return address from stack
    lw      $s0,                                4($sp)                                                                                                                                  # Load word: Restores $s0 register from stack
    lw      $s1,                                8($sp)                                                                                                                                  # Load word: Restores $s1 register from stack
    lw      $s2,                                12($sp)                                                                                                                                 # Load word: Restores $s2 register from stack
    lw      $s3,                                16($sp)                                                                                                                                 # Load word: Restores $s3 register from stack
    lw      $s4,                                20($sp)                                                                                                                                 # Load word: Restores $s4 register from stack
    addi    $sp,                                $sp,                        24                                                                                                          # Add immediate: Adjusts stack pointer back up by 24 bytes
    jr      $ra                                                                                                                                                                         # Jump register: Returns to calling function

    #########################################File Error Handling Subroutine#########################################
file_error:                                                                                                                                                                             # Subroutine for handling file errors
    li      $v0,                                4                                                                                                                                       # Load immediate: Loads syscall code 4 (print string) into $v0
    la      $a0,                                error_message                                                                                                                           # Load address: Loads address of error_message string into $a0
    syscall                                                                                                                                                                             # System call: Prints error message
    j       file_input_loop                                                                                                                                                             # Jump: Jumps back to file_input_loop to retry file input

    #########################################Print X to File Subroutine#########################################
print_x_to_file:                                                                                                                                                                        # Subroutine to print x to file
    # Save registers
    addi    $sp,                                $sp,                        -20                                                                                                         # Add immediate: Decrements stack pointer by 20 bytes to make space for saved registers
    sw      $ra,                                0($sp)                                                                                                                                  # Store word: Saves return address to stack
    sw      $s0,                                4($sp)                                                                                                                                  # Store word: Saves $s0 register to stack
    sw      $s1,                                8($sp)                                                                                                                                  # Store word: Saves $s1 register to stack
    sw      $s2,                                12($sp)                                                                                                                                 # Store word: Saves $s2 register to stack
    sw      $s3,                                16($sp)                                                                                                                                 # Store word: Saves $s3 register to stack

    # Open file for writing
    li      $v0,                                13                                                                                                                                      # Load immediate: Loads syscall code 13 (open file) into $v0
    la      $a0,                                output_file                                                                                                                             # Load address: Loads address of output_file string into $a0
    li      $a1,                                1                                                                                                                                       # Load immediate: Loads flag for clear mode (1) into $a1
    li      $a2,                                0                                                                                                                                       # Load immediate: Loads mode parameter (0) into $a2
    syscall                                                                                                                                                                             # System call: Opens the file for writing
    move    $s0,                                $v0                                                                                                                                     # Move: Copies file descriptor from $v0 to $s0

    # Start with "x=" in buffer
    la      $s3,                                buffer1                                                                                                                                 # Load address: Loads address of buffer1 into $s3
    li      $t3,                                'x'                                                                                                                                     # Load immediate: Loads ASCII 'x' into $t3
    sb      $t3,                                ($s3)                                                                                                                                   # Store byte: Stores 'x' in buffer
    addi    $s3,                                $s3,                        1                                                                                                           # Add immediate: Moves buffer pointer to next position
    li      $t3,                                '='                                                                                                                                     # Load immediate: Loads ASCII '=' into $t3
    sb      $t3,                                ($s3)                                                                                                                                   # Store byte: Stores '=' in buffer
    addi    $s3,                                $s3,                        1                                                                                                           # Add immediate: Moves buffer pointer to next position

    # Check if number is negative
    l.s     $f1,                                zero                                                                                                                                    # Load single: Loads 0.0 into $f1
    c.lt.s  $f12,                               $f1                                                                                                                                     # Compare: Checks if $f12 (x value) is less than 0
    bc1f    positive_number_x                                                                                                                                                           # Branch if not negative: Jumps to positive_number_x if $f12 is not negative

    # Handle negative number
    neg.s   $f12,                               $f12                                                                                                                                    # Negate: Makes $f12 positive
    li      $t3,                                '-'                                                                                                                                     # Load immediate: Loads ASCII '-' into $t3
    sb      $t3,                                ($s3)                                                                                                                                   # Store byte: Stores minus sign in buffer
    addi    $s3,                                $s3,                        1                                                                                                           # Add immediate: Moves buffer pointer to next position
    j       continue_convert_x                                                                                                                                                          # Jump: Jumps to continue_convert_x

positive_number_x:                                                                                                                                                                      # Label for handling positive numbers
    li      $t3,                                32                                                                                                                                      # Load immediate: Loads ASCII space (32) into $t3
    sb      $t3,                                ($s3)                                                                                                                                   # Store byte: Stores space in buffer
    addi    $s3,                                $s3,                        1                                                                                                           # Add immediate: Moves buffer pointer to next position

continue_convert_x:                                                                                                                                                                     # Continue conversion for x
    # Convert float in $f12 to integer part
    cvt.w.s $f0,                                $f12                                                                                                                                    # Convert: Converts float in $f12 to integer in $f0
    mfc1    $s1,                                $f0                                                                                                                                     # Move from coprocessor: Moves integer part from $f0 to $s1

    # Get decimal part
    cvt.s.w $f0,                                $f0                                                                                                                                     # Convert: Converts integer in $f0 back to float
    sub.s   $f0,                                $f12,                       $f0                                                                                                         # Subtract: Calculates decimal part by subtracting integer part from original float
    l.s     $f1,                                hundred                                                                                                                                 # Load single: Loads 100.0 into $f1
    mul.s   $f0,                                $f0,                        $f1                                                                                                         # Multiply: Multiplies decimal part by 100
    cvt.w.s $f0,                                $f0                                                                                                                                     # Convert: Converts result back to integer
    mfc1    $s2,                                $f0                                                                                                                                     # Move from coprocessor: Moves decimal part to $s2

    # Convert integer part to ASCII string
    move    $t0,                                $s1                                                                                                                                     # Move: Copies integer part to $t0
    li      $t1,                                10                                                                                                                                      # Load immediate: Loads 10 into $t1 for division
    move    $t2,                                $s3                                                                                                                                     # Move: Copies current buffer position to $t2

int_to_ascii_x:                                                                                                                                                                         # Loop to convert integer part to ASCII
    div     $t0,                                $t1                                                                                                                                     # Divide: Divides $t0 by 10
    mfhi    $t3                                                                                                                                                                         # Move from HI: Gets remainder (last digit)
    mflo    $t0                                                                                                                                                                         # Move from LO: Gets quotient
    addi    $t3,                                $t3,                        '0'                                                                                                         # Add immediate: Converts digit to ASCII
    sb      $t3,                                ($t2)                                                                                                                                   # Store byte: Stores ASCII digit in buffer
    addi    $t2,                                $t2,                        1                                                                                                           # Add immediate: Moves buffer pointer to next position
    bnez    $t0,                                int_to_ascii_x                                                                                                                          # Branch if not zero: Continues loop if $t0 is not zero

    # Add decimal point
    li      $t3,                                '.'                                                                                                                                     # Load immediate: Loads ASCII '.' into $t3
    sb      $t3,                                ($t2)                                                                                                                                   # Store byte: Stores decimal point in buffer
    addi    $t2,                                $t2,                        1                                                                                                           # Add immediate: Moves buffer pointer to next position

    # Convert decimal part to ASCII (always two digits)
    move    $t0,                                $s2                                                                                                                                     # Move: Copies decimal part to $t0
    div     $t0,                                $t1                                                                                                                                     # Divide: Divides $t0 by 10
    mflo    $t3                                                                                                                                                                         # Move from LO: Gets first digit (tens)
    mfhi    $t4                                                                                                                                                                         # Move from HI: Gets second digit (ones)

    # Store tens digit first
    addi    $t3,                                $t3,                        '0'                                                                                                         # Add immediate: Converts tens digit to ASCII
    sb      $t3,                                ($t2)                                                                                                                                   # Store byte: Stores first decimal digit in buffer
    addi    $t2,                                $t2,                        1                                                                                                           # Add immediate: Moves buffer pointer to next position

    # Then store ones digit
    addi    $t4,                                $t4,                        '0'                                                                                                         # Add immediate: Converts ones digit to ASCII
    sb      $t4,                                ($t2)                                                                                                                                   # Store byte: Stores second decimal digit in buffer
    addi    $t2,                                $t2,                        1                                                                                                           # Add immediate: Moves buffer pointer to next position

    # Add newline
    li      $t3,                                10                                                                                                                                      # Load immediate: Loads ASCII newline character into $t3
    sb      $t3,                                ($t2)                                                                                                                                   # Store byte: Stores newline character in buffer
    addi    $t2,                                $t2,                        1                                                                                                           # Add immediate: Moves buffer pointer to next position

    # Calculate length
    la      $t0,                                buffer1                                                                                                                                 # Load address: Loads start of buffer into $t0
    sub     $t1,                                $t2,                        $t0                                                                                                         # Subtract: Calculates length of string (end - start)

    # Write to file
    li      $v0,                                15                                                                                                                                      # Load immediate: Loads syscall code 15 (write) into $v0
    move    $a0,                                $s0                                                                                                                                     # Move: Copies file descriptor to $a0
    move    $a1,                                $t0                                                                                                                                     # Move: Copies buffer address to $a1
    move    $a2,                                $t1                                                                                                                                     # Move: Copies length to $a2
    syscall                                                                                                                                                                             # System call: Writes buffer to file

    # Close file
    li      $v0,                                16                                                                                                                                      # Load immediate: Loads syscall code 16 (close file) into $v0
    move    $a0,                                $s0                                                                                                                                     # Move: Copies file descriptor to $a0
    syscall                                                                                                                                                                             # System call: Closes the file

    # Restore registers
    lw      $ra,                                0($sp)                                                                                                                                  # Load word: Restores return address from stack
    lw      $s0,                                4($sp)                                                                                                                                  # Load word: Restores $s0 register from stack
    lw      $s1,                                8($sp)                                                                                                                                  # Load word: Restores $s1 register from stack
    lw      $s2,                                12($sp)                                                                                                                                 # Load word: Restores $s2 register from stack
    lw      $s3,                                16($sp)                                                                                                                                 # Load word: Restores $s3 register from stack
    addi    $sp,                                $sp,                        20                                                                                                          # Add immediate: Adjusts stack pointer back up by 20 bytes
    jr      $ra                                                                                                                                                                         # Jump register: Returns to calling function

    #########################################Print y to File Subroutine#########################################
print_y_to_file:                                                                                                                                                                        # Subroutine to print y to file
    # Save registers
    addi    $sp,                                $sp,                        -20                                                                                                         # Add immediate: Decrements stack pointer by 20 bytes to make space for saved registers
    sw      $ra,                                0($sp)                                                                                                                                  # Store word: Saves return address to stack
    sw      $s0,                                4($sp)                                                                                                                                  # Store word: Saves $s0 register to stack
    sw      $s1,                                8($sp)                                                                                                                                  # Store word: Saves $s1 register to stack
    sw      $s2,                                12($sp)                                                                                                                                 # Store word: Saves $s2 register to stack
    sw      $s3,                                16($sp)                                                                                                                                 # Store word: Saves $s3 register to stack

    # Open file for writing
    li      $v0,                                13                                                                                                                                      # Load immediate: Loads syscall code 13 (open file) into $v0
    la      $a0,                                output_file                                                                                                                             # Load address: Loads address of output_file string into $a0
    li      $a1,                                9                                                                                                                                       # Load immediate: Loads flag for append mode (9) into $a1
    li      $a2,                                0                                                                                                                                       # Load immediate: Loads mode parameter (0) into $a2
    syscall                                                                                                                                                                             # System call: Opens the file for appending
    move    $s0,                                $v0                                                                                                                                     # Move: Copies file descriptor from $v0 to $s0

    # Start with "y=" in buffer
    la      $s3,                                buffer1                                                                                                                                 # Load address: Loads address of buffer1 into $s3
    li      $t3,                                'y'                                                                                                                                     # Load immediate: Loads ASCII 'y' into $t3
    sb      $t3,                                ($s3)                                                                                                                                   # Store byte: Stores 'y' in buffer
    addi    $s3,                                $s3,                        1                                                                                                           # Add immediate: Moves buffer pointer to next position
    li      $t3,                                '='                                                                                                                                     # Load immediate: Loads ASCII '=' into $t3
    sb      $t3,                                ($s3)                                                                                                                                   # Store byte: Stores '=' in buffer
    addi    $s3,                                $s3,                        1                                                                                                           # Add immediate: Moves buffer pointer to next position

    # Check if number is negative
    l.s     $f1,                                zero                                                                                                                                    # Load single: Loads 0.0 into $f1
    c.lt.s  $f12,                               $f1                                                                                                                                     # Compare: Checks if $f12 (y value) is less than 0
    bc1f    positive_number_y                                                                                                                                                           # Branch if not negative: Jumps to positive_number_y if $f12 is not negative

    # Handle negative number
    neg.s   $f12,                               $f12                                                                                                                                    # Negate: Makes $f12 positive
    li      $t3,                                '-'                                                                                                                                     # Load immediate: Loads ASCII '-' into $t3
    sb      $t3,                                ($s3)                                                                                                                                   # Store byte: Stores minus sign in buffer
    addi    $s3,                                $s3,                        1                                                                                                           # Add immediate: Moves buffer pointer to next position
    j       continue_convert_y                                                                                                                                                          # Jump: Jumps to continue_convert_y

positive_number_y:                                                                                                                                                                      # Label for handling positive numbers
    li      $t3,                                32                                                                                                                                      # Load immediate: Loads ASCII space (32) into $t3
    sb      $t3,                                ($s3)                                                                                                                                   # Store byte: Stores space in buffer
    addi    $s3,                                $s3,                        1                                                                                                           # Add immediate: Moves buffer pointer to next position

continue_convert_y:                                                                                                                                                                     # Continue conversion for y
    # Convert float in $f12 to integer part
    cvt.w.s $f0,                                $f12                                                                                                                                    # Convert: Converts float in $f12 to integer in $f0
    mfc1    $s1,                                $f0                                                                                                                                     # Move from coprocessor: Moves integer part from $f0 to $s1

    # Get decimal part
    cvt.s.w $f0,                                $f0                                                                                                                                     # Convert: Converts integer in $f0 back to float
    sub.s   $f0,                                $f12,                       $f0                                                                                                         # Subtract: Calculates decimal part by subtracting integer part from original float
    l.s     $f1,                                hundred                                                                                                                                 # Load single: Loads 100.0 into $f1
    mul.s   $f0,                                $f0,                        $f1                                                                                                         # Multiply: Multiplies decimal part by 100
    cvt.w.s $f0,                                $f0                                                                                                                                     # Convert: Converts result back to integer
    mfc1    $s2,                                $f0                                                                                                                                     # Move from coprocessor: Moves decimal part to $s2

    # Convert integer part to ASCII string
    move    $t0,                                $s1                                                                                                                                     # Move: Copies integer part to $t0
    li      $t1,                                10                                                                                                                                      # Load immediate: Loads 10 into $t1 for division
    move    $t2,                                $s3                                                                                                                                     # Move: Copies current buffer position to $t2

int_to_ascii_y:                                                                                                                                                                         # Loop to convert integer part to ASCII
    div     $t0,                                $t1                                                                                                                                     # Divide: Divides $t0 by 10
    mfhi    $t3                                                                                                                                                                         # Move from HI: Gets remainder (last digit)
    mflo    $t0                                                                                                                                                                         # Move from LO: Gets quotient
    addi    $t3,                                $t3,                        '0'                                                                                                         # Add immediate: Converts digit to ASCII
    sb      $t3,                                ($t2)                                                                                                                                   # Store byte: Stores ASCII digit in buffer
    addi    $t2,                                $t2,                        1                                                                                                           # Add immediate: Moves buffer pointer to next position
    bnez    $t0,                                int_to_ascii_y                                                                                                                          # Branch if not zero: Continues loop if $t0 is not zero

    # Add decimal point
    li      $t3,                                '.'                                                                                                                                     # Load immediate: Loads ASCII '.' into $t3
    sb      $t3,                                ($t2)                                                                                                                                   # Store byte: Stores decimal point in buffer
    addi    $t2,                                $t2,                        1                                                                                                           # Add immediate: Moves buffer pointer to next position

    # Convert decimal part to ASCII (always two digits)
    move    $t0,                                $s2                                                                                                                                     # Move: Copies decimal part to $t0
    div     $t0,                                $t1                                                                                                                                     # Divide: Divides $t0 by 10
    mflo    $t3                                                                                                                                                                         # Move from LO: Gets first digit (tens)
    mfhi    $t4                                                                                                                                                                         # Move from HI: Gets second digit (ones)

    # Store tens digit first
    addi    $t3,                                $t3,                        '0'                                                                                                         # Add immediate: Converts tens digit to ASCII
    sb      $t3,                                ($t2)                                                                                                                                   # Store byte: Stores first decimal digit in buffer
    addi    $t2,                                $t2,                        1                                                                                                           # Add immediate: Moves buffer pointer to next position

    # Then store ones digit
    addi    $t4,                                $t4,                        '0'                                                                                                         # Add immediate: Converts ones digit to ASCII
    sb      $t4,                                ($t2)                                                                                                                                   # Store byte: Stores second decimal digit in buffer
    addi    $t2,                                $t2,                        1                                                                                                           # Add immediate: Moves buffer pointer to next position

    # Add newline
    li      $t3,                                10                                                                                                                                      # Load immediate: Loads ASCII newline character into $t3
    sb      $t3,                                ($t2)                                                                                                                                   # Store byte: Stores newline character in buffer
    addi    $t2,                                $t2,                        1                                                                                                           # Add immediate: Moves buffer pointer to next position

    # Calculate length
    la      $t0,                                buffer1                                                                                                                                 # Load address: Loads start of buffer into $t0
    sub     $t1,                                $t2,                        $t0                                                                                                         # Subtract: Calculates length of string (end - start)

    # Write to file
    li      $v0,                                15                                                                                                                                      # Load immediate: Loads syscall code 15 (write) into $v0
    move    $a0,                                $s0                                                                                                                                     # Move: Copies file descriptor to $a0
    move    $a1,                                $t0                                                                                                                                     # Move: Copies buffer address to $a1
    move    $a2,                                $t1                                                                                                                                     # Move: Copies length to $a2
    syscall                                                                                                                                                                             # System call: Writes buffer to file

    # Close file
    li      $v0,                                16                                                                                                                                      # Load immediate: Loads syscall code 16 (close file) into $v0
    move    $a0,                                $s0                                                                                                                                     # Move: Copies file descriptor to $a0
    syscall                                                                                                                                                                             # System call: Closes the file

    # Restore registers
    lw      $ra,                                0($sp)                                                                                                                                  # Load word: Restores return address from stack
    lw      $s0,                                4($sp)                                                                                                                                  # Load word: Restores $s0 register from stack
    lw      $s1,                                8($sp)                                                                                                                                  # Load word: Restores $s1 register from stack
    lw      $s2,                                12($sp)                                                                                                                                 # Load word: Restores $s2 register from stack
    lw      $s3,                                16($sp)                                                                                                                                 # Load word: Restores $s3 register from stack
    addi    $sp,                                $sp,                        20                                                                                                          # Add immediate: Adjusts stack pointer back up by 20 bytes
    jr      $ra                                                                                                                                                                         # Jump register: Returns to calling function

    #########################################Print z to File Subroutine#########################################
print_z_to_file:                                                                                                                                                                        # Subroutine to print z to file
    # Save registers
    addi    $sp,                                $sp,                        -20                                                                                                         # Add immediate: Decrements stack pointer by 20 bytes to make space for saved registers
    sw      $ra,                                0($sp)                                                                                                                                  # Store word: Saves return address to stack
    sw      $s0,                                4($sp)                                                                                                                                  # Store word: Saves $s0 register to stack
    sw      $s1,                                8($sp)                                                                                                                                  # Store word: Saves $s1 register to stack
    sw      $s2,                                12($sp)                                                                                                                                 # Store word: Saves $s2 register to stack
    sw      $s3,                                16($sp)                                                                                                                                 # Store word: Saves $s3 register to stack

    # Open file for writing
    li      $v0,                                13                                                                                                                                      # Load immediate: Loads syscall code 13 (open file) into $v0
    la      $a0,                                output_file                                                                                                                             # Load address: Loads address of output_file string into $a0
    li      $a1,                                9                                                                                                                                       # Load immediate: Loads flag for append mode (9) into $a1
    li      $a2,                                0                                                                                                                                       # Load immediate: Loads mode parameter (0) into $a2
    syscall                                                                                                                                                                             # System call: Opens the file for appending
    move    $s0,                                $v0                                                                                                                                     # Move: Copies file descriptor from $v0 to $s0

    # Start with "z=" in buffer
    la      $s3,                                buffer1                                                                                                                                 # Load address: Loads address of buffer1 into $s3
    li      $t3,                                'z'                                                                                                                                     # Load immediate: Loads ASCII 'z' into $t3
    sb      $t3,                                ($s3)                                                                                                                                   # Store byte: Stores 'z' in buffer
    addi    $s3,                                $s3,                        1                                                                                                           # Add immediate: Moves buffer pointer to next position
    li      $t3,                                '='                                                                                                                                     # Load immediate: Loads ASCII '=' into $t3
    sb      $t3,                                ($s3)                                                                                                                                   # Store byte: Stores '=' in buffer
    addi    $s3,                                $s3,                        1                                                                                                           # Add immediate: Moves buffer pointer to next position

    # Check if number is negative
    l.s     $f1,                                zero                                                                                                                                    # Load single: Loads 0.0 into $f1
    c.lt.s  $f12,                               $f1                                                                                                                                     # Compare: Checks if $f12 (z value) is less than 0
    bc1f    positive_number_z                                                                                                                                                           # Branch if not negative: Jumps to positive_number_z if $f12 is not negative

    # Handle negative number
    neg.s   $f12,                               $f12                                                                                                                                    # Negate: Makes $f12 positive
    li      $t3,                                '-'                                                                                                                                     # Load immediate: Loads ASCII '-' into $t3
    sb      $t3,                                ($s3)                                                                                                                                   # Store byte: Stores minus sign in buffer
    addi    $s3,                                $s3,                        1                                                                                                           # Add immediate: Moves buffer pointer to next position
    j       continue_convert_z                                                                                                                                                          # Jump: Jumps to continue_convert_z

positive_number_z:                                                                                                                                                                      # Label for handling positive numbers
    li      $t3,                                ' '                                                                                                                                      # Load immediate: Loads ASCII space (32) into $t3
    sb      $t3,                                ($s3)                                                                                                                                   # Store byte: Stores space in buffer
    addi    $s3,                                $s3,                        1                                                                                                           # Add immediate: Moves buffer pointer to next position

continue_convert_z:                                                                                                                                                                     # Continue conversion for z
    # Convert float in $f12 to integer part
    cvt.w.s $f0,                                $f12                                                                                                                                    # Convert: Converts float in $f12 to integer in $f0
    mfc1    $s1,                                $f0                                                                                                                                     # Move from coprocessor: Moves integer part from $f0 to $s1

    # Get decimal part
    cvt.s.w $f0,                                $f0                                                                                                                                     # Convert: Converts integer in $f0 back to float
    sub.s   $f0,                                $f12,                       $f0                                                                                                         # Subtract: Calculates decimal part by subtracting integer part from original float
    l.s     $f1,                                hundred                                                                                                                                 # Load single: Loads 100.0 into $f1
    mul.s   $f0,                                $f0,                        $f1                                                                                                         # Multiply: Multiplies decimal part by 100
    cvt.w.s $f0,                                $f0                                                                                                                                     # Convert: Converts result back to integer
    mfc1    $s2,                                $f0                                                                                                                                     # Move from coprocessor: Moves decimal part to $s2

    # Convert integer part to ASCII string
    move    $t0,                                $s1                                                                                                                                     # Move: Copies integer part to $t0
    li      $t1,                                10                                                                                                                                      # Load immediate: Loads 10 into $t1 for division
    move    $t2,                                $s3                                                                                                                                     # Move: Copies current buffer position to $t2

int_to_ascii_z:                                                                                                                                                                         # Loop to convert integer part to ASCII
    div     $t0,                                $t1                                                                                                                                     # Divide: Divides $t0 by 10
    mfhi    $t3                                                                                                                                                                         # Move from HI: Gets remainder (last digit)
    mflo    $t0                                                                                                                                                                         # Move from LO: Gets quotient
    addi    $t3,                                $t3,                        '0'                                                                                                         # Add immediate: Converts digit to ASCII
    sb      $t3,                                ($t2)                                                                                                                                   # Store byte: Stores ASCII digit in buffer
    addi    $t2,                                $t2,                        1                                                                                                           # Add immediate: Moves buffer pointer to next position
    bnez    $t0,                                int_to_ascii_z                                                                                                                          # Branch if not zero: Continues loop if $t0 is not zero

    # Add decimal point
    li      $t3,                                '.'                                                                                                                                      # Load immediate: Loads ASCII newline character into $t3
    sb      $t3,                                ($t2)                                                                                                                                   # Store byte: Stores newline character in buffer
    addi    $t2,                                $t2,                        1                                                                                                           # Add immediate: Moves buffer pointer to next position

    # Convert decimal part to ASCII (always two digits)
    move    $t0,                                $s2                                                                                                                                     # Move: Copies decimal part to $t0
    div     $t0,                                $t1                                                                                                                                     # Divide: Divides $t0 by 10
    mflo    $t3                                                                                                                                                                         # Move from LO: Gets first digit (tens)
    mfhi    $t4                                                                                                                                                                         # Move from HI: Gets second digit (ones)

    # Store tens digit first
    addi    $t3,                                $t3,                        '0'                                                                                                         # Add immediate: Converts tens digit to ASCII
    sb      $t3,                                ($t2)                                                                                                                                   # Store byte: Stores first decimal digit in buffer
    addi    $t2,                                $t2,                        1                                                                                                           # Add immediate: Moves buffer pointer to next position

    # Then store ones digit
    addi    $t4,                                $t4,                        '0'                                                                                                         # Add immediate: Converts ones digit to ASCII
    sb      $t4,                                ($t2)                                                                                                                                   # Store byte: Stores second decimal digit in buffer
    addi    $t2,                                $t2,                        1                                                                                                           # Add immediate: Moves buffer pointer to next position

    # Add newline character
    li      $t3,                                10                                                                                                                                      # Load immediate: Loads ASCII space (32) into $t3
    sb      $t3,                                ($t2)                                                                                                                                   # Store byte: Stores space character in buffer
    addi    $t2,                                $t2,                        1                                                                                                           # Add immediate: Moves buffer pointer to next position

    # Calculate length
    la      $t0,                                buffer1                                                                                                                                 # Load address: Loads start of buffer into $t0
    sub     $t1,                                $t2,                        $t0                                                                                                         # Subtract: Calculates length of string (end - start)

    # Write to file
    li      $v0,                                15                                                                                                                                      # Load immediate: Loads syscall code 15 (write) into $v0
    move    $a0,                                $s0                                                                                                                                     # Move: Copies file descriptor to $a0
    move    $a1,                                $t0                                                                                                                                     # Move: Copies buffer address to $a1
    move    $a2,                                $t1                                                                                                                                     # Move: Copies length to $a2
    syscall                                                                                                                                                                             # System call: Writes buffer to file

    # Close file
    li      $v0,                                16                                                                                                                                      # Load immediate: Loads syscall code 16 (close file) into $v0
    move    $a0,                                $s0                                                                                                                                     # Move: Copies file descriptor to $a0
    syscall                                                                                                                                                                             # System call: Closes the file

    # Restore registers
    lw      $ra,                                0($sp)                                                                                                                                  # Load word: Restores return address from stack
    lw      $s0,                                4($sp)                                                                                                                                  # Load word: Restores $s0 register from stack
    lw      $s1,                                8($sp)                                                                                                                                  # Load word: Restores $s1 register from stack
    lw      $s2,                                12($sp)                                                                                                                                 # Load word: Restores $s2 register from stack
    lw      $s3,                                16($sp)                                                                                                                                 # Load word: Restores $s3 register from stack
    addi    $sp,                                $sp,                        20                                                                                                          # Add immediate: Adjusts stack pointer back up by 20 bytes
    jr      $ra                                                                                                                                                                         # Jump register: Returns to calling function




