#include <stdio.h>
#include <string.h>

int main(int argc, char* argv[]){

	if(2 != argc){				// 1 arg allowed
		printf("Usage:\n");
		printf("%s <param>\n", *argv);
		return 1;
	}

	char c;					// character from argv string
	int i = strlen(argv[1]);		// index for string to char
	int fact = 1;				// fact of index
	int sum = 0;				// sum of convertion

	while(i--){
		c = argv[1][i];
		if(c < 0x30)			// if c < '0'
			return 1;
		if(c > 0x39)			// if c > '9'
			return 1;
		sum += fact * (c - 0x30);	// 10^0 * [0]; 10^1 * [1]; 10^2 * [2]
		fact *= 10;			// ^0; ^1; ^2
	}
	printf("%d\n", sum);

	return 0;
}
