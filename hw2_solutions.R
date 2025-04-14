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

# Extract unique species from penguins data set.
data(penguins) # Load penguins data set. 
(species <- unique(penguins[1])) # Extract unique species. 

# Create a list where each element contains data for one species. # UGGGGGGHGHGHGHG
speciesData <- penguins %>%
  split(.$species)
