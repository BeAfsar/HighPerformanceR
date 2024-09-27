# Comparing basic dplyr usage against doParallel in dataset aggregation

library( dplyr     )
library( stringi   )
library( lubridate )


# Simulate dataset for the exercise
n = 1000

data = data.frame( id   = 1:n,
                   str  = stri_rand_strings( n, 4 ), 
                   num1 = rnorm( n ),
                   num2 = rnorm( n, mean = 10, sd = 2 ),
                   num3 = rnorm( n, mean = 100, sd = 10 ) 
)

head( data )

timediff_sec = function( t1, t2 )
{ return( as.numeric( difftime( t2, t1, units = "secs") ) ) }

dplyr_bench = function( dataset ) {
  start_t = Sys.time()
  
  res = dataset %>%
    group_by( str ) %>% summarize( mean_num1 = mean( num1 ),
                                   mean_num2 = mean( num2 ),
                                   mean_num3 = mean( num3 ) 
    )
  end_t = Sys.time()
  dur   = timediff_sec( start_t, end_t )
  
  print( paste0( "Total time elapsed: ", dur ) )
  return( res )
}

dplyr_bench_res = dplyr_bench( data )

# Rewrite the above such that the code uses data.table as a backend for dplyr
library(data.table)

dtplyr_bench = function(dataset) {
  start_time = Sys.time()
  
  res = dataset %>%
    group_by(str) %>%
    summarize(
      mean_num1 = mean(num1),
      mean_num2 = mean(num2),
      mean_num3 = mean(num3)
    ) %>% as_tibble()
  
  
  end_time = Sys.time()
  duration = timediff_sec(start_time, end_time)
  
  print(paste0("Total time:", duration))
  return(res)
}

dtplyr_dataset = data.table:: # TASK: is something missing here?
dtplyr_bench_res = dtplyr_bench(dtplyr_dataset)

# Now aggregate using doParallel

# TASK: Insert Sys.time() into the right places so you can measure computing time.
# Measure the following: when to code starts, when the parallel step starts, when does data
# chunking starts, and when the code ends.

library(doParallel)

dplyr_parallel_bench = function(dataset) {
  # Function we'll run in parallel
  agg_function = function(dataset_chunk) {
    dataset_chunk %>%
      group_by(str) %>%
      summarize(
        mean_num1 = mean(num1),
        mean_num2 = mean(num2),
        mean_num3 = mean(num3)
      )
  }
  
  
  # Parallel setup
  ncores = 4
  registerDoParallel( cores = ncores )
  par_time = Sys.time()
  
  # Split the data into chunks
  chunk_size = n %/% ncores
  data_chunks = split(dataset, ceiling(seq_along(dataset$id) / chunk_size))
  
  
  # Perform the aggregation in parallel
  parallel_results = (chunk = data_chunks, .combine = ?, .packages = ?) ? {
    agg_function(chunk)
  }
  
  # Combine the results from parallel processing
  final_result = do.call(rbind, parallel_results)
  
  
  
  
  print(paste("Total time:", timediff_sec( start_time, end_time)))
  print(paste("Parallel init time:", timediff_sec(start_time, par_time )))
  print(paste("Chunk time:", timediff_sec(par_time, chunk_time)))
  print(paste("Processing time:", timediff_sec(chunk_time, end_time )))
  
  return(final_result)
}

dplyr_parallel_bench_res = dplyr_parallel_bench(data)


dplyr_parallel_tibble_bench = function(dataset) {
  # Function we'll run in parallel
  agg_function = function(dataset_chunk) {
    dataset_chunk %>%
      group_by(str) %>%
      summarize(
        mean_num1 = mean(num1),
        mean_num2 = mean(num2),
        mean_num3 = mean(num3)
      ) %>% as_tibble()
  }
  
  
  
  # Parallel setup
  ncores = 4
  registerDoParallel( cores = ncores )
  
  
  # Split the data into chunks
  chunk_size = n %/% ncores
  data_chunks = split(dataset, ceiling(seq_along(dataset$id) / chunk_size))
  
  
  # Perform the aggregation in parallel
  parallel_results = ?(chunk = data_chunks, .combine = ?, .packages = ?) ? {
    agg_function(chunk)
  }
  
  # Combine the results from parallel processing
  final_result = do.call(rbind, parallel_results)
  end_time = Sys.time()
  
  
  
  print(paste("Total time:", timediff_sec( start_time, end_time)))
  print(paste("Parallel init time:", timediff_sec(start_time, par_time )))
  print(paste("Chunk time:", timediff_sec(par_time, chunk_time)))
  print(paste("Processing time:", timediff_sec(chunk_time, end_time )))
  
  return(final_result)
}

dplyr_parallel_bench_res <- dplyr_parallel_bench(data)

# Testing with different amount of cores
core_count_test = function(dataset, ncores_max) {
  # Function we'll run in parallel
  agg_function = function(dataset_chunk) {
    dataset_chunk %>%
      group_by(str) %>%
      summarize(
        mean_num1 = mean(num1),
        mean_num2 = mean(num2),
        mean_num3 = mean(num3)
      )
  }
  
  # Initialize an empty data frame
  time_df = data.frame(ncores = c(), total_time = c(), compute_time = c(), overhead_time = c())
  
  # Iterate
  for (ncores in 1:ncores_max) {
    
    
    # Parallel setup
    
    registerDoParallel( cores = ncores)
    
    
    # Split the data into chunks
    chunk_size = n %/% ncores
    data_chunks = split(dataset, ceiling(seq_along(dataset$id) / chunk_size))
    
    
    # Perform the aggregation in parallel
    parallel_results = ?(chunk = data_chunks, .combine = ?, .packages = ?) ? {
      agg_function(chunk)
    }
    
    # Combine the results from parallel processing
    final_result = do.call(rbind, parallel_results)
    
    
    
    # Append results
    time_df = rbind(
      time_df, 
      data.frame(
        ncores        = ncores, 
        total_time    = timediff_sec(start_time, end_time ), 
        compute_time  = timediff_sec(chunk_time, end_time ), 
        overhead_time = timediff_sec(start_time, par_time ) + 
          timediff_sec(par_time, chunk_time )
      )
    )
  }
  
  return(time_df)
}

core_count_test_res = core_count_test(dataset = data, ncores_max = 8)
core_count_test_res