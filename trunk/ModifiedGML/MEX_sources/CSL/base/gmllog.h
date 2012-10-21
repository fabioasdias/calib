//---------------------------------------------------------------------------

#ifndef _GML_LOG_H_
#define _GML_LOG_H_

#include <string>
#include "stdio.h"
#include "gmlsmartobject.h"

namespace gml
{
  class LogFile : public SmartObject
  {
  public:
    LogFile(std::string in_sLogFileName);
    void Log(const char* pstrFormat, ...);

  private:
    FILE* m_LogFile;
    std::string m_LogFileName;
  };
}

/*
#ifdef _DEBUG
static gml::Ref<LogFile> g_refLogFile;

inline void CREATELOG(const char* in_psFilename)
{
  g_refLogFile = new gml::LogFile(in_psFilename);
}

inline void LOG(const char* in_sString, ...)
{
  g_refLogFile->Log()
}
#else
 #define CREATELOG()
 #define LOG()
#endif
*/

#endif
