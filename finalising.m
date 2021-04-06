close all
clear
clc
%% traceket ábrázol, illetve heatmapet
dnam = uigetdir('Select folder where the ms.mat file folder for the desired videos exist: ');
file = uigetfile('Select ms.mat file: ', 'ms.mat');
load([dnam '/' file]);
t = ms.FiltTraces;
[a,~] = size(t);
%%
figure(1)
for i = 1 : a
    t(i,:) = normalize(t(i,:));
end
plot((t + (1: size(t, 1))')');
ticks = (0:a);
yticks(ticks);
title('Normalized Ca traces')

saveas(figure(1), fullfile(dnam, 'traces'), 'tif');


figure(2)
imagesc(t)
saveas(figure(2), fullfile(dnam, 'heatmap'), 'tif'); 

%%
M = t;
%% 
N = mean(M);
figure(3)
plot(N)
title('Mean calcium activity');

%% treshold calculation
tt = timer('ExecutionMode', 'singleShot', 'StartDelay', 30, 'TimerFcn', @pressEnter); %%% timer waits 30 seconds, if not set it will be default
start(tt);
prompt33 = 'Based on Mean calcium activity define the threshold for peak finding!: ';
MPH = input(prompt33);
stop(tt);
delete(tt);

%% half width calculation

ttt = timer('ExecutionMode', 'singleShot', 'StartDelay', 30, 'TimerFcn', @pressEnter); %%% timer waits 30 seconds, if not set it will be default
start(ttt);
prompt44 = 'Based on Mean calcium activity define the threshold for peak finding!: ';
MHW = input(prompt44);
stop(ttt);
delete(ttt);


%% scatter plot az összes olyan elemet, ami kell

color = rand(size(M,1),3);
for kk = 1 : size(M,1)
    [aa,b] = findpeaks(M(kk,:), 'MinPeakHeight', MPH);
    for kkk = 1 : size(aa,2)
        if aa(:,kkk) ~= kk
            aa(:,kkk) = kk;
        end
    end
    figure(5);
    hold on
    ylim([0,a+1])
    grid on
    scatter(b, aa, 'filled');
end
[q,~] = size(M);
ticks = 1:q; 
yticks(ticks);


%% normalize function elemei, nem érdekes számotokra

function norm_frame = normalize(frame_in, dim)
% norm_frame = normalize normalize intensity to [0, 1]
%   frame_in is input frame or video
%   dim is dimension flag, optional
%   Jinghao Lu 01/16/2016

    if nargin < 2
        dim = 4; %%% treat the tensor as a whole %%%
    end
    if dim == 4
        mn = nanmin(nanmin(nanmin(frame_in)));
        norm_frame = frame_in - mn;
        mx = nanmax(nanmax(nanmax(norm_frame)));
        norm_frame = norm_frame / mx;
    else
        norm_frame = frame_in - repmat(nanmin(frame_in, [], dim), 1, size(frame_in, dim));
        norm_frame = norm_frame ./ (repmat(nanmax(norm_frame, [], dim), 1, size(frame_in, dim)));
    end
end