# Zscore scaling operator

##### Description

The `zscore_scaling_operator` calculates the z score for all data points. 

##### Usage

Input projection|.
---|---
`y-axis`        | numeric, y values, per cell 
`color`         | factor, a variable that defines a grouping of the data such that calculations will be based within the groups

Input parameters|.
---|---
`Dimension`      | this can be either Rows or Columns. It is used to determine if the scaled values should be calculated based on rows (spots) or columns (arrays)

Output relations|.
---|---
`Scale`          | numeric, Row or Column scaled value per cell

##### Details

The operator assumes that every cell contains a single value (cells with missing value are ignored). A data color can be used to stratify the scaling into groups. I.e. when you add a data color that defines a grouping, the scaling parameters will be calculated within the groups rather than globally.