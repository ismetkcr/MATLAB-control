# Copyright 1994-2006 The MathWorks, Inc.
#
# File    : accel_vc.tmf   $Revision: 1.21.4.19 $
#
# Abstract:
#       Accelerator template makefile for building a Windows-based,
#       RTW generated mex-file of Simulink model using generated C code
#       and the
#          Microsoft Visual C/C++ compiler versions 6.0, 7.1
#
#       Note that this template is automatically customized by the Real-Time
#       Workshop build procedure to create "<model>.mk"
#
#       The following defines can be used to modify the behavior of the
#       build:
#
#         OPT_OPTS       - Optimization option. Specify OPT_OPTS=-g to
#                          create a mex file for debugging.
#         MEX_OPTS       - User specific mex options.
#         USER_SRCS      - Additional user sources, such as files needed by
#                          S-functions.
#         USER_INCLUDES  - Additional include paths
#                          (i.e. USER_INCLUDES="-Iwhere-ever -Iwhere-ever2")
#
#       This template makefile is designed to be used with a system target
#       file that contains 'rtwgensettings.BuildDirSuffix' see accel.tlc

#------------------------ Macros read by make_rtw ------------------------------
#
# The following macros are read by the Real-Time Workshop build procedure:
#
#  MAKECMD         - This is the command used to invoke the make utility
#  HOST            - What platform this template makefile is targeted for
#                    (i.e. PC or UNIX)
#  BUILD           - Invoke make from the Real-Time Workshop build procedure
#                    (yes/no)?
#  SYS_TARGET_FILE - Name of system target file.

MAKECMD         = nmake
HOST            = PC
BUILD           = yes
SYS_TARGET_FILE = accel.tlc

#---------------------- Tokens expanded by make_rtw ----------------------------
#
# The following tokens, when wrapped with "|>" and "<|" are expanded by the
# Real-Time Workshop build procedure.
#
#  MODEL_NAME      - Name of the Simulink block diagram
#  MODEL_MODULES   - Any additional generated source modules
#  MAKEFILE_NAME   - Name of makefile created from template makefile <model>.mk
#  MATLAB_ROOT     - Path to were MATLAB is installed.
#  MATLAB_BIN      - Path to MATLAB executable.
#  S_FUNCTIONS     - List of S-functions.
#  S_FUNCTIONS_LIB - List of S-functions libraries to link.
#  SOLVER          - Solver source file name
#  NUMST           - Number of sample times
#  TID01EQ         - yes (1) or no (0): Are sampling rates of continuous task
#                    (tid=0) and 1st discrete task equal.
#  NCSTATES        - Number of continuous states
#  BUILDARGS       - Options passed in at the command line.
#  MEXEXT          - extension that a mex file has. See the MATLAB mexext 
#                    command

MODEL           = RTex
MODULES         = RTex_acc_data.c rt_nonfinite.c 
MAKEFILE        = RTex.mk
MATLAB_ROOT     = C:\MATLABR7a
ALT_MATLAB_ROOT = C:\MATLAB~1
MATLAB_BIN      = C:\MATLABR7a\bin
ALT_MATLAB_BIN  = C:\MATLAB~1\bin
S_FUNCTIONS     = RTBlock.cpp
S_FUNCTIONS_LIB = 
SOLVER          = ode3.c
NUMST           = 2
TID01EQ         = 1
NCSTATES        = 3
MEM_ALLOC       = RT_STATIC
BUILDARGS       =  GENERATE_REPORT=0 ADD_MDL_NAME_TO_GLOBALS=1
MEXEXT          = mexw32

MODELREFS       = 
SHARED_SRC      = 
SHARED_SRC_DIR  = 
SHARED_BIN_DIR  = 
SHARED_LIB      = 
MEX_OPT_FILE    = -f "$(MATLAB_BIN)\$(ML_ARCH)\mexopts\msvc80opts.bat"
COMPUTER        = PCWIN

#--------------------------- Model and reference models -----------------------
MODELLIB                  = RTexlib.lib
MODELREF_LINK_LIBS        = 
MODELREF_INC_PATH         = 
RELATIVE_PATH_TO_ANCHOR   = ..
MODELREF_TARGET_TYPE      = NONE

!if "$(MATLAB_ROOT)" != "$(ALT_MATLAB_ROOT)"
MATLAB_ROOT = $(ALT_MATLAB_ROOT)
!endif
!if "$(MATLAB_BIN)" != "$(ALT_MATLAB_BIN)"
MATLAB_BIN = $(ALT_MATLAB_BIN)
!endif

#--------------------------- Tool Specifications ------------------------------

!include $(MATLAB_ROOT)\rtw\c\tools\vctools.mak

MEX    = $(MATLAB_BIN)\mex
CC     = $(MATLAB_BIN)\mex -c
LIBCMD = lib
PERL   = $(MATLAB_ROOT)\sys\perl\win32\bin\perl

#------------------------------ Include/Lib Path -------------------------------
MATLAB_INCLUDES =                    $(MATLAB_ROOT)\simulink\include
MATLAB_INCLUDES = $(MATLAB_INCLUDES);$(MATLAB_ROOT)\extern\include
MATLAB_INCLUDES = $(MATLAB_INCLUDES);$(MATLAB_ROOT)\rtw\c\src

# Additional includes

MATLAB_INCLUDES = $(MATLAB_INCLUDES);$(MATLAB_ROOT)\work\SUPERL~1\RTV711~1.0\RTEX_A~1
MATLAB_INCLUDES = $(MATLAB_INCLUDES);$(MATLAB_ROOT)\work\SUPERL~1\RTV711~1.0
MATLAB_INCLUDES = $(MATLAB_INCLUDES);$(MATLAB_ROOT)\rtw\c\libsrc


INCLUDE = .;$(RELATIVE_PATH_TO_ANCHOR);$(MATLAB_INCLUDES);$(ADD_INCLUDES);$(INCLUDE);$(MODELREF_INC_PATH)

!if "$(SHARED_SRC_DIR)" != ""
INCLUDE = $(INCLUDE);$(SHARED_SRC_DIR)
!endif

#------------------------ C and MEX optimization options -----------------------

DEFAULT_OPT_OPTS = -O

MEX_OPTS = 
OPT_OPTS = $(DEFAULT_OPT_OPTS)

MEX_OPT_OPTS = $(OPT_OPTS)    # passed to 'mex -c'

!if "$(MEX_OPTS)" == "-g"
MEX_OPT_OPTS =
!endif

#-------------------------------- Mex Options  ---------------------------------

MEX_FLAGS = $(MEX_ARCH) $(MEX_OPTS) $(MEX_OPT_OPTS) $(MEX_OPT_FILE)

#----------------------------- Source Files -----------------------------------
USER_SRCS =

SRCS = $(MODULES) $(USER_SRCS)

OBJS_CPP_UPPER = $(SRCS:.CPP=.obj)
OBJS_CPP_LOWER = $(OBJS_CPP_UPPER:.cpp=.obj)
OBJS_C_UPPER = $(OBJS_CPP_LOWER:.C=.obj)
OBJS = $(MODEL)_acc.obj $(OBJS_C_UPPER:.c=.obj)

SHARED_OBJS = $(SHARED_SRC:.c=.obj)

#-------------------------- Additional Libraries ------------------------------

LIBS =

!if "$(OPT_OPTS)" == "$(DEFAULT_OPT_OPTS)"
LIBS = $(LIBS) $(MATLAB_ROOT)\rtw\c\lib\win32\rtwlib_rtwsfcn_vc.lib
!else
LIBS = $(LIBS) rtwlib.lib
!endif



LIBUT    = $(MATLAB_ROOT)\extern\lib\win32\microsoft\libut.lib
LIBS     = $(LIBS) $(LIBUT)

CMD_FILE = $(MODEL).lnk
GEN_LNK_SCRIPT = $(MATLAB_ROOT)\rtw\c\tools\mkvc_lnk.pl

#--------------------------------- Rules ---------------------------------------
all: set_environment_variables ..\$(MODEL)_acc.$(MEXEXT)

..\$(MODEL)_acc.$(MEXEXT) : $(OBJS) $(SHARED_LIB) $(LIBS)
	@echo ### Linking ...
	$(PERL) $(GEN_LNK_SCRIPT) $(CMD_FILE) $(OBJS)
	$(MEX) $(MEX_FLAGS) @$(CMD_FILE) $(S_FUNCTIONS_LIB) $(SHARED_LIB) $(LIBS) -outdir .. 
	@echo ### Created mex file: $(MODEL)_acc.$(MEXEXT)

# Look in simulink/src helper files

{$(MATLAB_ROOT)\simulink\src}.c.obj :
	@echo ### Compiling $<
	$(CC) $(MEX_FLAGS) $<

# Additional sources

{$(MATLAB_ROOT)\rtw\c\src}.c.obj :
	@echo ### Compiling $<
	$(CC) $(MEX_FLAGS) $<

{$(MATLAB_ROOT)\rtw\c\libsrc}.c.obj :
	@echo ### Compiling $<
	$(CC) $(MEX_FLAGS) $<



{$(MATLAB_ROOT)\rtw\c\src}.cpp.obj : 
	@echo ### Compiling $< 
	$(CC) $(MEX_FLAGS) $< 

{$(MATLAB_ROOT)\rtw\c\libsrc}.cpp.obj : 
	@echo ### Compiling $< 
	$(CC) $(MEX_FLAGS) $< 

 



# Put these rules last, otherwise nmake will check toolboxes first


{$(RELATIVE_PATH_TO_ANCHOR)}.c.obj :
	@echo ### Compiling $<
	$(CC) $(MEX_FLAGS) $(USER_INCLUDES) $<

{$(RELATIVE_PATH_TO_ANCHOR)}.cpp.obj :
	@echo ### Compiling $<
	$(CC) $(MEX_FLAGS) $(USER_INCLUDES) $<

.c.obj :
	@echo ### Compiling $<
	@if exist $*.pdb del $*.pdb
	@if exist ..\$(MODEL)_acc.pdb del ..\$(MODEL)_acc.pdb
	$(CC) $(MEX_FLAGS) $(USER_INCLUDES) $<

.cpp.obj :
	@echo ### Compiling $<
	@if exist $*.pdb del $*.pdb
	@if exist ..\$(MODEL)_acc.pdb del ..\$(MODEL)_acc.pdb
	$(CC) $(MEX_FLAGS) $(USER_INCLUDES) $<

!if "$(SHARED_LIB)" != ""
$(SHARED_LIB) : $(SHARED_SRC)
	@echo ### Creating $@
	@$(CC) $(MEX_FLAGS) -outdir $(SHARED_BIN_DIR)\ @<<
$?
<<
	@$(LIBCMD) /nologo /out:$@ $(SHARED_OBJS)
	@echo ### Created $@
!endif

set_environment_variables:
	@set INCLUDE=$(INCLUDE)
	@set LIB=$(LIB)
	@set MATLAB=$(MATLAB_ROOT)

# Libraries:



MODULES_rtwlib = \
          rt_backsubcc_dbl.obj \
          rt_backsubcc_sgl.obj \
          rt_backsubrc_dbl.obj \
          rt_backsubrc_sgl.obj \
          rt_backsubrr_dbl.obj \
          rt_backsubrr_sgl.obj \
          rt_enab.obj \
          rt_forwardsubcc_dbl.obj \
          rt_forwardsubcc_sgl.obj \
          rt_forwardsubcr_dbl.obj \
          rt_forwardsubcr_sgl.obj \
          rt_forwardsubrc_dbl.obj \
          rt_forwardsubrc_sgl.obj \
          rt_forwardsubrr_dbl.obj \
          rt_forwardsubrr_sgl.obj \
          rt_hypot.obj \
          rt_hypot32.obj \
          rt_i32zcfcn.obj \
          rt_look.obj \
          rt_look1d.obj \
          rt_look1d32.obj \
          rt_look2d32_general.obj \
          rt_look2d32_normal.obj \
          rt_look2d_general.obj \
          rt_look2d_normal.obj \
          rt_look32.obj \
          rt_lu_cplx.obj \
          rt_lu_cplx_sgl.obj \
          rt_lu_real.obj \
          rt_lu_real_sgl.obj \
          rt_matdivcc_dbl.obj \
          rt_matdivcc_sgl.obj \
          rt_matdivcr_dbl.obj \
          rt_matdivcr_sgl.obj \
          rt_matdivrc_dbl.obj \
          rt_matdivrc_sgl.obj \
          rt_matdivrr_dbl.obj \
          rt_matdivrr_sgl.obj \
          rt_matmultandinccc_dbl.obj \
          rt_matmultandinccc_sgl.obj \
          rt_matmultandinccr_dbl.obj \
          rt_matmultandinccr_sgl.obj \
          rt_matmultandincrc_dbl.obj \
          rt_matmultandincrc_sgl.obj \
          rt_matmultandincrr_dbl.obj \
          rt_matmultandincrr_sgl.obj \
          rt_matmultcc_dbl.obj \
          rt_matmultcc_sgl.obj \
          rt_matmultcr_dbl.obj \
          rt_matmultcr_sgl.obj \
          rt_matmultrc_dbl.obj \
          rt_matmultrc_sgl.obj \
          rt_matmultrr_dbl.obj \
          rt_matmultrr_sgl.obj \
          rt_nrand.obj \
          rt_sat_div_int16.obj \
          rt_sat_div_int32.obj \
          rt_sat_div_int8.obj \
          rt_sat_div_uint16.obj \
          rt_sat_div_uint32.obj \
          rt_sat_div_uint8.obj \
          rt_sat_prod_int16.obj \
          rt_sat_prod_int32.obj \
          rt_sat_prod_int8.obj \
          rt_sat_prod_uint16.obj \
          rt_sat_prod_uint32.obj \
          rt_sat_prod_uint8.obj \
          rt_urand.obj \
          rt_zcfcn.obj \
          

rtwlib.lib : rtw_proj.tmw $(MAKEFILE) $(MODULES_rtwlib)
	@echo ### Creating $@
	$(LIBCMD) /nologo /out:$@ $(MODULES_rtwlib)
	@echo ### Created $@



#----------------------------- Dependencies -----------------------------------

$(OBJS) : $(MAKEFILE) rtw_proj.tmw
