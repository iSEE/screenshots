# iSEE screenshots

This repository contains code to automatically generate screenshots of **iSEE** instances,
using the `appshot()` function from the **webshot** package to generate screenshots in an automated manner.
This provides a location from which other repositories can access these screenshots (e.g., during vignette compilation).

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

Then it is a simple matter of modifying `sources.csv` to include the source repository and the path to the Rmarkdown file(s).
Currently, only repositories in the `iSEE` organization are supported as sources.

A push to the **screenshots** repository will trigger recompilation of the screenshots via GitHub Actions,
populating `images/` with PNGs in the `compiled` branch.
This set up allows us to delete and regenerate images at any point without swamping the `master` with large binaries.
