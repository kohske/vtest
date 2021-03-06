\name{vdiff_webpage}
\alias{vdiff_webpage}
\title{Generate web pages for viewing differences in test results}
\usage{
  vdiff_webpage(ref1 = "HEAD", ref2 = "", pkg = NULL,
    filter = "", convertpng = TRUE, method = "ghostscript",
    prompt = TRUE)
}
\arguments{
  \item{ref1}{a git commit ref to compare (usually this
  should be the older ref). If \code{"recent"}, then use
  the most recent commit with a saved resultset.}

  \item{ref2}{a git commit ref to compare (usually this
  should be the newer ref). The empty string \code{""}
  refers to the last-run tests.}

  \item{pkg}{package object or path.}

  \item{filter}{a regular expression; result pages will be
  generated only only for test contexts that match this
  pattern.}

  \item{convertpng}{if TRUE, convert the source PDFs files
  to PNG. Otherwise they are kept in PDF format, and are
  viewable only in some browers.}

  \item{method}{the method for converting to PNG. Presently
  can be \code{"ghostscript"} or \code{"imagemagick"}.}

  \item{prompt}{ask to open web page in browser.}
}
\description{
  This function is used for comparing the test results for
  two different commits of the package that was tested.
}
\seealso{
  \code{\link{vdiffstat}} for a data frame of information
  about changed tests.

  \code{\link{vtest_webpage}} for creating a web page of
  results for a single commit.
}

