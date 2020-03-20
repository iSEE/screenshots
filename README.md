# iSEE screenshots

## Overview 

This repository contains code to automatically generate screenshots of **iSEE** instances,
using the `appshot()` function from the **webshot** package to generate screenshots in an automated manner.
This provides a location from which other repositories can access these screenshots (e.g., during vignette compilation).

## Rmarkdown as instance generators 

To trigger screenshot construction, a "source" repository should contain Rmarkdown files that create **iSEE** instances.

- Each Rmarkdown file should create Shiny app objects in an `app` variable.
This chunk should be followed by a code chunk that calls the `SCREENSHOT()` function,
supplied with the desired name of the image and (optionally) the delay between loading the app and taking the screenshot.

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
      # Replace <SRC> with the name of the source repository.
      knitr::include_graphics(file.path("https://raw.githubusercontent.com/iSEE/screenshots/compiled/images/<SRC>", x))
  }
  ```
  ````

## Adding an Rmarkdown source

To specify an Rmarkdown file as an instance generator,
modify `sources.csv` to include the source repository and the path to the Rmarkdown file.
Currently, only repositories in the `iSEE` organization are supported as sources.

A push to the **screenshots** repository will trigger recompilation of the screenshots via GitHub Actions,
populating `images/` with PNGs in the `compiled` branch.
This set-up allows us to delete and regenerate images at any point without swamping the `master` with large binaries.

By default, files are retrieved from the `master` branch unless specified otherwise
(with `@<BRANCH>` notation after the source repository name in `sources.csv`).
If the source repository requires the screenshots to be present to pass CI before merging to its `master`,
this means a little dance is required:

1. Commit the Rmarkdown files to a non-`master` branch of the source repository (e.g., the `devel` branch)
Allow CI failures to occur.
2. Add the new Rmarkdown files to `sources.csv` in the `screenshots` repository,
with `@devel` added to the end of the repository name.
Push to trigger re-compilation of the screenshots.
3. Bump `devel` branch in the source repository to pass CI, and then merge into `master`.
4. Delete `@devel` from `sources.csv` and push to the `screenshots` repository.

Alternatively, if you have sufficient privileges,
you can just force changes to `master` in **1** and add new entries to `sources.csv` without specifying the branch in **2**,
allowing you to skip the `devel`-related steps in **3** and **4** entirely.
