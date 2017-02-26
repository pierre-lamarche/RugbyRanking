library(dplyr)
library(sqldf)
options(stringsAsFactors = FALSE)

source("Scrap ranking.R")
source("Scrap matches.R")
source("Scrap teams.R")
source("define class team.R")
source("define class match.R")
source("computeRanking.R")

second_step <- 60*60*24*7
date_start <- as.POSIXct("20/10/2003", format = "%d/%m/%Y")
date_end <- as.POSIXct("20/02/2017", format = "%d/%m/%Y")
array_date <- as.Date(as.POSIXct(seq(from = as.numeric(date_start),
                                     to = as.numeric(date_end),
                                     by = second_step), origin = "1970-01-01"))

json <- lapply(array_date, getRankingRugby)
rankingHistoric <- do.call("rbind",json)

teamsXV_ranked <- unique(rankingHistoric[!duplicated(rankingHistoric$team.id),])

matches <- getMatchesRugby(from = "20/10/2003", to = "20/02/2017")

matchesId <- matches[,c("matchId","teams.id1","teams.id2")]
names(matchesId) <- c("matchId","teams_id1","teams_id2")

teamsToTake <- teamsXV_ranked[,c("team.id","team.name")]
names(teamsToTake) <- c("team_id","team_name")

matchesXV <- sqldf("select matchId from matchesId where teams_id1 in (select team_id from teamsToTake) and
                   teams_id2 in (select team_id from teamsToTake)")
matchesXV <- merge(matches, matchesXV)
matchesXV <- mutate(matchesXV,
                    events.rankingsWeight = ifelse(is.na(events.rankingsWeight), 1, 
                                                   events.rankingsWeight))
matchesXV <- matchesXV[order(as.numeric(matchesXV$time.millis)),]

### create team objects as a start
for (k in 1:nrow(teamsXV_ranked)) {
  t <- teamsXV_ranked[k,]
  hR <- new("irregular_ts", time = as.POSIXct(t$date),
            value = as.numeric(t$pts))
  newObj <- new("team", name = t$team.name, id = t$team.id,
                ranking = as.numeric(t$pts), dateRanking = as.POSIXct(t$date),
                historicRanking = hR)
  txt <- paste0("team", t$team.id, " <- newObj")
  eval(parse(text = txt))
}

### compute ranking

for (r in 1:nrow(matchesXV)) {
  dataMatch <- matchesXV[r,]
  idTeamA <- dataMatch$teams.id1
  idTeamB <- dataMatch$teams.id2
  teamA <- eval(parse(text = paste0("team",idTeamA)))
  ### bonus for the receiving team
  #teamA@ranking <- teamA@ranking + 3
  teamB <- eval(parse(text = paste0("team",idTeamB)))
  newMatch <- new("match", teamA = teamA, teamB = teamB, 
                  scoreA = as.numeric(dataMatch$scores1),
                  scoreB = as.numeric(dataMatch$scores2), 
                  date = as.POSIXct(as.numeric(dataMatch$time.millis)/1000, origin = "1970-01-01"),
                  competition = dataMatch$events.label,
                  weight = as.numeric(dataMatch$events.rankingsWeight))
  updateTeam <- computeRanking(newMatch, type = "WR")
  eval(parse(text = paste0("team",idTeamA, " <- updateTeam$teamA")))
  eval(parse(text = paste0("team",idTeamB, " <- updateTeam$teamB")))
}


rankingFR <- filter(rankingHistoric,
                    team.id == "42")

plot(team42@historicRanking@time, team42@historicRanking@value, type = "l", col = "blue", lwd = 2)
lines(as.POSIXct(rankingFR$date), rankingFR$pts, col = "lightblue", lty = 2, lwd = 2)
