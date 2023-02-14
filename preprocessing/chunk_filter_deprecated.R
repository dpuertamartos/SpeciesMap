PARTIAL_SIZE <- 500000

loop_index <- 0
checker <- TRUE

while(checker){
  
  partial_dataframe <- read.csv(file="E:/biodiversity-data/occurence.csv",
                                nrows=PARTIAL_SIZE,
                                skip=loop_index*PARTIAL_SIZE, 
                                header=FALSE,sep=",")
  filtered_partial_dataframe <- partial_dataframe[partial_dataframe[, 23] == "PL", ]
  # filtered_partial_dataframe <- subset(partial_dataframe, countryCode == "PL")
  output_filename <- paste0("./data/filtered", loop_index, ".csv")
  write.csv(filtered_partial_dataframe, output_filename, row.names = FALSE)
  if(nrow(partial_dataframe)<PARTIAL_SIZE){
    checker <- FALSE
    print("finish")
  }
  loop_index <- loop_index + 1
  print(loop_index)
}




