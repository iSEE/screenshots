# This script will consider all Rmarkdown files in the 'vignettes' subdirectory
# (typically as part of an R package structure) and execute them, taking
# appshots along the way whenever it sees a SCREENSHOT command.

library(callr)
src.dir <- "vignettes"
all.assets <- list.files(src.dir, full.names=TRUE)

out.dir <- "screenshots"
final.dir <- file.path(src.dir, out.dir)
unlink(final.dir, recursive=TRUE)
dir.create(final.dir)

for (fn in all.assets) {
    r(fun=function(fname, dir) {
        SCREENSHOT <- function(x, delay=10) {
            webshot2::appshot(app, delay=delay, file=file.path(dir, x)) # bound to global 'app'.
        }
        rmarkdown::render(fname, run_pandoc=FALSE) # avoid need for the bib file.
    }, args=list(fname=fn, dir=out.dir), show=TRUE)
}
