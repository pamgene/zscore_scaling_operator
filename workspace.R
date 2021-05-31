library(tercen)
library(dplyr)

# Set appropriate options
#options("tercen.serviceUri"="http://tercen:5400/api/v1/")
#options("tercen.workflowId"= "4133245f38c1411c543ef25ea3020c41")
#options("tercen.stepId"= "2b6d9fbf-25e4-4302-94eb-b9562a066aa5")
#options("tercen.username"= "admin")
#options("tercen.password"= "admin")

do.scale = function(df, new_col_name) {
  value                    <- df$.y - mean(df$.y, na.rm = TRUE)
  value                    <- value/sd(value, na.rm = TRUE)
  value[!is.finite(value)] <- NaN 
  result                   <- cbind(df, value)
  colnames(result)         <- c(colnames(df), new_col_name)
  result
}

ctx = tercenCtx()

dimension <- ifelse(is.null(ctx$op.value('Dimension')), 'Row', as.character(ctx$op.value('Dimension')))

data <- ctx %>% 
  select(.ci, .ri, .y)
  
if (dimension == "Row") {
  data <- data %>% group_by(.ri)
} else if (dimension == "Column") {
  data <- data %>% group_by(.ci)
} else {
  stop("Invalid option for dimension")
}

new_col_name <- paste(dimension, "Scale", sep = ".")
data %>% 
  do(do.scale(., new_col_name)) %>%
  ctx$addNamespace() %>%
  ctx$save()
