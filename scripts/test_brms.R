library(brms)
library(microbenchmark)

# an 'empty' model run first, because compiling takes a while
fit_empty <- brm(count ~ zAge + zBase * Trt + (1|patient),
                 data = epilepsy, family = poisson(),
                 chains = 0)

# the actual test with different number of cores
brms_results <- microbenchmark(
  
  single_core = {update(fit_empty, recompile = FALSE,
                        chains = 4, cores = 1)
  },
  
  multicore = {update(fit_empty, recompile = FALSE,
                      chains = 4, cores = 6)
  }, times = 3
)

print(brms_results)