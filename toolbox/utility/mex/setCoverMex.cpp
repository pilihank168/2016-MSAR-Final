#include <stdio.h>
#include <stdlib.h>
#include "mex.h"
#include "matrix.h"
#include "utility.hpp"

void mexFunction(
	int nlhs,	mxArray *plhs[],
	int nrhs, const mxArray *prhs[])
{
  //input arguments
  double *S;
  int selectNum;
  //output arguments
  int *selectedIndex;
  double *coverRate;
  int selectedCount;

  S = mxGetPr(prhs[0]);
  selectNum = (int)mxGetPr(prhs[1])[0];

  selectedIndex = new int[selectNum];
  coverRate = new double[selectNum];
  selectedCount = setCover(S, mxGetM(prhs[0]), mxGetN(prhs[0]), selectNum, selectedIndex, coverRate);

  plhs[0] = mxCreateDoubleMatrix(selectedCount, 1, mxREAL);
  plhs[1] = mxCreateDoubleMatrix(selectedCount, 1, mxREAL);
  for (int i = 0; i < selectedCount; i++)
  {
    mxGetPr(plhs[0])[i] = selectedIndex[i] + 1;  //因為matlab從1起跳
    mxGetPr(plhs[1])[i] = coverRate[i];
  }
  delete [] selectedIndex;
  delete [] coverRate;
}
