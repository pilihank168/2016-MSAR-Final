// To compile: mex medianMex.cpp d:/users/jang/c/lib/utility.cpp
//#pragma comment(lib, "d:/users/jang/c/lib/utility.lib")
#include <string.h>
#include <math.h>
#include "mex.h"
#include "utility.hpp"

/* Input Arguments */
#define	IN	prhs[0]
/* Output Arguments */
#define	OUT	plhs[0]

void mexFunction(
	int nlhs,	mxArray *plhs[],
	int nrhs, const mxArray *prhs[])
{
	double	*in, *out;
	int m, n;
	char message[200];

	/* Check for proper number of arguments */
	if (nrhs!=1){
		strcpy(message, mexFunctionName());
		strcat(message, " requires one input arguments.");
		mexErrMsgTxt(message);
	}

	/* Dimensions of the input matrix */
	m = mxGetM(IN);
	n = mxGetN(IN);
	
	if ((m!=1) && (n!=1))
		mexErrMsgTxt("Input should be a vector, not a matrix!");

	/* Assign pointers to the various parameters */
	in = mxGetPr(IN);
	double *temp=(double*)malloc(m*n*sizeof(double));	// We need to make a copy first since vecMedian will change the input vector!
	memcpy(temp, in, m*n*sizeof(double));
	
	/* Create a matrix for the return argument */
	OUT = mxCreateDoubleMatrix(1, 1, mxREAL);
	out = mxGetPr(OUT);
	out[0]=vecMedian(temp, m*n);	// Faster version which do sorting first
	
	free(temp);
}
