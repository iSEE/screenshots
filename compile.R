# This script will consider all Rmarkdown files in the 'vignettes' subdirectory
# (typically as part of an R package structure) and execute them, taking
# appshots along the way whenever it sees a SCREENSHOT command.
# remotes::install_github("rstudio/webshot2")

args <- commandArgs(trailingOnly=TRUE)
if (length(args)) {
    all.assets <- args
} else {
    src.dir <- "vignettes"
    all.assets <- list.files(src.dir, full.names=TRUE, pattern=".Rmd$")
}

library(callr)

for (fn in all.assets) {
    r(fun=function(fname) {
        SCREENSHOT <- function(x, delay=20) {
            dir.create(dirname(x), recursive=TRUE, showWarning=FALSE)
            webshot2::appshot(app, delay=delay, file=x) # bound to global 'app'.
        }
        rmarkdown::render(fname, run_pandoc=FALSE) # avoid need for the bib file.
    }, args=list(fname=fn), show=TRUE)
}
