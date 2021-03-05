function GRTWSA = GRACEAnomCalc ()

% Syntax
%
%       GRTWSA = GRACEANOMCALC(...)
%
%
% Discription
%
%       The purpose of this fucntion is to is to extract GRACETWS anomlaies 
%       based on any desired time interval. The GRACE-TWS BASIN averaged values
%       are read, then based on the new time baseline, GRACE derived TWSA
%       for the desired based is acquired. 
%
%
%
% Input
%       
%       year_start              A year when first GRACE observations was
%                               measured
%        
%       day_start               A day when first GRACE observations was
%                               measured  
%        
%       year_finish             A year when last GRACE observations was
%                               measured
%        
%       day_finish              A date when first GRACE observations was
%                               measured
%        
%       year_start_se           The beginning year of desired time window
%        
%       day_start_se            The beginning date of desired time window
%        
%       year_finish_se          The finishing year of desired time window
%        
%       day_finish_se           The finishing year of desired time window
%        
%       in_basin                index of desired basin of interest
%        
%
% Output  
%
%       GRTWSA                    Calculated GRACE derived TWSA for a basin 
%                                 of interest   
% 
%
% 
% Reference
%
% See also:  GRACEAnom
%
% Author: Ala Bahrami 
%
% Created Date: 28/08/2017
%
% Revision :        03/05/2021
%                   
%                   
%
% Todo : collect time input information in one file  
% 
    %% Copyright (C) 2021 Ala Bahrami
    %% Loading Input data if they aren't imported    
    %load BasinTWS

    if nargin == 0 
        year_start     = 2002;
        day_start      = 91;
        year_finish    = 2015;
        day_finish     = 365;
        year_start_se  = 2004;
        day_start_se   = 245;
        year_finish_se = 2015;
        day_finish_se  = 213;
        in_basin       = 1;     
    end 
 
    % load variables 
     load BasinAnom
     load ShareTime
     
%% construct time and finding GRACE indices
    [ms, ds]   = Julian2MonthDay(day_start , year_start);
    [mf, df]   = Julian2MonthDay(day_finish , year_finish);
    
    [ms_se, ds_se]   = Julian2MonthDay(day_start_se , year_start_se);
    [mf_se, df_se]   = Julian2MonthDay(day_finish_se , year_finish_se);
    
    ts = datetime(year_start, ms, ds);
    tf = datetime(year_finish, mf, df);
    
    ts_se = datetime(year_start_se, ms_se, ds_se);
    tf_se = datetime(year_finish_se, mf_se, df_se);
    
    tt = ts : calmonths(1) : tf;
    r1 = find(tt == ts_se);
    r2 = find(tt == tf_se);
    time = ShareTime.Data(1).Timecomplete(r1:r2);
    
%% extracting GRACE and calcculate anomalies based on the new baseline     
    TWSA = BasinAnom(1).BasinCalc(in_basin).Data(4).AnomEd(r1:r2);
    TWSA_mean  = nanmean(TWSA);
    
    % recalculate anomalies based on the selection time baseline
    GRTWSA = TWSA - TWSA_mean;
    
end 