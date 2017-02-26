setClass("irregular_ts",
         slots = c(time = "POSIXct", value = "numeric"))

setClass("team",
         slots = c(name="character", id="character", ranking="numeric", dateRanking="POSIXct",
                        historicRanking="irregular_ts"))

updateRanking <- function(team, ranking, date) {
  team@historicRanking@time <- c(team@historicRanking@time, date)
  team@historicRanking@value <- c(team@historicRanking@value, ranking)
  team@dateRanking <- date
  team@ranking <- ranking
  return(team)
}