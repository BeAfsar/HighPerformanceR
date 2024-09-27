# import the csv file from the scratch directory of the course project
surveys_complete <- read.csv("/scratch/project_2011190/shared_data/surveys_complete.csv")


#for loop:
library(tictoc)
tic()
hindfoot_halfs <- vector()
for(row_number in 1:nrow(surveys_complete)) {
  hindfoot_half <- surveys_complete$hindfoot_length[row_number] / 2
  hindfoot_halfs <- c(hindfoot_halfs, hindfoot_half)
}
toc()


#for loop with a pre-assigned result vector:
tic()
hindfoot_halfs <- vector(length = nrow(surveys_complete))
for(row_number in 1:nrow(surveys_complete)) {
  hindfoot_half <- surveys_complete$hindfoot_length[row_number] / 2
  hindfoot_halfs[row_number] <- hindfoot_half
}
toc()

# apply() family function
# input requires some modification, because apply expects data in table format
# you could also pick the column with surveys_complete[8]
tic()
hindfoot_halfs <- apply(surveys_complete[c("hindfoot_length")], 1, function(x) x / 2)
toc()


# map() family function in the package purrr
library(purrr)
tic()
hindfoot_halfs <- map_vec(surveys_complete$hindfoot_length, function(x) x / 2)
toc()

# a vectorized function: 
tic()
hindfoot_halfs <- surveys_complete$hindfoot_length / 2
toc()


#for loop:
profvis({
  hindfoot_halfs <- vector()
  for(row_number in 1:nrow(surveys_complete)) {
    hindfoot_half <- surveys_complete$hindfoot_length[row_number] / 2
    hindfoot_halfs <- c(hindfoot_halfs, hindfoot_half)
  }
})


#for loop with a pre-assigned result vector:
profvis({
  hindfoot_halfs <- vector(length = nrow(surveys_complete))
  for(row_number in 1:nrow(surveys_complete)) {
    hindfoot_half <- surveys_complete$hindfoot_length[row_number] / 2
    hindfoot_halfs[row_number] <- hindfoot_half
  }
})


# apply() family function
# input requires some modification, because apply expects data in table format
# you could also pick the column with surveys_complete[8]
profvis({
  hindfoot_halfs <- apply(surveys_complete[c("hindfoot_length")], 1, function(x) x / 2)
})


# map() family function in the package purrr
library(purrr)
profvis({
  hindfoot_halfs <- map_vec(surveys_complete$hindfoot_length, function(x) x / 2)
})

# a vectorized function: 
profvis({
  hindfoot_halfs <- surveys_complete$hindfoot_length / 2
})