library(pryr)
sizes <- sapply(0:10, function(n) object_size(seq_len(n)))
plot(0:10 , sizes, xlab = "Length", ylab = "Size (bytes)",
     type = "s")


sizes2 <- sapply(0:1000000, function(n) object_size(seq_len(n)))
plot(0:1000000 , sizes2, xlab = "Length", ylab = "Size (bytes)",
     type = "s")