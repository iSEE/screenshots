library(webshot)
app.dir <- "../apps"
all.files <- list.files(app.dir, pattern=".R$", recursive=TRUE)

for (x in all.files) {
    curenv <- new.env()
    source(file.path(app.dir, x), local=curenv)

    delay <- curenv$delay
    if (is.null(delay)) {
        delay <- 10
    }

    fname <- sub(".R$", ".png", x)
    dir.create(dirname(fname), showWarning=FALSE, recursive=TRUE)
    appshot(curenv$app, delay=delay, file=fname, cliprect="viewport")
}
