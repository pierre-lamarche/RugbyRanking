computeRk <- function(teamA, teamB, scoreA, scoreB) {
  switch <- (1+0.5*(as.numeric(abs(scoreA - scoreB) >= 15)))*(as.numeric(scoreA > scoreB) - 
                                                                as.numeric(scoreB > scoreA) +
                                                                (teamB$ranking - teamA$ranking)*0.1)
  
  teamA$ranking <- teamA$ranking + switch
  teamB$ranking <- teamB$ranking - switch
  return(list(teamA = teamA, teamB = teamB))
}

computeRanking <- function(match) {
  
}