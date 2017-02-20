second_step <- 60*60*24*5
date_start <- as.POSIXct("15/01/2004", format = "%d/%m/%Y")
date_end <- as.POSIXct("20/02/2017", format = "%d/%m/%Y")
array_date <- as.Date(as.POSIXct(seq(from = as.numeric(date_start),
                                     to = as.numeric(date_end),
                                     by = second_step), origin = "1970-01-01"))


json <- lapply(array_date, getRankingRugby)
rankingHistoric <- do.call(json, "rbind")