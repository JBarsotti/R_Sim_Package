#' Calling a function that will get the simulation code set up
#' 
#' The function sets the proper output directories,
#' gathers the needed input files, and then proceeds to call a secondary
#' function that will actually rin the simualtion code.
#' In order to use the function, all the required variables for the
#' simulation must have already been initialized.
#' @export

go_program <- function()
{
  
  # Create output path only if directory does not already exist
  dir.create(file.path(child))
  
  # Set new working directory as child directory
  setwd(child)
  
  # Don't run if file master.csv is already in output directory
  file_extension <- paste(child, "master.csv", sep="")
  
  if (!isTRUE(file.exists(file_extension)))
  {
    
    # Calculate number of different combinations of variables
    all_vars <- list(gfs, avals, bnums, ovals, vvals, uvals, evals, xvals, svals, ivals, yvals, yyvals,
                     wvals, tvals, dvals, pvals, zvals, cvals, vcvals, vtvals, q1vals, q2vals,
                     qsvals, mpcvals, mptvals, gplvals)
    
    #Used to calculate number of iterations it takes for code to complete
    combinations <- 1
    
    for (var in 1:length(all_vars))
    {
      combinations <- combinations*length(all_vars[[var]])
    }
    
    # Transfer necessary files to output directory
    filestocopy <- c("contacts.csv", "counts.csv", "jobs.csv", 
                     "sheets.csv", "flat.05")
    
    filestocopy <- paste(parent, filestocopy, sep="")
    
    for (file in filestocopy)
    {
      file.copy(file, child)
    }
    
    # Trace CSV header
    trace_header <- t(c("A", "B", "VO", "VB", "UB", "E", "X", "S", "I", "Y", "YY",
                        "W", "T", "D", "P", "Z", "VC", "VS", "VT", "Q1", "Q2", "QS", 
                        "QT", "GPL", "MPC", "MPT"))
    
    # Write to trace CSV            
    write.table(trace_header, "trace.csv", append=FALSE, row.names=FALSE, col.names=FALSE, sep=",", dec=".", quote=FALSE)
    
    # Master CSV output header
    master_header <- t(c("i", "j", "pat", "hcw", "B", "%ILI", "GPL", "Z", "D", "Y", 
                         "YY", "A", "X", "E", "S", "I", "W", "T", "VB", "UB", "V", 
                         "VO", "VX", "P", "VC", "VS", "VT", "Q1", "Q2", "QS", "QT",
                         "MPC", "MPT", "MPS", "#rounds", "#totpat", "#tothcw", "#vacpat",
                         "#vachcw", "#infpat", "#infhcw", "#hcwpat", "#pathcw", "#hcwhcw",
                         "#sickdays", "#avglos", "npat0", "nhcw0", "new_infected", "R0", 
                         "secondary_infect", "%pat", "%hcw", "%total", "first_test",
                         "first_day", "sum_days_sym", "hcw_infected", "pat_infected", 
                         "%first_test", "%first_day", "sum_days_all", "infectivity"))
    
    # Write to master CSV            
    write.table(master_header, "master.csv", append=FALSE, row.names=FALSE, col.names=FALSE, sep=",", dec=".", quote=FALSE)
    
    # Start the timer!
    start.time <- Sys.time()
    
    # Call the R function that runs the simulation code
    run_sim(combinations, run_type)
    
    
    # Print that program is finished
    sprintf("Finished!")
    
    # Honestly have no idea what this does, but Alberto does it in his shell
    # scripts
    system("grep -v msec < error > curves")
    
    # Go back to working directory
    setwd(wd)
    
    # Calculate how long program took to run
    end.time <- Sys.time()
    time.taken <- end.time - start.time
    sprintf("Runtime: %f", time.taken)
    
  } else {
    sprintf("WARNING: File master.csv already exists.")
  }
  
}
#------------------------------------------------------------------------------------------


#' Progress monitoring
#'
#' Monitors the progress of the simulation code by percent complete.
#' Prints to screen the progress. 
#' @export

progress <- function (percent, max = 100)
{
  
  cat(sprintf('\rProgram progress: %0.2f%%', percent))
  
  if (percent == max)
  {
    cat('\n')
  }
  
} 

#------------------------------------------------------------------------------------------


#' Function calls the C code and runs the simulation
#'
#' Calls the simulation code in a nested "for" loop that inputs
#' all possible combinations of the variables. Also allows for either serial
#' or parallel code to be run.
#' @param combinations Number of total combinations of variables
#' @param run_type Either "serial or "parallel"
#' @examples 
#' @export

run_sim <- function(combinations, run_type)
{
  
  # Initialize variables so that they can be used
  
  gf <- aval <- bnum <- oval <- vval <- uval <- eval <- xval <- sval <- ival <- yval <- yyval <-
    wval <- tval <- dval <- pval <- zval <- cval <- vsval <- vcval <- vtval <- q1val <- q2val <-
    qsval <- qtval <- mpcval <- mptval <- gplval <- 0
  
  # Determine whether to use serial or parallel code
  if (run_type == "serial")
  {
    
    print("Running in serial.")
    run_start <- paste("nohup ", parent, "sim", sep="")
    run_end   <- paste0(" 2>> error | tail -n +2 >> master.csv")
    
    
  }   else if (run_type == "parallel") {
    
    print("Running in parallel.")
    run_start <- paste0("nohup mpirun -np ", numprocs, " --mca opal_paffinity_alone 1", 
                        " --mca mpi_yield_when_idle 0 ", paste(parent, "simMPI", sep=""))
    run_end   <- paste0(" 2>> error")
    
    
  }
  else {
    
    print("Error inputting parallel or serial!")
    return(0)
    
  }
  
  counter <- 0
  
  for (gf in gfs)
  {
    for (aval in avals)
    {
      for (bnum in bnums)
      {
        for (oval in ovals)
        {
          for (vval in vvals)
          {
            for (uval in uvals)
            {
              for (eval in evals)
              {
                for (xval in xvals)
                {
                  for (sval in svals)
                  {
                    for (ival in ivals)
                    {
                      for (yval in yvals)
                      {
                        for (yyval in yyvals)
                        {
                          for (wval in wvals)
                          {
                            for (tval in tvals)
                            {
                              for (dval in dvals)
                              {
                                for (pval in pvals)
                                {
                                  for (zval in zvals)
                                  {
                                    for (cval in cvals)
                                    {
                                      for (vcval in vcvals)
                                      {
                                        for (vsval in vsvals)
                                        {
                                          for (vtval in vtvals)
                                          {
                                            for (q1val in q1vals)
                                            {
                                              for (q2val in q2vals)
                                              {
                                                for (qsval in qsvals)
                                                {
                                                  for (qtval in qtvals)
                                                  {
                                                    for (mpcval in mpcvals)
                                                    {
                                                      for (mptval in mptvals)
                                                      {
                                                        for (gplval in gplvals)
                                                        {
                                                          
                                                          # Write trace to "trace.CSV"  
                                                          trace_vals <- t(c(aval, bnum, oval, vval, uval, eval, 
                                                                          xval, sval, ival, yval, yyval,
                                                                          wval, tval, dval, pval, zval, 
                                                                          vcval, vsval, vtval, q1val, 
                                                                          q2val, qsval, qtval, gplval, 
                                                                          mpcval, mptval))
                                                          
                                                          write.table(trace_vals, "trace.csv", append=TRUE, row.names=FALSE, col.names=FALSE, sep=",", dec=".", quote=FALSE)
                                                          
                                                          
                                                          # Run simulation and store output
                                                          system(paste0(run_start, " -f 1 -n ", N, " -a ", aval, " -m ", nmod, 
                                                                        " -r ", nrep, " -p ", pval, " -c ", cval, " -b ", bnum, " -v ", 
                                                                        vval, " -o ", oval, " -u ", uval, " -e ", eval, " -s ", sval, " -i ", ival,
                                                                        " -z ", zval, " -w ", wval, " -t ", tval, " -d ", dval, " -x ", xval,
                                                                        " -y ", yval, " -yy ", yyval, " -vc ", vcval, " -vs ", vsval,
                                                                        " -vt ", vtval, " -q1 ", q1val, " -q2 ", q2val, " -qs ", qsval,
                                                                        " -qt ", qtval, " -mpc ", mpcval, " -mpt ", mptval, " -gpl ",
                                                                        gplval, " -gf ", gf,  run_end)) 
                                                          
                                                          # Concatenate temporary files
                                                          processes <- numprocs - 1
                                                          system(paste0("eval cat proces_{1..", processes, "} >>master.csv"))
                                                          system(paste0("eval rm proces_{1..", processes, "}"))
                                                          
                                                          # Track the progress of the code
                                                          counter <- counter+1
                                                          decimal <- counter / combinations
                                                          percent <- decimal * 100
                                                          
                                                          progress(percent)
                                                          
                                                        }
                                                      }
                                                    }
                                                  }
                                                }
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  
}

#------------------------------------------------------------------------------------------


