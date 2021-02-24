function STFL = MESH_ST_extract(prmname, year_start, day_start,...
                                year_finish, day_finish)

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
%       day_start               Start day of simulation in Julian day 
%
%       year_finish             Finish year of simulation 
%
%       day_finish              Finish day of simulation in Julian day
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
        day_start        = 245;
        year_finish      = 2017;
        day_finish       = 242;
    end 
    
    fid  = fopen(prmname);
    Info = textscan(fid, '%s %s');
    fclose(fid);      
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
    rs = find (st(:,1) == year_start  & st(:,2) == day_start); 
    rf = find (st(:,1)  == year_finish & st(:,2) == day_finish); 
    st = st(rs : rf, :);
    
    for j = 1 : m
            STFL(j).data = st(:, 2*(j+1) - 1 : 2*(j+1));
    end 
end 