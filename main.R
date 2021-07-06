library(tercen)
library(dplyr)

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
  mutate(z = scale(.y) %>% as.numeric() ) %>%
  ungroup(.) %>%
  select(.ri, .ci, !!new_col_name := z) %>%
  ctx$addNamespace() %>%
  ctx$save()

