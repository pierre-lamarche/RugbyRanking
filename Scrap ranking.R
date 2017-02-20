getRankingRugby <- function(date) {
  require(rjson)
  day <- format(date,"%d")
  month <- format(date,"%m")
  year <- format(date,"%Y")
  json_file <- fromJSON(file = paste0("http://cmsapi.pulselive.com/rugby/rankings/mru.json?date=",year,"-",month,"-",day))
  json_file <- lapply(json_file$entries, function(x) {
    x[sapply(x, is.null)] <- NA
    unlist(x)
  })
  json_file <- do.call("rbind", json_file)
  tab <- as.data.frame(json_file)
  tab$date <- date
  tab
}