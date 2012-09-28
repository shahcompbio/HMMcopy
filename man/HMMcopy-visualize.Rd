\name{HMMcopy Visualization}
\alias{plotBias}
\alias{plotCorrection}
\alias{plotParam}
\alias{plotSegments}
\alias{stateCols}
\title{
Visualization functions for correctReadcount results
}
\description{
  Convinience functions for creating plots for the analysis of the readcount
  correction process by \code{\link{correctReadcount}}
}
\usage{
plotBias(correctOutput, points = 10000, ...)
plotCorrection(correctOutput, chr = space(correctOutput)[1], ...)
plotSegments(correctOutput, segmentOutput, chr = space(correctOutput)[1], ...)
plotParam(segmentOutput, param, ...)
stateCols()
}
\arguments{
  \item{correctOutput}{
    Output value from \code{\link{correctReadcount}}
  }

  \item{segmentOutput}{
    Output value from \code{\link{HMMsegment}}
  }

  \item{points}{
    Number of random sampled points to plot, decreasing reduces runtime
  }

  \item{chr}{
    Chromosome name to plot.  A single value for \code{\link{plotCorrection}}
    and a vector for \code{\link{plotSegments}}.
  }

  \item{param}{
    Input parameters to call that produced segmentOutput
  }

  \item{...}{
    Furthur arguments are passed to \code{\link{plot}}.
  }
}


\details{
  \code{\link{plotBias}} shows the effects of the correction process on
  GC bias and mappability bias in HTS readcounts.

  \code{\link{plotCorrection}} shows the effects of the correction on the copy
  number profile.  Defaultly plotting the entire first chromosome found in the
  list.

  \code{\link{plotSegments}} shows the resultant segments and states assigned
  to each segment.

  \code{\link{plotParam}} shows the initial suggested distribution of copy
  number in each state (dashed), and the optimal distribution of copy number
  in each state (solid)

  \code{\link{stateCols}} returns a vector of six colours used in
  \code{\link{plotSegments}} and \code{\link{plotParam}}

}

\author{
  Daniel Lai
}

\seealso{
  \code{\link{correctReadcount}} and \code{\link{HMMsegment}} for generating
  intended output.
}

\examples{

data(tumour)

# Visualize one at a time
par(ask = TRUE)
plotBias(normal_copy)
plotCorrection(tumour_copy)
par(mfrow = c(1, 1))
plotSegments(tumour_copy, tumour_segments)
plotParam(tumour_segments, tumour_param)

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{hplot}
