computeRkWR <- function(scoreA, scoreB, rankingA, rankingB, weight) {
  if (abs(rankingA - rankingB) < 10) {
    swap <- (as.numeric(scoreB > scoreA) 
             - as.numeric(scoreA > scoreB) 
             + (rankingA - rankingB)*0.1)
  } else {
    swap <- 2*(as.numeric(scoreB > scoreA)*as.numeric(rankingA > rankingB) 
               - as.numeric(scoreA > scoreB)*as.numeric(rankingB > rankingA))
    + as.numeric(scoreA == scoreB)*sign(rankingA - rankingB)
  }
  
  if (abs(scoreA - scoreB > 15))
    weight <- weight*1.5
  rankingA <- rankingA - swap*weight
  rankingB <- rankingB + swap*weight
  return(list(rankingA = rankingA, rankingB = rankingB))
}

computeRkWR_alt <- function(scoreA, scoreB, rankingA, rankingB, weight) {
  swap <- (as.numeric(scoreB > scoreA) 
           - as.numeric(scoreA > scoreB) 
           + (rankingA - rankingB)*0.1)
  
  if (abs(scoreA - scoreB > 15))
    weight <- weight*1.5
  rankingA <- rankingA - swap*weight
  rankingB <- rankingB + swap*weight
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

computeRanking <- function(match, type = c("WR","ELO","WRa")) {
  teamA <- match@teamA
  teamB <- match@teamB
  if (type == "WR")
    newRanking <- computeRkWR(match@scoreA, match@scoreB, teamA@ranking, teamB@ranking, 
                              match@weight) else if (type == "ELO")
                                newRanking <- computeRkELO(match@scoreA, match@scoreB, teamA@ranking, teamB@ranking, 10) else
                                  newRanking <- computeRkWR_alt(match@scoreA, match@scoreB, teamA@ranking, teamB@ranking, 
                                                                match@weight)
  teamA <- updateRanking(teamA, newRanking$rankingA, as.POSIXct(match@date, format = "%Y-%m-%d"))
  teamB <- updateRanking(teamB, newRanking$rankingB, as.POSIXct(match@date, format = "%Y-%m-%d"))
  return(list(teamA = teamA, teamB = teamB))
}
