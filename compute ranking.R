library(dplyr)
library(sqldf)
options(stringsAsFactors = FALSE)

source("Scrap ranking.R")
source("Scrap matches.R")
source("Scrap teams.R")
source("define class team.R")
source("define class match.R")
source("computeRanking.R")

matches <- getMatchesRugby(from = "01/01/2000", to = "15/02/2017")
teams <- getTeamsRugby()

teamsXV <- filter(teams,
                  teams.type == levels(teams.type)[6] & teams.sport == levels(teams.sport)[1])
## add Morocco, Tunisia, Moldova, Croatia...
# teamsXV <- rbind(teamsXV,
#                  data.frame(teams.id = "745", teams.country = "Morocco", 
#                             teams.sport = levels(teamsXV$teams.sport)[1],
#                             teams.type = levels(teamsXV$teams.type)[6], 
#                             teams.naming.name = "Morocco"),
#                  data.frame(teams.id = "775", teams.country = "Tunisia", 
#                             teams.sport = levels(teamsXV$teams.sport)[1],
#                             teams.type = levels(teamsXV$teams.type)[6], 
#                             teams.naming.name = "Tunisia"),
#                  data.frame(teams.id = "743", teams.country = "Moldova", 
#                             teams.sport = levels(teamsXV$teams.sport)[1],
#                             teams.type = levels(teamsXV$teams.type)[6], 
#                             teams.naming.name = "Moldova"))

teamsToTake <- data.frame(teamsXV[,"teams.id"])
names(teamsToTake) <- "teams.id"

teamsSQL <- teamsToTake
names(teamsSQL) <- "id"

teams1 <- merge(matches[,c("teams.id1","teams.name1","teams.id2")], teamsToTake, by.x = "teams.id2",
                by.y = "teams.id")
teams1 <- unique(teams1[,c("teams.id1","teams.name1")])
names(teams1) <- c("id","name")
teams2 <- merge(matches[,c("teams.id2","teams.name2","teams.id1")], teamsToTake, by.x = "teams.id1",
                by.y = "teams.id")
teams2 <- unique(teams2[,c("teams.id2","teams.name2")])
names(teams2) <- c("id","name")
teamsMatch <- unique(rbind(teams1, teams2))

teamsMissing <- sqldf("select distinct id, name from teamsMatch where id not in 
                      (select distinct id from teamsSQL)")

teamsMissing <- data.frame(teams.id = teamsMissing$id,
                           teams.country = teamsMissing$name,
                           teams.sport = levels(teamsXV$teams.sport)[1],
                           teams.type = levels(teamsXV$teams.type)[6],
                           teams.naming.name = teamsMissing$name)
teamsXV <- rbind(teamsXV, teamsMissing)

matchXV <- merge(matches, teamsToTake, by.x = "teams.id1", by.y = "teams.id")

matchXV <- mutate(matchXV,
                  time.millis = as.numeric(as.character(time.millis)),
                  date = format(as.POSIXct(time.millis/1000, origin = "1970-01-01"),"%d/%m/%Y"))
matchXV <- matchXV[order(matchXV$time.millis),]

### create team objects as a start
for (k in 1:nrow(teamsXV)) {
  t <- teamsXV[k,]
  hR <- new("irregular_ts", time = as.POSIXct("31/12/1999", format = "%d/%m/%Y"),
            value = 40)
  newObj <- new("team", name = t$teams.naming.name, id = t$teams.id,
                ranking = 40, dateRanking = as.Date("31/12/1999", format = "%d/%m/%Y"),
                historicRanking = hR)
  txt <- paste0("team", t$teams.id, " <- newObj")
  eval(parse(text = txt))
}

### compute ranking

for (r in 1:nrow(matchXV)) {
  dataMatch <- matchXV[r,]
  idTeamA <- dataMatch$teams.id1
  idTeamB <- dataMatch$teams.id2
  teamA <- eval(parse(text = paste0("team",idTeamA)))
  teamB <- eval(parse(text = paste0("team",idTeamB)))
  newMatch <- new("match", teamA = teamA, teamB = teamB, 
                  scoreA = as.numeric(dataMatch$scores1),
                  scoreB = as.numeric(dataMatch$scores2), 
                  date = as.Date(as.POSIXct(dataMatch$time.millis/1000, origin = "1970-01-01")),
                  competition = dataMatch$events.label)
  updateTeam <- computeRanking(newMatch, type = "WR")
  eval(parse(text = paste0("team",idTeamA, " <- updateTeam$teamA")))
  eval(parse(text = paste0("team",idTeamB, " <- updateTeam$teamB")))
}
