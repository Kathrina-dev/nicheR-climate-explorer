# nicheRclimate [![R-CMD-check](https://github.com/Kathrina-dev/nicheR-climate-explorer/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Kathrina-dev/nicheR-climate-explorer/actions/workflows/R-CMD-check.yaml)

**Climate Data Explorer for Ecological Niche Modeling** 

`nicheRclimate` is an R package and Shiny application designed to facilitate interactive exploration of bioclimatic variables and ecological niche workflows. It provides tools to download, process, filter, and visualize climate raster data, supporting reproducible ecological modeling pipelines.

<img width="1919" height="758" alt="image" src="https://github.com/user-attachments/assets/206772e5-0c1c-4d13-948e-7dd968223fd4" />

---

## Features

- **Interactive Shiny GUI** for climate data exploration
- **Global and regional raster processing**: South America, Africa, Asia
- **Parameter-driven filtering** to simulate ecological niches (e.g., temperature range)
- **Suitability mapping** based on environmental constraints
- **Modular helper functions** for reproducible workflows:
  - `download_bioclim()` – download WorldClim bioclimatic variables
  - `get_bio1()` – extract BIO1 (Annual Mean Temperature)
  - `crop_region()` – crop rasters to a specific region
- **Fully structured R package** for maintainability and deployment:
  - DESCRIPTION, NAMESPACE, and roxygen2 documentation
  - Exportable `run_app()` entry point

---

## Installation

You can install the package directly from GitHub:

```r
# install remotes if not already installed
install.packages("remotes")

# install nicheRclimate from GitHub
remotes::install_github("YOUR_GITHUB_USERNAME/nicheRclimate")
```

Load the package:

```r
library(nicheRclimate)
```

---

## Launch the Shiny App

```r
run_app()
```

This launches an interactive interface where you can:

Select a geographic region (South America, Africa, Asia)
Filter climate data by temperature range
Explore raw, cropped, filtered, and suitability raster maps

Example Workflow

```r
# Download bioclimatic data
clim <- download_bioclim(path = "data")

# Extract BIO1 (Annual Mean Temperature)
bio1 <- get_bio1(clim)

# Crop to South America
cropped <- crop_region(bio1, "South America")

# Plot the cropped raster
terra::plot(cropped)
```

---

## Shiny App Tabs

- Raw Data – Visualize global bioclimatic variables

- Processing – Cropped raster for the selected region

- Niche – Filtered raster simulating the ecological niche

- Prediction – Suitability map highlighting areas meeting niche conditions

---

## Project Structure

```r
nicheRclimate/
├── R/                  # R scripts (app, data processing, helpers)
├── data/               # Raster data storage
├── man/                # Documentation files
├── DESCRIPTION
├── NAMESPACE
├── README.md           # Project overview and instructions
├── nicheR-climate-explorer.Rproj
└── .gitignore
```

---

## Reproducibility

All steps in the Shiny app correspond to reproducible R functions, enabling:

Scripted workflows based on interactive sessions

Export of processed rasters and visualizations

Integration into larger ecological niche modeling pipelines

---

## References

WorldClim – Global climate data
 
Virtual niche and species modeling approaches in R: virtualspecies, evniche, and NicheA

---

## License

MIT License. See LICENSE file for details.

---

## Contributing

Contributions, issues, and feature requests are welcome. Please fork the repository and submit a pull request.

---
