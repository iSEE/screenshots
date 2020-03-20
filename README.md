# iSEE screenshots

## Overview 

This repository specifies a Docker image to automatically generate screenshots of **iSEE** instances,
using the `appshot()` function from the **webshot** package. 
This allows other repositories to set up GitHub Actions using [the published image on DockerHub](https://hub.docker.com/repository/docker/iseedevelopers/screenshots);
the idea is to recreate screenshots on the fly and then store them as static PNGs in those repositories, 
for referencing during vignette compilation.
We prefer static PNGs over attempting regeneration during vignette compilation 
as the screenshot generation is rather fragile (system dependency on `PhantomJS`, intermittent time-out problems). 

## Rmarkdown as instance generators 

To trigger screenshot construction, a "source" repository should contain Rmarkdown files in the `vignettes/` subdirectory.

- Each Rmarkdown file can create Shiny app objects in an `app` variable (possibly multiple times).
The chunk that creates `app` should be followed by a code chunk that calls the `SCREENSHOT()` function,
supplied with the desired name of the PNG file and (optionally) the delay between loading the app and taking the screenshot.

  ````
  ```{r}
  # Something happens to create 'app'.
  app <- iSEE()
  ```
  
  ```{r}
  SCREENSHOT(app, delay=20)
  ```
  ````

- Each Rmarkdown file should have a silent code chunk at the top that defines the `SCREENSHOT` function if it doesn't exist.
This will be used to insert the screenshots during Rmarkdown compilation in the source repository;
it will be ignored when the screenshots are being compiled in the **screenshots** repository.

  ````
  ```{r, eval=!exists("SCREENSHOT"), include=FALSE}
  SCREENSHOT <- function(x, ...) {
      knitr::include_graphics(file.path("screenshots", x))
  }
  ```
  ````

## Setting up GitHub Actions

See `.github/workflows/compile.yml` in https://github.com/iSEE/iSEE for an example.
The idea is to checkout the source repository, run through `vignettes/` to generate screenshots,
and then upload the screenshots as a workflow artifact.
Developers can then download the artifact and manually commit the desired images into the repository for use in vignettes.

At some point, we may have an automated commit,
though this depends on the screenshots _not_ changing too frequently,
otherwise the source repository will have bloated blobs.

