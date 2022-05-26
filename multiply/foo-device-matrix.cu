
#include "foo-device-matrix.h"

#include "foo-cuda-except.h"

#ifndef FOO_DEVICE_MATRIX_BLOCK_SIZE
#define FOO_DEVICE_MATRIX_BLOCK_SIZE 512
#endif

#ifndef FOO_DEVICE_MATRIX_BLOCK_WIDTH
#define FOO_DEVICE_MATRIX_BLOCK_WIDTH 16
#endif

#ifndef FOO_DEVICE_MATRIX_BLOCK_HEIGHT
#define FOO_DEVICE_MATRIX_BLOCK_HEIGHT 16
#endif

#if FOO_DEVICE_MATRIX_BLOCK_WIDTH*FOO_DEVICE_MATRIX_BLOCK_HEIGHT > FOO_DEVICE_MATRIX_BLOCK_SIZE
#error GPU block size need to less or equal 512 items 
#endif

static __global__ void foo_device_matrix_dot_kernel(void* _C, void* _A, void* _B, int rowc, int colc, int rc) {
		
		int j = blockIdx.x*blockDim.x + threadIdx.x;
		int i = blockIdx.y*blockDim.y + threadIdx.y;
		int r;
		
		double* C = (double*) _C;
		double* B = (double*) _B;
		double* A = (double*) _A;
		
		if ((i < rowc) && (j < colc)) {
			
			C[i*colc + j] = 0.0f;
			
			for (r = 0; r < rc; r++) {
				
				C[i*colc + j] = C[i*colc + j] + A[i*rc + r]*B[r*colc + j];
			}
		}
}

foo::DeviceMatrix::DeviceMatrix(int row_count, int column_count) {
	
	this->count_row = row_count;
	this->count_column = column_count;
	
	(*this).init();
	
	this->p = nullptr;
}

foo::DeviceMatrix::~DeviceMatrix() {
	
	cudaError_t err = cudaSuccess;
	
	if (this->p != nullptr) {
		
		err = cudaFree(this->p);
		
		if (err != cudaSuccess) {
			
			throw CUDAExcept(err);
		}
		
		this->p = nullptr;
	}

}

void foo::DeviceMatrix::toDevice() {
	
	cudaError_t err = cudaSuccess;
	
	if (this->p == nullptr) {
		
		err = cudaMalloc(&(this->p), 
				         (this->count_column)*(this->count_row)*sizeof(double));
				         
		if (err != cudaSuccess) {
			
			throw CUDAExcept(err);
		}
		
		err = cudaMemcpy(this->p, 
					     (void*) this->data, 
						 (this->count_column)*(this->count_row)*sizeof(double),
						  cudaMemcpyHostToDevice);
	
		if (err != cudaSuccess) {
			
			throw CUDAExcept(err);
		}
	}

}


void foo::DeviceMatrix::toHost() {
	
	cudaError_t err = cudaSuccess;
	
	if (this->p != nullptr) {
		
		err = cudaMemcpy((void*) this->data, 
					      this->p, 
						 (this->count_column)*(this->count_row)*sizeof(double),
						  cudaMemcpyDeviceToHost);
		
		if (err != cudaSuccess) {
			
			throw CUDAExcept(err);
		}
		
		err = cudaFree(this->p);
		
		if (err != cudaSuccess) {
			
			throw CUDAExcept(err);
		}
		
		this->p = nullptr;
	}
}

foo::DeviceMatrix foo::DeviceMatrix::operator*(foo::DeviceMatrix& m) {
	
		
		DeviceMatrix res(this->count_row, m.count_column);
	
		if (this->p == nullptr) {
		
			(*this).toDevice();
		}
	
		if (m.p == nullptr) {
		
			m.toDevice();
		}
	
		res.toDevice();
	
		int block_count_x, block_count_y;

		block_count_x = res.count_column/FOO_DEVICE_MATRIX_BLOCK_WIDTH +
						((res.count_column % FOO_DEVICE_MATRIX_BLOCK_WIDTH != 0)? 1: 0);
	
		block_count_y = res.count_row/FOO_DEVICE_MATRIX_BLOCK_HEIGHT +
						((res.count_row % FOO_DEVICE_MATRIX_BLOCK_HEIGHT != 0)? 1: 0);

	
		dim3 grid_size(block_count_x, block_count_y, 1);
		dim3 block_size(FOO_DEVICE_MATRIX_BLOCK_WIDTH, FOO_DEVICE_MATRIX_BLOCK_HEIGHT, 1);
	
		if (this->profiler != nullptr) {
		
			(*(this->profiler)).start();
		}
	
		foo_device_matrix_dot_kernel <<<grid_size, block_size>>>(res.p,
																 this->p,
	                                                             m.p,
	                                                             res.count_row,
	                                                             res.count_column,
	                                                             this->count_column);
		cudaThreadSynchronize();
	
		if (this->profiler != nullptr) {
		
			(*(this->profiler)).stop();
		}
	
		res.toHost();
	
		return res;
	
}

