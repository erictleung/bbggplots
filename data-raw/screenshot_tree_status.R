# Take a screenshot of the cherry tree map
# Usage: Rscript screenshot_tree_status.R

# Load libraries
library(chromote)
library(glue)
library(here)

# Create new session
message("Creating new browser instance...")
b <- ChromoteSession$new()
Sys.sleep(3)

# Navigate to website and screenshot image of garden
message("Navigating to Brooklyn Botanic Garden's website...")
b$go_to("https://www.bbg.org/collections/cherries")
message("Creating snapshot of the garden map...")
b$screenshot(
    here("assets", "screenshots", glue("bbg_screenshot_{Sys.Date()}.png")),
    selector = "#cherrymap"
)
message("Complete!")

