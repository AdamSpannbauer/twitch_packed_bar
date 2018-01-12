
irssi_to_df = function(log_file_in, date=Sys.Date(), verbose=TRUE) {
  #read data
  if(verbose) cat("reading data...\n")
  log_lines = readLines(log_file_in)

  # rm lines with log open/close data
  if(verbose) cat("trimming lines...\n")
  meta_lines     = grepl(x=log_lines, '^--- Log|^\\d\\d:\\d\\d -!- ')
  log_lines_trim = log_lines[!meta_lines]

  # 2 cases to clean
  # cases = c("15:31  * primzed PRESS Kreygasm FOR PLUPBALLZ PogChamp",
  #            "15:56 < iconicivan> vish ResidentSleeper")

  if(verbose) cat("extracting message data & converting to df...\n")
  #use regex to capture time, user type (as * or <), username, msg text
  matched_info = stringr::str_match(log_lines_trim, stringr::regex('(^\\d\\d:\\d\\d)\\s+(\\*|\\<)\\s+(\\w+)(.+)'))
  matched_info_dt = data.table::as.data.table(matched_info)
  data.table::setnames(matched_info_dt, c("raw","time","msg_type","user","msg"))
  suppressWarnings(matched_info_dt[,datetime := strptime(paste(date, time), format="%Y-%m-%d %H:%M")])
  matched_info_dt = matched_info_dt[, .(datetime, user, msg, msg_type)]

  #trim whitespace all cols
  matched_info_dt[, (names(matched_info_dt)) := lapply(.SD, trimws), .SDcols = names(matched_info_dt)]
  #rm '>' from start of msgs
  matched_info_dt[,msg := trimws(gsub("^\\>", "", msg, perl=TRUE))]

  #output clean chat
  return(matched_info_dt)
}
