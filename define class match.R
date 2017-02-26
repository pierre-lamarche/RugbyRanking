setClass("match",
         slots = c(teamA = "team", teamB = "team", scoreA = "numeric", scoreB = "numeric", 
                   date = "POSIXct", competition = "character", weight = "numeric"))