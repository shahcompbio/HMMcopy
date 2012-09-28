\name{HMMcopy Segmentation}
\alias{HMMsegment}
\title{
Segmentation and classification of copy number profiles
}
\description{
Takes in a copy number profile and segments it into predicted regions of
equal copy number, and assigns a biologically motivated copy number state
to each region using a Hidden Markov Model (HMM).  This is an extension 
to the HMM described in Shah et al., 2006.  
}
\usage{
HMMsegment(correctOut, param = NULL, autosomes = NULL,
    maxiter = 50, getparam = FALSE, verbose = TRUE)
}

\arguments{

\item{correctOut}{
Output value from \code{\link{correctReadcount}}
}

\item{param}{
If none is provided, will generate a reasonable set of parameters based on the
input data, which can optionally be returned for inspection and manual
adjustment by setting 'getparam' to TRUE.

See Details for more information on parameters.

A matrix with parameters values in columns for each state in rows:
\describe{
    \item{e}{Probability of extending a segment, increase to lengthen segments,
    decrase to shorten segments. Range: (0, 1)}
    \item{strength}{Strength of initial e suggestion, reducing allows e to
    change, increasing makes e undefiable.  Range: [0, Inf)}
    \item{mu}{Suggested median for copy numbers in state, change to readjust
    classification of states. Range: (-Inf, Inf)}
    \item{lambda}{Suggested precision (inversed variance) for copy numbers
    in state, increase to reduce overlap between states. Range: [0, Inf)}
    \item{nu}{Suggested degree of freedom between states, increase to reduce
    overlap between states. Range: [0, Inf)}
    \item{kappa}{Suggested distribution of states. Should sum to 1.}
    \item{m}{Optimal value for mu, difference from corresponding mu value
    determines elasticity of the mu value. \emph{i.e.} Set to identical value
    as mu if you don't want mu to move much.}
    \item{eta}{Mobility of mu, increase to allow more movement. Range: [0, Inf)}
    \item{gamma}{Prior shape on lambda, gamma distribution.  Effects flexibility
    of lambda.}
    \item{S}{Prior scale on lambda, gamma distribution.  Effects flexibility of
    lambda.}
  }
}

\item{autosomes}{
Array of LOGICAL values corresponding to the 'chr' argument where an
element is TRUE if the chromosome is an autosome, otherwise FALSE.  If not
provided, will automatically set the following chromosomes to false:
"X", "Y", "23", "24", "chrX", chrY", "M", "MT", "chrM".
}

\item{maxiter}{
  The maximum number of iterations allows for the Maximum-Expectation algorithm,
  reduce to decrease running time at the expense of robustness.
}

\item{getparam}{
  If TRUE, generates and returns parameters without running segmentation.
}

\item{verbose}{
Set to FALSE if messages are not desired
}

}

\details{

  \code{\link{HMMsegment}} is a two stage algorithm that first runs an
  Expectation-Maximization algorithm to find the optimal set of parameters
  based on suggested parameter inputs, and allowed flexibilities.  After
  iteratively finding the optimal parameters, the actual segmentation of the
  data is conducted with the Viterbi algorithm, finally output segmented
  states.  This is an extension to the hidden Markov model described in Shah
  et al., 2006.

  Parameters are divided into two main categories:
  \itemize{
    \item Initial parameters: e, mu, lambda, nu, kappa
    \item Flexibility parameters: strength, m, eta, gamma, S
  }

  Where \emph{initial parameters} are treated as starting suggestions for the
  parameter optimization algorithm, and flexibility parameters (hyperparameters)
  define how much the initial parameters are allowed to deviate during the
  search for the optimal parameters.

  With a good copy number dataset, in theory, given enough flexibility, the
  algorithm should always find a similar set of optimal parameters regardless
  of initial parameters (although running times will vary).

  If for some reason you wish to \emph{manually} set the parameters for the
  final segmentation process, one should tune all flexibility parameters to
  minimal values.  For example, if you wish to increase the length of segments,
  you could set:
  \preformatted{
    param$e <- 0.9999999999999999
    param$strength <- 1e30
  }

  Which suggests that segments should be very long, and gives minimal to
  non-existant flexibility to your suggestion.

  See vignette for diagrammed example:
  \preformatted{
    vignette("HMMcopy")
  }

}

\value{
A list object containing multiple values, although in practice only the
state assigned to each copy number value in 'states' and the segments of
non-overlapping states in 'segs' are of interest.

By default, there are 6 states, which in a diploid sample corresponds to the
following chromosomal copies and biological state:

\describe{
  \item{1}{<=0 copies, homozogous deletion}
  \item{2}{1 copy, heterozogous deletion}
  \item{3}{2 copies, neutral}
  \item{4}{3 copies, gain}
  \item{5}{4 copies, amplification}
  \item{6}{>=5 copies, high level amplification}
}

The full list of output is
as follows:

\describe{
  \item{states}{The state assigned to each copy number value}
  \item{segs}{Non-overlapping segments and medians of each segment}
  \item{mus}{Optimal median of of copy numbers in state}
  \item{lambda}{Optimal precision of copy numbers in state}
  \item{pi}{Optimal state distribution}
  \item{loglik}{The likelihood values of each EM algorithm iteration}
  \item{rho}{Posterior marginals (responsibilities) for each position and state}
}

}

\references{
Sohrab P Shah, Xiang Xuan, Ron J DeLeeuw, Mehrnoush Khojasteh, Wan L Lam, Raymond Ng, and
Kevin P Murphy. Integrating copy number polymorphisms into array cgh analysis using a robust hmm.
Bioinformatics, \bold{22(14)}:e431-9, Jul 2006.
}

\author{
	Daniel Lai, Gavin Ha, Sohrab Shah
}

\seealso{
	\code{\link{correctReadcount}}, to correct the readcounts prior to
	segmentation and classification for better results.
}

\examples{

data(tumour) # Load tumour_copy
tumour_segments <- HMMsegment(tumour_copy)

}

\keyword{IO}
