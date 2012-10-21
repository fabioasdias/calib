# Microsoft Developer Studio Project File - Name="dmCornerDetect" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Dynamic-Link Library" 0x0102

CFG=dmCornerDetect - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "dmCornerDetect.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "dmCornerDetect.mak" CFG="dmCornerDetect - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "dmCornerDetect - Win32 Release" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "dmCornerDetect - Win32 Debug" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "dmCornerDetect - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MT /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /YX /FD /c
# ADD CPP /nologo /MT /W3 /GX /O2 /I "c:\progra~1\MAtLab7\extern\include" /I "c:\progra~1\MAtLab7\extern\include\cpp" /I "..\..\\" /I "..\..\..\\" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /YX /FD /c
# ADD BASE MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x419 /d "NDEBUG"
# ADD RSC /l 0x419 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib libmx.lib libmex.lib libmat.lib cv.lib cxcore.lib /nologo /subsystem:windows /dll /machine:I386 /out:"dmCornerDetect.dll" /libpath:"d:\Math\MAtLab6p5\extern\lib\win32\microsoft\msvc60" /libpath:"d:\Math\MAtLab6p5\extern\lib\win32" /libpath:"c:\progra~1\MAtLab7\extern\lib\win32\microsoft\msvc60" /libpath:"c:\progra~1\MAtLab7\extern\lib\win32"

!ELSEIF  "$(CFG)" == "dmCornerDetect - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MTd /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /YX /FD /GZ /c
# ADD CPP /nologo /MTd /W3 /Gm /GX /ZI /Od /I "c:\progra~1\MAtLab7\extern\include" /I "c:\progra~1\MAtLab7\extern\include\cpp" /I "..\..\\" /I "..\..\..\\" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "MATLAB_MEX_FILE" /FR /YX /FD /GZ /c
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x419 /d "_DEBUG"
# ADD RSC /l 0x419 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll /debug /machine:I386 /pdbtype:sept
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib libmx.lib libmex.lib libmat.lib cv.lib cxcore.lib /nologo /subsystem:windows /dll /debug /machine:I386 /out:"dmCornerDetect.dll" /pdbtype:sept /libpath:"c:\progra~1\MAtLab7\extern\lib\win32\microsoft\msvc60" /libpath:"c:\progra~1\MAtLab7\extern\lib\win32"

!ENDIF 

# Begin Target

# Name "dmCornerDetect - Win32 Release"
# Name "dmCornerDetect - Win32 Debug"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Source File

SOURCE=.\dmCornerDetect.def
# End Source File
# Begin Source File

SOURCE=.\mxMain.cpp
# End Source File
# Begin Source File

SOURCE=..\..\calibinit\utility.cpp
# End Source File
# Begin Source File

SOURCE=..\..\calibinit\utility.h
# End Source File
# End Group
# Begin Group "Detector"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\..\calibinit\dmcalibinit.cpp
# End Source File
# Begin Source File

SOURCE=..\..\calibinit\dmcalibinit.h
# End Source File
# End Group
# End Target
# End Project
