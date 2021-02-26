function RFcoef = runoff_coeff_calc(prmnamest, year_start, day_start, hour_start, min_start,...
                                year_finish, day_finish, hour_finish, min_finish, ind_PREACC)

% Syntax
%
%       RFCOEF = RUNOFF_COEFF_CALC(...)
% 
% Discription
%
%       The pupoose of this function is to calculate the runoff coefficient
%       for each of subbasin in any desired basin of interest.
%        
%
% Input 
%
%       prmnamest               The input parameter file includes directory 
%                               of streamflow data as well as its information. 
%
%       year_start              Start year of simulation 
%
%       day_start               Start day of simulation in Julian day 
%
%       hour_start              Start hour of simulation
%        
%       min_start               Start minute of simulation
%
%       year_finish             Finish year of simulation 
%
%       hour_finish             finish hour of simulation
%        
%       min_finish              finish minute of simulation
%
%       day_finish              Finish day of simulation in Julian day
%
%       ind_PREACC              index of precipitation in the wb file   
%
%
% Output      
% 
%       RFCOEF                   calculated runoff coefficient for any 
%                                subbasin of interest                  
%
% Reference 
%       
%
% See also: MESH_WBBA_extract, MESH_ST_extract 
%
% Author: Ala Bahrami       
%
% Created Date: 02/25/2021
%
% last modified : 02/25/2021
%
%
%% Copyright (C) 2021 Ala Bahrami    
%% loading the input files
    if nargin == 0
        prmnamest          = 'STFLO_Fraser_glacier.txt';
        year_start         = 2004;
        day_start          = 245;
        hour_start         = 0;
        min_start          = 0;
        year_finish        = 2017;
        day_finish         = 242;
        hour_finish        = 22;
        min_finish         = 30;
        ind_PREACC         = 3;
    end 
      
%% caling the streamflow records and information 
    STFL = MESH_ST_extract(prmnamest, year_start, day_start,...
                                year_finish, day_finish);
    m = length(STFL);
    
%% getting precipitation accumulated for each subbasin    
    % Note : the directory for reading the guage based wb simulation can be 
    % modified regarding user file structure. 
    PRECACC =zeros(m,1);
    for i = 1: m
        str   = 'Input\Fraser\nonglacier\subbasin\daily\Basin_average_water_balance_Gauge';
        str2  = sprintf('%d.csv',i);
        fdir  = strcat(str, str2);

        prmnamewb = 'BAWB_gauge_daily.txt';
        FileOut = strcat('prm/',prmnamewb);

        % writing the output wb file 
        fid = fopen(FileOut,'w');
        fprintf(fid, '%s %s\t', 'BAWB_daily', fdir);
        fclose(fid);
        BAWB = MESH_WBBA_extract(prmnamewb, year_start, day_start, hour_start, min_start, ...        
                            year_finish, day_finish, hour_finish, min_finish, ...       
                            false);
                        
        PRECACC (i) = BAWB(end, ind_PREACC);                 
    end 
%% calcculate runoff density 
    flow   = zeros(m,1);
    runoff = zeros(m,1);
    RFcoef = cell(m,2); 
    
    for i = 1 : m
        % calculate flow volume in m3
        flow(i) =  sum(STFL(i).data(:,1)) * 24 * 3600;
        % calculate runoff in mm
        runoff(i) = flow(i)/(STFL(i).info(3)*10^6)*1000;
        % runoff coefficient
        RFcoef{i,1} = char(STFL(i).id);
        RFcoef{i,2} = round(runoff(i)/PRECACC (i), 2);
    end 
    
%% write file to output
    outdir = 'output/fraser/runoffcoeff/rfcoef.xlsx'; 
    xlswrite(outdir, RFcoef);
    
end 