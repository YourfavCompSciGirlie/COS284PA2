#include <stdio.h>
// need this for free()
#include <stdlib.h>

extern float convertStringToFloat(const char *str);
extern float* extractAndConvertFloats(int *numFloats);
extern double processArray(float *arr, int size);

int main() {
    int numFloats;
    // the extraction and convert to floats: Task 2 
    float *floats = extractAndConvertFloats(&numFloats);

    // the conversion from sting to floats: Task 1? 
    if (floats != NULL) {
        printf("Converted numbers:\n");
        for (int i = 0; i < numFloats; i++) {
            printf("%f\n", floats[i]);
        }

        // this will process the array: Task 3
        double sum = processArray(floats, numFloats);
        printf("The sum of the processed array is: %f\n", sum);

        free(floats);
    }
    // adding this valid check:
    else {
        printf("No valid floats were extracted.\n");
    }

    return 0;
}

/** Console input: `| 32.133 45.66 -21.255 |`'s expected output: 

Enter values separated by whitespace and enclosed in pipes (|):
| 32.133 45.66 -21.255 |
Converted numbers:
32.132999
45.660000
-21.254999
The sum of the processed array is: 475.434491

*/