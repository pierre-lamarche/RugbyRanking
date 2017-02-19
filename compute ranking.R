library(dplyr)
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

teamsToTake <- data.frame(teamsXV[,"teams.id"])
names(teamsToTake) <- "teams.id"
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
  newMatch <- new("match", teamA = teamA, teamB = teamB, scoreA = dataMatch$scores1,
                  scoreB = dataMatch$scores2, 
                  date = format(as.POSIXct(dataMatch$time.millis/1000, origin = "1970-01-01"),"%d/%m/%Y"),
                  competition = dataMatch$events.label)
  updateTeam <- computeRanking
}
