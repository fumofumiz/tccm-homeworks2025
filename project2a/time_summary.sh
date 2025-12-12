#!/bin/bash

RES_DIR="RESULTS"
OUT_DIR="TIMINGS_SUMMARY"

mkdir -p "${OUT_DIR}"

OUT_SPARSE="${OUT_DIR}/times_sparse.txt"
OUT_MANUAL="${OUT_DIR}/times_manual.txt"
OUT_DGEMM="${OUT_DIR}/times_dgemm.txt"

: > "${OUT_SPARSE}"
: > "${OUT_MANUAL}"
: > "${OUT_DGEMM}"

for DIR in ${RES_DIR}/MATRIX_*; do
    MATRIX=$(basename "${DIR}")
    FILE="${DIR}/output.txt"

    [ -f "${FILE}" ] || continue

    T_SPARSE=$(grep "Time for sparse multiplication" "${FILE}" | awk '{print $NF}')
    T_MANUAL=$(grep "Time for manual multiplication" "${FILE}" | awk '{print $NF}')
    T_DGEMM=$(grep "Time for multiplication using DGEMM" "${FILE}" | awk '{print $NF}')

    echo "${MATRIX} ${T_SPARSE}" >> "${OUT_SPARSE}"
    echo "${MATRIX} ${T_MANUAL}" >> "${OUT_MANUAL}"
    echo "${MATRIX} ${T_DGEMM}"  >> "${OUT_DGEMM}"
done

