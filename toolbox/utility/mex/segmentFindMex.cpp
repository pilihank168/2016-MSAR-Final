// To compile: mex segmentFindMex.cpp f:/users/jang/c/lib/utility.cpp
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
	int i, m, n, segmentNum, beginFieldIndex, endFieldIndex, durationFieldIndex;
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
	
	/* Assign pointers to the various parameters */
	in = mxGetPr(IN);
	SEGMENT *segment=segmentFind(in, m*n, &segmentNum);

	// �Ω� MATLAB ���c�}�C�����W��
	const char *fieldNames[] = {"begin", "end", "duration"};
	int structNum = segmentNum;				// ���c�}�C������
	int fieldNum = sizeof(fieldNames)/sizeof(*fieldNames);	// ��쪺�Ӽ�
	int dims[2] = {1, structNum};				// ���c�}�C������

	// ���Ϳ�X���c�}�C
	OUT = mxCreateStructArray(2, dims, fieldNum, fieldNames);
	
	// ���o���W�ٹ��������ޭȡA�H�K�ϥ� mxSetFieldByNumber() �����ȶi��]�w
	beginFieldIndex = mxGetFieldNumber(OUT, "begin");
	endFieldIndex = mxGetFieldNumber(OUT, "end");
	durationFieldIndex = mxGetFieldNumber(OUT, "duration");
	
	// ��J MATLAB ���c�}�C������
	for (i=0; i<structNum; i++) {
		mxArray *fieldValue;
		// ��J���W�� begin ����
		fieldValue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(fieldValue) = segment[i].begin+1;					// MATLAB indexing
		mxSetFieldByNumber(OUT, i, beginFieldIndex, fieldValue);
		// ��J���W�� end ����
		fieldValue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(fieldValue) = segment[i].end+1;					// MATLAB indexing
		mxSetFieldByNumber(OUT, i, endFieldIndex, fieldValue);
		// ��J���W�� begin ����
		fieldValue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(fieldValue) = segment[i].duration;
		mxSetFieldByNumber(OUT, i, durationFieldIndex, fieldValue);
	}
	
	free(segment);
}
