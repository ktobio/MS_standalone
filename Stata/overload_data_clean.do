/**********************************************************This .do file reads in the following .csv files from Ankit,which are used in our OVERLOAD analyses:cultureofwork_04-16.csv, cultureofwork_05-16.csv, cultureofwork_06-16.csv, cultureofwork_07-16.csv, cultureofwork_08-16.csv, cultureofwork_09-16.csvmessagenetworksize_04-16.csv, messagenetworksize_04-16.csv, messagenetworksize_05-16.csv, messagenetworksize_06-16.csv, messagenetworksize_07-16.csv, messagenetworksize_08-16.csv, messagenetworksize_09-16.csv, messagenetworksize_10-16.csvtenantmetadata_10.18.csvIt then collapses this 6-months of weekly data so there isone observation for each tenantID-country pairing.Finally, it joins the culture MS data with the DB data**********************************************************/set more offcapture log closeclearlog using "logs/overload_data_clean_$S_DATE", replace*Culture of Work Data**reading in the .csv filesforeach x in 04 05 06 07 08 09 {cd ..insheet using "data/raw/MS/cultureofwork_`x'-16.csv", names casecd Statasave "data//cultureofwork_`x'-16.dta", replaceclear}*appending the Stata filesuse "data//cultureofwork_04-16.dta"foreach x in 05 06 07 08 09 {append using "data//cultureofwork_`x'-16.dta"}rename TotalTwoAttendeeMeetingCount TotTwoAttendeeMtgCountrename TotalThreeAttendeeMeetingCount TotThreeAttendeeMtgCount rename TotalFourAttendeeMeetingCount TotFourAttendeeMtgCount rename TotalFiveAttendeeMeetingCount TotFiveAttendeeMtgCountrename TotalSixAttendeeMeetingCount TotSixAttendeeMtgCount rename TotalSevenAttendeeMeetingCount TotSevenAttendeeMtgCount rename TotalEightAttendeeMeetingCount TotEightAttendeeMtgCount rename TotalNineAttendeeMeetingCount TotNineAttendeeMtgCount rename TotalTenPlusAttendeeMeetingCount TotTenPlusAttendeeMtgCount label var msgSentPerUser_int "Avg # of Msgs Sent per User (Internal)"label var msgSentPerUser_ext "Avg # of Msgs Sent per User (External)"label var mtgsPerUser "Avg # of Meetings per User "label var mtgHoursPerAttendee "Average # of Mtg Hrs per Attendee"label var TotTwoAttendeeMtgCount "# of Mtgs where Attendee Count = 2"label var TotThreeAttendeeMtgCount  "# of Mtgs where Attendee Count = 3"label var TotFourAttendeeMtgCount "# of Mtgs where Attendee Count = 4"label var TotFiveAttendeeMtgCount "# of Mtgs where Attendee Count = 5"save "data//cultureofwork.dta", replaceclear*Message Network Size Data*reading in the .csv filesforeach x in 03 04 05 06 07 08 09 10 {cd ..insheet using "data/raw/MS/messagenetworksize_`x'-16.csv", names casecd Statasave "data//messagenetworksize_`x'-16.dta", replaceclear}*This dataset has different variables*don't use*use "data//messagenetworksize_03-16.dta"*compressuse "data//messagenetworksize_04-16.dta"compress*appending the Stata filesforeach x in 05 05 06 07 08 09 10 {append using "data//messagenetworksize_`x'-16.dta"compress}save "data//messagenetworksize.dta", replaceclear*D&B Datacd ..insheet using "data/raw/MS/tenantmetadata_10.18.csv"count if employeec=="NULL"replace employeec="" if employeec=="NULL"destring employeec, replacesum employeec, detailcd Statasave "data//tenantmetadata_10.18.dta", replacedclear*Culture of Work Data*use "data//cultureofwork.dta"g counter=1collapse (sum) counter (mean) msgSenders_int msgSentPerUser_int msgSentLowerQtileVal_int msgSentUpperQtileVal_int msgSenders_ext msgSentPerUser_ext msgSentLowerQtileVal_ext ///msgSentUpperQtileVal_ext mtgAttendees mtgHoursPerAttendee mtgHoursLowerQtileVal mtgHoursUpperQtileVal mtgsPerUser mtgsPerTenant TotalMeetingAttendanceCount ///TotalMeetingCount TotTwoAttendeeMtgCount TotThreeAttendeeMtgCount TotFourAttendeeMtgCount TotFiveAttendeeMtgCount TotSixAttendeeMtgCount ///TotSevenAttendeeMtgCount TotEightAttendeeMtgCount TotNineAttendeeMtgCount TotTenPlusAttendeeMtgCount, by (OmsTenantId CountryName)foreach var in msgSenders_int msgSentPerUser_int msgSentLowerQtileVal_int msgSentUpperQtileVal_int msgSenders_ext msgSentPerUser_ext msgSentLowerQtileVal_ext ///msgSentUpperQtileVal_ext mtgAttendees mtgHoursPerAttendee mtgHoursLowerQtileVal mtgHoursUpperQtileVal mtgsPerUser mtgsPerTenant TotalMeetingAttendanceCount ///TotalMeetingCount TotTwoAttendeeMtgCount TotThreeAttendeeMtgCount TotFourAttendeeMtgCount TotFiveAttendeeMtgCount TotSixAttendeeMtgCount ///TotSevenAttendeeMtgCount TotEightAttendeeMtgCount TotNineAttendeeMtgCount TotTenPlusAttendeeMtgCount counter {replace `var'=`var'*counter}collapse (sum) msgSenders_int msgSentPerUser_int msgSentLowerQtileVal_int msgSentUpperQtileVal_int msgSenders_ext msgSentPerUser_ext msgSentLowerQtileVal_ext ///msgSentUpperQtileVal_ext mtgAttendees mtgHoursPerAttendee mtgHoursLowerQtileVal mtgHoursUpperQtileVal mtgsPerUser mtgsPerTenant TotalMeetingAttendanceCount ///TotalMeetingCount TotTwoAttendeeMtgCount TotThreeAttendeeMtgCount TotFourAttendeeMtgCount TotFiveAttendeeMtgCount TotSixAttendeeMtgCount ///TotSevenAttendeeMtgCount TotEightAttendeeMtgCount TotNineAttendeeMtgCount TotTenPlusAttendeeMtgCount counter, by ( OmsTenantId CountryName )foreach var in msgSenders_int msgSentPerUser_int msgSentLowerQtileVal_int msgSentUpperQtileVal_int msgSenders_ext msgSentPerUser_ext msgSentLowerQtileVal_ext ///msgSentUpperQtileVal_ext mtgAttendees mtgHoursPerAttendee mtgHoursLowerQtileVal mtgHoursUpperQtileVal mtgsPerUser mtgsPerTenant TotalMeetingAttendanceCount ///TotalMeetingCount TotTwoAttendeeMtgCount TotThreeAttendeeMtgCount TotFourAttendeeMtgCount TotFiveAttendeeMtgCount TotSixAttendeeMtgCount ///TotSevenAttendeeMtgCount TotEightAttendeeMtgCount TotNineAttendeeMtgCount TotTenPlusAttendeeMtgCoun counter {replace `var'=`var'/counter}label var CountryName "The name of the country the users in this row are located in"label var msgSenders_ext "# of users who have sent msgs from internal to external"label var msgSenders_int "# of users who have sent msgs from internal to internal"label var msgSentLowerQtileVal_ext "avg # of msgs sent to external in the lower quartile"label var msgSentLowerQtileVal_int "avg # of msgs sent to internal in the lower quartile"label var msgSentPerUser_ext "avg # of msgs sent external per user"label var msgSentPerUser_int "avg # of msgs sent internal per user"label var msgSentUpperQtileVal_ext "avg # of msgs sent to external in the upper quartile"label var msgSentUpperQtileVal_int "avg # of msgs sent to internal in the upper quartile"label var mtgAttendees "# of users who have mtgs"label var mtgHoursLowerQtileVal "avg # of mtg hours"label var mtgHoursPerAttendee "avg mtg hours per user"label var mtgHoursUpperQtileVal "avg mtg hours per user in the upper quartile"label var mtgsPerTenant "count of mtgs for the week for the ten-wk-cntry"label var mtgsPerUser "avg # of mtgs per user"label var OmsTenantId "tenant Id"label var TotTwoAttend "# of mtgs for the ten-wk-cntry when attendee count is 2"label var TotThreeAtten "# of mtgs for the ten-wk-cntry when attendee count is 3"label var TotFourAttend "# of mtgs for the ten-wk-cntry when attendee count is 4"label var TotFiveAtten "# of mtgs for the ten-wk-cntry when attendee count is 5"label var TotSixAtten "# of mtgs for the ten-wk-cntry when attendee count is 6"label var TotSevenAtten "# of mtgs for the ten-wk-cntry when attendee count is 7"label var TotEightAtten "# of mtgs for the ten-wk-cntry when attendee count is 8"label var TotNineAtte "# of mtgs for the ten-wk-cntry when attendee count is 9"label var TotTen "# of mtgs for the ten-wk-cntry when attendee count is 10"replace Country=proper(Country)save "data//cultureofwork_collapsed.dta", replaceclear*Message Network Size*use "data//messagenetworksize"g counter=1foreach var in internal_population internal_mean_contacts internal_stdev_contacts external_population external_mean_contacts external_stdev_contacts {replace `var'="" if `var'=="#NUL#"destring `var', replace}collapse (sum) counter (mean) total_population internal_population internal_mean_contacts internal_stdev_contacts external_population external_mean_contacts external_stdev_contacts, by ( OmsTenantId CountryName)foreach var in total_population internal_population internal_mean_contacts internal_stdev_contacts external_population external_mean_contacts external_stdev_contact {replace `var'=`var'*counter}collapse (sum) counter total_population internal_population internal_mean_contacts internal_stdev_contacts external_population external_mean_contacts external_stdev_contact, by ( OmsTenantId CountryName)foreach var in total_population internal_population internal_mean_contacts internal_stdev_contacts external_population external_mean_contacts external_stdev_contact {replace `var'=`var'/counter}label var CountryName "country the user is located in"label var external_population "# of people with any external contacts from this ten-wk-cntry"label var external_mean_contacts "avg # of  external contacts people have from this ten-wk-cntry" label var external_stdev_contacts "standard deviation of external contacts people have from this ten-wk-cntry" label var internal_population "# of people with any internal contacts from this ten-wk-cntry" label var internal_mean_contacts "avg # of internal contacts people have from this ten-wk-cntry" label var internal_stdev_contacts "standard deviation of internal contacts people have from this ten-wk-cntry" label var OmsTenantId "tenant id"label var total_population "# of distinct users that have any contacts from this tenant-week-country"replace Country=proper(Country)save "data//messagenetworksize_collapse", replaceclearuse "data//tenantmetadata_10.18.dta"bysort oms country: egen max_rev=max(revenue)bysort oms country: egen max_emp=max(employeecount)rename oms OmsTenantIdrename country CountryNamereplace Country="United States" if Country=="USA"replace Country="United Kingdom" if Country=="WALES" | Country=="ENGLAND" | Country=="NORTHERN IRELAND" | Country=="SCOTLAND"replace Country=proper(Country)keep if max_rev==revenuereplace yearstart="" if yearstart=="NULL"destring yearstart, replacebysort Oms Country: egen min_year=min(yearstart)keep Oms line Country max_rev max_emp min_yearduplicates dropmerge m:m OmsTenantId CountryName using "data//cultureofwork_collapsed.dta"tab _mkeep if _m==3drop _mg produc=(max_rev/1000000)/max_empreplace max_rev=max_rev/1000000save "data//cultureofwork_DB", replaceclear