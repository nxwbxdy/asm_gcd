#include <stdio.h>

/**
 *	The comparisons are separated and in hex to make it more
 *	similar to the assembly language and makes it also
 *	easier to compare in the disassembly
 */
int main(int argc, char* argv[]){

	if(2 != argc){					// 1 arg allowed
		printf("Usage:\n");
		printf("%s <param>\n", *argv);
		return 1;
	}

	int i = 0;					// length of string counter
	int fact = 1;					// fact of index
	int sum = 0;					// sum of convertion
	
	// len counter
	while(argv[1][i++]);				// string length counter
	i--;						// remove 1 from '\0'

	// validation
	while(i--){
		if(argv[1][i] < 0x30)			// if c < '0'
			return 1;
		if(argv[1][i] > 0x39)			// if c > '9'
			return 1;
		// calculation
		sum += fact * (argv[1][i] - 0x30);	// 10^0 * [0]; 10^1 * [1]; 10^2 * [2]
		fact *= 10;				// ^0; ^1; ^2
	}

	// output
	printf("%d\n", sum);

	return 0;
}
