
test: test.o foo-matrix.o foo-matrix-row.o foo-host-matrix.o \
      foo-device-matrix.o foo-profiler.o foo-except.o \
      foo-matrix-except.o foo-cuda-except.o foo-share-matrix.o
	@echo "Build $@"
	@mpicc $^ -L/common/cuda/lib64 -lcudart -o $@

foo-except.o: foo-except.cpp
	@echo "Compile $@"
	@mpicc -c $^

foo-matrix-except.o: foo-matrix-except.cpp
	@echo "Compile $@"
	@mpicc -c $^

foo-cuda-except.o: foo-cuda-except.cpp
	@echo "Compile $@"
	@mpicc -c $^

test.o: test.cpp
	@echo "Compile $@"
	@mpicc -c $^

foo-matrix.o: foo-matrix.cpp
	@echo "Compile $@"
	@mpicc -c $^

foo-matrix-row.o: foo-matrix-row.cpp
	@echo "Compile $@"
	@mpicc -c $^
	
foo-host-matrix.o: foo-host-matrix.cpp
	@echo "Compile $@"
	@mpicc -c $^
	
foo-profiler.o: foo-profiler.cpp
	@echo "Compile $@"
	@mpicc -c $^


foo-device-matrix.o: foo-device-matrix.cu
	@echo "Compile $@"
	@nvcc -c $^ -arch sm_13

foo-share-matrix.o: foo-share-matrix.cu
	@echo "Compile $@"
	@nvcc -c $^ -arch sm_13
