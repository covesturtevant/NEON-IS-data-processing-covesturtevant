##############################################################################################
#' @title Wrapper for applying calibration conversion to NEON L0 data

#' @author 
#' Cove Sturtevant \email{csturtevant@battelleecology.org}

#' @description 
#' Wrapper function. Apply calibration conversion function to NEON L0 data, thus generating NEON
#' L0' data.    

#' @param data Data frame of L0 data. Must include POSIXct time variable readout_time.  
#' @param calSlct A named list of data frames, list element corresponding to the variable for which
#' uncertainty coefficients are to be compiled. The data frame in each list element holds 
#' information about the calibration files and time periods that apply to the variable, as returned 
#' from NEONprocIS.cal::def.cal.slct. See documentation for that function. 
#' @param FuncConv A data frame of the variables for to convert and the function to convert 
#' them with. Columns include:\cr
#' \code{var} Character. The variable in data for which to compute uncertainty \cr
#' \code{FuncConv} A character string indicating the calibration conversion function  
#' within the NEONprocIS.cal package that should be used. For most NEON data products, this will be 
#' "def.cal.conv.poly". Note that any alternative function must accept arguments "data", "infoCal", 
#' and "log", even if they are unused in the function, and must return a vector of converted data.
#' Input "data" to the function is an array of the data for the applicable term. Input "infoCal" is
#' a data frame of calibration information (including uncertainty) as returned from 
#' NEONprocIS.cal::def.read.cal.xml. If no calibration files are associated with the term, infoCal 
#' would be passed in to the function as NULL. Input "log" is a logger object as generated by 
#' NEONprocIS.base::def.log.init and used in this script to generate hierarchical logging.\cr
#' @param DirCal Character string. Relative or absolute path (minus file name) to the main calibration
#' directory. Nested within this directory are directories for each variable in calSlct, each holding
#' calibration files for that variable. Defaults to "./"
#' @param log A logger object as produced by NEONprocIS.base::def.log.init to produce structured log
#' output. Defaults to NULL, in which the logger will be created and used within the function.

#' @return A data frame of the converted (calibrated) L0' data, limited to the variables in FuncConv.

#' @references Currently none

#' @keywords Currently none

#' @examples Currently none

#' @seealso \link[NEONprocIS.cal]{def.cal.slct}
#' @seealso \link[NEONprocIS.cal]{def.read.cal.xml}
#' @seealso \link[NEONprocIS.cal]{def.cal.conv.poly}
#' @seealso \link[NEONprocIS.cal]{def.cal.func.poly}

#' @export

# changelog and author contributions / copyrights
#   Cove Sturtevant (2020-02-13)
#     original creation
##############################################################################################
wrap.cal.conv <- function(data,
                          calSlct,
                          FuncConv,
                          DirCal="./",
                          log=NULL){
  # initialize logging if necessary
  if (base::is.null(log)) {
    log <- NEONprocIS.base::def.log.init()
  }
  
  # Basic starting info
  timeMeas <- data$readout_time
  
  # Initialize
  dataConv <- base::subset(data,select=FuncConv$var)
  dataConv[] <- NA
  
  # Loop through variables
  for(idxVarCal in FuncConv$var){
    
    calSlctIdx <- calSlct[[idxVarCal]]

    # Run through each selected calibration and apply the calibration function for the applicable time period
    for(idxRow in base::seq_len(base::nrow(calSlctIdx))){
      
      # What points in the output correspond to this row?
      setCal <- timeMeas >= calSlctIdx$timeBgn[idxRow] & timeMeas < calSlctIdx$timeEnd[idxRow]
      
      # If a calibration file is available for this period, open it and get calibration information
      if(!base::is.na(calSlctIdx$file[idxRow])){
        fileCal <- base::paste0(DirCal,'/',idxVarCal,'/',calSlctIdx$file[idxRow])
        infoCal <- NEONprocIS.cal::def.read.cal.xml(NameFile=fileCal,Vrbs=TRUE)
      } else {
        infoCal <- NULL
      }
      
      # Determine the calibration function to use
      FuncConvIdx <- base::get(FuncConv$FuncConv[FuncConv$var == idxVarCal], base::asNamespace("NEONprocIS.cal"))
      
      # Pass the calibration information to the calibration function
      dataConv[setCal,idxVarCal] <- base::do.call(FuncConvIdx,args=base::list(data=data[setCal,idxVarCal],infoCal=infoCal,log=log))
    }
    
  }
  
  return(dataConv)
  
}
