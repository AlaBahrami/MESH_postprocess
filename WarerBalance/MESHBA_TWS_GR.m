function BasinTWS_Stat = MESHBA_TWS_GR(prmname, year_start, day_start, hour_start, min_start,...        
                         year_finish, day_finish, hour_finish, min_finish, ...       
                         timestep, in_basin)

% Syntax
%
%       BASINTWS_STAT = MESHBA_TWS_GR(...)
% 
% Discription
%
%       The purpose of this function is to read MESH basin average water balance 
%       compartments and GRACE observations and calculate the metrics and show
%       two time series. 
%
% Input 
%
%       prmname                 The input parameter file includes input
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
%       hour_finish             finish hour of simulation
%        
%       min_finish              finish minute of simulation
%
%       timestep                flag for activating time step data 
%
%       in_basin                index of basin of interest (e.g., Fraser)
%
%
% Output      
% 
%       BasinTWS_Stat           Summary of basin averaged statistics                   
%
% Reference 
%       
%
% See also: MESH_WBBA_extract, MESH_BAWB_extract 
%
% Author: Ala Bahrami       
%
% Created Date: 03/05/2021
%
%
% note : becasuse the modified version of the code for consdiering ICE/TICE
% is not implemented yet, the nonglacier simulation are consided. Second,
% when I run the code, I forget to obtain monthly values, so I convert them
% to monthly ones. 
%
%   Todo I: the monthly calculations should be implemeneted inside the MESH_WBBA_extract
%          programs
% 
%       II: time input information should be entered in one file 
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
        hour_finish      = 22;
        min_finish       = 30;
        timestep         = false;
        in_basin         = 1;
    end 

%% setting parameters 
    if (timestep)
        j = 2;
    else 
        j = 0;
    end 

    %index
    ind_STGW       = 38+j;
    
%%  Retreiving daily BAWB 
    BAWB = MESH_WBBA_extract(prmname, year_start, day_start, hour_start, min_start, ...        
                            year_finish, day_finish, hour_finish, min_finish, ...       
                            timestep);
                        
%% setting Julian calendar parameters 

    days1 = [1 , 31; 32 , 60; 61 , 91; 92 , 121;122 , 152; 153, 182; 183, 213;...
        214, 244; 245 , 274; 275, 305; 306 , 335; 336 , 366];

    days1(:,3) = days1(:,2) - days1(:,1) +1;

    days2 = [1 , 31; 32 , 59; 60 , 90; 91 , 120; 121 , 151; 152, 181; 182, 212;...
        213, 243; 244 , 273; 274, 304; 305 , 334; 335 , 365];

    days2(:,3) = days2(:,2) - days2(:,1) +1;
    
%% convert daily simulation to monthly values 
    year_now =  year_start;
    day_now  =  day_start;
    count    = 0;
    ENDDATE  = false;
    B        = BAWB(: , ind_STGW);
    
    while(~ENDDATE)
            
            if (isempty(B))
                disp('The program reached end of input file')
                disp('Check the input parameters')
                break
            end

            count = count + 1;

            if (mod (year_now , 4) == 0)
                dys = days1;
            else
                dys = days2;
            end
            
            r = find(dys == day_now);
            days    = dys(r,3);
            day_now = day_now + days;  

            if (year_now ~= year_finish)

                if (day_now > 365)

                    if (day_now > 366)
                        day_now  = day_now - 366;
                        year_now = year_now + 1; 
                    else 
                        day_now  = day_now - 365;
                        year_now = year_now + 1;

                    end 

                end

            end

            if  (year_now >= year_finish)

                if (day_now > day_finish) 
                        ENDDATE = true ;
                end 

            end
            
            % monthly calculation 
            % this condition is set when last simulation does not reach end
            % of month
            if (length(B) >= days)
                STGW             = B(1:days);
                STGW_m(count)    = mean(STGW);
                B(1: days) = [];
            else 
                break;
            end 
                       
    end 
%% Extracting GRACE observations 
    year_start_gr     = 2002;
    day_start_gr      = 91;
    year_finish_gr    = 2015;
    day_finish_gr     = 365;
    year_start_se     = 2004;
    day_start_se      = 245;
    year_finish_se    = 2015;
    day_finish_se     = 213;  
    
    GRTWSA = GRACEAnomCalc (year_start_gr, day_start_gr, year_finish_gr, day_finish_gr, ...
                            year_start_se, day_start_se, year_finish_se, day_finish_se, ...
                            in_basin);

%% extracting MESH monthly storage based on time period of selection
    day_finish_se2     = 243;
    
    [ms, ds]   = Julian2MonthDay(day_start , year_start);
    [mf, df]   = Julian2MonthDay(day_finish , year_finish);
    
    [ms_se, ds_se]   = Julian2MonthDay(day_start_se , year_start_se);
    [mf_se, df_se]   = Julian2MonthDay(day_finish_se , year_finish_se);
    [~, df_se2]      = Julian2MonthDay(day_finish_se2 , year_finish_se);
    
    ts = datetime(year_start, ms, ds);
    tf = datetime(year_finish, mf, df);
    
    ts_se  = datetime(year_start_se, ms_se, ds_se);
    tf_se  = datetime(year_finish_se, mf_se, df_se);
    tf_se2 = datetime(year_finish_se, mf_se, df_se2);
    
    % finding monthly indices 
    time_m = ts : calmonths(1) : tf;
    rm1 = find(time_m == ts_se);
    rm2 = find(time_m == tf_se);
    
    % finding daily indices
    td = ts : caldays(1) : tf;
    rd1 = find(td == ts_se);
    rd2 = find(td == tf_se2);
    
%% calculate MESH daily time mean and covert GRACE TWSA to absolute value
    MESH_STGW_mean = mean(BAWB(rd1: rd2, ind_STGW));
    MESH_STGW_mon  = STGW_m(rm1:rm2)';
    
    GRTWS = GRTWSA + MESH_STGW_mean; 
    
    %finding months in which data are available 
    fd = ~isnan(GRTWS);
    n  = sum(fd);
    
%% stats header information
    BasinTWS_Stat = struct([]);
    BasinTWS_Stat{1,2} = 'RMSD[mm]';
    BasinTWS_Stat{1,3} = 'MD[mm]';
    BasinTWS_Stat{1,4} = 'Bias(%)';
    BasinTWS_Stat{1,5} = 'ubRMSD';
    BasinTWS_Stat{1,6} = 'Pearson';
    BasinTWS_Stat{1,7} = 'test_Pearson';
    
    BasinTWS_Stat{2,1} = 'MESH_GR';
%% calculate the RMSD MESH vs GRACE 
    rmsd(:,1) = MESH_STGW_mon(fd) - GRTWS(fd);
    rmsd = rmsd .^2 ;
    resid = rmsd;
    rmsd = sum(rmsd);
    rmsd = sqrt((1/n)*rmsd);
    BasinTWS_Stat{2,2} = rmsd(1,1);
    
%% Calculate the mean difference (MD) MESH vs GRACE 
    md(:,1) = MESH_STGW_mon(fd) - GRTWS(fd);
    md = sum(md);
    md = (1/n).*(md);
    BasinTWS_Stat{2,3} = md(1,1);
    
%% calculate the PBIAS
    gr_mean      = mean(GRTWS(fd));
 
    errd(:,1) = MESH_STGW_mon(fd) - GRTWS(fd);
    bias(1,1) = sum(errd(:,1)) ./ (gr_mean * n); 
    BasinTWS_Stat{2,4} = bias(1,1) * 100; 

%% calculate the ubRMSD
    mesh_mean = mean(MESH_STGW_mon(fd));
    
    ubrmsd = (MESH_STGW_mon(fd) - mesh_mean) - (GRTWS(fd) - gr_mean);
    
    ubrmsd = ubrmsd .^2 ;
    resid2 = ubrmsd;
    ubrmsd = sum(ubrmsd);
    ubrmsd = sqrt((1/n)*ubrmsd);
    BasinTWS_Stat{2,5} = ubrmsd(1,1);

%%  calculate pearson correlation
    [rval, pval] = corrcoef(GRTWS(fd), MESH_STGW_mon(fd));
    
    if (pval(1,2)<=0.05 && pval(1,2)>=-0.05)
        H0 = 'significant';
    else
        H0 = 'no-significant';
    end 
    
    BasinTWS_Stat{2,6} = round(rval(1,2),2);
    BasinTWS_Stat{2,7} = H0;
    
%% Setting plot style and parameters
    color ={[0.35 0.35 0.35],[0.850 0.325 0.0980],[0.055 0.310 0.620],...
                             [0 0.48 0.070],'w'};
    lsty  =  {'-','--'};
    marker = {'o'};
    
%% showing results
    DataName = {'MESH-derived TWS','GRACE-derived TWS'};
    outdir = 'output\fraser\non_glacier\basin\';
    fs1 = strcat(outdir,'TWS.fig');
    %fs2 = strcat(outdir,'flow.tif');
    fs2 = strcat(outdir,'TWS.png');
    fs3 = strcat(outdir,'TWS_Stat.xlsx');
    
    TWS = [MESH_STGW_mon, GRTWS];
    fig = figure ('units','normalized','outerposition',[0 0 1 1]);
    for i = 1 : 2
        h = plot(time_m(rm1 : rm2), TWS(: , i) ,'DatetimeTickFormat' , 'yyyy-MMM');
        h.Marker = marker{1};
        h.LineStyle =  lsty{i};
        h.Color = 'k';
        h.MarkerSize = 8;   
        h.MarkerFaceColor = color{1+i};
        h.MarkerEdgeColor = 'k';
        h.LineWidth = 1.5;
        hold on
    end 
    hold off
    grid on
    
    % Axis Labels
    xlabel('\bf Time (months)','FontSize',18,'FontName', 'Times New Roman');
    ylabel('\bf Equivalent Water Height [mm]','FontSize',18,'FontName', 'Times New Roman');
    
    title('Fraser Basin Average Estimates','FontSize',18,...
             'FontWeight','bold','FontName', 'Times New Roman')
    % Axis limit
    % xlimit
    xlim([time_m(rm1) time_m(rm2)])
    
    % Axis setting
    ax = gca; 
    set(ax , 'FontSize', 18,'FontWeight','bold','FontName', 'Times New Roman')
    ax.GridAlpha = 0.4;
    ax.GridColor = [0.65, 0.65, 0.65];
    
    % Legend setting 
    h = legend(DataName{:});
    h.Location = 'northwest'; 
    h.FontSize = 14;
    h.Orientation = 'horizontal';
    h.EdgeColor = color{end};
    
    % saving 
    saveas(fig, fs1);
    saveas(fig, fs2);
    close(fig);
    
    % write stats to output 
    xlswrite(fs3, BasinTWS_Stat);
    
end 