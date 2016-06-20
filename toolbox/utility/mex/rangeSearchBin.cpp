// To compile: mex -I/users/jang/c/lib -I/users/jang/c/lib/utility rangeSearchBin.cpp \users\jang\c\lib\utility\utility.cpp
#include <string.h>
#include <math.h>
#include "mex.h"
#include "utility.hpp"

/* Input Arguments */
#define	IN		prhs[0]
#define	BOUNDARY	prhs[1]
/* Output Arguments */
#define	OUT		plhs[0]

void mexFunction(
	int nlhs,	mxArray *plhs[],
	int nrhs, const mxArray *prhs[])
{
	double	*in, *boundary, *out;
	int m, n, boundaryLen;
	char message[200];

	/* Check for proper number of arguments */
	if (nrhs!=2){
		strcpy(message, mexFunctionName());
		sprintf(message, "Usage: output = %s(input, boundary)\n", mexFunctionName());
		mexErrMsgTxt(message);
	}

	/* Dimensions of the input matrix */
	m = mxGetM(IN);
	n = mxGetN(IN);
	
	/* Assign pointers to the various parameters */
	in = mxGetPr(IN);
	boundary = mxGetPr(BOUNDARY);
	boundaryLen=mxGetM(BOUNDARY)*mxGetN(BOUNDARY);
	
	/* Create a matrix for the return argument */
	OUT = mxCreateDoubleMatrix(m, n, mxREAL);
	out = mxGetPr(OUT);
	for (int i=0; i<m*n; i++)
		out[i]=rangeSearchBin(boundary, boundaryLen, in[i])+1;		// Plus one for MATLAB indexing
}
