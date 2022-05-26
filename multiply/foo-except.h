#ifndef __FOO_EXCEPT_H__
#define __FOO_EXCEPT_H__

namespace foo {

	class Except {
	
		protected:
			
			int error_code;
		
		public:
			
			bool match(int err_code);
			int getErrorCode();
		
	};
}


#endif
