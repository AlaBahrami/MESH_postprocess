function MESH_WBBA_Sho(prmname, prmnamets,...
                        year_start, day_start, hour_start, min_start, ...        
                        year_finish, day_finish, day_finish2, hour_finish, min_finish,...
                        timestep, subbasin)

% Syntax
%
%       MESH_WBBA_SHO(...)
% 
% Discription
%
%       The pupoose of this function is to read MESH basin average water balance 
%       compartments, daily and timestep. Then, desired figures are plotted.
%        
% 
%
% Input 
%
%       prmname                 The input parameter of daily simulations
%
%       prmnamets               The input parameter of timestep simulations
%
%       year_start              Start year of simulation 
%
%       day_start               Start day of simulation 
%
%       hour_start              Start hour of simulation
%        
%       min_start               Start minute of simulation
%
%       year_finish             Finish year of simulation 
%
%       day_finish              Finish day of simulation 
%
%       day_finish2             Finish day of simulation 
%
%       hour_finish             finish hour of simulation
%        
%       min_finish              finish minute of simulation
%
%       timestep                flag for activating time step data 
%
%       subbasin                flag for activating subbasin data
%
% Output      
% 
%                               series of plots                  
%
% Reference 
%       
%
% See also: MESH_WBBA_extract, Julian2MonthDay
%
% Author: Ala Bahrami       
%
% Created Date: 02/21/2021
%
% last modified : 02/24/2021
%
%
%% Copyright (C) 2021 Ala Bahrami                                                              
%% loading the input files 

    if nargin == 0
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
    end  
% Note1): if in any circumstance, the day finish from both time step and
% daily simulation does not match, users sould declare day_finish2.
% otherwise day_finish2 equals to day_finish
% 
% Note 2: here the majority of plots are based on daily simulations, so the
% time step simulations are set to false.
%
%% construct time 
    [ms, ds]   = Julian2MonthDay(day_start , year_start);
    [mf, df]   = Julian2MonthDay(day_finish , year_finish);
    [mf2, df2] = Julian2MonthDay(day_finish2 , year_finish);
    
    ts = datetime(year_start, ms, ds);
    tf = datetime(year_finish, mf, df);
    ts2 = datetime(year_start, ms, ds, hour_start, min_start, 0);
    tf2 = datetime(year_finish, mf2, df2, hour_finish, min_finish, 0);

% daily
    time    =  ts : caldays(1) : tf;
    time_yr =  ts : calyears(1) : tf;
    
%  time step 
    time_ts  =  ts2 : hours(0.5) : tf2;
    
%% MESH storage components parameters
    if (timestep)
        ind_HOUR     = 3;  
        ind_MINS     = 4;
        j = 2; 
    else
        j = 0;    
    end
     
    % index
    ind_year       = 1;    ind_day        = 2; 
    ind_PREACC     = 3+j;  ind_ETACC      = 4+j;
    ind_ROFACC     = 5+j;  ind_OVRFLWACC  = 6+j;  ind_LATFLWACC   = 7+j;  ind_DRAINSOLACC = 8+j;
    ind_DSTGWACC   = 9+j;  ind_PREC       = 10+j; ind_ET          = 11+j; ind_ROF         = 12+j;
    ind_OVRFLW     = 13+j; ind_LATFLW     = 14+j; ind_DRAINSOL    = 15+j;
    ind_FZWSCAN    = 16+j; ind_LQWSCAN    = 17+j; ind_SNO         = 18+j; ind_LQWSSNO     = 19+j; 
    ind_LQWSPND    = 20+j;
    ind_LQWSSOL1   = 21+j; ind_FZWSSOL1   = 22+j; ind_ALWSSOL1       = 23+j;
    ind_LQWSSOL2   = 24+j; ind_FZWSSOL2   = 25+j; ind_ALWSSOL2       = 26+j;
    ind_LQWSSOL3   = 27+j; ind_FZWSSOL3   = 28+j; ind_ALWSSOL3       = 29+j;
    ind_LQWSSOL4   = 30+j; ind_FZWSSOL4   = 31+j; ind_ALWSSOL4       = 32+j;
    ind_LQWSSOL    = 33+j; ind_FZWSSOL    = 34+j; ind_ALWSSOL        = 35+j;
    ind_STGGW      = 36+j; ind_DZS        = 37+j;  
    ind_STGW       = 38+j; ind_DSTGW      = 39+j;
    
%% Setting plot style and parameters 
    % Plot Style 
%     color = {[0.55 0.55 0.55],[0.35 0.35 0.35],[0.8500 0.3250 0.0980],'b','r','g',[0.25 0.25 0.25],...
%         'w', 'b', 'm','w'};
    color ={[0.35 0.35 0.35],[0.850 0.325 0.0980],[0.055 0.310 0.620],...
                             [0 0.48 0.070],'w'};
    lsty  =  {'-','--'};    
%% reading input file 
    BAWB    = MESH_WBBA_extract(prmname, year_start, day_start, hour_start, min_start, ...        
                            year_finish, day_finish, hour_finish, min_finish, ...       
                            timestep);
%% assigning title       
%tl = 'Fraser Basin Average';
    name = split(prmname,"_");
    str = name{2};
    if (~subbasin)
            tl = strcat (str ,' Basin', ' Average');
    else
            tl = strcat (str ,' Subbasin', ' Average');
    end
%% output directory 
    if (~subbasin)
        outdir = 'output\fraser\non_glacier\basin\';
        outdir = strcat(outdir, str, '_');
    else
        outdir = 'output\fraser\non_glacier\subbasin\';
        outdir = strcat(outdir, str, '_');
    end

%% reading timestep
    % this section is activated when the imblance of entire basin is
    % needed. It can be activated if the imbalance of subbasin is desired
    if (~subbasin)
        BAWB_ts = MESH_WBBA_extract(prmnamets, year_start, day_start, hour_start, min_start, ...        
            year_finish, day_finish2, hour_finish, min_finish, ...       
            ~timestep);

    % calculating time step imbalance    
        % Note1 : It is recommended to use the time step results rather than daily
        % one. 
        % setting j for ts results
        j = 2;
        imbl = BAWB_ts(:, ind_PREC + j) - BAWB_ts(:, ind_ET + j) - BAWB_ts(:, ind_ROF + j) - ...
                        BAWB_ts(:, ind_DSTGW + j);
        % This imblance of first simulations is high, so I removed it 
        imbl_sum = round(sum(imbl(2:end)),2);

        % resetting it to its default value 
        j = 0;
     
    
   % plotting imbalance  
        fs1 = strcat(outdir,'imbalance.fig');
        %fs2 = strcat(outdir,'imbalance.tif');
        fs2 = strcat(outdir,'imbalance.png');
        
        DataName = sprintf('The summation of imbalance is: %0.2f', imbl_sum);
        fig = figure ('units','normalized','outerposition',[0 0 1 1]);

        h = plot(time_ts(2:end), imbl(2:end),'DatetimeTickFormat' , 'yyyy-MMM'); 
        h.LineStyle =  lsty{1};
        h.LineWidth = 2;
        h.Color = color{3};
        grid on 

        st = [];
        % Axis Labels
        xlabel('\bf Time [time steps]','FontSize',14,'FontName', 'Times New Roman');
        ylabel('\bf Equivalent Water Height [mm]','FontSize',14,'FontName', 'Times New Roman');
        title(tl,'FontSize',14,...
                 'FontWeight','bold','FontName', 'Times New Roman')

        % Axis limit
        % xlimit
        xlim([time_ts(2) time_ts(end)])

        % Axis setting
        ax = gca; 
        set(ax , 'FontSize', 14,'FontWeight','bold','FontName', 'Times New Roman')
        ax.GridAlpha = 0.4;
        ax.GridColor = [0.65, 0.65, 0.65];
        ax.XTick = time_yr;

        h = legend(DataName);
        h.Location = 'northwest'; 
        h.FontSize = 14;
        h.Orientation = 'horizontal';
        h.EdgeColor = color{end};
        saveas(fig, fs1);
        saveas(fig, fs2);
        close(fig);
    end 
%% Plotting WB compartments    
% overland, lateral and drainage 
    % output dir 
    fs1 = strcat(outdir,'flow.fig');
    %fs2 = strcat(outdir,'flow.tif');
    fs2 = strcat(outdir,'flow.png');
    
    st(:,1) = BAWB(: , ind_OVRFLWACC); 
    st(:,2) = BAWB(: , ind_LATFLWACC); 
    st(:,3) = BAWB(: , ind_DRAINSOLACC); 
    DataName =  {'OVRFLWACC', 'LATFLWACC', 'DRAINSOLACC'};
    
    fig = figure ('units','normalized','outerposition',[0 0 1 1]);
    
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
    ylabel('\bf Equivalent Water Height [mm]','FontSize',14,'FontName', 'Times New Roman');
    title(tl,'FontSize',14,...
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
    
    h = legend(DataName{:});
    h.Location = 'northwest'; 
    h.FontSize = 14;
    h.Orientation = 'horizontal';
    h.EdgeColor = color{end};     
    
    saveas(fig, fs1);
    saveas(fig, fs2);
    close(fig);
    
% SWE
    fs1 = strcat(outdir,'SWE.fig');
    %fs2 = strcat(outdir,'SWE.tif');
    fs2 = strcat(outdir,'SWE.png');
    
    st(:,1) = BAWB(: , ind_SNO); 
    DataName =  {'SNO'};
    
    fig = figure ('units','normalized','outerposition',[0 0 1 1]);
    
    h = plot(time, st(:,1),'DatetimeTickFormat' , 'yyyy-MMM'); 
    h.LineStyle =  lsty{1};
    h.LineWidth = 2;
    h.Color = color{3};
    st = [];
    grid on 
    
    % Axis Labels
    xlabel('\bf Time [days]','FontSize',14,'FontName', 'Times New Roman');
    ylabel('\bf Equivalent Water Height [mm]','FontSize',14,'FontName', 'Times New Roman');
    title(tl,'FontSize',14,...
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
    
    h = legend(DataName{:});
    h.Location = 'northwest'; 
    h.FontSize = 14;
    h.Orientation = 'horizontal';
    h.EdgeColor = color{end};
    
    saveas(fig, fs1);
    saveas(fig, fs2);
    close(fig);
    
%  Liquid, Frozen, and ALW
    fs1 = strcat(outdir,'WS.fig');
    %fs2 = strcat(outdir,'WS.tif');
    fs2 = strcat(outdir,'WS.png');
    
    st(:,1) = BAWB(: , ind_LQWSSOL); 
    st(:,2) = BAWB(: , ind_FZWSSOL); 
    st(:,3) = BAWB(: , ind_ALWSSOL); 
    
    DataName =  {'LQWSSOL', 'FZWSSOL', 'ALWSSOL'};
    
    fig = figure ('units','normalized','outerposition',[0 0 1 1]);
    
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
    ylabel('\bf Equivalent Water Height [mm]','FontSize',14,'FontName', 'Times New Roman');
    title(tl,'FontSize',14,...
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
    
    h = legend(DataName{:});
    h.Location = 'northwest'; 
    h.FontSize = 14;
    h.Orientation = 'horizontal';
    h.EdgeColor = color{end};
    
    saveas(fig, fs1);
    saveas(fig, fs2);
    close(fig);
% STGGW
    fs1 = strcat(outdir,'GW.fig');
    %fs2 = strcat(outdir,'GW.tif');
    fs2 = strcat(outdir,'GW.png');
    
    st(:,1) = BAWB(: , ind_STGGW); 
    min_st = min(st);
    max_st = max(st) + 5;
    DataName =  {'STGGW'};
    
    fig = figure ('units','normalized','outerposition',[0 0 1 1]);
    
    h = plot(time, st(:,1),'DatetimeTickFormat' , 'yyyy-MMM'); 
    h.LineStyle =  lsty{1};
    h.LineWidth = 2;
    h.Color = color{3};
    st = [];
    grid on 
    
    % Axis Labels
    xlabel('\bf Time [days]','FontSize',14,'FontName', 'Times New Roman');
    ylabel('\bf Equivalent Water Height [mm]','FontSize',14,'FontName', 'Times New Roman');
    title(tl,'FontSize',14,...
             'FontWeight','bold','FontName', 'Times New Roman')

    % Axis limit
    % xlimit
    xlim([time(1) time(end)])
    ylim([min_st max_st])
    % Axis setting
    ax = gca; 
    set(ax , 'FontSize', 14,'FontWeight','bold','FontName', 'Times New Roman')
    ax.GridAlpha = 0.4;
    ax.GridColor = [0.65, 0.65, 0.65];
    ax.XTick = time_yr;
    
    h = legend(DataName{:});
    h.Location = 'northwest'; 
    h.FontSize = 14;
    h.Orientation = 'horizontal';
    h.EdgeColor = color{end};
    
    saveas(fig, fs1);
    saveas(fig, fs2);
    close(fig);

% Total Storage and other compartments
    fs1 = strcat(outdir,'STGW.fig');
    %fs2 = strcat(outdir,'STGW.tif');
    fs2 = strcat(outdir,'STGW.png');
    
    st(:,1) = BAWB(: , ind_STGW); 
    st(:,2) = BAWB(: , ind_SNO); 
    st(:,3) = BAWB(: , ind_LQWSSOL);
    st(:,4) = BAWB(: , ind_FZWSSOL);
    
    DataName =  {'STGW', 'SNO', 'LQWSSOL', 'FZWSSOL'};
    
    fig = figure ('units','normalized','outerposition',[0 0 1 1]);
    for j = 1 : 4
        h = plot(time, st(:,j),'DatetimeTickFormat' , 'yyyy-MMM'); 
        hold on
        h.LineStyle =  lsty{1};
        h.LineWidth = 2;
        h.Color = color{j};
    end 
    st = [];
    grid on 
    hold off
    
    % Axis Labels
    xlabel('\bf Time [days]','FontSize',14,'FontName', 'Times New Roman');
    ylabel('\bf Equivalent Water Height [mm]','FontSize',14,'FontName', 'Times New Roman');
    title(tl,'FontSize',14,...
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
    
    h = legend(DataName{:});
    h.Location = 'northwest'; 
    h.FontSize = 14;
    h.Orientation = 'horizontal';
    h.EdgeColor = color{end};
    
    saveas(fig, fs1);
    saveas(fig, fs2);
    close(fig);
end 