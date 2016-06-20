#include <string.h>
#include <math.h>
#include "mex.h"

/* Input Arguments */
#define	PITCH		prhs[0]

/* Output Arguments */
#define	OUTPITCH	plhs[0]

#include "pitch.cpp"

void mexFunction(
	int nlhs,	mxArray *plhs[],
	int nrhs, const mxArray *prhs[])
{
	double *pitch, *outPitch, *temp;
	int pitchLen, outPitchLen;
	char message[200];

	/* Check for proper number of arguments */
	if (nrhs!=1) {
		strcpy(message, mexFunctionName());
		strcat(message, " requires 1 input arguments.\n");
		strcat(message, "Usage: ");
		strcat(message, mexFunctionName());
		strcat(message, " pitch");
		mexErrMsgTxt(message);
	}

	/* Assign pointers to the various parameters */
	pitch = mxGetPr(PITCH);
	pitchLen = mxGetM(PITCH)*mxGetN(PITCH);

	temp = cutZero(pitch, pitchLen, &outPitchLen);

	/* Create a matrix for the return argument */
	OUTPITCH = mxCreateDoubleMatrix(1, outPitchLen, mxREAL);
	outPitch = mxGetPr(OUTPITCH);
	memcpy(outPitch, temp, outPitchLen*sizeof(double)); 
	free(temp);
}
