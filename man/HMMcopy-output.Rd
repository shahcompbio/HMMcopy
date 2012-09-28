\name{WIG Output Functions}
\alias{rangedDataToWig}
\alias{rangedDataToSeg}
\title{
  WIG Output Functions
}
\description{
  Fast fixedStep WIG file formatting and output
}
\usage{
rangedDataToWig(correctOutput, file, column = "copy", sample = "R",
  verbose = TRUE)
rangedDataToSeg(correctOutput, file, column = "copy", sample = "R",
  verbose = TRUE)
}
\arguments{
\item{correctOutput}{
    \code{\link[IRanges:RangedData-class]{RangedData}} object for output,
    default options expect output from \code{\link{correctReadcount}}.
}
\item{file}{
    Filepath to write output to.
}
\item{column}{
    Column in input object to export.  Defaults to corrected copy number.
}
\item{sample}{
    Sample name of the exported dataset, defaults to \dQuote{R}
}
\item{verbose}{
    Set to FALSE to suppress messages.
}
}
\details{
  Assumes that all ranges in data set are non-overlapping windows of fixed
  width covering the entire genome.  Note that positions in WIG files are
  1-based while those in SEG files are 0-based.
}
\references{
  \describe{
    \item{WIG}{\url{http://genome.ucsc.edu/goldenPath/help/wiggle.html}}
    \item{SEG}{\url{http://www.broadinstitute.org/igv/SEG}}
  }
}
\author{
  Daniel Lai
}

\seealso{
  \code{\link{correctReadcount}} output is the intended input
}

\examples{
  data(tumour) # Load tumour_copy
  rangedDataToWig(tumour_copy, file = "test.wig")
  rangedDataToSeg(tumour_copy, file = "test.seg")
}
\keyword{IO}
