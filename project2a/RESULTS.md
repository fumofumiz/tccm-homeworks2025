## TIMING AND PERFORMANCE ANALYSIS

The execution time required by the program to perform matrix–matrix multiplications was
measured for three different methods: dense matrix multiplication using **DGEMM**, dense
matrix multiplication using a **hand-written routine**, and **sparse matrix multiplication**.
All timing measurements were performed on the same machine in order to ensure that the
execution times are directly comparable. The multiplication methods were repeated **100
times in a loop** in order to record measurable times.
It is possible to consult the data in the Excel file in the `RESULTS/` directory, called 
`results_mult.xlsx`.


## PROFILING AND SCALING ANALYSIS 

## MATRIX FILLING RATE

**Table 1.** reports representative execution times for fixed matrix dimensions (N=125)
and varying filling rates. The table illustrates the type of data contained in the Excel
file in the `RESULTS/` directory, called `results_mult.xlsx`. It includes only a subset of
the full dataset, which is sufficient to produce the plot discussed below.

### Table 1 – Execution times for fixed matrix size and varying filling

| dimension |    dgemm |   manual |     sparse | filling |
| --------: | -------: | -------: | ---------: | ------: |
|       125 | 0.116411 | 0.772696 |   6.08E−02 |       2 |
|       125 | 0.116532 | 0.772337 |   0.256631 |       5 |
|       125 | 0.116041 | 0.772230 |   0.862849 |      10 |
|       125 | 0.116159 | 0.772004 |   4.412728 |      25 |
|       125 | 0.117361 | 0.774304 |  16.903868 |      50 |


**Figure 1.** Execution time as a function of the matrix filling for a fixed matrix dimension  
\( N = 125 \).

<img src="https://github.com/fumofumiz/tccm-homeworks2025/blob/master/project2a/RESULTS/MATRIX_FILLING(n%3D125)_logaritmic.png" width="750" />

The vertical axis is shown on a logarithmic scale. DGEMM and the manual dense
implementation exhibit an almost filling-independent execution time over the explored
range. This behavior reflects the fact that, for dense algorithms, the computational cost
is dominated by full matrix–matrix operations and is therefore essentially independent of
the actual number of non-zero elements.

In contrast, the sparse matrix multiplication shows a pronounced dependence on the filling
factor. As the filling increases, the matrix progressively loses its sparsity and the
number of required operations grows rapidly, leading to a marked increase in execution
time. This trend is compatible with a power-law–like scaling, as indicated by the high
\( R^2 \) value obtained from the fit in the logarithmic representation. Conversely, the low
\( R^2 \) values found for the dense methods confirm the absence of a meaningful dependence
on the filling factor.

---

### MATRIX SIZE

The dependence of the execution time on the matrix size was analyzed. Here is shown the case
by keeping the filling fixed at **2%** and varying the matrix dimension. The data used for this analysis 
are reported in Table 2 and consists on a representative sample for what is find in the excel file.

**Table 2** – Execution times for varying matrix size at fixed filling (2%)

| dimension |    dgemm |     manual |     sparse | filling |
| --------: | -------: | ---------: | ---------: | ------: |
|        12 | 1.46E−04 |   7.72E−04 |   9.70E−05 |       2 |
|        25 | 1.09E−03 |   6.08E−03 |   5.86E−04 |       2 |
|        50 | 8.43E−03 |   4.80E−02 |   3.13E−03 |       2 |
|        75 | 3.12E−02 |   0.169522 |   1.02E−02 |       2 |
|       125 | 0.116411 |   0.772696 |   6.08E−02 |       2 |
|       250 | 0.901165 |   6.468384 |   0.710542 |       2 |
|       500 |        8 |  77.009439 |   8.305124 |       2 |
|       750 |       63 | 569.562869 |  38.154346 |       2 |
|       999 |       86 | 1782.98178 | 116.863993 |       2 |


**Figure 2.** Execution time as a function of the matrix dimension at fixed filling (2%),
shown on a logarithmic scale.

<img src="https://github.com/fumofumiz/tccm-homeworks2025/blob/master/project2a/RESULTS/MATRIX_SIZE(FILLING%3D2)_logaritmic.png" width="750" />

DGEMM and the sparse implementation show comparable execution times over the explored
range, with the sparse approach being slightly faster in some cases. The logarithmic
representation highlights an approximate power-law scaling for all three methods. The 
manual dense implementation displays the steepest growth with matrix size.


Overall, when the matrix size is varied at fixed filling, all methods exhibit a similar scaling, with performance differences mainly arising from the
prefactor. In contrast, when the filling factor is varied at fixed matrix size, the dense 
approaches remain essentially unaffected, while the sparse implementation shows a strong 
dependence on the filling due to the progressive loss of sparsity.
