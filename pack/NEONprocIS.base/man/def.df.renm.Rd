% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/def.df.renm.R
\name{def.df.renm}
\alias{def.df.renm}
\title{Rename columns of a dataframe based on variable mapping}
\usage{
def.df.renm(df, mappNameVar = NULL, log = NULL)
}
\arguments{
\item{df}{Data frame.}

\item{mappNameVar}{A data frame providing the input/output variable names, as output from
NEONprocIS.base::mapp.var.in.out. Columns are:\cr
\code{nameVarIn} Character. Input column name.\cr
\code{nameVarOut} Character. Input column name.\cr
Defaults to NULL. In which case the output column names will match the input column names.
Any column names in df not found in mappNameVar$nameVarIn will retain their original names.}

\item{log}{A logger object as produced by NEONprocIS.base::def.log.init to produce structured log
output. Defaults to NULL, in which the logger will be created and used within the function.}
}
\value{
A data frame with renamed columns.
}
\description{
Definition function. Rename the columns of a data frame based on variable name mapping.
}
\examples{
NEONprocIS.base::def.df.renm(df=data.frame(X=c(1,2,3),Y=c(4,5,6)),
                             mappNameVar=data.frame(
                                 nameVarIn=c('X','Y'),
                                 nameVarOut=c('A','B'),
                                 stringsAsFactors=FALSE))
}
\references{
Currently none
}
\seealso{
\link[NEONprocIS.cal]{def.var.mapp.in.out}
}
\author{
Cove Sturtevant \email{csturtevant@battelleecology.org}
}
\keyword{Currently}
\keyword{none}
