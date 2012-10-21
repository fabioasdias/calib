#ifndef _GML_RTTI_H_
#define _GML_RTTI_H_

#include <string.h>

namespace gml
	{
	
  /// A unique identifier of the plugin
  typedef char* InterfaceID;

  bool inline CompareInterfaces(const InterfaceID& i1, const InterfaceID& i2)
		{
		return ::strcmp(i1,i2) == 0;
		}
	

	
#define GML_RTTI(type, parent_type)\
  virtual inline gml::InterfaceID GetID() const {return type::ID();}\
  static inline gml::InterfaceID ID() {return (gml:: InterfaceID)(#type);} \
  virtual bool Implements(const gml::InterfaceID& type1)  const \
  {if (gml::CompareInterfaces(ID(), type1)) return true; \
   else return (parent_type::Implements(type1));}
	

#define GML_RTTI_BASE(type)\
  virtual inline gml::InterfaceID GetID()  const {return type::ID();}\
  static inline gml::InterfaceID ID() {return (gml::InterfaceID)(#type);} \
  virtual bool Implements(const gml::InterfaceID& type1)  const \
		{if (gml::CompareInterfaces(ID(), type1)) return true; return false;} 

	
	
template<class TARGET_CLASS, class SOURCE_CLASS> 
TARGET_CLASS* dyn_cast(SOURCE_CLASS* object)
	{
	if (!object)
		return NULL;

	if (object->Implements(TARGET_CLASS::ID()))
		return (TARGET_CLASS*)object;
	else
		return NULL;
	}


	}
#endif