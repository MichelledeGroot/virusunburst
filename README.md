# virusunburst

The virusunburst package provides functions to easily visualise ViruSreen results. 
## Installation

```r
devtools::install_github("MichelledeGroot/virusunburst", dependencies=TRUE)
```
``` r
library(virusunburst)
```


## Usage single sample analysis

With the make_sunburst function, you can create a sunburst that will plot the taxonomies based on the total read count for each best hit.
The inner circle represents the families, the middle circle represents the genus and the outer circle represents the species.
``` r
make_sunburst("path_to_full_taxonomy.csv")
```
<img src="man/figures/example_reads.jpeg" width="710"/>

Alternatively, you can choose a different column as group size.
``` r
make_sunburst("path_to_full_taxonomy.csv", size_col = "Covered_bases")
```

Another function is to create a heatmap of your sample. This will illustrate the values of all columns.
``` r
make_heatmap("path_to_full_taxonomy.csv")
```
<img src="man/figures/example_heatmap.jpeg" width="710"/>

## Usage multiple sample analysis

To create a stacked bar plot of the total amount of reads per species, you can use the following function:
``` r
compare_runs("path_to_folder")
```
With the size_col argument you can change the column used for the bar sizes and the size_col argument changes the taxon level which is either family, genus or species. The type agrument is default to plot the total amount of reads ('count') but can be changed to 'pct' to plot relative bars from 0 to 100%.
``` r
compare_runs("path_to_folder", taxon_level = "genus", size_col = "Covered_bases", type="pct")
```

The path you provide has to be a folder where the full taxonomy csv files are stored. An example of such a plot is shown below:

<img src="man/figures/example_barplot.jpeg" width="710"/>

