library(Hmisc)
library(httr)
#library(RJSONIO)
library(rjson)
#library(jsonlite)
library(plyr)
library(dplyr)

getDataRugby <- function(from, to) {
  from <- as.Date(from, "%d/%m/%Y")
  to <- as.Date(to, "%d/%m/%Y")
  d1 <- format(from,"%d")
  m1 <- format(from,"%m")
  y1 <- format(from,"%Y")
  d2 <- format(to,"%d")
  m2 <- format(to,"%m")
  y2 <- format(to,"%Y")
  json_file <- fromJSON(file = paste0("http://cmsapi.pulselive.com/rugby/match.json?startDate=",y1,"-",m1,"-",d1,"&endDate=",y2,"-",m2,"-",d2))
  meta_data <- json_file$pageInfo
  nPages <- ceiling(meta_data$numEntries/100)
  
  json_file <- fromJSON(file = paste0("http://cmsapi.pulselive.com/rugby/match.json?startDate=2000-01-01&endDate=2000-12-31&page=1&pageSize=10"))
  json_file <- lapply(json_file$content, function(x) {
    x[sapply(x, is.null)] <- NA
    unlist(x)
  })
  nameVar <- names(json_file[[1]])
  i <- which(duplicated(nameVar))
  j <- which(duplicated(nameVar, fromLast = TRUE))
  nameVar[j] <- paste0(nameVar[j],"1")
  nameVar[i] <- paste0(nameVar[i],"2")
  
  for (k in 1:nPages) {
    json_file <- fromJSON(file = paste0("http://cmsapi.pulselive.com/rugby/match.json?startDate=",y1,"-",m1,"-",d1,"&endDate=",y2,"-",m2,"-",d2,"&page=",k,"&pageSize=100"))
    json_file <- lapply(json_file$content, function(x) {
      x[sapply(x, is.null)] <- NA
      unlist(x)
    })
    json_file <- lapply(json_file, function(x) {
      nameX <- names(x)
      i <- which(duplicated(nameX))
      j <- which(duplicated(nameX, fromLast = TRUE))
      nameX[j] <- paste0(nameX[j],"1")
      nameX[i] <- paste0(nameX[i],"2")
      names(x) <- nameX
      x[nameVar]
    })
    if (k == 1)
      dataRugby <- do.call("rbind", json_file) else
        dataRugby <- rbind(dataRugby, do.call("rbind", json_file))
  }
  dataRugby <- as.data.frame(dataRugby)
  names(dataRugby) <- nameVar
  return(dataRugby)
}
