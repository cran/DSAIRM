% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/simulate_bacteria_fit.R
\name{simulate_bacteria_fit}
\alias{simulate_bacteria_fit}
\title{Fitting a simple bacteria infection models to Streptococcus pneumoniae infection data}
\usage{
simulate_bacteria_fit(
  B = 1,
  I = 1,
  g = 0.1,
  glow = 1e-04,
  ghigh = 100,
  Bmax = 1e+08,
  Bmaxlow = 10000,
  Bmaxhigh = 1e+10,
  dB = 0.01,
  dBlow = 1e-04,
  dBhigh = 100,
  kI = 0.001,
  kIlow = 1e-04,
  kIhigh = 100,
  rI = 0.1,
  rIlow = 1e-04,
  rIhigh = 100,
  Imax = 10000,
  Imaxlow = 1,
  Imaxhigh = 1e+10,
  dI = 0.1,
  dIlow = 0.001,
  dIhigh = 100,
  iter = 10,
  solvertype = 1
)
}
\arguments{
\item{B}{: initial number of bacteria : numeric}

\item{I}{: initial number of neutrophils (immune response) : numeric}

\item{g}{: maximum rate of bacteria growth : numeric}

\item{glow}{: lower bound for g : numeric}

\item{ghigh}{: upper bound for g : numeric}

\item{Bmax}{: bacteria carrying capacity : numeric}

\item{Bmaxlow}{: lower bound for Bmax : numeric}

\item{Bmaxhigh}{: upper bound for Bmax : numeric}

\item{dB}{: bacteria death rate : numeric}

\item{dBlow}{: lower bound for dB : numeric}

\item{dBhigh}{: upper bound for dB : numeric}

\item{kI}{: rate of bacteria killing by immune response : numeric}

\item{kIlow}{: lower bound for k : numeric}

\item{kIhigh}{: upper bound for k : numeric}

\item{rI}{: immune response growth rate : numeric}

\item{rIlow}{: lower bound for r : numeric}

\item{rIhigh}{: upper bound for r : numeric}

\item{Imax}{: immune response carrying capacity : numeric}

\item{Imaxlow}{: lower bound for Imax : numeric}

\item{Imaxhigh}{: upper bound for Imax : numeric}

\item{dI}{: immune response decay rate : numeric}

\item{dIlow}{: lower bound for dI : numeric}

\item{dIhigh}{: upper bound for dI : numeric}

\item{iter}{: max number of steps to be taken by optimizer : numeric}

\item{solvertype}{: the type of solver/optimizer to use (1-3) : numeric}
}
\value{
The function returns a list containing as elements the best fit time series data frame, the best fit parameters,
the data and the final SSR
}
\description{
This function runs a simulation of a compartment model
using a set of ordinary differential equations.
The model describes a simple bacteria infection system.
}
\details{
A simple compartmental ODE model for a bacterial infection
is fitted to data.
The fitting is done using solvers/optimizers from the nloptr package (which is a wrapper for the nlopt library).
The package provides access to a large number of solvers.
Here, we only implement 3 solvers, namely 1 = NLOPT_LN_COBYLA, 2 = NLOPT_LN_NELDERMEAD, 3 = NLOPT_LN_SBPLX
For details on what those optimizers are and how they work, see the nlopt/nloptr documentation.
}
\section{Warning}{
 This function does not perform any error checking. So if
  you try to do something nonsensical (e.g. specify negative parameter or starting values,
  the code will likely abort with an error message.
}

\examples{
# To run the code with default parameters just call the function:
\dontrun{result <- simulate_bacteria_fit()}
# To apply different settings, provide them to the simulator function, like such:
result <- simulate_bacteria_fit(iter = 5)
}
\seealso{
See the Shiny app documentation corresponding to this
function for more details on this model.
}
\author{
Andreas Handel
}
