# This script will consider an Rmarkdown file and execute it, taking appshots
# along the way whenever it sees a SCREENSHOT command.

library(callr)
all.assets <- read.csv("sources.csv", header=FALSE, stringsAsFactors=FALSE)

for (i in seq_len(nrow(all.assets))) {
    r(fun=function(repo, fname) {
        final.dir <- file.path("images", repo)
        dir.create(final.dir, showWarning=FALSE, recursive=TRUE)

        SCREENSHOT <- function(x, delay=10) {
            webshot::appshot(app, delay=delay, file=x) # bound to global 'app'.
        }

        src <- sprintf("https://raw.githubusercontent.com/iSEE/%s/screenshots/%s", repo, fname)
        fname2 <- file.path(final.dir, basename(fname))
        download.file(src, fname2)
        rmarkdown::render(fname2, run_pandoc=FALSE) # avoid need for the bib file.
    }, args=list(repo=all.assets[i,1], fname=all.assets[i,2]))
}    
