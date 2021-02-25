function MESH_WBBA()

% Syntax
%
%       MESH_WBBA(...)
% 
% Discription
%
%       The pupoose of this function extarct a seies of plots for basin and
%       subbasins. The program can have the capability to calculate
%       analyses. 
%        
% 
%
% Input 
%
%
% Output      
% 
%                               series of plots and analysis                  
%
% Reference 
%       
%
% See also: MESH_WBBA_Sho
%
% Author: Ala Bahrami       
%
% Created Date: 02/24/2021
%
% last modified : 02/24/2021
%
%
%% Copyright (C) 2021 Ala Bahrami

%% setting the inputs 

    prmname          = 'BAWB_Fraser_nonglac_daily.txt';
    prmnamets        = 'BAWB_Fraser_nonglac_ts.txt';
    year_start       = 2004;
    day_start        = 245;
    hour_start       = 0;
    min_start        = 0;
    year_finish      = 2017;
    day_finish       = 242;
    day_finish2      = 243;
    hour_finish      = 22;
    min_finish       = 30;
    timestep         = false;
    subbasin         = false;

%% getting output plots for the Fraser 
    MESH_WBBA_Sho(prmname, prmnamets,...
                        year_start, day_start, hour_start, min_start, ...        
                        year_finish, day_finish, day_finish2, hour_finish, min_finish,...
                        timestep, subbasin)
                    
%% setting inputs for subbasins  
    subbasin = true; 
    % station 08JC002
    prm         = {'BAWB_08JC002_nonglac_daily.txt', 'BAWB_08KB001_nonglac_daily.txt', 'BAWB_08KG001_nonglac_daily.txt',...
                    'BAWB_08KH006_nonglac_daily.txt', 'BAWB_08LF051_nonglac_daily.txt','BAWB_08MB005_nonglac_daily.txt',...
                    'BAWB_08MC018_nonglac_daily.txt','BAWB_08MF005_nonglac_daily.txt','BAWB_08MF040_nonglac_daily.txt'};
    
%% getting output plots for 9 subbasins used for calibration   
    for i = 1 : 9
        MESH_WBBA_Sho(prm{i}, prmnamets,...
                            year_start, day_start, hour_start, min_start, ...        
                            year_finish, day_finish, day_finish2, hour_finish, min_finish,...
                            timestep, subbasin)
    end 

end 