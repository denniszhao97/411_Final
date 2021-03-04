# This file is used to make configuring paths easier and control libraries throughout the project
# Constant paths --------------------------------------------------------
DATAROOT <- '~/github/411_Final'


# Path functions --------------------------------------------------------

path_builder <- function(path = '', root_func = NULL) { 
  function(file_path = '') {
    if (is.null(root_func)) {
      file.path(path, file_path)
    } else {
      root_func(file.path(path, file_path))
    }
  }
}

data_root <- path_builder(DATAROOT)
build     <- path_builder('build',    data_root)
dataset  <- path_builder('dataset', data_root)

# Libraries -------------------------------------------------------------
library(readr)
library(ggplot2)
library(tidyverse)
