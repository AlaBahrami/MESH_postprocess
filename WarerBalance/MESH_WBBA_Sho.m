function MESH_WBBA_Sho()

% Syntax
%
%       MESH_WBBA_SHO(...)
% 
% Discription
%
%       The pupoose of this function is to read MESH basin average water balance 
%       compartments, daily and timestep. Then, desired figures are plotted.
%       If it is required, the BAWB output can be saved. 
% 
%
% Input 
%
%       prmname                 The input parameter file includes input
%                               file information (daily and ts). 
%
%       year_start              Start year of simulation 
%
%       day_start               Start day of simulation 
%
%       year_finish             Finish year of simulation 
%
%       day_finish              Finish day of simulation 
%
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
% Created Date: 02/21/2021
%
%   todo:
%       1) modify indices for considering ts results 
%       2) modify the MESH_BAWB_extract to get wb for basin and subbasins 
%       3) modify it to be comatabile to read all subbasins 
%
%% Copyright (C) 2021 Ala Bahrami                                                              
%% loading the input files 

    if nargin == 0
        prmname          = 'BAWB_Fraser_glac.txt';
        ts               = datetime(2004, 09, 01);
        tf               = datetime(2017, 08, 30);
        year_start       = 2004;
        day_start        = 245;
        hour_start       = 0;
        min_start        = 0;
        year_finish      = 2017;
        day_finish       = 242;
        day_finish2      = 243;
        hour_finish      = 22;
        min_finish       = 30;
    end 

    fid  = fopen(prmname);
    Info = textscan(fid, '%s %s');
    fclose(fid);
    
    ts2 = datetime(2004, 09, 01, hour_start, min_start, 0);
    tf2 = datetime(2017, 08, 31, hour_finish, min_finish, 0);
    
%% construct time 
% daily
    time    =  ts : caldays(1) : tf;
    time_yr =  ts : calyears(1) : tf;
    
%  time step 
    time_ts  =  ts2 : hours(0.5) : tf2;
    
%% MESH storage components parameters
% note : ts outputs have two columns more than daily ones. add number 2 to
% indices for presentation and calculation 

    % index
    ind_year       = 1;  ind_day        = 2;
    %ind_HOUR       = 3;  ind_MINS       = 4;
    
    ind_PREACC     = 3;  ind_ETACC      = 4;
    ind_ROFACC     = 5;  ind_OVRFLWACC  = 6;  ind_LATFLWACC   = 7;  ind_DRAINSOLACC = 8;
    ind_DSTGWACC   = 9;  ind_PREC       = 10; ind_ET          = 11; ind_ROF         = 12;
    ind_OVRFLW     = 13; ind_LATFLW     = 14; ind_DRAINSOL    = 15;
    ind_FZWSCAN    = 16; ind_LQWSCAN    = 17; ind_SNO         = 18; ind_LQWSSNO     = 19; 
    ind_LQWSPND    = 20;
    ind_LQWSSOL1   = 21; ind_FZWSSOL1   = 22; ind_ALWSSOL1       = 23;
    ind_LQWSSOL2   = 24; ind_FZWSSOL2   = 25; ind_ALWSSOL2       = 26;
    ind_LQWSSOL3   = 27; ind_FZWSSOL3   = 28; ind_ALWSSOL3       = 29;
    ind_LQWSSOL4   = 30; ind_FZWSSOL4   = 31; ind_ALWSSOL4       = 32;
    ind_LQWSSOL    = 33; ind_FZWSSOL    = 34; ind_ALWSSOL        = 35;
    ind_STGGW      = 36; ind_DZS        = 37;  
    ind_STGW       = 38; ind_DSTGW      = 39;

    % description
    descr_year       = 'year';      descr_day         = 'day';
    descr_hour       = 'hour';      descr_mins        = 'mins';
    
    descr_PREACC     = 'PREACC';    descr_ETACC      = 'ETACC';
    descr_ROFACC     = 'ROFACC';    descr_OVRFLWACC  = 'OVRFLWACC';     descr_LATFLWACC   = 'LATFLWACC';    descr_DRAINSOLACC = 'DRAINSOLACC';
    descr_DSTGWACC   = 'DSTGWACC';  descr_PREC       = 'PREC';          descr_ET          = 'ET';           descr_ROF         = 'ROF';
    descr_OVRFLW     = 'OVRFLW';    descr_LATFLW     = 'LATFLW';        descr_DRAINSOL    = 'DRAINSOL';
    descr_FZWSCAN    = 'FZWSCAN';   descr_LQWSCAN    = 'LQWSCAN';       descr_SNO         = 'SNO';          descr_LQWSSNO     = 'LQWSSNO'; 
    descr_LQWSPND    = 'LQWSPND';
    descr_LQWSSOL1   = 'LQWSSOL1';  descr_FZWSSOL1   = 'FZWSSOL1';      descr_ALWSSOL1       = 'ALWSSOL1';
    descr_LQWSSOL2   = 'LQWSSOL2';  descr_FZWSSOL2   = 'FZWSSOL2';      descr_ALWSSOL2       = 'ALWSSOL2';
    descr_LQWSSOL3   = 'LQWSSOL3';  descr_FZWSSOL3   = 'FZWSSOL3';      descr_ALWSSOL3       = 'ALWSSOL3';
    descr_LQWSSOL4   = 'LQWSSOL4';  descr_FZWSSOL4   = 'FZWSSOL4';      descr_ALWSSOL4       = 'ALWSSOL4';
    descr_LQWSSOL    = 'LQWSSOL';   descr_FZWSSOL    = 'FZWSSOL';       descr_ALWSSOL        = 'ALWSSOL';
    descr_STGGW      = 'STGGW';     descr_DZS        = 'DZS';  
    descr_STGW       = 'STGW';      descr_DSTGW      = 'DSTGW';

%% reading input file 
    BAWB    = xlsread(Info{1,2}{1 , 1});
    BAWB_ts = xlsread(Info{1,2}{2 , 1});
    
    % extracting monnthly indices 
    rs = find ( BAWB(:,1) == year_start  & BAWB(:,2) == day_start); 
    rf = find (BAWB(:,1)  == year_finish & BAWB(:,2) == day_finish); 
    
    rs2 = find ( BAWB_ts(:,1) == year_start  & BAWB_ts(:,2) == day_start...
                & BAWB_ts(:,3) == hour_start  & BAWB_ts(:,4) == min_start); 
    rf2 = find ( BAWB_ts(:,1) == year_finish  & BAWB_ts(:,2) == day_finish2...
                & BAWB_ts(:,3) == hour_finish  & BAWB_ts(:,4) == min_finish); 
    
    BAWB    =  BAWB(rs : rf, :);
    BAWB_ts =  BAWB_ts(rs2 : rf2, :);

%% calculating time step imbalance    
% Note1 : It is recommended to use the time step results rather than daily
% one. 
% Note2: Because ts outputs are used, number 2 is added to indices 
imbl = BAWB_ts(:, ind_PREC + 2) - BAWB_ts(:, ind_ET + 2) - BAWB_ts(:, ind_ROF + 2) - ...
                BAWB_ts(:, ind_DSTGW + 2);
% This imblance of first simulations is high, so I removed it 
imbl_sum = round(sum(imbl(2:end)),2);

%% Setting plot style and parameters 
    % Plot Style 
%     color = {[0.55 0.55 0.55],[0.35 0.35 0.35],[0.8500 0.3250 0.0980],'b','r','g',[0.25 0.25 0.25],...
%         'w', 'b', 'm','w'};
    color ={[0.35 0.35 0.35],[0.850 0.325 0.0980],[0.055 0.310 0.620],...
                             [0 0.48 0.070],'w'};
    lsty  =  {'-','--'};
    
%% Plotting WB compartments 
    
% imbalance 
    DataName = sprintf('The summation of imbalance is: %0.2f', imbl_sum);
    figure ('units','normalized','outerposition',[0 0 1 1]);
    
    h = plot(time_ts(2:end), imbl(2:end),'DatetimeTickFormat' , 'yyyy-MMM'); 
    h.LineStyle =  lsty{1};
    h.LineWidth = 2;
    h.Color = color{3};
    grid on 
    
    st = [];
    % Axis Labels
    xlabel('\bf Time [time steps]','FontSize',14,'FontName', 'Times New Roman');
    ylabel('\bf Equivalent Water Height [mm]','FontSize',14,'FontName', 'Times New Roman');
    title('Fraser Basin Average','FontSize',14,...
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

% overland, lateral and drainage 
    st(:,1) = BAWB(: , ind_OVRFLWACC); 
    st(:,2) = BAWB(: , ind_LATFLWACC); 
    st(:,3) = BAWB(: , ind_DRAINSOLACC); 
    
    DataName =  {descr_OVRFLWACC, descr_LATFLWACC, descr_DRAINSOLACC};
    
    figure ('units','normalized','outerposition',[0 0 1 1]);
    
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
    title('Fraser Basin Average','FontSize',14,...
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
    
% SWE
    st(:,1) = BAWB(: , ind_SNO); 
    DataName =  {descr_SNO};
    
    figure ('units','normalized','outerposition',[0 0 1 1]);
    
    h = plot(time, st(:,1),'DatetimeTickFormat' , 'yyyy-MMM'); 
    h.LineStyle =  lsty{1};
    h.LineWidth = 2;
    h.Color = color{3};
    st = [];
    grid on 
    
    % Axis Labels
    xlabel('\bf Time [days]','FontSize',14,'FontName', 'Times New Roman');
    ylabel('\bf Equivalent Water Height [mm]','FontSize',14,'FontName', 'Times New Roman');
    title('Fraser Basin Average','FontSize',14,...
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

%  Liquid, Frozen, and ALW

    st(:,1) = BAWB(: , ind_LQWSSOL); 
    st(:,2) = BAWB(: , ind_FZWSSOL); 
    st(:,3) = BAWB(: , ind_ALWSSOL); 
    
    DataName =  {descr_LQWSSOL, descr_FZWSSOL, descr_ALWSSOL};
    
    figure ('units','normalized','outerposition',[0 0 1 1]);
    
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
    title('Fraser Basin Average','FontSize',14,...
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
    
% STGGW
    
    st(:,1) = BAWB(: , ind_STGGW); 
    DataName =  {descr_STGGW};
    
    figure ('units','normalized','outerposition',[0 0 1 1]);
    
    h = plot(time, st(:,1),'DatetimeTickFormat' , 'yyyy-MMM'); 
    h.LineStyle =  lsty{1};
    h.LineWidth = 2;
    h.Color = color{3};
    st = [];
    grid on 
    
    % Axis Labels
    xlabel('\bf Time [days]','FontSize',14,'FontName', 'Times New Roman');
    ylabel('\bf Equivalent Water Height [mm]','FontSize',14,'FontName', 'Times New Roman');
    title('Fraser Basin Average','FontSize',14,...
             'FontWeight','bold','FontName', 'Times New Roman')

    % Axis limit
    % xlimit
    xlim([time(1) time(end)])
    ylim([0 16])
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

% Total Storage and other compartments
    st(:,1) = BAWB(: , ind_STGW); 
    st(:,2) = BAWB(: , ind_SNO); 
    st(:,3) = BAWB(: , ind_LQWSSOL);
    st(:,4) = BAWB(: , ind_FZWSSOL);
    
    DataName =  {descr_STGW, descr_SNO, descr_LQWSSOL, descr_FZWSSOL};
    
    figure ('units','normalized','outerposition',[0 0 1 1]);
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
    title('Fraser Basin Average','FontSize',14,...
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

end 