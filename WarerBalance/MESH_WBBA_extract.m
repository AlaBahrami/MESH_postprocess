function BAWB = MESH_WBBA_extract(prmname, year_start, day_start, hour_start, min_start, ...        
                            year_finish, day_finish, day_finish2, hour_finish, min_finish, ...       
                            timestep)

% Syntax
%
%       BAWB = MESH_WBBA_EXTRACT(...)
% 
% Discription
%
%       The pupoose of this function is to read MESH basin average water balance 
%       compartments, daily, or timestep. For other timesteps modifications
%       should be applied. The desired ouput then can be read for visual 
%       presentation or other postprocess calculation. 
% 
%
% Input 
%
%       prmname                 The input parameter file includes input
%                               file information . 
%
%       year_start              Start year of simulation 
%
%       month_start             Start month of simulation
%
%       day_start               Start day of simulation 
%
%       hour_start              Start hour of simulation
%        
%       min_start               Start minute of simulation
%
%       year_finish             Finish year of simulation 
%
%       month_finish            Finish month of simulation     
%
%       day_finish              Finish day of simulation 
%
%       hour_finish             finish hour of simulation
%        
%       min_finish              finish minute of simulation
%
%       timestep                whether time step data is read
%
% Output      
% 
%       BAWB                    Basin Averaged TWS                  
%
% Reference 
%       
%
% See also: 
%
% Author: Ala Bahrami       
%
% Created Date: 02/23/2021
%
%
%% Copyright (C) 2021 Ala Bahrami                                                              
%% loading the input files 

    if nargin == 0
        prmname          = 'BAWB_Fraser_nonglac_daily.txt';
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
    end 

    fid  = fopen(prmname);
    Info = textscan(fid, '%s %s');
    fclose(fid);    
%% reading input file 
    BAWB    = xlsread(Info{1,2}{1 , 1});    
    % finding indices if  a selection of dataset rather than full record is
    % required
    if (timestep)
        rs = find ( BAWB(:,1) == year_start  & BAWB(:,2) == day_start...
                & BAWB(:,3) == hour_start  & BAWB(:,4) == min_start); 
        rf = find ( BAWB(:,1) == year_finish  & BAWB(:,2) == day_finish2...
                & BAWB(:,3) == hour_finish  & BAWB(:,4) == min_finish); 
    else
        rs = find ( BAWB(:,1) == year_start  & BAWB(:,2) == day_start); 
        rf = find (BAWB(:,1)  == year_finish & BAWB(:,2) == day_finish); 
    end
 
    BAWB    =  BAWB(rs : rf, :);
end 