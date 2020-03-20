# This script will consider an Rmarkdown file and execute it, taking appshots
# along the way whenever it sees a SCREENSHOT command.

library(callr)
all.assets <- read.csv("sources.csv", header=FALSE, stringsAsFactors=FALSE)

# Necessary to get a working PhantomJS, as the HOME environment variable
# changes between a local instance and when it is executed by GitHub Actions.
# I can't just modify the PATH, either, as webshot starts a new process to 
# take the screenshot, and this doesn't inherit the environment variables.
if (normalizePath(Sys.getenv("HOME"))!="/root") {
    file.symlink("/root/bin", "~/bin")
}

for (i in seq_len(nrow(all.assets))) {
    r(fun=function(repo, fname) {
        if (grepl("@", repo)) {
            branch <- sub(".*@", "", repo)
            repo <- sub("@.*", "", repo)
        } else {
            branch <- "master"
        }

        final.dir <- file.path("images", repo)
        dir.create(final.dir, showWarning=FALSE, recursive=TRUE)

        SCREENSHOT <- function(x, delay=10) {
            webshot::appshot(app, delay=delay, file=x) # bound to global 'app'.
        }

        src <- file.path("https://raw.githubusercontent.com/iSEE", repo, branch, fname)
        fname2 <- file.path(final.dir, basename(fname))
        download.file(src, fname2)
        rmarkdown::render(fname2, clean=FALSE, run_pandoc=FALSE) # avoid need for the bib file.
    }, args=list(repo=all.assets[i,1], fname=all.assets[i,2]), show=TRUE)
}
