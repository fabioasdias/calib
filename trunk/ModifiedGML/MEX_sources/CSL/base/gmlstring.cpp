//
//  GMlib -- Graphics & Media Lab Common Source Library
//
//  $Id: gmlstring.cpp,v 1.17 2004/11/11 19:26:32 leo Exp $
//
//  Copyright (C) 2004, Moscow State University Graphics & Media Lab
//  gmlsupport@graphics.cs.msu.su
//  
//  This file is part of GMlib software.
//  For conditions of distribution and use, see the accompanying README file.

// gml includes
#include "gmlcommon.h"
#include "gmlstring.h"
//#include "../math/gmlmath.h" // dont include math, 'cause base does not depend on it

#include <stdio.h> 
#include <stdarg.h>

#include <windows.h>

#ifdef _MSC_VER

#include <utility>

#define min std::_cpp_min
#define max std::_cpp_max

#endif

using namespace gml;


void String::Format(const char* format, ...)
{
  va_list params;

  va_start(params, format); // Initialize variable arguments

  FormatV(format, params);

  va_end(params);            // Reset variable arguments. 
};

void String::FormatV(const char* format, va_list arglist)
{
  int len = GuessMaxFormattedLen(format, arglist);
  char* new_str = new char[len + 1];

  int char_written = vsprintf(new_str, format, arglist); 
  ASSERT(char_written <= len);
  *this = new_str;
  delete[] new_str;
};



// -----------------------------------------------------------------
// Private functions
// -----------------------------------------------------------------


// taken from MFC's CString implementation  (UNICODE and INT64 eliminated)
// now does not require any MFC includes

int String::GuessMaxFormattedLen(const char* format_str, va_list arglist)
{
  // make a guess at the maximum length of the resulting string
  int nMaxLen = 0;
  for (const char*lpsz = format_str; *lpsz != '\0'; ++lpsz)
  {
    // handle '%' character, but watch out for '%%'
    if (*lpsz != '%' || *(++lpsz) == '%')
    {
      nMaxLen += strlen(lpsz);
      continue;
    }

    int nItemLen = 0;

    // handle '%' character with format
    int nWidth = 0;
    for (; *lpsz != '\0'; ++lpsz)
    {
      // check for valid flags
      if (*lpsz == '#')
        nMaxLen += 2;   // for '0x'
      else if (*lpsz == '*')
        nWidth = va_arg(arglist, int);
      else if (*lpsz == '-' || *lpsz == '+' || *lpsz == '0' || *lpsz == ' ')
        ;
      else // hit non-flag character
        break;
    }
    // get width and skip it
    if (nWidth == 0)
    {
      // width indicated by
      nWidth = atoi(lpsz);
      for (; *lpsz != '\0' && isdigit(*lpsz); ++lpsz)
        ;
    }
    ASSERT(nWidth >= 0);

    int nPrecision = 0;
    if (*lpsz == '.')
    {
      // skip past '.' separator (width.precision)
      ++lpsz;

      // get precision and skip it
      if (*lpsz == '*')
      {
        nPrecision = va_arg(arglist, int);
        ++lpsz;
      }
      else
      {
        nPrecision = atoi(lpsz);
        for (; *lpsz != '\0' && isdigit(*lpsz); ++lpsz)
          ;
      }
      ASSERT(nPrecision >= 0);
    }

    // now should be on specifier
    switch (*lpsz)
    {
        // single characters
      case 'c':
      case 'C':
        nItemLen = 2;
        va_arg(arglist, char);
        break;

        // strings
      case 's':
      case 'S':
        {
          const char* pstrNextArg = va_arg(arglist, const char*);
          if (pstrNextArg == NULL)
            nItemLen = 6;  // "(null)"
          else
          {
            nItemLen = strlen(pstrNextArg);
            nItemLen = max(1, nItemLen);
          }
        }
        break;
    }  

    // adjust nItemLen for strings
    if (nItemLen != 0)
    {
      if (nPrecision != 0)
        nItemLen = min(nItemLen, nPrecision);
      nItemLen = max(nItemLen, nWidth);
    }
    else
    {
      switch (*lpsz)
      {
          // integers
        case 'd':
        case 'i':
        case 'u':
        case 'x':
        case 'X':
        case 'o':
          va_arg(arglist, int);
          nItemLen = 32;
          nItemLen = max(nItemLen, nWidth + nPrecision);
          break;

        case 'e':
        case 'g':
        case 'G':
          va_arg(arglist, double);
          nItemLen = 128;
          nItemLen = max(nItemLen, nWidth + nPrecision);
          break;

        case 'f':
          {
            double f;
            char* pszTemp = NULL;

            // 312 == strlen("-1+(309 zeroes).")
            // 309 zeroes == max1 precision of a double
            // 6 == adjustment in case precision is not specified,
            //   which means that the precision defaults to 6
            pszTemp = (char *) malloc(max(nWidth, 312 + nPrecision + 6));

            f = va_arg(arglist, double);
            sprintf(pszTemp, "%*.*f", nWidth, nPrecision + 6, f);
            nItemLen = strlen(pszTemp);
            free(pszTemp);
          }
          break;

        case 'p':
          va_arg(arglist, void *);
          nItemLen = 32;
          nItemLen = max(nItemLen, nWidth + nPrecision);
          break;

          // no output
        case 'n':
          va_arg(arglist, int *);
          break;

        default:
          ASSERT(false);  // unknown formatting option
      }
    }

    // adjust nMaxLen for output nItemLen
    nMaxLen += nItemLen;
  }
  return nMaxLen;
}



#if !defined(__BORLANDC__)
//////////////////////////////////////////////////////////////////////////////
  ///
  std::basic_string<wchar_t> String::ToUnicode(const std::string& src, int codepage)
    {
    // find the size of the buffer
    int buffer_size = MultiByteToWideChar(codepage, MB_PRECOMPOSED, src.c_str(), -1, NULL, 0);
    // create the buffer
    wchar_t* str = new wchar_t[buffer_size + 1];
    int res = MultiByteToWideChar(codepage, MB_PRECOMPOSED, src.c_str(), -1, str, buffer_size);
    ASSERT(res);
    
    std::basic_string<wchar_t> out_str = str;
    delete[] str;
    
    return out_str;
    }
  
  //////////////////////////////////////////////////////////////////////////////
  ///
  std::string String::FromUnicode(const std::basic_string<wchar_t>& src, int codepage)
    {
    // find the size of the buffer
    int buffer_size = WideCharToMultiByte(codepage, 0, src.c_str(), -1, NULL, NULL, NULL, NULL);
    // create the buffer
    char* str = new char[buffer_size + 1];
    int res = WideCharToMultiByte(codepage, 0, src.c_str(), -1, str, buffer_size, NULL, NULL);
    ASSERT(res);
    
    std::string out_str = str;
    delete[] str;
    
    return out_str;
    }

#endif