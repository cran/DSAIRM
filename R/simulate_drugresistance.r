############################################################
##a stochastic model for acute virus infection
#with drug treatment and resistance emergence
##written by Andreas Handel (ahandel@uga.edu), last change 5/1/18
############################################################



#this specifies the rates used by the adapativetau routine
#needs to be before main function so it's clear where description belongs to
evolutionratefunc <- function(y, parms, t)
{
  with(as.list(c(y, parms)),
       {

         #specify each rate/transition/reaction that can happen in the system
         rates=c(  b*U*Vs,
                   b*U*Vr,
                   dI*Is,
                   dI*Ir,
                   (1-e)*(1-m)*p*Is,
                   c*Vs,
                   (1-e)*m*p*Is+(1-f)*p*Ir,
                   c*Vr
         ) #end specification of each rate/transition/reaction
         return(rates)
       })
} #end function specifying rates used by adaptivetau



#' Stochastic simulation of a compartmental acute virus infection model
#' with treatment and drug resistant strain
#'
#' @description  Simulation of a stochastic model with the following compartments:
#' Uninfected target cells (U), Infected with wild-type/sensitive and untreated (Is),
#' infected with resistant (Ir), wild-type virus (Vs), resistant virus (Vr).
#'
#' @param U0 initial number of target cells
#' @param Is0 initial number of wild-type infected cells
#' @param Ir0 initial number of resistant infected cells
#' @param Vs0 initial number of wild-type virus
#' @param Vr0 initial number of resistant virus
#' @param b level/rate of infection of cells
#' @param dI rate of infected cell death
#' @param e efficacy of drug
#' @param m fraction of resistant mutants created
#' @param p virus production rate
#' @param c virus removal rate
#' @param f fitness cost of resistant virus
#' @param rngseed seed for random number generator to allow reproducibility
#' @param tmax maximum simulation time, units depend on choice of units for your
#'   parameters
#' @return A list. The list has only one element called ts.
#' ts contains the time-series of the simulation.
#' The 1st column of ts is Time, the other columns are the model variables.
#' @details A compartmental ID model with several states/compartments
#' is simulated as a stochastic model using the adaptive tau algorithm as implemented by ssa.adaptivetau
#' in the adpativetau package. See the manual of this package for more details.
#' The function returns the time series of the simulated disease as output matrix,
#' with one column per compartment/variable. The first column is time.
#' @section Warning:
#' This function does not perform any error checking. So if you try to do
#' something nonsensical (e.g. have I0 > PopSize or any negative values or fractions > 1),
#' the code will likely abort with an error message.
#' @examples
#' # To run the simulation with default parameters just call the function:
#' result <- simulate_drugresistance()
#' # To choose parameter values other than the standard one, specify them, like such:
#' result <- simulate_drugresistance(tmax = 200, e = 0.5)
#' # You should then use the simulation result returned from the function, like this:
#' plot(result$ts[,"Time"],result$ts[,"Vs"],xlab='Time',ylab='Uninfected cells',type='l')
#' @references See the manual for the adaptivetau package for details on the algorithm.
#'             The implemented model is loosely based on: Handel et al 2007 PLoS Comp Bio
#'            "Neuraminidase Inhibitor Resistance in Influenza: Assessing the Danger of Its
#'            Generation and Spread"
#' @author Andreas Handel
#' @export






simulate_drugresistance <- function(U0 = 1E5, Is0 = 0, Ir0 = 0, Vs0 = 10, Vr0 =0, tmax = 100, b = 1e-5, dI = 1, e = 0, m = 1e-4, p = 1e2, c = 4, f = 0.1, rngseed = 100)
{
  Y0 = c(U = U0, Is = Is0,  Ir = Ir0, Vs = Vs0, Vr = Vr0);  #combine initial conditions into a vector
  dt = tmax / 1000; #time step for which to get results back
  timevec = seq(0, tmax, dt); #vector of times for which solution is returned (not that internal timestep of the integrator is different)

  #combining parameters into a parameter vector
  pars = c(b = b, dI = dI, e = e, m = m, p = p, c = c, f = f);

  #specify for each reaction/rate/transition how the different variables change
  #needs to be in exactly the same order as the rates listed in the rate function
  transitions = list(c(U = -1, Is = +1), #infection of U to Is
                     c(U = -1, Ir = +1), #infection of U to Ir
                     c(Is = -1), #Is cell death
                     c(Ir = -1), #Ir cell death
                     c(Vs = +1), #susceptible virus produced
                     c(Vs = -1), #susceptible virus removed
                     c(Vr = +1), #resistant virus produced
                     c(Vr = -1) #resistant virus removed
  ) #end list of transitions


  #this line runs the simulation, i.e. integrates the differential equations describing the infection process
  #the result is saved in the odeoutput matrix, with the 1st column the time, the 2nd, 3rd, 4th column the variables S, I, R
  set.seed(rngseed) # to allow reproducibility
  output = adaptivetau::ssa.adaptivetau(init.values = Y0, transitions = transitions,  rateFunc = evolutionratefunc, params = pars, tf = tmax)

  colnames(output) = c('Time','U','Is','Ir','Vs','Vr')

  #return result as list, with element ts containing the time-series
  result = list()
  result$ts = as.data.frame(output)
  return(result)
}
