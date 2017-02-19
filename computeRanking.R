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
  pDA <- 1/(1+10**(-D/15))
  pDB <- 1/(1+10**(D/15))
  rankingA <- rankingA + K*((scoreA - scoreB) - pDA)
  rankingB <- rankingB + K*((scoreB - scoreA) - pDB)
}

computeRanking <- function(match, type = c("WR","ELO")) {
  
}