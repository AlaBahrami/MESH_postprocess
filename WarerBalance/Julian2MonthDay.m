function [month, day] = Julian2MonthDay(jday , year)
% Syntax
 %
 %       Julian2MonthDay() 
 %       [MONTH,DAY] = JULIAN2MONTHDAY(...)
 % 
 %                
 % Discription 
 % 
 %
 %       The pupose of this function is based gets input variables jday  and 
 %       year, then return the month and day. 
 %
 %
 % Input 
 %  
 %       jday                    Julian day
 %       year                    year
 %
 % Outout
 % 
 %
 %        month                  month of the year
 %
 %        day                    day passed after beginning of the month 
 %
 % Reference : module_dates.f90
 %
 % See also  :   
 %
 % Author : Ala Bahrami 
 %
 % date of creation : 02/01/2018
 % Last modified    : 02/01/2018
 %
 %% Setting the input parameters 
 
 daysnl = [31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365]; 
 daysyl = [31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366]; 
 
 %% checking if the year is leap or not 
 
 is_leap = (mod(year, 4) == 0 && ~ mod(year, 100) == 0) || (mod(year, 400) == 0);

 if (is_leap) 
    ndays = 366;
 else
    ndays = 365;
 end 

 %% calculating the day of the month 
 
 
 
    for i = 2 : 12
        
        if (ndays == 365) 
                int_i = daysnl(i - 1);
                int_f = daysnl(i);
        elseif (ndays == 366) 
                int_i = daysyl(i - 1);
                int_f = daysyl(i);
        end 
    
        if (jday <= 31)
            month = 1;
            day   = jday;
            break 
        else 
            
            if ((jday > int_i) && (jday <= int_f)) 
                    month = i;
                    day = jday - int_i;
                    break
            end  
            
        end 
        
    end 
  
end 