library(tidyverse) # readr, dplyr, tibble, forcats, stringr, lubridate, ...

# Set the working directory
setwd(here::here("workshop_2026", "data_processing"))  # works from any working directory; needs install.packages("here")

tidy_df <- read_delim("data.txt", delim = "\t")
tidy_df |> head(n = 3)

tidy_df <- read_csv("data.csv")
tidy_df |> head(n = 3)

tidy_df <- read_tsv("data_no_col_names.txt", col_names = FALSE)
tidy_df |> head(n = 3)
## add column names to tidy_df
tidy_df <- tidy_df |>
  setNames(
    c(
      "ID",
      "age",
      "height",
      "col",
      "name",
      "date",
      "soda"
    )
  )
tidy_df |> head(n = 3)

tidy_df <- read_tsv("data.txt")
# print out the first 6 rows
tidy_df |> head()
# print out the first 3 rows
tidy_df |> head(n = 3)

# print out column names
# tidy_df |> colnames()
# change "col" to "color"
tidy_df <- tidy_df |>
  rename(
    uniqueID = ID,
    color = col
  )
tidy_df |> head(n = 3)

# Drop uninformative columns
tidy_df <- tidy_df |> select(-c(uniqueID, name))
tidy_df |> head(n = 3)

# readr correctly interpreted NA to be a missing value for
# age and its data type is what we expect, an integer.

# However, height has "???" for missing data and readr
# kept the entire column as "chr", for character strings.
# So we need to fix this column by replacing "???" with NA
tidy_df <- tidy_df |> mutate(height = na_if(height, "???"))
tidy_df |> head(n = 3)

## now convert the datatype for the "height" column to numeric
tidy_df <- tidy_df |> mutate(height = as.numeric(height))
tidy_df |> head(n = 3)

## Both "color" and "soda" should be factors and
## we need correct the random capitalization.
## However, first let's look at the different values
## in the "color" column
tidy_df |> distinct(color)
## And we see all kinds of different capitalization,
## so let's make all of the strings lowercase
tidy_df <- tidy_df |>
  mutate(color = color |> str_to_lower() |> as_factor())
tidy_df |> distinct(color)
tidy_df |> head(n = 3)
## ...and we see that "color" is still
## "chr", but we want it to be a factor, so
## let's convert it.
tidy_df <- tidy_df |> mutate(color = as_factor(color))
## Now verify the change:
tidy_df |> head(n = 3)

## NOTE: With lubridate, two-digit years 69-99 become 19xx and 00-68 become 20xx, so 5/4/73 is 1973.
## ALSO NOTE: If you have two-digit years in the 2069+ range, they will be read wrongly

tidy_df <- tidy_df |>
  mutate(
    # str_trim() first removes leading/trailing whitespace.
    # Then try each order in turn for every value: month-day-year "mdy",
    # year-month-day "ymd", then abbreviated month name-day-year
    # (e.g. "Jan. 1 '14") "bdy".
    # Finally, as_date() converts the date-times to plain dates.
    date = date |>
      str_trim() |>
      parse_date_time(orders = c("mdy", "ymd", "bdy")) |>
      as_date()
  )

tidy_df |> head(n = 3)

tidy_df |>
  filter(date > today()) |>
  head(n = 3)

tidy_df <- tidy_df |>
  mutate(
    # Dates after today can only come from two-digit years parsed as 20xx
    date = if_else(date > today(), date - years(100), date)
  )

# Check the new values and the new column type
tidy_df |> head(n = 3)

# now to fix the inconsistant capitalization in the soda column
tidy_df |> distinct(soda)
## ...so let's make them all lowercase and convert to a factor
tidy_df <- tidy_df |>
  mutate(soda = soda |> str_to_lower() |> as_factor())

## let's check the updated values
tidy_df |> distinct(soda)
tidy_df |> head(n = 3)

## Now, just to show the method, we'll downsample the data...
## first, print out the number of rows in tidy_df
tidy_df |> nrow()
## Now downsample th edata
downsampled_tidy_df <- tidy_df |> slice_sample(prop = 0.5)
## Now print the number of rows to verify the downsampling
downsampled_tidy_df |> nrow()

## Now, to show the method, split the data into
## independent variables, X, and a dependent variable, y
X <- tidy_df |> select(-c(soda))
X |> head(n = 3)

y <- tidy_df |> select(soda)
y |> head(n = 3)
# now convert the yes and no values to 1 and 0
y$soda <- as.numeric(y$soda == "yes")
y |> head(n = 3)

## now split the data into train and test sets
train_tidy_df <- downsampled_tidy_df |> head(prop = 0.8)
train_tidy_df |> nrow()
test_tidy_df <- downsampled_tidy_df |> slice_tail(prop = 0.2)
test_tidy_df |> nrow()

##
## NOTE: In R, we don't need to one-hot encode the data
##

##
## Now it's time for standardizing the data if that
## is something we need to do. Some ML methods need this
## (like Support Vector Machines and neural networks)
## others (like decision trees) do not
##
## Standardizing the data means subtracting the mean
## from each value and dividing by the standard deviation
##
## For this example, let's assume it is something
## we need to do. So we'll apply it to the
## "height" column
train_tidy_df |> head(n = 3)
train_height_stats <- train_tidy_df |>
  summarize(
    mean = mean(height, na.rm = TRUE),
    sd = sd(height, na.rm = TRUE)
  )
train_height_stats

## now standardize, using the training mean and sd for both sets...
train_tidy_df <- train_tidy_df |>
  mutate(
    height = (height - train_height_stats$mean) /
      train_height_stats$sd
  )
train_tidy_df |> head(n = 3)

test_tidy_df <- test_tidy_df |>
  mutate(
    height = (height - train_height_stats$mean) /
      train_height_stats$sd
  )
test_tidy_df |> head(n = 3)
