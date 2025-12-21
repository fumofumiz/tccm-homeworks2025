#!/bin/bash
#SBATCH -p g100_usr_prod
#SBATCH -A tra25_tccm
#SBATCH -t 24:00:00
#SBATCH -N1 --ntasks-per-node=1 --cpus-per-task=1
#SBATCH --mail-type=END
#SBATCH --mail-user=frumiz00@login.g100.cineca.it

MAT_DIR="Matrices"
RES_DIR="RESULTS"
N=100
D="n"

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
${D}
EOF

    # una sola esecuzione
    ./sparse < "${INPUT}" > "${OUTPUT}" 2>&1
done

