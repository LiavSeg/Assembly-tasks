
# Q3 - MIPS 32-bit Number Bit Reversal Program

## Description
This MIPS assembly program reverses the order of the bits in a 16-bit binary number provided as input. It takes a decimal number in the range of -9999 to 9999 (inclusive), converts it to its binary representation, reverses the order of the bits, and then displays the reversed binary number along with its decimal representation.

## Usage
1. Clone the repository to your local machine.
2. Navigate to the project directory containing the MIPS assembly file.
3. Assemble the MIPS program using a suitable MIPS assembler. For example, you can use the SPIM simulator's assembler:
4. Follow the on-screen instructions to input a decimal number when prompted.
5. The program will display the binary representation of the input number, its reverse, and the corresponding decimal values.

## Requirements
- SPIM (MIPS32 Simulator)

# Q4 Bull-Cow Game in MIPS Assembly

## Description
This MIPS assembly program implements a simple Bull-Cow game. The program prompts the user to input a 3-digit number with unique digits (0-9). It then enters a loop where the user has to guess the secret number. After each guess, the program provides feedback in the form of "bulls" (correct digit in the correct position) and "cows" (correct digit in the wrong position). The game continues until the user guesses the number correctly or decides to quit.

## How to Play
1. Clone the repository to your local machine.
2. Assemble the MIPS program using a suitable MIPS assembler.
3. Execute the assembled program.
4. Follow the on-screen instructions to play the Bull-Cow game.
5. Input a 3-digit number with unique digits when prompted.
6. After each guess, the program will provide feedback.
7. Continue guessing until you find the secret number or decide to quit.

## Instructions
- Ensure that your guesses and the secret number consist of three unique digits in the range of 0 to 9.
- If the guess contains a correct digit in the correct position, it will be marked as a "bull" (b).
- If the guess contains a correct digit in the wrong position, it will be marked as a "cow" (c).
- If none of the digits in the guess match the secret number, it will be marked as "n".


