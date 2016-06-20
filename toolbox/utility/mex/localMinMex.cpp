// To compile: mex localMinMex.cpp d:/users/jang/c/lib/utility.cpp
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
	int m, n, i, j, localMinCount, *tempOut;
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
	tempOut=(int *)malloc(m*n*sizeof(int));
	localMinCount=vecLocalMin(in, m*n, tempOut);

	/* Create a matrix for the return argument */
	if (m==1)
		OUT = mxCreateDoubleMatrix(1, localMinCount, mxREAL);
	else
		OUT = mxCreateDoubleMatrix(localMinCount, 1, mxREAL);
	out = mxGetPr(OUT);
	for (i=0; i<localMinCount; i++)
		out[i]=(double)(tempOut[i]+1);	// MATLAB index
	
	free(tempOut);
}
