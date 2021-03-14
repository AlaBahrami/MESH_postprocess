function MESH_SF_Metrics_sho()

% Syntax
%
%       MESH_SF_METRICS_SHO(...)
% 
% Discription
%
%       The purpose of this function is to read MESH calculated metrics
%       based on streamflow observations from multiple model simulation.
%       Then, present metrics in figure plots
%
% Input 
%
%       prmname                 The input parameter file includes input
%
%
% Output      
% 
%                               Series of plots                   
%
% Reference 
%       
%
% See also: 
%
% Author: Ala Bahrami       
%
% Created Date: 03/07/2021
%
%% Copyright (C) 2021 Ala Bahrami                                                              
%% loading the input files 

    if nargin == 0
        prmname        = 'STFLO_Fraser_metrics.txt';
    end 
    fid  = fopen(prmname);
    Info = textscan(fid, '%s %s');
    fclose(fid);
    
%% Reading input files
    m = length(Info{1,2});
    % it is hard coded should be modified. 
    metrics = zeros (81,12, m);
    for i = 1 : m
        metrics(:,:,i) = dlmread(Info{1,2}{i , 1});
    end 
    
%% extract Basin ids  
    % these are calibration sets
    DataName = {'08JC002','08KB001','08KH006','08KG001',...
                '08LF051','08MB005','08MC018','08MF005','08MF040'};
    n = length(DataName);
    Basin_id = [6,15,19,25,49,60,63,69,70];        
    
%% extarcting mettics for each station                         
    bias  = zeros(n,m);
    nsd   = zeros(n,m);
    lnnsd = zeros(n,m);
    kge   = zeros(n,m);
    for i = 1 : n
        for j = 1 : m 
            % use minus to be compatible to (sim - obs)
            % and 100 to convert it to percentage
            bias(i,j)  = -metrics(Basin_id(i),4,j)*100;
            nsd(i,j)   = metrics(Basin_id(i),6,j);
            lnnsd(i,j) = metrics(Basin_id(i),8,j);  
            kge(i,j)   = metrics(Basin_id(i),11,j);
        end 
    end 
%% Setting plot style and parameters 
    % Plot Style 
    color ={[0.55 0.55 0.55], [0.35 0.35 0.35],[0.850 0.325 0.0980],[0.055 0.310 0.620],...
                             [0 0.48 0.070],[0.8 0.608 0],'w'};
               
%% display metrics results from different simulations
    simlab ={'nonglacier-Liard','glacier-Liard','nonglacier-Athabasca',...
            'glacier-Athabasca','glacier-Athabasca-5IAK','glacier-Athabasca-5IAK-RDRS'};
    yl = {'PBIAS [%]','NSD','LnNSD','KGE'};   
    outdir = 'Output\Fraser\metrics\';
    for p = 1 : n
        fig = figure ('units','normalized','outerposition',[0 0 1 1]);
        for k = 1 :4
            subplot(1,4,k)
            if (k ==1)
                % PBIAS
                b = bar(bias(p,:));
            elseif (k==2)
                % NSD
                b = bar(nsd(p,:));
            elseif(k==3)
                % LNNSD
                b = bar(lnnsd(p,:));
            else
                % kge
                b = bar(kge(p,:));
            end

            for i = 1 : m
                b.FaceColor = 'flat';
                b.CData(i,:) = color{i};
            end 

            % axis label and setting 
            ylabel(yl{k},'FontSize',18,'FontName', 'Times New Roman','FontWeight','bold');
            title(DataName{p},'FontSize',18,...
                     'FontWeight','bold','FontName', 'Times New Roman');

            % axis setting 
            ax = gca; 
            set(ax , 'FontSize', 14,'FontWeight','bold','FontName', 'Times New Roman')
            ax.GridAlpha = 0.4;
            ax.YColor = 'k';
            ax.XTickLabel = simlab;
            ax.XTickLabelRotation = 45;
        end
        %saving figures
        fs1 = strcat(outdir,'-',DataName{p},'.fig');
        %fs2 = strcat(outdir,'-',DataName{p},'.tif');
        fs2 = strcat(outdir,'-',DataName{p},'.png');
        saveas(fig, fs1);
        saveas(fig, fs2);
        close(fig);
    end 
end 