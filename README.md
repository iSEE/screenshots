# iSEE screenshots

## Overview

This repository contains code to automatically generate screenshots of **iSEE** instances,
using the `appshot()` function from the **webshot** package to generate screenshots in an automated manner.
This provides a location from which other packages can access these screenshots (e.g., during vignette compilation).

## Organization

We organize the repository into these subdirectories:

- `data/`, a directory of R scripts to generate a `SummarizedExperiment` object.
- `apps/`, a directory of R scripts to create an **iSEE** instance.
- `images/`, a directory of screenshots for each **iSEE** instance.

Note that `images/` is only populated with PNGs in the `compiled` branch of this repository.
This allows us to delete and regenerate images at any point without swamping the `master` with large binaries.

## Instructions 

To avoid constructing the same `SummarizedExperiment` multiple times for different **iSEE** instances,
we centralize data processing into a common `data/` directory.
Here, each script is expected to generate an RDS file containing a `SummarizedExperiment` object.
The RDS file should contain the same prefix as the script, e.g., `allen.R` should generate `allen.rds`.

Each script in `data/` should load an SE object from an RDS file and generate a Shiny app object named `app`.
We suggest using **rprojroot** to access the RDS file, to ensure that the file can be run from anywhere inside the repository.
The script may also generate `delay`, a numeric scalar specifying the number of seconds to wait before taking the screenshot.
Longer delays may be necessary to ensure that more complex plots are properly built.

The `images/compile.R` file will execute each script in `apps/` and take the screenshot with the specified delay.
A PNG file is produced with the same prefix as its originating source file.
Note that it is necessary to run `webshot::install_phantomjs()` before running this script.
You should also change the branch to `compiled` before generating and committing new images.

## Contribute

Contributors should add files to `data/` and `apps/` as necessary; we will take care of recompiling them.
