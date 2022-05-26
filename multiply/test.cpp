#include <mpi.h>
#include <iostream>

#include "foo.h"

void print_matrix(foo::Matrix& m) {
	
	int i = 0;
	int j = 0;
	
	for (i = 0; i < m.getRowCount(); i++) {
		
		for (j = 0; j < m.getColumnCount(); j++) {
			
			std::cout << m[i][j] << " ";
		}
		
		std::cout << std::endl;
	}

}

int main(int argc, char** argv) {
	
	MPI_Init(&argc, &argv);
	
	foo::Profiler profiler;
	
	foo::DeviceMatrix m(1024, 1024);
	foo::HostMatrix h(1024, 1024);
	foo::ShareMatrix ss(1024);
	
	m.setProfiler(profiler); 
	h.setProfiler(profiler);
	ss.setProfiler(profiler);

		int i = 0;
		int j = 0;

		for (i = 0; i < m.getRowCount(); i++) {
		
			for (j = 0; j < m.getColumnCount(); j++) {
			
				m[i][j] = 1.0;
				h[i][j] = 1.0;
				ss[i][j] = 1.0;
			}
		}
	
		foo::DeviceMatrix test1 = m*m;
		std::cout << "cuda time: " << profiler.getValue() << std::endl;
		
		m.toHost();
		
		foo::ShareMatrix test3 = ss*ss;
		std::cout << "share time: " << profiler.getValue() << std::endl;
		
	
		foo::HostMatrix test2 = h*h;
		std::cout << "host time: " << profiler.getValue() << std::endl;
	

	MPI_Finalize();

	return 0;
}
