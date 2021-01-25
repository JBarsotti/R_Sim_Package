# This script works like a bash shell script in that it sets up the variables to use in
# the sim.c code and then calls it.
#------------------------------------------------------------------------------------------

#'* I WOULD LIKE TO THANK MY BFFS STACKEXCHANGE AND STACKOVERFLOW. I CAN HONESTLY SAY *
#'* I COULDN'T HAVE DONE IT WITHOUT YOU. XOXOXOXOXO *
#'* --------------------------------------------------------------------------------------- *






#'* TO LOGIN AND USE A MAXIMUM OF 56 SLOTS FOR MPI, RUN THE FOLLOWING COMMAND: *
#'* qlogin -pe 56cpn 56 -q AML *
#'
#'* YOU MUST RUN module load openmpi/2.1.2_parallel_studio-2017.4 IN THE COMMAND TERMINAL *
#'* IF YOU WANT TO USE PARALLEL PROCESSING *

# Install necessary package from my GitHub repository
install.packages("devtools")
library(devtools)
install_github("PippintheFoolhardy/R_Sim_Package")
library(simfunctions)
#------------------------------------------------------------------------------------------

#------------------------------------------------------------------------------------------
# system("module load openmpi/2.1.2_parallel_studio-2017.4")

#------------------------------------------------------------------------------------------

# Some needed variables that are NOT input into the simulation
#------------------------------------------------------------------------------------------
run_type <- "serial"

# Output path
child <- "/Users/ebarsotti/mysim/mytests/testing/"

# Get current working directory
wd <- getwd()

# Directory that contains important simulation files need to run the code
parent <- "/Users/ebarsotti/mysim/"
# setwd(parent)
#------------------------------------------------------------------------------------------

# Here we initialize variables to use in the simulation
#------------------------------------------------------------------------------------------

# Decide whether to use parallel or serial code (I recommend using serial for 
# nreps*nmods <= 500)

# Specify files that you want to use for %ILI
gfs <- "flat.05"  

# Set number of processes to use (must divide number of models so that there
# is a whole number as the dividend)
numprocs <- 20  

# Specify number of agents in the simulation
N <- 1000   

# Specify alpha calibration parameter  
avals <- c(0.45)                                                   

# Specify number of models
nmod <- 50

# Specify number of replicates
nrep <- 5        

# Specify number of initial infecteds
bnums <- c(3, 5, 7, 10)  

# Specify vaccine distribution strategy
ovals <- c(0) 

# Specify vaccine budge for HCWs
vvals <- c(0.0, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 
          0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1.0)

# Specify patient vaccination rate
uvals <- c(0)                                                         

# Specify vaccine efficacy
evals <- c(0.0, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 
          0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95)

# Specify disease model to use             
xvals <- c(5) 

# Specify disease susceptibility of each agent
svals <- c(0.95)

# Specify infectivity level of all agents (unfortunately constant right now but can
# change later) (s * i = probability of transmission but not really LOL)
ivals <- c(0.105)  

# Specify asymptomatic rate of agents
yvals <- c(0.4)      

# Asymptomatic attenuation rate
yyvals <- c(1.0)                   

# Incubation period of disease in days                        
wvals <- c(5) 

# Infection lasting time after incubation period in days
tvals <- c(14)                 

# Patient discharge rate (5 = 1/5 chance of discharge)
dvals <- c(5)         

# PPE effectiveness rate
pvals <- c(0)             

# Persistence parameter
zvals <- c(1.0)             

# Contact threshold (default is -1)
cvals <- c(-1)       

# Voluntary isolation compliance parameter
vcvals <- c(0.0)

# Voluntary isolation start day for HCWs who are willing to self-isolate (usually W+1)
vsvals <- c(0)

# Voluntary isolation duration in days (should be until HCW is not feeling sick anymore)
vtvals <- c(0)         

# Morning forced quarantine probability for HCWs when using screening
q1vals <- c(0.0)                            

# Evening forced quarantine probability for HCWs when using screening
q2vals <- c(0.0) 

# Mandatory isolation start date (usually W+1)
qsvals <- c(5)      

# Mandatory isolation duration 
qtvals <- c(14)

# Multiplexed cohorted HCWs
mpcvals <- c(1)              

# Multiplexing threshold
mptvals <- c(0.0)                                                  

# Ground patient lag time in weeks (for %ILI)
gplvals <- c(0)  

# Call "go_program" to run simulation
go_program()

#------------------------------------------------------------------------------------------
