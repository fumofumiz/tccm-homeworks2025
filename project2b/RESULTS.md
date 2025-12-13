

| dimension | CPU    | GPU   | CPU non parallel | CPU/GPU time |
| --------- | ------ | ----- | ---------------- | ------------ |
| 1000      | 0.041  | 0.198 | 0.485            | 0.208        |
| 2500      | 0.441  | 0.245 | 3.654            | 1.796        |
| 5000      | 2.333  | 0.387 | 12.553           | 6.024        |
| 10000     | 9.525  | 0.860 | 78.863           | 11.081       |
| 25000     | 59.264 | 2.917 | 595.154          | 20.318<br>   |



<img src="https://github.com/fumofumiz/tccm-homeworks2025/blob/master/project2b/results/execution_time_plot.png" width="750" />

In the table presented above, as well as in the Excel file available at the provided link, the execution time required to compute the dominant eigenvalue is reported for each of the three implementations as a function of the matrix dimension. 
The results directory contains the input files, the Excel file with the collected data, and the graph showing the trend of the CPU/GPU execution time ratio with respect to the matrix size.
From the results, it is evident that for small matrix dimensions (1000-2500), the CPU/GPU time ratio is less than 1. In this range of matrix size, GPU parallelization is not convenient since the trade-off is unfavorable, as the data transfers are more costly than the parallel speedup.
As the matrix dimension increases beyond approximately 2500, GPU acceleration becomes increasingly advantageous. For large matrices, the GPU implementation outperforms the CPU version, reaching a speedup of about 20x for the largest tested matrix size (25000).
Finally, the manual CPU implementation based on explicit loops is always the least efficient approach. In all tested cases, it is approximately one order of magnitude slower than the CPU version using optimized Fortran intrinsic functions (matmul and dot_product). 
