#RESULTS AND DISCUSSION


|           |            | Execution times |         |            | Ratios           |                  |
| --------- | ---------- | --------------- | ------- | ---------- | ---------------- | ---------------- |
| Dimension | Eigenvalue | CPUimp (s)      | GPU (s) | CPUexp (s) | CPUimp/GPU ratio | CPUexp/GPU ratio |
| 1000      | 1.990      | 0.757           | 0.756   | 6.217      | 1.001            | 8.222            |
| 2500      | 1.990      | 6.886           | 1.155   | 52.320     | 5.962            | 45.301           |
| 5000      | 1.990      | 38.208          | 3.271   | 211.361    | 11.681           | 64.616           |
| 10000     | 1.990      | 130.119         | 3.530   | 1343.781   | 36.856           | 380.625          |
| 25000     | 1.990      | 1047.822        | 14.305  | 10528.555  | 73.248           | 735.993          |


<img src="https://github.com/fumofumiz/tccm-homeworks2025/blob/master/project2b/results/execution_time_plot.png" width="750" />

In the table presented above, as well as in the Excel file available at the provided link, the execution time required to compute the dominant eigenvalue is reported for each of the three implementations as a function of the matrix dimension. 
CPUimp refers to CPU implementation that uses fortran functions, CPUexp refers to the CPU implementation that uses explicit nested loops.

The results were obtained with a maximum number of iterations of 10000 and an error threshold of 0.01, they could probably be improved with some tuning, but that wasn't the point of this project. Since the initial vector is generated randomly the results may differ between two different systems. The eigenvalue obtained is, however, independent from the initial point.  
 
The results/ directory contains the input files, the Excel file with the collected data, and the graph showing the trend of the CPU/GPU execution time ratio with respect to the matrix size.
From the results, it is evident that for small matrix dimensions (1000-2500), the CPU/GPU time ratio is less than 1. In this range of matrix size, GPU parallelization is not convenient since the trade-off is unfavorable, as the data transfers are more costly than the parallel speedup.
As the matrix dimension increases beyond approximately 2500, GPU acceleration becomes increasingly advantageous. For large matrices, the GPU implementation outperforms the CPU version, reaching a speedup of about 20x for the largest tested matrix size (25000).
Finally, the manual CPU implementation based on explicit loops is always the least efficient approach. In all tested cases, it is approximately one order of magnitude slower than the CPU version using optimized Fortran intrinsic functions (matmul and dot_product). 
