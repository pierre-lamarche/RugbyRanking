getTeamsRugby <- function() {
  json_file <- fromJSON(file = "http://cmsapi.pulselive.com/rugby/country.json?&page=0")
  ### value labels for the factors
  sportLabels <- do.call("c",json_file$content$sportLookup)
  typeLabels <- do.call("c",json_file$content$typeLookup)
  nPages <- ceiling(json_file$pageInfo$numEntries/100)
  for (k in 0:nPages) {
    json_file <- fromJSON(file = paste0("http://cmsapi.pulselive.com/rugby/country.json?&pageSize=100&page=",k))
    json_file <- lapply(json_file$content$countries, function(x) {
      x[sapply(x, is.null)] <- NA
      unlist(x)
    })
    json_file <- lapply(json_file, function(x) {
      i <- which(names(x) == "teams.id")
      if (length(i) > 1) 
        j <- c(i[2:length(i)]-1,length(x)) else
          j <- length(x)
      if (length(i) > 1) {
        kk <- mapply(function(i,j) x[i:j], i=i, j=j)
        tab <- lapply(kk, function(x) x[c("teams.id","teams.country","teams.sport","teams.type","teams.naming.name")])
        do.call("rbind", tab)
      } else if (length(i) == 1) {
        tab <- t(matrix(x[c("teams.id","teams.country","teams.sport","teams.type","teams.naming.name")]))
        colnames(tab) <- c("teams.id","teams.country","teams.sport","teams.type","teams.naming.name")
        tab
      }
    })
    if (k == 0)
      dataRugby <- as.data.frame(do.call("rbind", json_file)) else
        dataRugby <- rbind(dataRugby, as.data.frame(do.call("rbind", json_file)))
  }
  dataRugby$teams.sport <- factor(dataRugby$teams.sport,
                                  levels = 1:length(sportLabels),
                                  labels = sportLabels)
  dataRugby$teams.type <- factor(dataRugby$teams.type,
                                 levels = 1:length(typeLabels),
                                 labels = typeLabels)
  dataRugby <- filter(dataRugby,
                      !is.na(teams.id))
  return(dataRugby)
}