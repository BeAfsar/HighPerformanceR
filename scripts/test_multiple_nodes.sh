#!/bin/bash -l
#SBATCH --job-name=future_map # give your job a name here
#SBATCH --account=project_2011190 # project number of the course project
#SBATCH --output=io/output_%j.txt
#SBATCH --error=io/errors_%j.txt
#SBATCH --partition=large
#SBATCH --time=00:05:00 # h:min:sek, this reserves 5 minutes
#SBATCH --nodes=3
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=1000

# Load r-env
module load r-env

# Clean up .Renviron file in home directory
if test -f ~/.Renviron; then
    sed -i '/TMPDIR/d' ~/.Renviron
fi

# Specify a temp folder path (add your personal folder here)
echo "TMPDIR=/scratch/project_2011190/personal/bekirafs" >> ~/.Renviron 

# Run the R script - note that this line is different from the other examples
srun apptainer_wrapper exec RMPISNOW --no-save --slave -f test_multiple_nodes.R