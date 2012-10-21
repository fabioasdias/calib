//
//  GMlib -- Graphics & Media Lab Common Source Library
//
//  $Id:
//
//  Copyright (C) 2004, Moscow State University Graphics & Media Lab
//  gmlsupport@graphics.cs.msu.su
//  
//  This file is part of GMlib software.
//  For conditions of distribution and use, see the accompanying README file.

#include "gmllog.h"
#include "gmlstring.h"

#include <stdio.h>
#include <stdarg.h>

#ifndef __BORLANDC__
#else
#include <vcl.h>
#endif
using gml::LogFile;

LogFile::LogFile (std::string in_sLogFileName)
  : m_LogFileName(""),
    m_LogFile(NULL)
{
  m_LogFileName = in_sLogFileName;

  // открытие файла на запись (заодно очищение)
  m_LogFile = fopen(m_LogFileName.c_str(), "w");
  fclose(m_LogFile);
}

void LogFile::Log(const char* pstrFormat, ...)
{
  // format and write the data we were given
  va_list args;
  va_start(args, pstrFormat);

  gml::String str;
  str.FormatV(pstrFormat, args);
  va_end(args);
  int StrLength = str.length();
  const char* Buffer = str.c_str();

  // запись в файл
  m_LogFile = fopen(m_LogFileName.c_str(), "a+");
  fwrite(Buffer, StrLength, 1, m_LogFile);
  fwrite("\n", 1, 1, m_LogFile);
  fclose(m_LogFile);

  return;
}

#ifdef __BORLANDC__
#pragma package(smart_init)
#endif
