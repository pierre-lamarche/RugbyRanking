# RugbyRanking

Following the Six Nations 2017, I read this interesting [webpage](http://www.worldrugby.org/rankings/explanation) explaining how World Rugby's rating was calculated (also thanks a lot to [L'Equipe](http://www.lequipe.fr/Rugby/Actualites/France-ecosse-decisif-en-vue-du-tirage-au-sort-de-la-coupe-du-monde-2019/776621) for pointing out the webpage). I was then wondering how much the ranking was sensitive to the method of computation, and in particular, I was eager to test the ELO method applied to chess for instance. I am grateful to this [Github repo](https://github.com/octonion/rugby) which provides with the Web database for rugby (and more) matches: this avoided me to write text miners in order to extract the results from the World Rugby webpage.

Recomputing the ranking since 2003, and trying alternative methods of ranking:

| Position | Official WR ranking | Alternative WR ranking | ELO ranking | Alternative ELO ranking |
|----------|---------------------|------------------------|-------------|--------|
| 1        | NZL                 | NZL                    | ENG         | NZL    |
| 2        | ENG                 | ENG                    | NZL         | ENG    | 
| 3        | AUS                 | AUS                    | AUS         | AUS    |
| 4        | IRE                 | IRE                    | IRE         | IRE    |
| 5        | WAL                 | WAL                    | WAL         | FRA    |
| 6        | RSA                 | SCO                    | FRA         | SCO    |
| 7        | FRA                 | RSA                    | SCO         | ARG    |
| 8        | SCO                 | FRA                    | RSA         | WAL    |
| 9        | ARG                 | ARG                    | FJI         | RSA    |
| 10       | FJI                 | FJI                    | GEO         | GEO    |

*Ranking as on Feb, 19, 2017.*