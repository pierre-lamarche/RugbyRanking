computeRkWR <- function(scoreA, scoreB, rankingA, rankingB) {
  switch <- (1+0.5*(as.numeric(abs(scoreA - scoreB) >= 15)))*(as.numeric(scoreA > scoreB) - 
                                                                as.numeric(scoreB > scoreA) +
                                                                (rankingB - rankingA)*0.1)
  
  rankingA <- rankingA + switch
  rankingB <- rankingB - switch
  return(list(rankingA = rankingA, rankingB = rankingB))
}

computeRkELO <- function(scoreA, scoreB, rankingA, rankingB, K) {
  D <- rankingA - rankingB
  pDA <- 1/(1+10**(-D/20))
  pDB <- 1/(1+10**(D/20))
  outcome <- as.numeric(scoreA > scoreB) + 0.5*as.numeric(scoreA == scoreB)
  rankingA <- rankingA + K*(outcome - pDA)
  rankingB <- rankingB + K*(1 - outcome - pDB)
  return(list(rankingA = rankingA, rankingB = rankingB))
}

computeRanking <- function(match, type = c("WR","ELO")) {
  teamA <- match@teamA
  teamB <- match@teamB
  if (type == "WR")
    newRanking <- computeRkWR(match@scoreA, match@scoreB, teamA@ranking, teamB@ranking) else
      newRanking <- computeRkELO(match@scoreA, match@scoreB, teamA@ranking, teamB@ranking, 10)
  teamA <- updateRanking(teamA, newRanking$rankingA, as.POSIXct(match@date))
  teamB <- updateRanking(teamB, newRanking$rankingB, as.POSIXct(match@date))
  return(list(teamA = teamA, teamB = teamB))
}
