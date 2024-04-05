#!/usr/bin/env Rscript

## Inspired by https://github.com/r-universe-org/base-image/blob/f20ec9fc6f51ef8a89aad489206a43790bd9bf77/Rprofile#L10-L16
## and adapted / simplified

my_universe <- "https://tldbsm.r-universe.dev"
my_repos <- trimws(strsplit(my_universe, ';')[[1]])

if (Sys.info()[["sysname"]] == "Linux") {
    rver <- getRversion()
    distro <- system(r"( awk -F= '/VERSION_CODENAME/ {print $2}' /etc/os-release )", intern=TRUE)
    my_binaries <- sprintf('%s/bin/linux/%s/%s', my_repos[1], distro, substr(rver, 1, 3))
    options(repos = c(binaries = my_binaries, universe = my_repos, getOption("repos")),
            bspm.version.check = TRUE)    # so that tiledb from my_universe wins over r2u/cran binary
} else {
    options(repos = c(universe = my_repos, getOption("repos")))
}

if (interactive()) print(getOption("repos"))

## having to list RcppInt64 is a micro bug in r2u, it is used headerd only but should install as binary too
## by making it an Imports in tiledbsoma we can avoid this -- so next release. Then we only need "tiledbsoma"
install.packages(c("RcppInt64", "tiledbsoma"))
tiledbsoma::show_package_versions()
