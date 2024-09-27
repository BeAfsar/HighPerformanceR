#!/bin/bash -l
#SBATCH --job-name=future_map # give your job a name here
#SBATCH --account=project_2011190 # project number of the course project
#SBATCH --output=io/output_%j.txt
#SBATCH --error=io/errors_%j.txt
#SBATCH --partition=small
#SBATCH --time=00:05:00 # h:min:sek, this reserves 5 minutes
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=3  # this sets the job to have 3
#SBATCH --mem-per-cpu=1000
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
srun apptainer_wrapper exec Rscript --no-save test_future.R # your R script file here