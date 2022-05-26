#ifndef __FOO_PROFILER_H__
#define __FOO_PROFILER_H__

namespace foo {

	class Profiler {
	
		private:
			
			double time_value;
		
		public:
			
			void start();
			void stop();
			double getValue();
	
	};


}


#endif
