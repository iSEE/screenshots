# iSEE screenshots

## Overview 

This repository specifies a Docker image to automatically generate screenshots of **iSEE** instances,
using the `appshot()` function from the **webshot** package. 
This allows other repositories to use [the published image on DockerHub](https://hub.docker.com/repository/docker/iseedevelopers/screenshots) to recreate screenshots on the fly.
Screenshots can then be stored as static PNGs in those repositories, e.g., for referencing during vignette compilation.
We prefer static PNGs over attempting regeneration during vignette compilation 
as the screenshot generation is rather fragile (system dependency on `PhantomJS`, intermittent time-out problems). 

## Rmarkdown as instance generators 

To trigger screenshot construction, a "source" repository should contain Rmarkdown files in the `vignettes/` subdirectory.

- Each Rmarkdown file can create Shiny app objects in an `app` variable (possibly multiple times).
The chunk that creates `app` should be followed by a code chunk that calls the `SCREENSHOT()` function,
supplied with the desired path of the PNG file and (optionally) the delay between loading the app and taking the screenshot.
We suggest saving to a `screenshots/` subdirectory withint `vignettes/`.

  ````
  ```{r}
  # Something happens to create 'app'.
  app <- iSEE()
  ```
  
  ```{r}
  SCREENSHOT("screenshots/some_name_here.png", delay=20)
  ```
  ````

- Each Rmarkdown file should have a silent code chunk at the top that defines the `SCREENSHOT` function if it doesn't exist.
This will be used to insert the PNGs during Rmarkdown compilation in the source repository;
it will be ignored when the screenshots are being compiled by the `compile.R` script from this repository.

  ````
  ```{r, eval=!exists("SCREENSHOT"), include=FALSE}
  SCREENSHOT <- function(x, ...) knitr::include_graphics(x)
  ```
  ````

## Compiling screenshots

Navigate to the directory containing the desired source repository on your local machine and run:

```sh
git rm -rf --ignore-unmatch vignettes/screenshots
docker run --rm -v "$(pwd)":"/workspace" --workdir=/workspace iseedevelopers/screenshots
git add vignettes/screenshots
git commit -m "Recompiled screenshots."
```

This will (re)create and commit a `screenshots` directory containing all screenshots generated from the vignettes.

Alternatively, if you already have `PhantomJS` set up, you can replace the `docker` call with just running `compile.R`.
This may be preferable if the screenshots require **iSEE** functionality not yet available in the DockerHub image.

It is also possible to do this automatically via GitHub Actions,
though we eventually decided it was less intrusive to manage commits manually.
