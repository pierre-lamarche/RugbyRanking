library(dplyr)

source("Scrap ranking.R")
source("Scrap matches.R")
source("Scrap teams.R")
source("define class team.R")

matches <- getMatchesRugby(from = "01/01/2000", to = "15/02/2017")
teams <- getTeamsRugby()

teamsXV <- filter(teams,
                  teams.type == levels(teams.type)[6] & teams.sport == levels(teams.sport)[1])

teamsToTake <- data.frame(teamsXV[,"teams.id"])
names(teamsToTake) <- "teams.id"
matchXV <- merge(matches, teamsToTake, by.x = "teams.id1", by.y = "teams.id")

matchXV <- mutate(matchXV,
                  time.millis = as.numeric(as.character(time.millis)),
                  date = format(as.POSIXct(time.millis/1000, origin = "1970-01-01"),"%d/%m/%Y"))
matchXV <- matchXV[order(matchXV$time.millis),]