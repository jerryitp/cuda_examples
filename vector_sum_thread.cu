#include <stdio.h>

#define N 10

__global__ void add(int *a, int *b, int *c)
{
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    
    while(tid < N)
    {
        c[tid] = a[tid] + b[tid];
        tid += blockDim.x * gridDim.x;
    }
}


int main(void)
{
    int a[N], b[N], c[N];
    int *dev_a, *dev_b, *dev_c;
    int i, x;

    cudaMalloc((void**)&dev_a,N*sizeof(int));
    cudaMalloc((void**)&dev_b,N*sizeof(int));
    cudaMalloc((void**)&dev_c,N*sizeof(int));
    

    for(i=0; i<N; i++)
    {
        a[i] = -i;
        b[i] = i * i;
    }

    cudaMemcpy(dev_a, a, N * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b, b, N * sizeof(int), cudaMemcpyHostToDevice);

    add<<<(N+127)/128, 128>>>(dev_a, dev_b, dev_c);

    cudaMemcpy(c, dev_c, N*sizeof(int), cudaMemcpyDeviceToHost); 

    for(x=0; x<N; x++)
    {
        printf("%d + %d = %d\n", a[x], b[x], c[x]);
    } 
    
    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_c);

    return 0;   

}