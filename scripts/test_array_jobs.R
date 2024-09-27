# this lets us access the array number in R (from $SLURM_ARRAY_TASK_ID in the batch job script)
arrays <- commandArgs(trailingOnly = TRUE)

filepath <- "/scratch/project_2011190/personal/bekirafs/HighPerformanceR/data/"
csv_name <- paste0(filepath, "community", arrays[1], ".csv")

comm <- read.csv2(csv_name, header = T, row.names = 1)
dist <- vegan::vegdist(t(comm), method = "bray")
dist <- as.matrix(dist)
Sys.sleep(5) # added to extend the running time of the small example
filename = gsub(".csv", "_array.dist", csv_name)
write.table(dist, filename)
print(filename) # prints the file name into the output file which would otherwise be empty