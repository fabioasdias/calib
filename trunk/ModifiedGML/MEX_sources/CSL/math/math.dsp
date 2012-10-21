# Microsoft Developer Studio Project File - Name="math" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Static Library" 0x0104

CFG=math - Win32 Thread Safe Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "math.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "math.mak" CFG="math - Win32 Thread Safe Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "math - Win32 Release" (based on "Win32 (x86) Static Library")
!MESSAGE "math - Win32 Debug" (based on "Win32 (x86) Static Library")
!MESSAGE "math - Win32 MFC Debug" (based on "Win32 (x86) Static Library")
!MESSAGE "math - Win32 MFC Release" (based on "Win32 (x86) Static Library")
!MESSAGE "math - Win32 Thread Safe Release" (based on "Win32 (x86) Static Library")
!MESSAGE "math - Win32 Thread Safe Debug" (based on "Win32 (x86) Static Library")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "math - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "../lib"
# PROP Intermediate_Dir "Release"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /YX /FD /c
# ADD CPP /nologo /G6 /MD /W3 /GR /GX /O2 /I "..\sdk\libjpeg\include" /D "NDEBUG" /D "_WINDOWS" /D "WIN32" /YX /FD /c
# ADD BASE RSC /l 0x419 /d "NDEBUG"
# ADD RSC /l 0x419 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo

!ELSEIF  "$(CFG)" == "math - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "../libd"
# PROP Intermediate_Dir "Debug"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /YX /FD /GZ /c
# ADD CPP /nologo /G6 /MDd /W3 /Gm /GX /ZI /Od /D "_WINDOWS" /D "_DEBUG" /D "WIN32" /YX /FD /GZ /c
# ADD BASE RSC /l 0x419 /d "_DEBUG"
# ADD RSC /l 0x419 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo

!ELSEIF  "$(CFG)" == "math - Win32 MFC Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "math___Win32_MFC_Debug"
# PROP BASE Intermediate_Dir "math___Win32_MFC_Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "math___Win32_MFC_Debug"
# PROP Intermediate_Dir "math___Win32_MFC_Debug"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /G6 /MDd /W3 /Gm /GX /ZI /Od /D "_WINDOWS" /D "_DEBUG" /D "WIN32" /YX /FD /GZ /c
# ADD CPP /nologo /G6 /MDd /W3 /Gm /GX /ZI /Od /D "_WINDOWS" /D "_DEBUG" /D "WIN32" /YX /FD /GZ /c
# ADD BASE RSC /l 0x419 /d "_DEBUG"
# ADD RSC /l 0x419 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo

!ELSEIF  "$(CFG)" == "math - Win32 MFC Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "math___Win32_MFC_Release"
# PROP BASE Intermediate_Dir "math___Win32_MFC_Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "math___Win32_MFC_Release"
# PROP Intermediate_Dir "math___Win32_MFC_Release"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /G6 /MD /W3 /GR /GX /O2 /D "NDEBUG" /D "_WINDOWS" /D "WIN32" /YX /FD /c
# ADD CPP /nologo /G6 /MD /W3 /GR /GX /O2 /D "NDEBUG" /D "_WINDOWS" /D "WIN32" /YX /FD /c
# ADD BASE RSC /l 0x419 /d "NDEBUG"
# ADD RSC /l 0x419 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo

!ELSEIF  "$(CFG)" == "math - Win32 Thread Safe Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "math___Win32_Thread_Safe_Release"
# PROP BASE Intermediate_Dir "math___Win32_Thread_Safe_Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "math___Win32_Thread_Safe_Release"
# PROP Intermediate_Dir "math___Win32_Thread_Safe_Release"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /G6 /MD /W3 /GR /GX /O2 /D "NDEBUG" /D "_WINDOWS" /D "WIN32" /YX /FD /c
# ADD CPP /nologo /G6 /MD /W3 /GR /GX /O2 /D "NDEBUG" /D "_WINDOWS" /D "WIN32" /D "GML_THREAD_SAFE" /YX /FD /c
# ADD BASE RSC /l 0x419 /d "NDEBUG"
# ADD RSC /l 0x419 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo

!ELSEIF  "$(CFG)" == "math - Win32 Thread Safe Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "math___Win32_Thread_Safe_Debug"
# PROP BASE Intermediate_Dir "math___Win32_Thread_Safe_Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "math___Win32_Thread_Safe_Debug"
# PROP Intermediate_Dir "math___Win32_Thread_Safe_Debug"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /G6 /MDd /W3 /Gm /GX /ZI /Od /D "_WINDOWS" /D "_DEBUG" /D "WIN32" /YX /FD /GZ /c
# ADD CPP /nologo /G6 /MDd /W3 /Gm /GX /ZI /Od /D "_WINDOWS" /D "_DEBUG" /D "WIN32" /D "GML_THREAD_SAFE" /YX /FD /GZ /c
# ADD BASE RSC /l 0x419 /d "_DEBUG"
# ADD RSC /l 0x419 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo

!ENDIF 

# Begin Target

# Name "math - Win32 Release"
# Name "math - Win32 Debug"
# Name "math - Win32 MFC Debug"
# Name "math - Win32 MFC Release"
# Name "math - Win32 Thread Safe Release"
# Name "math - Win32 Thread Safe Debug"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Source File

SOURCE=.\gmlmath.cpp
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# Begin Source File

SOURCE=.\gmlbbox2.h
# End Source File
# Begin Source File

SOURCE=.\gmlbbox3.h
# End Source File
# Begin Source File

SOURCE=.\gmlbsphere3.h
# End Source File
# Begin Source File

SOURCE=.\gmlmath.h
# End Source File
# Begin Source File

SOURCE=.\gmlmatrix2.h
# End Source File
# Begin Source File

SOURCE=.\gmlmatrix3.h
# End Source File
# Begin Source File

SOURCE=.\gmlmatrix4.h
# End Source File
# Begin Source File

SOURCE=.\gmlquat.h
# End Source File
# Begin Source File

SOURCE=.\gmlray3.h
# End Source File
# Begin Source File

SOURCE=.\gmlvector2.h
# End Source File
# Begin Source File

SOURCE=.\gmlvector3.h
# End Source File
# Begin Source File

SOURCE=.\gmlvector4.h
# End Source File
# End Group
# End Target
# End Project
