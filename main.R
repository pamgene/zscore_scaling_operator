library(tercen)
library(dplyr)

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

color <- FALSE
if (length(ctx$colors) == 1) {
  data  <- data %>% mutate(group = ctx$select(ctx$colors) %>% pull())
  color <- TRUE
}

if (dimension == "Row") {
  if (color) {
    data <- data %>% group_by(.ri, group) 
  } else {
    data <- data %>% group_by(.ri) 
  }
} else if (dimension == "Column") {
  if (color) {
    data <- data %>% group_by(.ci, group) 
  } else {
    data <- data %>% group_by(.ci) 
  }
} else {
  stop("Invalid option for dimension")
}

new_col_name <- paste(dimension, "Scale", sep = ".")
data %>% 
  do(do.scale(., new_col_name)) %>%
  ungroup(.) %>% 
  select(.ri, .ci, all_of(new_col_name)) %>%
  ctx$addNamespace() %>%
  ctx$save()
