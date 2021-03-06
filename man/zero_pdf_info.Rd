\name{zero_pdf_info}
\alias{zero_pdf_info}
\title{Normalize creation information in PDF files}
\usage{
  zero_pdf_info(infile = NULL, outfile = NULL)
}
\arguments{
  \item{infile}{input file name}

  \item{outfile}{output file name (must be different from
  \code{infile})}
}
\description{
  For a PDF, modify the CreationDate and ModDate (lines 5
  and 6) so that the files are exactly the same, regardless
  of date + time they were actually created. It also
  changes the Producer field (line 8) to "R 0.00.0",
  instead of the usual version, e.g., "R 2.15.0".
}

