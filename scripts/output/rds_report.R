# |  (C) 2008-2023 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# --------------------------------------------------------------
# description: extract report in rds and mif format from run. N.B.
#              Francesca edited lines 37-59 to include BII reporting
#              and ensure printing of all report funcitons requiring
#              "detail" and "dir" to be specified 
# comparison script: FALSE
# position: 2
# ---------------------------------------------------------------


library(magclass)
library(magpie4)
library(lucode2)
library(quitte)
library(gms)
options("magclass.verbosity" = 1)

############################# BASIC CONFIGURATION #############################
if(!exists("source_include")) {
  outputdir <- "/p/projects/landuse/users/miodrag/projects/tests/flexreg/output/H12_setup1_2016-11-23_12.38.56/"
  readArgs("outputdir")
}

outputdir <- "~/Land Use analysis/magpie/output/FPS_new_NDC_SSP2_NUE_pastedNDC_pa3050_2023-07-17_16.05.16"

cfg <- gms::loadConfig(file.path(outputdir, "config.yml"))
gdx <- file.path(outputdir, "fulldata.gdx")
rds <- paste0(outputdir, "/report.rds")
mif <- paste0(outputdir, "/report.mif")
runstatistics  <- paste0(outputdir, "/runstatistics.rda")
resultsarchive <- "/p/projects/rd3mod/models/results/magpie"
###############################################################################

detail <- "TRUE" #FV added
dir <- "."       #FV added

report <- getReport(gdx, scenario = cfg$title, dir = outputdir)
write.report(report, file = mif)
q <- as.quitte(report)
if(all(is.na(q$value))) stop("No values in reporting!")

BII <- BII(gdx,level = "reg") #FV added

bii_varname <- "Biodiversity|BII"

BII_dataq <- BII %>% dimSums() %>%  #FV added
                     as.quitte() %>%
                      mutate(scenario = case_when(scenario == "(Missing)" ~ cfg$title,
                                                  scenario != "(Missing)" ~ cfg$title),
                             model = case_when(model == "(Missing)" ~ cfg$model_name ,
                                               model != "(Missing)" ~ cfg$model_name ),
                             variable = case_when(variable == "NA" ~ bii_varname ,
                                                  variable != "NA" ~ bii_varname )) %>%
                      print()


q_final <- q %>% rbind(BII_dataq) %>% #FV added
                 print()

saveRDS(q_final, file = rds, version = 2) #FV edited

if(file.exists(runstatistics) & dir.exists(resultsarchive)) {
  stats <- list()
  load(runstatistics)
  if(is.null(stats$id)) {
    # create an id if it does not exist (which means that statistics have not
    # been saved to the archive before) and save statistics to the archive
    message("No id found in runstatistics.rda. Calling lucode2::runstatistics() to create one.")
    stats <- lucode2::runstatistics(file = runstatistics, submit = cfg$runstatistics)
    message("Created the id ", stats$id)
    # save stats locally (including id) otherwise it would generate a new id (and
    # resubmit the results and the statistics) next time rds_report is executed
    save(stats, file = runstatistics, compress = "xz")
  }

  # Save report to results archive
  saveRDS(q, file = paste0(resultsarchive, "/", stats$id, ".rds"), version = 2)
  cwd <- getwd()
  setwd(resultsarchive)
  system("ls 1*.rds > files")
  setwd(cwd)
}
