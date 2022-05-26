#ifndef __FOO_DEVICE_MATRIX_H__
#define __FOO_DEVICE_MATRIX_H__

#include "foo-matrix.h"

namespace foo {

	class DeviceMatrix: public Matrix {
		
		private:
			
			void* p;
		
		public:
			
			DeviceMatrix(int row_count, int column_count);
			~DeviceMatrix();
			
			foo::DeviceMatrix operator*(foo::DeviceMatrix& m);
	
			void toDevice();
			void toHost();
			
	};

}


#endif
