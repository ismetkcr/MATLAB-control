/*
 * This file is not available for use in any application other than as a
 * MATLAB(R) MEX file for use with the Simulink(R) Accelerator product.
 */

/*
 * RTex_acc.c
 *
 * Real-Time Workshop code generation for Simulink model "RTex_acc.mdl".
 *
 * Model Version              : 1.101
 * Real-Time Workshop version : 6.6  (R2007a)  01-Feb-2007
 * C source code generated on : Fri Sep 07 10:51:30 2007
 */
#include <math.h>
#include "RTex_acc.h"
#include "RTex_acc_private.h"
#include <stdio.h>
#include "simstruc.h"
#include "fixedpoint.h"
#define CodeFormat                     S-Function
#define AccDefine1                     Accelerator_S-Function

/* Outputs for root system: '<Root>' */
static void mdlOutputs(SimStruct *S, int_T tid)
{
  /* TransferFcn Block: '<Root>/B_0_0' */
  ((BlockIO *) _ssGetBlockIO(S))->B_0_0_0 = (((Parameters *) ssGetDefaultParam(S))
    ->P_2[0])*((ContinuousStates *) ssGetContStates(S))->TransferFcn_CSTATE[0]
    + (((Parameters *) ssGetDefaultParam(S))->P_2[1])*((ContinuousStates *)
    ssGetContStates(S))->TransferFcn_CSTATE[1]
    + (((Parameters *) ssGetDefaultParam(S))->P_2[2])*((ContinuousStates *)
    ssGetContStates(S))->TransferFcn_CSTATE[2];
  if (ssIsSampleHit(S, 1, 0)) {        /* Sample time: [0.05s, 0.0s] */
    /* Scope: '<Root>/Scope1' */
    /* Call into Simulink for Scope */
    ssCallAccelRunBlock(S, 0, 1, SS_CALL_MDL_OUTPUTS);

    /* DiscretePulseGenerator: '<Root>/Pulse Generator' */
    ((BlockIO *) _ssGetBlockIO(S))->B_0_2_0 =
      (((D_Work *) ssGetRootDWork(S))->clockTickCounter < ((Parameters *)
        ssGetDefaultParam(S))->P_7 &&
       ((D_Work *) ssGetRootDWork(S))->clockTickCounter >= 0) ?
      ((Parameters *) ssGetDefaultParam(S))->P_5 :
      0.0;
    if (((D_Work *) ssGetRootDWork(S))->clockTickCounter >= ((Parameters *)
         ssGetDefaultParam(S))->P_6-1) {
      ((D_Work *) ssGetRootDWork(S))->clockTickCounter = 0;
    } else {
      (((D_Work *) ssGetRootDWork(S))->clockTickCounter)++;
    }
  }

  /* Level2 S-Function Block: '<Root>/B_0_3' (RTBlock) */
  /* Call into Simulink for MEX-version of S-function */
  ssCallAccelRunBlock(S, 0, 3, SS_CALL_MDL_OUTPUTS);
  if (ssIsSampleHit(S, 1, 0)) {        /* Sample time: [0.05s, 0.0s] */
    /* Scope: '<Root>/Scope' */
    /* Call into Simulink for Scope */
    ssCallAccelRunBlock(S, 0, 4, SS_CALL_MDL_OUTPUTS);
  }

  /* tid is required for a uniform function interface. This system
   * is single rate, and in this case, tid is not accessed. */
  UNUSED_PARAMETER(tid);
}

/* Update for root system: '<Root>' */
#define MDL_UPDATE

static void mdlUpdate(SimStruct *S, int_T tid)
{
  /* Level2 S-Function Block: '<Root>/B_0_3' (RTBlock) */
  /* Call into Simulink for MEX-version of S-function */
  ssCallAccelRunBlock(S, 0, 3, SS_CALL_MDL_UPDATE);

  /* tid is required for a uniform function interface. This system
   * is single rate, and in this case, tid is not accessed. */
  UNUSED_PARAMETER(tid);
}

/* Derivatives for root system: '<Root>' */
#define MDL_DERIVATIVES

static void mdlDerivatives(SimStruct *S)
{
  /* TransferFcn Block: '<Root>/B_0_0' */
  {
    ((StateDerivatives *) ssGetdX(S))->TransferFcn_CSTATE[0] = ((Parameters *)
      ssGetDefaultParam(S))->P_1*((BlockIO *) _ssGetBlockIO(S))->B_0_2_0;
    ((StateDerivatives *) ssGetdX(S))->TransferFcn_CSTATE[0] += (((Parameters *)
      ssGetDefaultParam(S))->P_0[0])*((ContinuousStates *) ssGetContStates(S))
      ->TransferFcn_CSTATE[0]
      + (((Parameters *) ssGetDefaultParam(S))->P_0[1])*((ContinuousStates *)
      ssGetContStates(S))->TransferFcn_CSTATE[1]
      + (((Parameters *) ssGetDefaultParam(S))->P_0[2])*((ContinuousStates *)
      ssGetContStates(S))->TransferFcn_CSTATE[2];
    ((StateDerivatives *) ssGetdX(S))->TransferFcn_CSTATE[1] = (((Parameters *)
      ssGetDefaultParam(S))->P_0[3])*((ContinuousStates *) ssGetContStates(S))
      ->TransferFcn_CSTATE[0];
    ((StateDerivatives *) ssGetdX(S))->TransferFcn_CSTATE[2] = (((Parameters *)
      ssGetDefaultParam(S))->P_0[4])*((ContinuousStates *) ssGetContStates(S))
      ->TransferFcn_CSTATE[1];
  }
}

/* Function to initialize sizes */
static void mdlInitializeSizes(SimStruct *S)
{
  /* checksum */
  ssSetChecksumVal(S, 0, 1007434627U);
  ssSetChecksumVal(S, 1, 2063896359U);
  ssSetChecksumVal(S, 2, 2486253893U);
  ssSetChecksumVal(S, 3, 816366975U);

  /* options */
  ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE);

  /* Accelerator check memory map size match for DWork */
  if (ssGetSizeofDWork(S) != sizeof(D_Work)) {
    ssSetErrorStatus(S,"Unexpected error: Internal DWork sizes do "
                     "not match for accelerator mex file.");
  }

  /* Accelerator check memory map size match for BlockIO */
  if (ssGetSizeofGlobalBlockIO(S) != sizeof(BlockIO)) {
    ssSetErrorStatus(S,"Unexpected error: Internal BlockIO sizes do "
                     "not match for accelerator mex file.");
  }

  /* model parameters */
  _ssSetDefaultParam(S, (real_T *) &rtDefaultParameters);

  /* non-finites */
  rt_InitInfAndNaN(sizeof(real_T));
}

/* Empty mdlInitializeSampleTimes function (never called) */
static void mdlInitializeSampleTimes(SimStruct *S)
{
}

/* Empty mdlTerminate function (never called) */
static void mdlTerminate(SimStruct *S)
{
}

/* MATLAB MEX Glue */
#include "simulink.c"
