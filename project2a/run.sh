#!/bin/bash

MAT_DIR="Matrices"
RES_DIR="RESULTS"
N=100

mkdir -p "${RES_DIR}"

for MAT in ${MAT_DIR}/*.sparse; do
    FILE=$(basename "${MAT}")        # MATRIX_125_01p.sparse
    NAME="${FILE%.sparse}"           # MATRIX_125_01p
    SUBDIR="${RES_DIR}/${NAME}"

    mkdir -p "${SUBDIR}"

    INPUT="${SUBDIR}/input_${FILE}"
    OUTPUT="${SUBDIR}/output.txt"

    # crea input: A, B, N
    cat << EOF > "${INPUT}"
${MAT}
${MAT}
${N}
EOF

    # una sola esecuzione
    ./sparse < "${INPUT}" > "${OUTPUT}" 2>&1
done

