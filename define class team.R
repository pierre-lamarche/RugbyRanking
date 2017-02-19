setClass("irregular_ts",
         slots = c(time = "POSIXct", value = "numeric"))

setClass("team",
         slots = c(name="character", id="character", ranking="numeric", dateRanking="Date",
                        historicRanking="irregular_ts"))