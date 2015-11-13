splitrows <- function(x) {
    x <- r[x, ]
    m <- regmatches(x$dates, gregexpr("[[:alpha:]]+, [[:alpha:]]+ [[:alnum:]]+, [[:alpha:]]+", x$dates))
    if(length(m[[1]]) < 1) stop("unmatched string") 
    m <- data.frame(rsvps = unlist(m))
    merge(x, m, by=character(0))
}

dat <- read.csv("RSVP - Sheet1 (4).csv")
library(tidyr); library(dplyr); library(magrittr)
dat[is.na(dat$Are.you.bringing.anyone.with.you), "Are.you.bringing.anyone.with.you"] <- 2
makeNA <- function(x) {
    if(class(x) == "factor") levels(x)[levels(x) == ""] <- NA
    x
}
dat %<>% mutate_each(funs(makeNA))
r <- gather(dat, city, dates, Chicago.IL:Seattle.WA, na.rm = T)
sapply(levels(r$city), function(x){
    filter(r, city == x) %>% 
        write.csv(file = paste0(x, ".csv", collapse = ""))
})
r <- lapply(seq_len(nrow(r)), splitrows) %>% rbind_all #%>%

r %<>% group_by(city, rsvps) %>% 
    summarise(count = sum(Are.you.bringing.anyone.with.you),
              stay = any(Would.you.be.interested.in.hosting.us == "Come on over"),
              people = paste0(Name, collapse = ", "),
              emails = paste0(Email.Address, collapse = ", ")) %>%
    mutate(daynum = as.numeric(gsub("[^[:digit:]]", "", as.character(rsvps)))) %>%
    arrange(daynum, rsvps) %>% select(-daynum) 

write.csv(r, "rsvps.csv", row.names = F)
