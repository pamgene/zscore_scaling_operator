library(tercen)
library(dplyr)

# Set appropriate options
#options("tercen.serviceUri"="http://tercen:5400/api/v1/")
#options("tercen.workflowId"= "4133245f38c1411c543ef25ea3020c41")
#options("tercen.stepId"= "2b6d9fbf-25e4-4302-94eb-b9562a066aa5")
#options("tercen.username"= "admin")
#options("tercen.password"= "admin")

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
  mutate(z = scale(.y) %>% as.numeric() ) %>%
  ungroup(.) %>%
  select(.ri, .ci, !!new_col_name := z) %>%
  ctx$addNamespace() %>%
  ctx$save()
