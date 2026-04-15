library(rvest)
library(stringr)
library(jsonlite)


# Pull raw text information
flowers <- read_html("https://bbg.org/collections/cherries")
raw_text <-
    flowers |>
    html_elements("script") |>
    html_text2() |>
    pull(5)


# Step A: Remove the JS variable declaration 'var x = ' and the trailing ';' if
# it exists
clean_json <- gsub("^var\\s+\\w+\\s+=\\s+", "", raw_text)
clean_json <- gsub(";$", "", clean_json)


# Step B: Remove newlines or tabs that might be breaking the parser
clean_json <- gsub("[\\r\\n\\t]", "", clean_json)


# Step C: Parse
data_matrix <- fromJSON(clean_json)


# Step D: Structure as Data Frame
df <- as.data.frame(data_matrix)
colnames(df) <- c("id", "tree_name", "genus", "species", "tree_id", "x", "y", "bloom", "tooltip_img", "full_image")
