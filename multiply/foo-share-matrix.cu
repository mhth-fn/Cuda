
#include "foo-share-matrix.h"

#include "foo-cuda-except.h"

#ifndef FOO_SHARE_MATRIX_BLOCK_LEN
#define FOO_SHARE_MATRIX_BLOCK_LEN 16
#endif


static __global__ void foo_share_matrix_dot_kernel(void* _C, void* _A, void* _B, int matrix_len) {
		
		double* C = (double*) _C;
		double* B = (double*) _B;
		double* A = (double*) _A;
		
		int b_row = blockIdx.y;
		int b_col = blockIdx.x;
		
		double* Cs = &(C[matrix_len*b_row*FOO_SHARE_MATRIX_BLOCK_LEN + 
		                 b_col*FOO_SHARE_MATRIX_BLOCK_LEN]);
		double Cval = 0.0;
		
		int t_row = threadIdx.y;
		int t_col = threadIdx.x;
		
		int m = 0;
		int r = 0;
		
		for (m = 0; m < (matrix_len/FOO_SHARE_MATRIX_BLOCK_LEN); m++) {
			
			double* As = &(A[matrix_len*b_row*FOO_SHARE_MATRIX_BLOCK_LEN + 
			                 m*FOO_SHARE_MATRIX_BLOCK_LEN]);
			                 
			double* Bs = &(B[matrix_len*m*FOO_SHARE_MATRIX_BLOCK_LEN + 
			                 b_col*FOO_SHARE_MATRIX_BLOCK_LEN]); 
			
			__shared__ double Ash[FOO_SHARE_MATRIX_BLOCK_LEN][FOO_SHARE_MATRIX_BLOCK_LEN];
			__shared__ double Bsh[FOO_SHARE_MATRIX_BLOCK_LEN][FOO_SHARE_MATRIX_BLOCK_LEN];
			
			Ash[t_row][t_col] = As[t_row*matrix_len + t_col];
			Bsh[t_row][t_col] = Bs[t_row*matrix_len + t_col];
			
			__syncthreads();
			
			for (r = 0; r < FOO_SHARE_MATRIX_BLOCK_LEN; r++) {
				
				Cval+= Ash[t_row][r]*Bsh[r][t_col];
			}
			
			__syncthreads();				
	    }
		
		Cs[t_row*matrix_len + t_col] = Cval;
}


foo::ShareMatrix::ShareMatrix(int matrix_len) {
	
	this->count_row = matrix_len;
	this->count_column = matrix_len;
	
	(*this).init();
	
	this->p = nullptr;
}

foo::ShareMatrix::~ShareMatrix() {
	
	cudaError_t err = cudaSuccess;
	
	if (this->p != nullptr) {
		
		err = cudaFree(this->p);
		
		if (err != cudaSuccess) {
			
			throw CUDAExcept(err);
		}
		
		this->p = nullptr;
	}

}

void foo::ShareMatrix::toDevice() {
	
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


void foo::ShareMatrix::toHost() {
	
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


foo::ShareMatrix foo::ShareMatrix::operator*(foo::ShareMatrix& m) {
	
		
		ShareMatrix res(this->count_row);
	
		if (this->p == nullptr) {
		
			(*this).toDevice();
		}
	
		if (m.p == nullptr) {
		
			m.toDevice();
		}
	
		res.toDevice();
	
		dim3 grid_size(this->count_column/FOO_SHARE_MATRIX_BLOCK_LEN,
		               this->count_row/FOO_SHARE_MATRIX_BLOCK_LEN, 1);
		               
		dim3 block_size(FOO_SHARE_MATRIX_BLOCK_LEN, FOO_SHARE_MATRIX_BLOCK_LEN, 1);

		if (this->profiler != nullptr) {
		
			(*(this->profiler)).start();
		}
	
		foo_share_matrix_dot_kernel <<<grid_size, block_size>>>(res.p,
																this->p,
	                                                            m.p,
	                                                            res.count_row);
		//Ждем когда все потоки закончат заполнение 
		cudaThreadSynchronize();
	
		if (this->profiler != nullptr) {
		
			(*(this->profiler)).stop();
		}
	
		res.toHost();
	
		return res;
	
}
