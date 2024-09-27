# creating a list of .csv files in a folder

comm_csv_list <- list.files(path = "/scratch/project_2011190/personal/bekirafs/HighPerformanceR/data/", pattern = ".csv", full.names = TRUE) 

# this for loop goes through the .csv files in the list and carries out the same operations on each of them (reads in the csv file, calculates a distance matrix and saves the matrix as a .dist file)

library(tictoc)
tic()
for (comm_csv in comm_csv_list) {
  comm <- read.csv2(comm_csv, header = T, row.names = 1)
  dist <- vegan::vegdist(t(comm), method = "bray")
  dist <- as.matrix(dist)
  Sys.sleep(5) # added to extend the running time of the small example
  filename = gsub(".csv", ".dist", comm_csv)
  write.table(dist, filename)
}
toc()

library(tictoc)
library(doParallel)
tic()
registerDoParallel(cores = 3)
foreach (comm_csv = comm_csv_list) %dopar% {
  comm <- read.csv2(comm_csv, header = T, row.names = 1)
  dist <- vegan::vegdist(t(comm), method = "bray")
  dist <- as.matrix(dist)
  Sys.sleep(5) # added to extend the running time of the small example
  filename = gsub(".csv", ".dist", comm_csv)
  write.table(dist, filename)
}
toc()
