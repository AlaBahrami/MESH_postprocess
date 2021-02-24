function STFL = MESH_ST_extract(prmname, year_start, month_start, day_start,...
                                year_finish, month_finish, day_finish)

% Syntax
%
%       MESH_ST_EXTRACT(...)
% 
% Discription
%
%       The pupoose of this function is to read daily MESH simulated streamflow  
%       estimates as well as observations. The results can be read and 
%       plotted in other programs. Streamflow record information is read
%       to represent their ids. 
%
% Input 
%
%       prmname                 The input parameter file includes streamflow 
%                               data as well as its information. 
%                                
%
%       year_start              Start year of simulation 
%
%       month_start             Start month of simulation
%
%       day_start               Start day of simulation 
%
%       year_finish             Finish year of simulation 
%
%       month_finish            Finish month of simulation     
%
%       day_finish              Finish day of simulation 
%
%
% Output      
% 
%       STFL                    Station stremflow observations and simulations                  
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
%% Copyright (C) 2021 Ala Bahrami                                                              
%% loading the input files 
 
    if nargin == 0
        prmname          = 'STFLO_Fraser_nonglacier.txt';
        year_start       = 2004;
        month_start      = 9;
        day_start        = 1;
        year_finish      = 2017;
        month_finish     = 8;
        day_finish       = 30;
    end 
    
    fid  = fopen(prmname);
    Info = textscan(fid, '%s %s');
    fclose(fid);
      
%% construnct time 
    % time stamp is used to extract the subselction of data if is is
    % required
    % daily
    ts      = datetime(year_start, month_start, day_start);
    tf      = datetime(year_finish, month_finish, day_finish);
    time    =  ts : caldays(1) : tf;
    
%% Reading input files 
    %station info
    [stinf,id , ~] = xlsread(Info{1,2}{1 , 1});
    id = id(:,3);
    id(1,:) = [];
    stinf(:,4) = [];
    
    % number of stations 
    m = length(id);
    
    for i = 1 : m
        STFL(i).id   = id(i);
        STFL(i).info = stinf(i , 2:4);
    end
    
%%  reading streamflow simulations 
    st = xlsread(Info{1,2}{2 , 1});
    for j = 1 : m
            STFL(j).data = st(:, 2*(j+1) - 1 : 2*(j+1));
    end 
end 