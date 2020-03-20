# This script will consider all Rmarkdown files in the 'vignettes' subdirectory
# (typically as part of an R package structure) and execute them, taking
# appshots along the way whenever it sees a SCREENSHOT command.

library(callr)
src.dir <- "vignettes"
all.assets <- list.files(src.dir, full.names=TRUE)

# Necessary to get a working PhantomJS, as the HOME environment variable
# changes between a local instance and when it is executed by GitHub Actions.
# I can't just modify the PATH, either, as webshot starts a new process to 
# take the screenshot, and this doesn't inherit the environment variables.
if (Sys.which("phantomjs")=="" && normalizePath(Sys.getenv("HOME"))!="/root") {
    file.symlink("/root/bin", "~/bin")
}

out.dir <- "screenshots"
final.dir <- file.path(src.dir, out.dir)
unlink(final.dir, recursive=TRUE)
dir.create(final.dir)

for (fn in all.assets) {
    r(fun=function(fname, dir) {
        SCREENSHOT <- function(x, delay=10) {
            webshot::appshot(app, delay=delay, file=file.path(dir, x)) # bound to global 'app'.
        }
        rmarkdown::render(fname, run_pandoc=FALSE) # avoid need for the bib file.
    }, args=list(fname=fn, dir=out.dir), show=TRUE)
}
