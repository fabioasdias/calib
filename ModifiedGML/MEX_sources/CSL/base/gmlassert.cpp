//
//  GMlib -- Graphics & Media Lab Common Source Library
//
//  $Id: gmlassert.cpp,v 1.4 2005/02/11 09:12:16 leo Exp $
//
//  Copyright (C) 2004, Moscow State University Graphics & Media Lab
//  gmlsupport@graphics.cs.msu.su
//  
//  This file is part of GMlib software.
//  For conditions of distribution and use, see the accompanying README file.

// gml includes

#include "gmlassert.h"
#include <signal.h>
#include <string>
#include <vector>
#include <wchar.h>
#include <windows.h> 
#include <stdio.h>

#define IDC_FILE                        1019
#define IDC_LINE                        1020
#define IDC_INFO                        1021
#define IDC_PROGRAM                     1017
#define IDC_EXPRESSION                  1018
#define IDC_FILE                        1019
#define IDC_LINE                        1020
#define IDC_INFO                        1021
#define IDDEBUG                         1016
#define IDIGNOREALL                     1023
#define IDC_STATIC                      -1     

//====================================================================================

struct CAssertStruct
{
	char* m_Expression;
	char* m_FileName;
	int   m_iLine;
	char* m_Info;
	char* m_Program;
};

struct CIgnoreInfo
{
  std::string m_sFileName;
	std::string m_sExpression;
	std::string m_sInfo;
	int    m_iLine;
};

typedef struct {  
    DWORD  style; 
    DWORD  exStyle; 
    WORD   cDlgItems; 
    short  x; 
    short  y; 
    short  cx; 
    short  cy; 
    WORD   menu;         // name or ordinal of a menu resource
    WORD   windowClass;  // name or ordinal of a window class
    WCHAR  title[10]; // title string of the dialog box
} MYDLGTEMPLATE; 

//====================================================================================
// Function name	: AddDlgBoxItem
// Description	    : 
// Return type		: int 
//====================================================================================

int AddDlgBoxItem(unsigned char *in_pcDst, 
                  DWORD style, DWORD exStyle, short x, short y,
                  short cx, short cy, WORD id, WORD windowClass,
                  CHAR *in_pwcTitle)
{
  unsigned char   *pTemp;
  DLGITEMTEMPLATE *pTemplate;
	int     nChars, nActualChars;
  std::wstring    TempStr;

  pTemp = (unsigned char*)(((DWORD)in_pcDst + 3) & ~3);
  pTemplate = (DLGITEMTEMPLATE *)pTemp;

  pTemplate->style   = style;
  pTemplate->dwExtendedStyle = exStyle;
  pTemplate->x  = x;
  pTemplate->y  = y;
  pTemplate->cx = cx;
  pTemplate->cy = cy;
  pTemplate->id = id;

  pTemp += sizeof(DLGITEMTEMPLATE);

  // Window type
  *(WORD *)pTemp = 0xFFFF;
  pTemp += sizeof(WORD);
  *(WORD *)pTemp = windowClass;
  pTemp += sizeof(WORD);

	// transfer the caption even when it is an empty string
  nChars = strlen(in_pwcTitle) + 1;
  TempStr.resize(nChars);
	nActualChars = MultiByteToWideChar(CP_ACP, 0, in_pwcTitle, -1, &TempStr[0], nChars);
	memcpy(pTemp, &TempStr[0], nActualChars * sizeof(WCHAR));
	pTemp += nActualChars * sizeof(WCHAR);

	*(WORD*)pTemp = 0;  // How many bytes in data for control
	pTemp += sizeof(WORD);

  return pTemp - in_pcDst;
};

//=======================================================================
// Function name	: AddDialog
// Description	    : 
// Return type		: int 
// Argument         : unsigned char *in_pcDst
// Argument         : int in_iControls
//====================================================================================

int AddDialog(unsigned char *in_pcDst, int in_iControls, WCHAR *in_pwcTitle,  WCHAR *in_pwcFont)
{
  unsigned char *pTemp = in_pcDst;
  DLGTEMPLATE   *pTemplate = (DLGTEMPLATE *)pTemp;

  pTemplate->style     = DS_SETFONT | DS_3DLOOK | DS_CENTER | DS_SETFOREGROUND | DS_MODALFRAME | WS_POPUP | WS_CAPTION;
  pTemplate->cdit      = in_iControls;
  pTemplate->x         = 0;
  pTemplate->y         = 0;
  pTemplate->dwExtendedStyle = 0;
  pTemplate->cx        = 334;
  pTemplate->cy        = 124;

  pTemp += sizeof(DLGTEMPLATE);

  *(WORD *)pTemp = 0;
  pTemp += sizeof(WORD);
  *(WORD *)pTemp = 0;
  pTemp += sizeof(WORD);
  
  // Title
  wcscpy((WCHAR *) pTemp, in_pwcTitle);
  pTemp += sizeof(WCHAR) * (wcslen(in_pwcTitle) + 1);

  // Font
  *(WORD *)pTemp = 0x0008;
  pTemp += sizeof(WORD);

  wcscpy((WCHAR *) pTemp, in_pwcFont);
  pTemp += sizeof(WCHAR) * (wcslen(in_pwcFont) + 1);
 
  return pTemp - in_pcDst;
};

//====================================================================================
// Function name	: AssertDialogCallback
// Description	  : 
// Return type		: BOOL 
//====================================================================================

BOOL CALLBACK AssertDialogCallback(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	CAssertStruct* assert_struct = (CAssertStruct*)lParam;

	static CAssertStruct* pAssertStruct = NULL;

	switch(uMsg)
	{
	case WM_INITDIALOG:
		{
		pAssertStruct = assert_struct;

		SetDlgItemText(hWnd, IDC_INFO, assert_struct->m_Info);
		SetDlgItemText(hWnd, IDC_PROGRAM, assert_struct->m_Program);
		SetDlgItemText(hWnd, IDC_EXPRESSION, assert_struct->m_Expression);
		SetDlgItemText(hWnd, IDC_FILE, assert_struct->m_FileName);		
		char line[100];
		sprintf(line, "%d", assert_struct->m_iLine);
		SetDlgItemText(hWnd, IDC_LINE, line);
		EnableWindow(GetDlgItem(hWnd, IDIGNOREALL), TRUE);
    
		return TRUE;
		};
	case WM_COMMAND:
		{
			switch(LOWORD(wParam))
			{
			case IDOK:
			case IDDEBUG:
			case IDABORT:
			case IDIGNOREALL:
			//case IDIGNOREFOREVER:
				EndDialog(hWnd, LOWORD(wParam));
				return TRUE;
			};
		};
		break;
    
	case WM_CLOSE:
		EndDialog(hWnd, IDOK);
		return TRUE;
	}

	return FALSE;
}

//====================================================================================
// Function name	: _assert_ex
// Description	    : 
// Return type		: bool 
// Argument         : char* in_Expression
// Argument         : char* in_FileName
// Argument         : int in_iLine
// Argument         : char* in_Info
// Argument         : bool* io_bDebug
//====================================================================================

bool _assert_ex(char* in_Expression, char* in_FileName, int in_iLine, char* in_Info)
{
  static std::vector<CIgnoreInfo> ignore;
  int res;
	
	char name[MAX_PATH];
	if ( !GetModuleFileName(NULL, name, MAX_PATH))
		strcpy(name, "<program name unknown>");
	
	CAssertStruct assert_struct;

	assert_struct.m_Expression = in_Expression;
	assert_struct.m_FileName   = in_FileName;
	assert_struct.m_iLine      = in_iLine;
	assert_struct.m_Info       = in_Info;
	assert_struct.m_Program    = name;

	for (int i = 0; i < (int)ignore.size(); i++)
	{
		if (ignore[i].m_sFileName == in_FileName && ignore[i].m_iLine == in_iLine)
			return false;
	}
	
  HWND hWnd = GetForegroundWindow(); //FIXME?!

  // Create a template in memory
  unsigned char pcTmp[1024];
  int iOff = 0;

  iOff += AddDialog(pcTmp, 13, L"Assertion", L"MS Sans Serif");

  // Buttons
  iOff += AddDlgBoxItem(pcTmp + iOff, WS_CAPTION | WS_VISIBLE | WS_CHILD | WS_TABSTOP | BS_DEFPUSHBUTTON, 
                        0, 28, 97, 50, 20,
                        IDOK, 0x0080, "OK");
  iOff += AddDlgBoxItem(pcTmp + iOff, WS_CAPTION | WS_VISIBLE | WS_CHILD | WS_TABSTOP | BS_PUSHBUTTON, 
                        0, 86, 97, 50, 20,
                        IDIGNOREALL, 0x0080, "&Ignore All");
  iOff += AddDlgBoxItem(pcTmp + iOff, WS_CAPTION | WS_VISIBLE | WS_CHILD | WS_TABSTOP | BS_PUSHBUTTON, 
                        0, 202, 97, 50, 20,
                        IDDEBUG, 0x0080, "&Debug");
  iOff += AddDlgBoxItem(pcTmp + iOff, WS_CAPTION | WS_VISIBLE | WS_CHILD | WS_TABSTOP | BS_PUSHBUTTON, 
                        0, 260, 97, 50, 20,
                        IDABORT, 0x0080, "&Abort");
  
  // Main text
  iOff += AddDlgBoxItem(pcTmp + iOff, WS_CHILD | WS_BORDER | WS_VISIBLE | WS_TABSTOP | ES_MULTILINE | ES_LEFT | ES_READONLY | ES_AUTOHSCROLL, 
                        0, 3, 12, 315, 12,
                        IDC_INFO, 0x0081, "");

  // Error info
  iOff += AddDlgBoxItem(pcTmp + iOff, WS_CHILD | WS_VISIBLE | SS_LEFT, 
                        0, 7, 35, 38, 8,
                        IDC_STATIC, 0x0082, "Program:");
  iOff += AddDlgBoxItem(pcTmp + iOff, WS_CHILD | WS_BORDER | WS_VISIBLE | WS_TABSTOP | ES_MULTILINE | ES_LEFT | ES_READONLY | ES_AUTOHSCROLL, 
                        0, 54, 33, 267, 12,
                        IDC_PROGRAM, 0x0081, "");

  iOff += AddDlgBoxItem(pcTmp + iOff, WS_CHILD | WS_VISIBLE | SS_LEFT, 
                        0, 7, 50, 38, 8,
                        IDC_STATIC, 0x0082, "Expression:");
  iOff += AddDlgBoxItem(pcTmp + iOff, WS_CHILD | WS_BORDER | WS_VISIBLE | WS_TABSTOP | ES_MULTILINE | ES_LEFT | ES_READONLY | ES_AUTOHSCROLL, 
                        0, 54, 48, 267, 12,
                        IDC_EXPRESSION, 0x0081, "");

  iOff += AddDlgBoxItem(pcTmp + iOff, WS_CHILD | WS_VISIBLE | SS_LEFT, 
                        0, 7, 65, 38, 8,
                        IDC_STATIC, 0x0082, "Source file:");
  iOff += AddDlgBoxItem(pcTmp + iOff, WS_CHILD | WS_BORDER | WS_VISIBLE | WS_TABSTOP | ES_MULTILINE | ES_LEFT | ES_READONLY | ES_AUTOHSCROLL, 
                        0, 54, 63, 267, 12,
                        IDC_FILE, 0x0081, "");
  
  iOff += AddDlgBoxItem(pcTmp + iOff, WS_CHILD | WS_VISIBLE | SS_LEFT, 
                        0, 7, 80, 38, 8,
                        IDC_STATIC, 0x0082, "Line:");
  iOff += AddDlgBoxItem(pcTmp + iOff, WS_CHILD | WS_BORDER | WS_VISIBLE | WS_TABSTOP | ES_MULTILINE | ES_LEFT | ES_READONLY | ES_AUTOHSCROLL, 
                        0, 54, 78, 267, 12,
                        IDC_LINE, 0x0081, "");

  // Show dilaog
	res = DialogBoxIndirectParam(NULL, (DLGTEMPLATE *)&pcTmp, 
                               hWnd, (DLGPROC) AssertDialogCallback, (LPARAM)&assert_struct);
	
  switch(res)
  {
    case IDABORT:
		  raise(SIGABRT);
		  _exit(3);
      break;
    case IDDEBUG:
		  return true;
    case IDOK:
		  return false;
    case IDIGNOREALL:      
	    {
		    CIgnoreInfo info;
		    info.m_sFileName = in_FileName;
		    info.m_sExpression = in_Expression;
		    info.m_sInfo = in_Info;
		    info.m_iLine = in_iLine;
		    ignore.push_back(info);

		    return false;        
      };
      break;

  };

	abort();
  return false;
}

//====================================================================================
// Function name	: _assert_trace
// Description	    : 
// Return type		: bool 
// Argument         : char* in_Expression
// Argument         : char* in_FileName
// Argument         : int in_iLine
// Argument         : char* in_Format
// Argument         : ...
//====================================================================================

bool _assert_trace(char* in_Expression, char* in_FileName, int in_iLine, char* in_Format, ...)
{
	va_list args;
	va_start(args, in_Format);

	char buffer[10024];
	buffer[0] = 0;
	_vsnprintf(buffer, sizeof(buffer), in_Format, args);
	bool res = _assert_ex(in_Expression, in_FileName, in_iLine, buffer);

	va_end(args);

	return res;
}
