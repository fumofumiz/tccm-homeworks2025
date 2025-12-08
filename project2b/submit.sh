#!/bin/bash


#SBATCH --job-name=multi_gpu_job              # Descriptive job name
#SBATCH --time=04:00:00                       # Maximum wall time (hh:mm:ss)
#SBATCH --nodes=1                             # Number of nodes to use
#SBATCH --ntasks-per-node=1                   # Number of MPI tasks per node (e.g., 1 per GPU)
#SBATCH --cpus-per-task=1                     # Number of CPU cores per task (adjust as needed)
#SBATCH --gres=gpu:1                          # Number of GPUs per node (adjust to match hardware)
#SBATCH --partition=g100_usr_interactive      # GPU-enabled partition
#SBATCH --output=multiGPUJob.out              # File for standard output
#SBATCH --error=multiGPUJob.err               # File for standard error
#SBATCH --account=tra25_tccm                  # Project account number

# Load necessary modules (adjust to your environment)
module load nvhpc		              # Just in case, cuda should be sufficient to run the program 

# Optional: Set environment variables for performance tuning
#export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK   # Set OpenMP threads per task
#export NCCL_DEBUG=INFO                        # Enable NCCL debugging (for multi-GPU communication)

# Launch the distributed GPU application
# Replace with your actual command (e.g., mpirun or srun)
#srun --mpi=pmix ./my_distributed_gpu_app --config config.yaml

srun ./main < input > output
