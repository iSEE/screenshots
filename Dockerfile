FROM iseedevelopers/isee:latest

MAINTAINER infinite.monkeys.with.keyboards@gmail.com 
LABEL authors="infinite.monkeys.with.keyboards@gmail.com" \
    description="Docker image for screenshot generation."

RUN Rscript -e "BiocManager::install(c('scater', 'Rtsne'))"

RUN Rscript -e "BiocManager::install('webshot')"
RUN mkdir ~/bin
RUN apt-get update
RUN apt-get install lbzip2
RUN Rscript -e "webshot:::install_phantomjs()"

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
