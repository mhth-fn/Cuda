#ifndef __FOO_CUDA_EXCEPT_H__
#define __FOO_CUDA_EXCEPT_H__

#include "foo-except.h"

namespace foo {

	class CUDAExcept: public Except {
	
		public:
			
			CUDAExcept(int err_code);
			
	};

}


#endif
