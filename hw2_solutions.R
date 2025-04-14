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

# 2. Matrix vs. Data Frame
# -----------------------------------------------------------------------------
# Create a matrix containing only the numeric measurements from the penguins
# data set (bill length, bill depth, flipper length, body mass). 
  
# Change data type of year column so it won't be included. 
penguins$year <- as.character(as.factor(penguins$year))

# Select columns of penguins dataset where type is numeric, store in a matrix.
numberPenguin <- matrix(select(penguins, where(is.numeric)))

# Check if type is correct. 
is.matrix(numberPenguin) # = TRUE 
