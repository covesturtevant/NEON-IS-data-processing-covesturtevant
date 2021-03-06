##############################################################################################
#' @title Get metadata/properties from sensor locations json file 

#' @author
#' Cove Sturtevant \email{csturtevant@battelleecology.org}

#' @description
#' Definition function. Read sensor locations json file and return a data frame of metadata/properties 
#' filtered for a selected named location and/or install time range of interest

#' @param NameFile Filename (including relative or absolute path). Must be json format.
#' @param NameLoc Character value of the named location to restrict output to. Defaults to NULL, 
#' in which case no filtering is done for named location
#' @param TimeBgn POSIXct timestamp of the start time of interest (inclusive). Defaults to NULL, 
#' in which case no filtering is done for installed time range
#' @param TimeEnd POSIXct timestamp of the end time of interest (non-inclusive). Defaults to NULL, in 
#' which case the location information will be filtered for the exact time of TimeBgn.
#' @param log A logger object as produced by NEONprocIS.base::def.log.init to produce structured log
#' output. Defaults to NULL, in which the logger will be created and used within the function.

#' @return 
#' 
#' @references
#' License: (example) GNU AFFERO GENERAL PUBLIC LICENSE Version 3, 19 November 2007

#' @keywords currently none

#' @examples 
#' # Not run
#' # NameFile <- '/scratch/pfs/prt_calibrated_location_group/prt/2019/01/01/767/location/prt_767_locations.json'
#' # NameLoc <- 'CFGLOC100140'
#' # TimeBgn <- base::as.POSIXct('2019-01-01',tz='GMT)
#' # TimeEnd <- base::as.POSIXct('2019-01-02',tz='GMT)
#' # locMeta <- NEONprocIS.base::def.loc.meta(NameFile=NameFile,NameLoc=NameLoc,TimeBgn=TimeBgn,TimeEnd=TimeEnd)

#' @seealso \link[NEONprocIS.base]{def.read.avro.deve}
#'
#' @export

# changelog and author contributions / copyrights
#   Cove Sturtevant (2020-02-19)
#     original creation
##############################################################################################
def.loc.meta <- function(NameFile,NameLoc=NULL,TimeBgn=NULL,TimeEnd=NULL,log=NULL){
  # Initialize log if not input
  if (is.null(log)) {
    log <- NEONprocIS.base::def.log.init()
  }
  
  # Initialize output
  dmmyChar <- base::character(0)
  dmmyPosx <- base::as.POSIXct(dmmyChar)
  dmmyNumc <- base::numeric(0)
  rpt <- base::data.frame(name=dmmyChar,
                          site=dmmyChar,
                          install_date=dmmyPosx,
                          remove_date=dmmyPosx,
                          transaction_date=dmmyPosx,
                          context=dmmyChar,
                          location_id=dmmyChar,
                          location_code=dmmyChar,
                          HOR=dmmyChar,
                          VER=dmmyChar,
                          dataRate=dmmyNumc,
                          stringsAsFactors = FALSE)
  
  # Validate the json
  if(NEONprocIS.base::def.validate.json(jsonIn=NameFile,log=log) != TRUE){
    stop()
  }
  
  # Load the full json into list
  locFull <- rjson::fromJSON(file=NameFile,simplify=TRUE)
  
  # Properties of each named location listed in the locations file
  # Lists the named location, site, install_date, remove_date
  locProp <- geojsonsf::geojson_sf(NameFile) # data frame
  locProp$install_date <- base::as.POSIXct(locProp$install_date,format='%Y-%m-%dT%H:%M:%SZ',tz='GMT')
  locProp$remove_date <- base::as.POSIXct(locProp$remove_date,format='%Y-%m-%dT%H:%M:%SZ',tz='GMT')
  locProp$transaction_date <- base::as.POSIXct(locProp$transaction_date,format='%Y-%m-%dT%H:%M:%SZ',tz='GMT')
  
  # Is there a named location and/or date range we want to restrict location info to?
  setLocProp <- base::seq_len(base::nrow(locProp))
  if(!base::is.null(NameLoc)){
    setLocProp <- base::intersect(setLocProp,base::which(locProp$name == NameLoc))
  }
  if(!base::is.null(TimeBgn) && (base::is.null(TimeEnd) || TimeBgn == TimeEnd)){
    setLocProp <- base::intersect(setLocProp,base::which(locProp$install_date <= TimeBgn & (base::is.na(locProp$remove_date) | locProp$remove_date > TimeBgn)))
  } else if (!base::is.null(TimeBgn) && !base::is.null(TimeEnd)){
    setLocProp <- base::intersect(setLocProp,base::which(locProp$install_date <= TimeEnd & (base::is.na(locProp$remove_date) | locProp$remove_date > TimeBgn)))
  }
  locProp <- locProp[setLocProp,]
  
  # Pull out additional properties not in the properties list but one level higher
  locPropMore <- locFull$features[setLocProp]
  
  # Expected property names that might not be there
  nameProp <- c('Required Asset Management Location ID',
                'Required Asset Management Location Code',
                'HOR',
                'VER',
                'Data Rate') 
  
  # Populate the output data frame
  for(idxLoc in base::seq_len(base::nrow(locProp))){
    
    # Ensure property names available. Fill with NA otherwise.
    propFill <- base::lapply(nameProp,FUN=function(idxNameProp){
      if(base::is.null(locPropMore[[idxLoc]][[idxNameProp]])){
        return(NA)
      } else {
        return(locPropMore[[idxLoc]][[idxNameProp]])
      }
    })
    base::names(propFill) <- nameProp
    
    # format multiple values for context
    ctxt <- locProp$context[idxLoc]
    ctxt <- base::gsub(pattern='[\\[\\"]',replacement="",x=ctxt)
    ctxt <- base::gsub(pattern='\\]',replacement="",x=ctxt)
    ctxt <- base::strsplit(ctxt,',')[[1]]
    ctxt <- base::paste0(base::unique(ctxt),collapse='|')
    
    if(base::length(ctxt) == 0) {
      ctxt <- NA
    }
    
    rpt <- base::rbind(rpt,base::data.frame(name=locProp$name[idxLoc],
                                            site=locProp$site[idxLoc],
                                            install_date=locProp$install_date[idxLoc],
                                            remove_date=locProp$remove_date[idxLoc],
                                            transaction_date=locProp$transaction_date[idxLoc],
                                            context=ctxt,
                                            location_id=propFill[['Required Asset Management Location ID']],
                                            location_code=propFill[['Required Asset Management Location Code']],
                                            HOR=propFill$HOR,
                                            VER=propFill$VER,
                                            dataRate=propFill[['Data Rate']],
                                            stringsAsFactors = FALSE))
  }
  
  return(rpt)
  
}
