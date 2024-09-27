print(sessionInfo())
print(parallelly::availableCores()) # What does this do?
print(Sys.getenv("SLURM_CPUS_PER_TASK")) # What does this do?

library(vegan)

# change the file path in the next command to your personal folder
comm_csv_list <- list.files(path = "/scratch/project_2011190/personal/bekirafs/HighPerformanceR/data/", pattern = ".csv", full.names = TRUE) 

for (comm_csv in comm_csv_list) {
  comm <- read.csv2(comm_csv, header = T, row.names = 1)
  dist <- vegan::vegdist(t(comm), method = "bray")
  dist <- as.matrix(dist)
  filename = gsub(".csv", ".dist", comm_csv)
  write.table(dist, filename)
}