#####################
# load libraries
#####################

library(tidyverse)
library(httr)


##################################
# load REDCap API credentials 
# (stored locally, out of repo)
##################################

creds <- read_csv("../redcap_credentials.csv")


#####################
# import REDCap data
#####################

url <- 'https://redcap.med.upenn.edu/api/'
formData <- list('token' = creds$token[1],
                 content = 'report',
                 format = 'csv',
                 report_id = creds$report_id[1], # when report is selected in REDCap, the 5-digit ID will be displayed in the URL
                 csvDelimiter = '',
                 rawOrLabel = 'raw',
                 rawOrLabelHeaders = 'raw',
                 exportCheckboxLabel = 'false',
                 returnFormat = 'csv'
)
response <- POST(url, body = formData, encode = 'form')
rc <- type_convert(content(response, type = 'text/csv', 
                           col_types = cols(.default = col_character()))) %>%
  as_tibble()

