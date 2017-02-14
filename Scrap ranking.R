getRankingRugby <- function() {
  require(rjson)
  json_file <- fromJSON(file = paste0("http://cmsapi.pulselive.com/rugby/rankings/mru.json"))
  json_file <- lapply(json_file$entries, function(x) {
    x[sapply(x, is.null)] <- NA
    unlist(x)
  })
  json_file <- do.call("rbind", json_file)
  as.data.frame(json_file)
}