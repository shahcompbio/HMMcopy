\name{correctReadcount}
\alias{correctReadcount}
\title{
Readcount correction for GC and mappability bias
}
\description{
Corrects readcounts for GC and mappability bias using the binning/loess method
optimized for speed.
}
\usage{
correctReadcount(x, mappability = 0.9, samplesize = 50000, verbose = TRUE)
}
\arguments{
	\item{x}{
	\code{\link[IRanges:RangedData-class]{RangedData}} object returned by
	\code{\link{wigsToRangedData}}
}
  \item{mappability}{
	Mappability threshold [0, 1] below which points are ignored during creating
	the correction curve.
}
  \item{samplesize}{
	The number of points sampled during LOESS fitting, decreasing reduces
	runtime and memory usage, at the expense of robustness to data randomness.
}

	\item{verbose}{
	Set to FALSE it messages are not desired.
	}
}

\details{
	Input read counts are contained in the IRanges object, where number of reads 
	within bins (or sometimes called windows) of defined genomic size are 
	specified. GC content should also be computed using the exact same boundaries 
	for each bin. 
	
	Ensure that the GC content and mappability files have been mapped to the same genome 
	build (e.g. hg18) as the tumour and normal read libraries.
	
	Here is a summary of the correction procedure.
	\enumerate{
		\item Filter out bins with 0 reads and 0 GC content
		\item Filter out bins with reads within the top and bottom 1\% quantile (assumed to be outliers)
		\item Filter out bins with GC content within the top and bottom 1\% quantile
		\item Filter out bins with a mappability score of greater than 0.9 ('mappability' argument).
		\item Randomly sample up to 50000 ('samplesize' argument) of the remaining high-quality bins for the purposes keeping a good runtime.
		\item The first loess (on the reads-by-GC curve) with a small span (smoothing window) is performed, obtaining typically a highly sensitive curve (follows low density tails of distribution, but gets jagged in high density center).
		\item A second loess (on the first loess results) with a larger span is performed, recapitulating the curve in the low density tails and smoothing out the jagged regions in the high density center.
		\item 'cor.gc' is obtained by correcting each bin for GC content.  The number of observed reads is divided by the number of reads predicted by the loess curve given an observed GC proportion.
		\item Filter out just the top 1\% quantile of the cor.gc bins, then _randomly_ sample up to 50000 ('samplesize' argument) bins.
		\item A separate lowess curve is computed for mappability-by-GC (cor.gc).
		\item 'cor.map' is obtained by correcting each bin for mappability.  The cor.gc value is divided by the cor.gc value predicted by the mappability lowess curve generated in the previous step.
		\item 'copy' is obtained by setting all cor.map values <= to NA (i.e. NaN), then apply log2
	}
}

\value{
	The original A \code{\link[IRanges:RangedData-class]{RangedData}} object
	appended with 5 new columns:
	\describe{
		\item{valid}{Valid bins, which have valid read, gc, and mappability values}
		\item{ideal}{Ideal bins of high mappability and no outliers}
		\item{cor.gc}{GC-corrected readcounts}
		\item{cor.map}{Mappability corrected GC-corrected readcounts}
		\item{copy}{cor.map values after log base 2}
	}
}

\references{
Yuval Benjamini and Terence P Speed. Summarizing and correcting the gc content bias
in high-throughput sequencing. Nucleic Acids Res, \bold{40(10)}:e72, May 2012.
}
\author{
Daniel Lai
}

\seealso{
	\code{\link{wigsToRangedData}} to easily generate the proper input.
}
\examples{
	data(tumour) # Load tumour_reads
	tumour_copy <- correctReadcount(tumour_reads)
}
\keyword{manip}

