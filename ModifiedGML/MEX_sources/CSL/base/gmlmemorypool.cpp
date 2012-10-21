#include "gmlcommon.h"

// boost includes
#include "../../sdk/boost_1_31_0/boost/pool/pool.hpp"

//#include "gmllog.h"

// own includes
#define GMLMEMORYPOOL_IMPL
#include "gmlmemorypool.h"


using namespace gml;

//LogFile s_Log("c:\\memorypool_log.txt");

//////////////////////////////////////////////////////////////////////////////
///
Pool::PoolsMap Pool::s_pools;

//////////////////////////////////////////////////////////////////////////////
///
Pool::Pool(int iElemSize)
{
  //s_Log.Log("New pool, elem size: %d", iElemSize);
  m_boost_pool = new boost::pool<>(iElemSize, 500);
  ASSERT(m_boost_pool);
}

//////////////////////////////////////////////////////////////////////////////
///
void* Pool::Alloc()
{
  return m_boost_pool->malloc();
}

//////////////////////////////////////////////////////////////////////////////
///
void Pool::Free(void* in_pObject)
{
  ASSERT(m_boost_pool);
  m_boost_pool->free(in_pObject);
}

//////////////////////////////////////////////////////////////////////////////
///
Pool* Pool::FindPool(int iElemSize)
{
  Pool* pPool = NULL;

  PoolsMap::iterator i = s_pools.find(iElemSize);
  if (i != s_pools.end())
    {
    pPool = (*i).second; // pool found
    return pPool;
    }


   // no such pool yet
   pPool = new Pool(iElemSize);
   s_pools[iElemSize] = pPool;

   return pPool;
 };

