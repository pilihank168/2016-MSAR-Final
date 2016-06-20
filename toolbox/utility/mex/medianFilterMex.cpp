// How to compile:
// mex -I/users/jang/c/lib/utility medianFilterMex.cpp d:/users/jang/c/lib/utility/utility.cpp

#include <string.h>
#include <math.h>
#include "mex.h"
#include "utility.hpp"

/* Input Arguments */
#define	INPUT			prhs[0]
#define	ORDER			prhs[1]

/* Output Arguments */
#define	OUTPUT	plhs[0]

void mexFunction(
	int nlhs,	mxArray *plhs[],
	int nrhs, const mxArray *prhs[])
{
	double	inputLen, order, *input, *output;

	/* Check for proper number of arguments */
	if (nrhs!=2){
		char message[200];
		sprintf(message, "Usage: output = %s(input, order)\n", mexFunctionName());
		mexErrMsgTxt(message);
	}

	input=mxGetPr(INPUT);
	inputLen=mxGetM(INPUT)*mxGetN(INPUT);
	order=mxGetScalar(ORDER);

	// Output matrix
	OUTPUT = mxCreateDoubleMatrix(mxGetM(INPUT), mxGetN(INPUT), mxREAL);
	output = mxGetPr(OUTPUT);
	memcpy(output, input, inputLen*sizeof(double));

	medianFilter(output, inputLen, order);
}
