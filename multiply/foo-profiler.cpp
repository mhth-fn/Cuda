#include <mpi.h>

#include "foo-profiler.h"

void foo::Profiler::start() {
	
	this->time_value = MPI_Wtime();

}

void foo::Profiler::stop() {
	
	this->time_value = MPI_Wtime() - this->time_value;

}

double foo::Profiler::getValue() {
	
	return this->time_value;
}
