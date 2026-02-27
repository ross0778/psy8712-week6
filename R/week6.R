# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(stringi)
library(stringr)
library(tibble)
library(dplyr)

# Data Import
citations <- stri_read_lines("../data/cites.txt", encoding = "Windows-1252")
citations_txt <- stri_subset_regex(citations, ".+")
print(str_c("The number of blank lines eliminated was ", length(citations) - length(citations_txt)))
print(str_c("The average number of characters/citation was ", mean(nchar(citations_txt))))

# Data Cleaning
random_sample <- (slice_sample(citations_tbl, n = 20))
View(random_sample)
citations_tbl <- tibble(line = 1:length(citations_txt), cite = citations_txt) %>% 
  mutate(authors = str_extract(cite, "^[^(]+"),
         year = str_extract(cite, "\\(\\d{4}\\)"),
         title = str_extract(cite, "(?<=\\)\\. ).+?(?=\\.)"),
         journal_title = str_extract(cite, "(?<=\\. )[^.]+(?=, \\d)"),
         book_title = str_extract(cite, "(?<=In ).+?(?= \\()"),
         journal_page_start = str_extract(cite, "(?<=, )\\d+(?=-)"),
         journal_page_end = str_extract(cite, "(?<=-)\\d+(?=\\.)"),
         book_page_start = str_extract(cite, "(?<=pp\\. )\\d+(?=-)"),
         book_page_end = str_extract(cite, "(?<=-)\\d+(?=\\))"),
         doi = str_extract(cite, "(?<=doi: |https://doi\\.org/)\\S+"),
         perf_ref = str_detect(cite, regex("performance", ignore_case = TRUE)),
         first_author = str_extract(cite, "^[^,]+, [A-Z]\\.(?: [A-Z]\\.)*")
         )
# Analysis