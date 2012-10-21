#ifndef _TIMER_H_
#define _TIMER_H_

namespace gml
  {
  /// Implements system timer wrapper
  class Timer 
    {
    private:
      Timer();
      
    public:
      
      /// Time in ticks
      double GetTime() const;
      
      /// Time in milliseconds
      double GetTimeMS() const;

      /// CPU ticks frequency
      double GetFrequency() const
        { return frequency; }
      
      /// Return single static timer instance
      static Timer& SystemTimer();
 
      inline double Ms2Ticks(double ms) const
        { return ms*GetFrequency()/1000.0; }
      
      inline double Ticks2Ms(double ticks) const
        { return ticks*1000.0/GetFrequency(); }
      
    private:

      int using_mm;
      double frequency;
      
    };
 
  
  
  }
#endif 