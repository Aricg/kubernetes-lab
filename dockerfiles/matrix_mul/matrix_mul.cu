#include <stdio.h>
#include <cuda_runtime.h>

const int N = 256;  // size of the square matrix

__global__ void matrixMul(int *a, int *b, int *c) {
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    int sum = 0;
    for (int i = 0; i < N; i++) {
        sum += a[row * N + i] * b[i * N + col];
    }
    c[row * N + col] = sum;
}

int main() {
    int *h_a, *h_b, *h_c;  // host matrices
    int *d_a, *d_b, *d_c;  // device matrices

    size_t size = N * N * sizeof(int);

    // Allocate space on the host
    h_a = (int *)malloc(size);
    h_b = (int *)malloc(size);
    h_c = (int *)malloc(size);

    // Initialize matrices
    for (int i = 0; i < N * N; i++) {
        h_a[i] = rand() % 1024;
        h_b[i] = rand() % 1024;
    }

    // Allocate space on the device
    cudaMalloc((void **)&d_a, size);
    cudaMalloc((void **)&d_b, size);
    cudaMalloc((void **)&d_c, size);

    // Copy host matrices to device
    cudaMemcpy(d_a, h_a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b, size, cudaMemcpyHostToDevice);

    dim3 threadsPerBlock(N, N);
    dim3 numBlocks(1, 1);
    matrixMul<<<numBlocks, threadsPerBlock>>>(d_a, d_b, d_c);

    // Copy result matrix back to host
    cudaMemcpy(h_c, d_c, size, cudaMemcpyDeviceToHost);

    // Print a few results
    printf("Sample results:\n");
    for (int i = 0; i < 10; i++) {
        printf("%d ", h_c[i]);
    }
    printf("\n");

    // Cleanup
    free(h_a);
    free(h_b);
    free(h_c);
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    return 0;
}

