getTeamsRugby <- function() {
  json_file <- fromJSON(file = "http://cmsapi.pulselive.com/rugby/country.json&page=0")
  ### value labels for the factors
  sportLabels <- do.call("c",json_file$content$sportLookup)
  typeLabels <- do.call("c",json_file$content$typeLookup)
  nPages <- ceiling(json_file$pageInfo$numEntries/10)
  for (k in 1:nPages) {
    json_file <- fromJSON(file = paste0("http://cmsapi.pulselive.com/rugby/country.json&pageSize=10&page=",k))
    json_file <- lapply(json_file$content$countries, function(x) {
      x[sapply(x, is.null)] <- NA
      unlist(x)
    })
    json_file <- lapply(json_file, function(x) {
      i <- which(names(x) == "teams.id")
      j <- c(i[2:length(i)]-1,length(x))
      k <- mapply(function(i,j) x[i:j], i=i, j=j)
      tab <- lapply(k, function(x) x[c("teams.id","teams.country","teams.sport","teams.type","teams.naming.name")])
      do.call("rbind", tab)
    })
    if (k == 1)
      dataRugby <- as.data.frame(do.call("rbind", json_file)) else
        dataRugby <- rbind(dataRugby, as.data.frame(do.call("rbind", json_file)))
  }
  dataRugby$teams.sport <- factor(dataRugby$teams.sport,
                                  levels = 1:length(sportLabels),
                                  labels = sportLabels)
  dataRugby$teams.type <- factor(dataRugby$teams.type,
                                 levels = 1:length(typeLabels),
                                 labels = typeLabels)
  return(dataRugby)
}