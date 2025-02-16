/*
 * RTex_acc.h
 *
 * Real-Time Workshop code generation for Simulink model "RTex_acc.mdl".
 *
 * Model Version              : 1.101
 * Real-Time Workshop version : 6.6  (R2007a)  01-Feb-2007
 * C source code generated on : Fri Sep 07 10:51:30 2007
 */
#ifndef _RTW_HEADER_RTex_acc_h_
#define _RTW_HEADER_RTex_acc_h_
#ifndef _RTex_acc_COMMON_INCLUDES_
# define _RTex_acc_COMMON_INCLUDES_
#include <math.h>
#include <stdlib.h>
#define S_FUNCTION_NAME                simulink_only_sfcn
#define S_FUNCTION_LEVEL               2
#define RTW_GENERATED_S_FUNCTION
#include "rtwtypes.h"
#include "simstruc.h"
#include "fixedpoint.h"
#include "rt_nonfinite.h"
#endif                                 /* _RTex_acc_COMMON_INCLUDES_ */

#include "RTex_acc_types.h"

/* Block signals (auto storage) */
typedef struct {
  real_T B_0_0_0;                      /* '<Root>/Transfer Fcn' */
  real_T B_0_2_0;                      /* '<Root>/Pulse Generator' */
  real_T B_0_3_0[2];                   /* '<Root>/Timer Function' */
} BlockIO;

/* Block states (auto storage) for system '<Root>' */
typedef struct {
  struct {
    void *LoggedData;
  } Scope1_PWORK;                      /* '<Root>/Scope1' */

  struct {
    void *LoggedData;
  } Scope_PWORK;                       /* '<Root>/Scope' */

  int32_T clockTickCounter;            /* '<Root>/Pulse Generator' */
  int_T TimerFunction_IWORK;           /* '<Root>/Timer Function' */
} D_Work;

/* Continuous states (auto storage) */
typedef struct {
  real_T TransferFcn_CSTATE[3];        /* '<Root>/Transfer Fcn' */
} ContinuousStates;

/* State derivatives (auto storage) */
typedef struct {
  real_T TransferFcn_CSTATE[3];        /* '<Root>/Transfer Fcn' */
} StateDerivatives;

/* State disabled  */
typedef struct {
  boolean_T TransferFcn_CSTATE[3];     /* '<Root>/Transfer Fcn' */
} StateDisabled;

/* Parameters (auto storage) */
struct Parameters {
  real_T P_0[5];                       /* Computed Parameter: A
                                        * '<Root>/Transfer Fcn'
                                        */
  real_T P_1;                          /* Computed Parameter: B
                                        * '<Root>/Transfer Fcn'
                                        */
  real_T P_2[3];                       /* Computed Parameter: C
                                        * '<Root>/Transfer Fcn'
                                        */
  real_T P_5;                          /* Expression: 1
                                        * '<Root>/Pulse Generator'
                                        */
  real_T P_6;                          /* Computed Parameter: Period
                                        * '<Root>/Pulse Generator'
                                        */
  real_T P_7;                          /* Computed Parameter: PulseWidth
                                        * '<Root>/Pulse Generator'
                                        */
  real_T P_8[2];                       /* Computed Parameter: P1Size
                                        * '<Root>/Timer Function'
                                        */
  real_T P_9;                          /* Expression: step
                                        * '<Root>/Timer Function'
                                        */
  real_T P_10[2];                      /* Computed Parameter: P2Size
                                        * '<Root>/Timer Function'
                                        */
  real_T P_11;                         /* Expression: tmrpriority
                                        * '<Root>/Timer Function'
                                        */
  real_T P_12[2];                      /* Computed Parameter: P3Size
                                        * '<Root>/Timer Function'
                                        */
  real_T P_13;                         /* Expression: ThPriority
                                        * '<Root>/Timer Function'
                                        */
};

extern Parameters rtDefaultParameters; /* parameters */

#endif                                 /* _RTW_HEADER_RTex_acc_h_ */
