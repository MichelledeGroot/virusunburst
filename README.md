# virusunburst

The virusunburst package provides functions to easily visualise ViruSreen results. 
## Installation

```r
devtools::install_github("MichelledeGroot/virusunburst", dependencies=TRUE)
```

## Usage

``` r
library(virusunburst)
```

With the make_sunburst function, you can create a sunburst that will plot the taxonomies based on the total read count for each best hit.
``` r
make_sunburst("path_to_full_taxonomy_csv")
```
<img src="man/figures/example_reads.jpeg" width="510"/>

Alternatively, you can choose a different column as group size.
``` r
make_sunburst("path_to_full_taxonomy_csv", size_col = "Covered_bases")
```
<img src="man/figures/example_bases.jpeg" width="510"/>

Another function is to create a heatmap of your sample. This will illustrate the values of all columns.
``` r
make_heatmap("path_to_full_taxonomy_csv")
```
<img src="man/figures/example_heatmap.jpeg" width="510"/>
