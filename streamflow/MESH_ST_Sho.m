function MESH_ST_Sho(prmname, year_start, year_finish, day_finish, mult_sim)

% Syntax
%
%       MESH_ST_SHO(...)
% 
% Discription
%
%       The pupoose of this function is to read daily MESH-derived streamflow 
%       estimates from single or multiple simulations. Thereafter, estimates  
%       are plotted in addition to streamflow observations. The default
%       plot is based on single simulation. 
%        
%
% Input 
%
%
% Output      
% 
%                               series of plots                  
%
% Reference 
%       
%
% See also: MESH_ST_extract, Julian2MonthDay
%
% Author: Ala Bahrami       
%
% Created Date: 02/24/2021
%
% last modified : 02/24/2021
%
%
%% Copyright (C) 2021 Ala Bahrami                                                              
%% loading input files 

    if nargin == 0
        prmname          = 'STFLO_Fraser_nonglacier.txt';
        year_start       = 2004;
        day_start        = 245;
        year_finish      = 2017;
        day_finish       = 242;
        mult_sim         = true;
    end
    
    if (mult_sim)
        prmname2          = 'STFLO_Fraser_glacier.txt';
    end 
    
%% construc time 
    [ms, ds]   = Julian2MonthDay(day_start , year_start);
    [mf, df]   = Julian2MonthDay(day_finish , year_finish);
    
    ts = datetime(year_start, ms, ds);
    tf = datetime(year_finish, mf, df);
    
% daily
    time    =  ts : caldays(1) : tf;
    time_yr =  ts : calyears(1) : tf;
    
%% Setting plot style and parameters 
    % Plot Style 
    color ={[0.35 0.35 0.35],[0.850 0.325 0.0980],[0.055 0.310 0.620],...
                             [0 0.48 0.070],'w'};
    lsty  =  {'-','--'};    
    
%% reading input file 
    STFL_nglac = MESH_ST_extract(prmname, year_start, day_start,...
                                year_finish, day_finish);
    if (mult_sim)
        STFL_glac = MESH_ST_extract(prmname2, year_start, day_start,...
                                year_finish, day_finish);
    end 
      
    m  = length(STFL_nglac);
%% assigning title 

%% output directory 

%% output directory 
    % todo should be considered based on multiple runs
    for i = 1 : m
        fig = figure ('units','normalized','outerposition',[0 0 1 1]);
        st(:,1) = STFL_nglac(i).data(: , 1); 
        st(:,2) = STFL_nglac(i).data(: , 2); 
        % this one should be conditioned 
        st(:,3) = STFL_glac(i).data(: , 2); 
        %DataName =  {''};

        for j = 1 : 3      
            h = plot(time, st(:,j),'DatetimeTickFormat' , 'yyyy-MMM');
            hold on 
            h.LineStyle =  lsty{1};
            h.LineWidth = 2;
            h.Color = color{j};
        end 

        hold off
        st = [];
        grid on

        % Axis Labels
        xlabel('\bf Time [days]','FontSize',14,'FontName', 'Times New Roman');
        ylabel('\bf River Discharge [cumecs]','FontSize',14,'FontName', 'Times New Roman');
        title('Station simulations','FontSize',14,...
                 'FontWeight','bold','FontName', 'Times New Roman')

        % Axis limit
        % xlimit
        xlim([time(1) time(end)])

        % Axis setting
        ax = gca; 
        set(ax , 'FontSize', 14,'FontWeight','bold','FontName', 'Times New Roman')
        ax.GridAlpha = 0.4;
        ax.GridColor = [0.65, 0.65, 0.65];
        ax.XTick = time_yr;
    end 

end 