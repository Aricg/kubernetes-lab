#FROM nvidia/cuda:11.0-base
FROM nvidia/cuda:12.2.0-devel-ubuntu20.04

WORKDIR /usr/src/app

# Copy CUDA matrix multiplication code
COPY matrix_mul.cu .

# Install minimal dependencies
#RUN apt-get update && apt-get install -y \
#  cuda-samples-11-0 \
#  && rm -rf /var/lib/apt/lists/*

# Compile the CUDA code
RUN nvcc matrix_mul.cu -o matrix_mul

CMD ["./matrix_mul"]
