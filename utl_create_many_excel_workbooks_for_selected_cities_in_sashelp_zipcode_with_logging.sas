Create excel workbook for selected cities in sashelp zipcode with logging;

github
https://tinyurl.com/yc8gvsvp
https://github.com/rogerjdeangelis/utl_create_many_excel_workbooks_for_selected_cities_in_sashelp_zipcode_with_logging

https://communities.sas.com/t5/Base-SAS-Programming/Macro-code-to-export-in-excel/m-p/449334


INPUT (create a workbbok for each city in the cities table)
===========================================================

 WORK.CITIES total obs=5

   CITY

   Concord
   Rome
   Jasper
   Rio
   Dayton


 SASHELP.ZIPCODE total obs=41,267

   ZIP    Y        X     CITY          STATE STATECODE  ...

   501 40.8131 -73.0464  Holtsville      36     NY      ...
   544 40.8132 -73.0493  Holtsville      36     NY      ...
   601 18.1660 -66.7236  Adjuntas        72     PR      ...
   602 18.3830 -67.1866  Aguada          72     PR      ...
   603 18.4332 -67.1520  Aguadilla       72     PR      ...
   .....


PROCESS (all the code)
=======================

data log;

  if _n_=0 then do;
      %let rc=%sysfunc(dosubl('
        proc sql;
          select quote(city)
          into :cities separated by ","
          from cities
        ;quit;
      '));
  end;
  retain out;
  do cities=&cities;

    call symputx('city',cities);

    rc=dosubl('
      * you could delete the workbook if it exists;
      libname xel "d:/xls/&city..xlsx";
      data xel.&city;
        set sashelp.zipcode(where=(city="&city"));
      run;quit;
      libname xel clear;
    ');

     out=cats("d:/xls/",cities,".xlsx");
     if rc = 0 then status="Completed";
     else status="Failed";
     output;
  end;

run;quit;


OUTPUT
======

 WORK.LOG total obs=5

           OUT            CITIES     RC     STATUS

   d:/xls/Concord.xlsx    Concord     0    Completed
   d:/xls/Rome.xlsx       Rome        0    Completed
   d:/xls/Jasper.xlsx     Jasper      0    Completed
   d:/xls/Rio.xlsx        Rio         0    Completed
   d:/xls/Dayton.xlsx     Dayton      0    Completed

*                _               _       _
 _ __ ___   __ _| | _____     __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/  | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|

;


Use SASHELP.ZIPCODE and

data cities;
 input city$;
cards4;
Concord
Rome
Jasper
Rio
Dayton
;;;;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

see above
