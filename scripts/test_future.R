library(purrr)
library(furrr) # one package of the future family of packages

# function that carries out the same distance matrix calculation we used earlier
distfunction <- function(comm_csv) {
  comm <- read.csv2(comm_csv, header = T, row.names = 1)
  dist <- vegan::vegdist(t(comm), method = "bray")
  dist <- as.matrix(dist)
  Sys.sleep(5) # added to extend the running time of the small example
  filename = gsub(".csv", ".dist", comm_csv)
  write.table(dist, filename)
}

# listing the csv files in the folder communities
comm_csv_list <- list.files(path = "/scratch/project_2011190/personal/bekirafs/HighPerformanceR/data/", pattern = ".csv", full.names = TRUE) 

# sequential
sequential <- system.time(results <- purrr::map(comm_csv_list, distfunction))
print("sequential")
print(sequential)

# converting the sequential code into parallel with future_map
plan(multicore)
multisession <- system.time(future_map(comm_csv_list, distfunction))
print("multisession")
print(multisession)