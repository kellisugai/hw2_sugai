# ============================================================================
# Author: Kelli Sugai 
# Course: PHB 228 Statistical Computing 
# Assignment: Homework 2 
# Date: 4/11/2025 
# The purpose of this script is to practice working with data structures, 
# mapping, and memory management. 
# ============================================================================

# *** PART 1: VERSION CONTROL SETUP 
repoLocation <- "https://github.com/kellisugai/hw2_sugai.git" 

# Load required packages. 
library(palmerpenguins)
library(dplyr)
library(ggplot2)
library(purrr)

# *** PART 2: DATA STRUCTURES
# -----------------------------------------------------------------------------
# 1. List Operations 
# -----------------------------------------------------------------------------

# Extract unique species from penguins data set.
data(penguins) # Load penguins data set. 
(species <- unique(penguins[1])) # Extract unique species. 

# Create a list where each element contains data for one species.
speciesData <- penguins %>%
  split(.$species)
names(speciesData)

# Add an attribute to each list element showing the sample size. 
sampleSize <- sapply(speciesData, nrow) # Get sample size for each species. 
attr(speciesData, "sample_size") <- sampleSize

# Demonstrate how to access the sample size attribute. 
attributes(speciesData)

# -----------------------------------------------------------------------------
# 2. Matrix vs. Data Frame
# -----------------------------------------------------------------------------

# Create a matrix containing only the numeric measurements from the penguins
# data set (bill length, bill depth, flipper length, body mass). 
  
# Change data type of year column so it won't be included. 
penguins$year <- as.character(as.factor(penguins$year))

# Select columns of penguins data set where type is numeric, store in a matrix.
numberPenguin <- as.matrix(select(penguins, where(is.numeric)))

# Check if type is correct. 
is.matrix(numberPenguin) # = TRUE, is a matrix.  

# Perform the same operation as a data frame. 
numbersDf <- data.frame(select(penguins, where(is.numeric)))

# Compare the results and explain any differences. 
head(numberPenguin)
head(numbersDf)
# While these look extremely similar, you'll notice that they are different if 
# you look at their type. 
typeof(numberPenguin)
typeof(numbersDf)
# The matrix is of type "double", while the data frame is a "list". This is 
# because a matrix is a 2-dimensional vector, and can only be of one type. 
# In our case, the type is double, so the entire matrix has a type "double". 
# By contrast, a data frame is a list of columns. 


