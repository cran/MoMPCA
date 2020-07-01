## ------------------------------------------------------------------------
set.seed(42)

## ---- include = FALSE----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup---------------------------------------------------------------
library(MoMPCA)
library(aricode)

## ---- eval=FALSE---------------------------------------------------------
#  data("BBCmsg")

## ----generate-data, echo=TRUE--------------------------------------------
N = 200
L = 250
simu <- simulate_BBC(N, L, epsilon = 0, lambda = 1)
Ytruth <- simu$Ytruth

## ----mmpca---------------------------------------------------------------
t0 <- system.time(res <- mmpca_clust(simu$dtm.full, Q = 6, K = 4,
                          Yinit = 'random',
                          method = 'BBCVEM',
                          max.epochs = 7,
                          keep = 1,
                          verbose = 2,
                          nruns = 2,
                          mc.cores = 2)
               )
print(t0)

## ----clustering-results, echo=TRUE, include=TRUE-------------------------
tab <- knitr::kable(table(res@clustering, Ytruth), format = 'markdown')
print(tab)
cat('Final ARI is ', aricode::ARI(res@clustering, Ytruth))

## ----condition-eval-plot, echo=F-----------------------------------------
cond = requireNamespace("ggplot2", quietly = TRUE) & requireNamespace("dplyr", quietly = TRUE) & requireNamespace("tidytext", quietly = TRUE)

## ----plot-results-topics, fig.dim=c(5,5), eval=cond----------------------
ggtopics <- plot(res, type = 'topics')
print(ggtopics)

## ----plot-results-bound, fig.dim=c(5,5), echo=TRUE, include=TRUE---------
ggbound <- plot(res, type = 'bound')
print(ggbound)

## ----model-selection, eval=F---------------------------------------------
#  t1 <- system.time(res <- mmpca_clust_modelselect(simu$dtm.full, Qs = 5:7, Ks = 3:5,
#                            Yinit = 'kmeans_lda',
#                            init.beta = 'lda',
#                            method = 'BBCVEM',
#                            max.epochs = 7,
#                            nruns = 3,
#                            verbose = 1)
#                 )
#  print(t1)
#  best_model = res$models
#  print(best_model)

