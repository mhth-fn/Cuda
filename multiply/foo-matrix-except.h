#ifndef __FOO_MATRIX_EXCEPT_H__
#define __FOO_MATRIX_EXCEPT_H__

#include "foo-except.h"

namespace foo {

	class MatrixExcept: public Except {
	
		public:
			
			typedef enum {
				
				ERROR_INVALID_ROW_INDEX,
				ERROR_INVALID_COLUMN_INDEX
				
			} MatrixExceptCode;
			
			MatrixExcept(foo::MatrixExcept::MatrixExceptCode err_code);
	
	};


}


#endif
