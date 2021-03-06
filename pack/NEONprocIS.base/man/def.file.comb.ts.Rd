% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/def.file.comb.ts.R
\name{def.file.comb.ts}
\alias{def.file.comb.ts}
\title{Merge the contents of multiple files (avro or parquet) that share a common time variable.}
\usage{
def.file.comb.ts(file, nameVarTime, log = NULL)
}
\arguments{
\item{file}{Character vector of full or relative file paths. Must be avro or parquet format.}

\item{nameVarTime}{Character value. The name of the time variable common across all files.}

\item{log}{A logger object as produced by NEONprocIS.base::def.log.init to produce structured log
output. Defaults to NULL, in which the logger will be created and used within the function.}
}
\value{
A data frame with the merged file contents.
}
\description{
Definition function. Merge the contents of multiple avro or parquet files that share a common time 
variable. Other than the time variable, the files should different columns. If any duplicate 
column names are found, only the first instance found will be retained. Any missing
timestamps among the files will be filled with NA values.
}
\examples{
# Not run
file <- c('/path/to/file1.avro','/path/to/file2.avro')
NEONprocIS.base::def.file.comb.ts(file=file,nameVarTime='readout_time')
}
\references{
Currently none
}
\seealso{
\link[NEONprocIS.base]{def.read.avro.deve}

\link[NEONprocIS.base]{def.read.parq}
}
\author{
Cove Sturtevant \email{csturtevant@battelleecology.org}
}
\keyword{Currently}
\keyword{none}
