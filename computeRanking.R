computeRkWR <- function(scoreA, scoreB, rankingA, rankingB) {
  switch <- (1+0.5*(as.numeric(abs(scoreA - scoreB) >= 15)))*(as.numeric(scoreA > scoreB) - 
                                                                as.numeric(scoreB > scoreA) +
                                                                (rankingB - rankingA)*0.1)
  
  rankingA <- rankingA + switch
  rankingB <- rankingB - switch
  return(list(rankingA = rankingA, rankingB = rankingB))
}

computeRanking <- function(match, type = c("WR","ELO")) {
  
}