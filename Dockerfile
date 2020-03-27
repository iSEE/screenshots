FROM iseedevelopers/isee:latest

MAINTAINER infinite.monkeys.with.keyboards@gmail.com 
LABEL authors="infinite.monkeys.with.keyboards@gmail.com" \
    description="Docker image for screenshot generation."

# Requirements for 'compile.R' (not sure why webshot2 depends
# on webshot, but apparently it does, so there you go).
RUN Rscript -e "BiocManager::install(c('rmarkdown', 'devtools'))"
RUN Rscript -e "BiocManager::install('webshot')"
RUN Rscript -e "devtools::install_github('rstudio/webshot2')"

# Defining the entrypoint for Git management and compilation. Note that though
# 'compile.R' lives in '/', the current working directory is assumed to be in
# the top level of the Git repository based on the 'docker run' settings.
COPY compile.R /compile.R
ENTRYPOINT ["Rscript", "-e", "source('/compile.R')"]

# Additional requirements for compilation of 'iSEE' vignettes.
RUN Rscript -e "BiocManager::install(c('scater', 'Rtsne', 'scRNAseq', 'BiocStyle'))"
