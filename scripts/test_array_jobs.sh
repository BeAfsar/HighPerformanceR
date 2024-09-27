#!/bin/bash -l
#SBATCH --job-name=my_array_job # name your job here
#SBATCH --account=project_2011190 # project number of the course project
#SBATCH --output=io/array_job_out_%A_%a.txt # note the different format
#SBATCH --error=io/array_job_err_%A_%a.txt # note the different format
#SBATCH --partition=small
#SBATCH --time=00:05:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1000
#SBATCH --array=1-3 # specific line to array jobs
#SBATCH --reservation=high_perf_r_fri # only used during this course

# Load r-env
module load r-env

# Clean up .Renviron file in home directory
if test -f ~/.Renviron; then
    sed -i '/TMPDIR/d' ~/.Renviron
fi

# Specify a temp folder path (add your personal folder here)
echo "TMPDIR=/scratch/project_2011190/personal/bekirafs" >> ~/.Renviron 

# Run the R script
srun apptainer_wrapper exec Rscript --no-save test_array_jobs.R $SLURM_ARRAY_TASK_ID