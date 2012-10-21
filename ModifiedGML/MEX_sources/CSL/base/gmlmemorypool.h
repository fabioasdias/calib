#ifndef GMLMEMORYPOOL_H
#define GMLMEMORYPOOL_H


#include <map>
#include <string>

#ifndef GMLMEMORYPOOL_IMPL
namespace boost
{
 struct default_user_allocator_new_delete;

 template <typename UserAllocator = default_user_allocator_new_delete>
 class pool;
};
#endif

namespace gml
{

class Pool
{
  private:

   Pool(int iElemSize);

  public:

   void* Alloc();
   void Free(void* in_pObject);

   static Pool* FindPool(int iElemSize);

  private:

   typedef std::map<int, Pool* > PoolsMap;
   static PoolsMap s_pools;

   boost::pool<>* m_boost_pool;
};


};


#endif