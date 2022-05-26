#include "foo-except.h"

bool foo::Except::match(int err_code) {
	
	return (this->error_code == err_code);
}

int foo::Except::getErrorCode() {
	
	return (this->error_code);

}
