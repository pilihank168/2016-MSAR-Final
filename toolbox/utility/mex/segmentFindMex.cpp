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

	// 用於 MATLAB 結構陣列的欄位名稱
	const char *fieldNames[] = {"begin", "end", "duration"};
	int structNum = segmentNum;				// 結構陣列的長度
	int fieldNum = sizeof(fieldNames)/sizeof(*fieldNames);	// 欄位的個數
	int dims[2] = {1, structNum};				// 結構陣列的維度

	// 產生輸出結構陣列
	OUT = mxCreateStructArray(2, dims, fieldNum, fieldNames);
	
	// 取得欄位名稱對應的索引值，以便使用 mxSetFieldByNumber() 對欄位值進行設定
	beginFieldIndex = mxGetFieldNumber(OUT, "begin");
	endFieldIndex = mxGetFieldNumber(OUT, "end");
	durationFieldIndex = mxGetFieldNumber(OUT, "duration");
	
	// 填入 MATLAB 結構陣列的欄位值
	for (i=0; i<structNum; i++) {
		mxArray *fieldValue;
		// 填入欄位名稱 begin 的值
		fieldValue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(fieldValue) = segment[i].begin+1;					// MATLAB indexing
		mxSetFieldByNumber(OUT, i, beginFieldIndex, fieldValue);
		// 填入欄位名稱 end 的值
		fieldValue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(fieldValue) = segment[i].end+1;					// MATLAB indexing
		mxSetFieldByNumber(OUT, i, endFieldIndex, fieldValue);
		// 填入欄位名稱 begin 的值
		fieldValue = mxCreateDoubleMatrix(1,1,mxREAL);
		*mxGetPr(fieldValue) = segment[i].duration;
		mxSetFieldByNumber(OUT, i, durationFieldIndex, fieldValue);
	}
	
	free(segment);
}
