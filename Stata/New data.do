capture log closeclearset more offset scheme s1colorlog using "logs\newdata_$S_DATE", replaceinsheet using "data\cultureofwork_02-16.csv", names caseforeach var in msgSenders_int msgSentPerUser_int msgSentLowerQtileVal_int msgSentUpperQtileVal_int msgSenders_ext msgSentPerUser_ext msgSentLowerQtileVal_ext msgSentUpperQtileVal_ext mtgAttendees mtgHoursPerAttendee mtgHoursLowerQtileVal mtgHoursUpperQtileVal mtgsPerUser mtgsPerTenant TotalMeetingAttendanceCount TotalMeetingCount TotalTwoAttendeeMeetingCount TotalThreeAttendeeMeetingCount TotalFourAttendeeMeetingCount TotalFiveAttendeeMeetingCount TotalSixAttendeeMeetingCount TotalSevenAttendeeMeetingCount TotalEightAttendeeMeetingCount TotalNineAttendeeMeetingCount TotalTenPlusAttendeeMeetingCount {replace `var'="" if `var'=="#NUL#"destring `var', replace}save "data\cultureofwork_02-16", replacestopinsheet using "data\messagenetworksize_10-16.csv", names caseforeach var in internal_population internal_mean_contacts internal_stdev_contacts external_population external_mean_contacts external_stdev_contacts {replace `var'="" if `var'=="#NUL#"destring `var', replace}save "data\messagenetworksize_10-16.dta", replacestopsave "data\MS_collapse_by_tenant_merge_$S_DATE", replace