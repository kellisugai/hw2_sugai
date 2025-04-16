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

# Describe when you would prefer each data structure (2-3 sentences). 
# A matrix is good when all of the data is the same type. A data frame is good 
# if you want to have multiple types of data. Additionally, it is easy to
# access variables of a data frame using the $ operator. I prefer to use 
# the data frame for most data analysis. 

# -----------------------------------------------------------------------------
# 3. Copy-on-Modify 
# -----------------------------------------------------------------------------

# Create a vector x with values 1:5. 
x <- 1:5

# Create a reference y pointing to the same vector. 
y <- x

# Modify y and explain what happens to x. 
y <- 1:3
print(y) # 1 2 3 
print(x) # 1 2 3 4 5 
# While y is modified, x remains unchanged. 

# Explain how this behavior differs from languages like Python or Java. 
# In Python, assigning one variable to another does not automatically create 
# a copy. Instead, they both point to the same location where the information 
# is stored. Because of this, modifying the new variable will modify the old 
# one as well. By contrast, in R, when you modify the new variable it will 
# automatically make a copy -- leaving the original variable unchanged. 

# *** PART 3: MAP FUNCTIONS 
# -----------------------------------------------------------------------------
# 4. Base R Apply Functions 
# -----------------------------------------------------------------------------

# Use lapply() to calculate the mean of each numeric variable in the 
# penguins data set (excluding NA's). 
(lMeans <- lapply(numbersDf, mean, na.rm = T))

# Use tapply() to find the mean body mass by species. 
(massSpecies <- tapply(
  X = penguins$body_mass_g,
  INDEX = penguins$species,
  FUN = function(x) mean(x, na.rm = TRUE)
)) 

# Use tapply() again to find the mean body mass by both species and sex. 
(massTwo <- tapply(
  X = penguins$body_mass_g, 
  INDEX = list(penguins$species, penguins$sex), 
  FUN = function(x) mean(x, na.rm = TRUE)
))

# Compare the output types from each function (1-2 sentences). 
typeof(lMeans) # "list" 
typeof(massSpecies) # "double" 
typeof(massTwo) # "double"

# The output of lapply() is always a list, but the output of tapply() is
# dependent on the input and the grouping factor. 

# -----------------------------------------------------------------------------
# 5. Purrr Map Functions 
# -----------------------------------------------------------------------------

# Rewrite the first task from question 4 using map_dbl(). 
(dblMeans <- map_dbl(.x = numbersDf, .f = mean, na.rm = T))

# Use map2() to calculate the ratio of bill length to bill depth
# for each species. 
(bill_ratio <- map2_dbl(
  .x = map(speciesData, "bill_length_mm"),
  .y = map(speciesData, "bill_depth_mm"),
  .f = ~ mean(.x / .y, na.rm = TRUE)
))

attr(speciesData, "bill_ratio") <- bill_ratio # Add as an attribute to our list. 
attributes(speciesData)

# Create a list where each element contains a different statistic 
# (mean, median, sd) for each measurement variable. 

listVariables <- c(penguins[,3:6]) # Make list of measurement variables. 
(summaryPenguin <- map(
  listVariables,
  ~list(
    mean = mean(.x, na.rm = T), 
    median = median(.x, na.rm = T), 
    sd = sd(.x, na.rm = T)
  )
))

# Explain which approach you prefer (base R vs purrr) and why (2-3 sentences). 

# Personally, I prefer the base R approach. This is because the arguments of 
# the apply() functions are easy for me to understand. Purrr is very similar, 
# but I don't find map() to be as intuitive. 


# -----------------------------------------------------------------------------
# 6. Practical Applications 
# -----------------------------------------------------------------------------

# Use the map pattern to create a separate histogram for each numeric variable 
# in the penguins data set. Each histogram should:
  # – Have an appropriate title based on the variable name
  # – Use faceting to show separate histograms by species
  # – Use a color palette that distinguishes between species
(histogramPenguin <- map2(
  .x = listVariables, # Numeric variables. 
  .y = names(listVariables), # Variable names. 
  .f = function(variable, namesOf){
      ggplot(data = penguins, 
             mapping = aes(x = .data[[namesOf]], fill = species)) + 
      geom_histogram() + 
      facet_wrap(~species) + 
      labs(title = paste("Counts of ", namesOf))
      }
  ))

# Write a brief explanation (2-3 sentences) of how this approach is more
# efficient than writing separate code for each plot. 

# This is more efficient than writing separate code for each plot because it 
# allows me to repeat the same settings of the plot without needing to 
# actually rewrite the code. If I had done this separately, it would have taken 
# 3 times as many lines of code. 

# *** PART 4: MEMORY MANAGEMENT
# -----------------------------------------------------------------------------
# 7. Efficient Code  
# -----------------------------------------------------------------------------

# The following code is inefficient. Rewrite it using pre-allocation:
  # result <- numeric(0)
  # for(i in 1:10000) {result <- c(result, iˆ2)} 

result <- numeric(10000)
for(i in 1:10000) {
  result[i] <- i^2
  } 

# Compare the execution time of your version vs. the original using system.time().
originalTime <- system.time({
  result <- numeric(0)
  for(i in 1:10000){
    result <- c(result, i^2)
  }
})

revisedTime <- system.time({
  result <- numeric(10000)
  for(i in 1:10000) {
    result[i] <- i^2
  } 
})

originalTime - revisedTime
#    user  system elapsed 
#   0.05    0.04    0.20 

# Explain why your version is more efficient in terms of R’s memory model
# (2-3 sentences). 

# My version is more efficient because it does not recopy and rebuild a 
# large vector every time it is run. Because of copy-on-modify, the original 
# method is creating a new copy of the vector for each iteration of the loop. 
# Mine instead modifies an existing vector. 


