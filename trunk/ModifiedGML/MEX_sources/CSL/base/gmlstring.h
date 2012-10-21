//
//  GMlib -- Graphics & Media Lab Common Source Library
//
//  $Id: gmlstring.h,v 1.9 2004/10/15 09:30:42 leo Exp $
//
//  Copyright (C) 2004, Moscow State University Graphics & Media Lab
//  gmlsupport@graphics.cs.msu.su
//  
//  This file is part of GMlib software.
//  For conditions of distribution and use, see the accompanying README file.

#ifndef _GMLSTRING_H_INCLUDED 
#define _GMLSTRING_H_INCLUDED 

/** @file gmlstring.h
 *  @brief defines gml::String
 */

#include <string>

#ifdef GML_USE_MFC
#include <afxwin.h>
#endif

namespace gml
{
  /** @addtogroup Base
   *  @{
   */

  using std::string;

  /// Standard string with some extensions
  /** @note use it instead of std::string
   *  @warning If you wish to make classes derived from String (or std::string) please
   *           be careful NOT no provide own destructor. This is so because the base class
   *           std::string has no virtual destructor and in case of addressing via
   *           pointer to the base class destructor of derived class will not be called!
   */
  class String : public string
  {
    public:
      /// @name Standard constructors (the same as in std::string)
      //@{

      /// Empty string
      String() : string()
      {
      }

      /// Copy constructor
      String(const string& rhs) : string(rhs)
      {
      }

      /// Constructor from substring
      /** @param rhs is a source string
       *  @param pos is a start position
       *  @param n is number of characters
       */
      String(const string& rhs, size_type pos, size_type n) : string(rhs,
                                                                     pos,
                                                                     n)
      {
      }

      /// From N characters of C string
      String(const char* s, size_type n) : string(s, n)
      {
      }

      /// From C string
      String(const char* s) : string(s)
      {
      }

      /// A sequence of n chars
      String(size_type n, char c) : string(n, c)
      {
      }

      /// two iterators point to a some string of list of chars
      String(const_iterator first, const_iterator last) : string(first, last)
      {
      }
      //@}

      //! @name MFC, VCL - specific functions (use defines to enable them)
      //@{


#ifdef GML_USE_MFC
      /// Conversion to MFC string
      /** @note works only if GML_USE_MFC is defined
       */
      CString AsCString() const
      {
        return CString(c_str());
      }

#endif
      //@}

      /// @name Utility functions
      //@{

      /// To integer
      /** @return return 0 if the input cannot be converted to a value of that type
       */
      int AsInt() const
      {
        return atoi(c_str());
      }

      /// To double
      /** @return return 0.0 if the input cannot be converted to a value of that type
       */
      double AsDouble() const
      {
        return atof(c_str());
      }


      /// write a formatted string and a variable list of arguments to this object
      void Format(const char* format, ...);
      /// write a formatted string and a variable list of arguments to this object
      void FormatV(const char* format, va_list arglist);


      //@}

      /// @name Unicode stuff
      //@{

// the Unicode stuff below seems to be not compilable under damn CBuilder... :AI
#if !defined(__BORLANDC__)
      static std::basic_string<wchar_t> ToUnicode(const std::string& src, int codepage = 0);
      static std::string                FromUnicode(const std::basic_string<wchar_t>& src, int codepage = 0);
#endif
      //@}

    private:

      int GuessMaxFormattedLen(const char* format_str, va_list arglist);
  };

  
  /** @} */
}


#endif