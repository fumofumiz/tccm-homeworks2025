## TIMING AND PERFORMANCE ANALYSIS

The execution time required by the program to perform matrix–matrix multiplications was
measured for three different methods: dense matrix multiplication using **DGEMM**, dense
matrix multiplication using a **hand-written routine**, and **sparse matrix multiplication**.
All timing measurements were performed on the same machine in order to ensure that the
execution times are directly comparable. The multiplication methods were repeated **100
times in a loop** in order to record measurable times.

Table 1 reports representative execution times for fixed matrix dimensions (125 and 250)
and varying filling rates. The table illustrates the type of data contained in the Excel
file in the `RESULTS/` directory, called `results_mult.xlsx`. It includes only a subset of 
the full dataset, which is sufficient to produce the plots discussed below.

### Table 1 – Execution times for fixed matrix size and varying filling

| dimension |    dgemm |   manual |     sparse | filling |
| --------: | -------: | -------: | ---------: | ------: |
|       125 | 0.116411 | 0.772696 |   6.08E−02 |       2 |
|       125 | 0.116532 | 0.772337 |   0.256631 |       5 |
|       125 | 0.116041 | 0.772230 |   0.862849 |      10 |
|       125 | 0.116159 | 0.772004 |   4.412728 |      25 |
|       125 | 0.117361 | 0.774304 |  16.903868 |      50 |
|       250 | 0.901165 | 6.468384 |   0.710542 |       2 |
|       250 | 0.898822 | 6.463258 |   3.119254 |       5 |
|       250 | 0.892939 | 6.457889 |  10.973503 |      10 |
|       250 | 0.899628 | 6.462266 |  66.025764 |      25 |
|       250 | 0.893496 | 6.471445 | 248.702263 |      50 |

---

## PROFILING AND SCALING ANALYSIS

The performance of the three multiplication methods was profiled by comparing their measured
execution times. Dense matrix multiplication using **DGEMM** consistently exhibits significantly
lower execution times than the hand-written dense routine, which in turn is systematically
slower across all tested configurations. Sparse matrix multiplication shows a markedly different
behaviour, as its performance strongly depends on the matrix structure. At low filling rates,
sparse multiplication can be competitive with or faster than dense methods, while its execution
time increases rapidly as the filling rate grows.

---

## SCALING WITH MATRIX FILLING RATE

For all the figures below, the data reported in **Table 1** are used.

<img src="https://github.com/fumofumiz/tccm-homeworks2025/blob/master/project2a/RESULTS/Matrix_filling(N%3D125).png" width="750" />

**Figure 1.** Execution time as a function of the matrix filling for a fixed matrix dimension
\(N = 125\). Serie 1 (DGEMM) and Serie 2 (manual dense implementation) show an almost constant
execution time, while Serie 3 (sparse multiplication) exhibits a strong dependence on the
filling rate, with rapidly increasing execution times as the percentage of non-zero elements
grows.

<img src="https://github.com/fumofumiz/tccm-homeworks2025/blob/master/project2a/RESULTS/Matrix_filling(N%3D125)_logaritmic_scaling.png" width="750" />

**Figure 2.** Execution time as a function of the matrix filling for a fixed matrix dimension
\(N = 125\), using a logarithmic scale on the vertical axis. The logarithmic representation
highlights the strong increase in execution time of Serie 3 (sparse) as the filling rate grows,
while Serie 1 (DGEMM) and Serie 2 (manual) remain confined within a narrow range.

<img src="https://github.com/fumofumiz/tccm-homeworks2025/blob/master/project2a/RESULTS/Matrix_filling(N%3D250).png" width="750" />

**Figure 3.** The same trend observed in Figure 1, but with larger absolute execution times due
to the increased matrix dimension (\(N = 250\)).

---

## SCALING WITH MATRIX SIZE

The dependence of the execution time on the matrix size was analyzed by keeping the filling
fixed at **2%** and varying the matrix dimension. The data used for this analysis are reported
in Table 2.

### Table 2 – Execution times for varying matrix size at fixed filling (2%)

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

The figures below show the execution time as a function of the matrix size.

<img src="https://github.com/fumofumiz/tccm-homeworks2025/blob/master/project2a/RESULTS/Matrix_size.png" width="750" />

Execution time as a function of the matrix dimension at fixed filling (2%). Serie 1 (DGEMM)
exhibits the lowest execution times across the explored range, Serie 2 (manual dense
implementation) shows the steepest increase with matrix size, while Serie 3 (sparse
multiplication) is competitive with serie 1.

<img src="https://github.com/fumofumiz/tccm-homeworks2025/blob/master/project2a/RESULTS/Matrix_size_logaritmic_scaling.png" width="750" />

Execution time as a function of the matrix dimension at fixed filling (2%), shown on a
logarithmic scale. The logarithmic representation highlights an approximate power-law scaling
for all three methods. Serie 2 (manual dense implementation) exhibits the steepest growth,
while Serie 1 (DGEMM) and Serie 3 (sparse) show similar scaling exponents but different
prefactors, with DGEMM faster over the explored range.

The figures above show the execution times as a function of matrix size using linear and
logarithmic scales, respectively. In the linear plot, the rapid increase in execution time
with matrix dimension is clearly visible, particularly for the manual dense implementation.
The logarithmic representation reveals that all three methods follow an approximate power-law
behavior with respect to matrix size over the explored range. At this filling percentage,
the execution times of the DGEMM and sparse implementations are comparable, with the sparse
method being mostly faster than the dense DGEMM approach.

