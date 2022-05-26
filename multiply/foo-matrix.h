#ifndef _FOO_MATRIX_H_
#define _FOO_MATRIX_H_

#include "foo-matrix-row.h"
#include "foo-profiler.h"

namespace foo {
	
	class Matrix {
		
		protected:
			
			double* data;
			MatrixRow* rows;
			
			int count_column;
			int count_row;
			
			Profiler* profiler;
			
			void init();
			
		public:
			
			Matrix();
			~Matrix();
			
			int getColumnCount();
			int getRowCount();
			
			void setProfiler(foo::Profiler& prof);
			
			foo::MatrixRow& operator[](int index);
	};

} 


#endif
