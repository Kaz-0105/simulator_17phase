% 評価のレーダーチャートを作る関数
close all;
clear;

% csvからデータを読み込む
data_table = readtable('results/1-1_network/database.csv');

% PhaseNumPerformanceMapの初期化
PhaseNumPerformanceMap = containers.Map('KeyType', 'char', 'ValueType', 'any');

% 固定式について
tmp_struct = [];

tmp_queue_array = zeros(1, 9);
tmp_queue_array(1) = 50.1;
tmp_queue_array(2) = 55.7;
tmp_queue_array(3) = 65.0;
tmp_queue_array(4) = 46.0;
tmp_queue_array(5) = 76.7;
tmp_queue_array(6) = 54.6;
tmp_queue_array(7) = 60.7;
tmp_queue_array(8) = 51.6;
tmp_queue_array(9) = 107.4;

tmp_struct.queue = tmp_queue_array;

tmp_delay_array = zeros(1, 9);
tmp_delay_array(1) = 33.5;
tmp_delay_array(2) = 33.0;
tmp_delay_array(3) = 38.1;
tmp_delay_array(4) = 33.2;
tmp_delay_array(5) = 47.2;
tmp_delay_array(6) = 34.6;
tmp_delay_array(7) = 34.4;
tmp_delay_array(8) = 34.9;
tmp_delay_array(9) = 49.0;

tmp_struct.delay = tmp_delay_array;

PhaseNumPerformanceMap('fix') = tmp_struct;

% 4フェーズについて
tmp_struct = [];

tmp_queue_array = zeros(1, 9);
tmp_queue_array(1) = 28.9;
tmp_queue_array(2) = 27.4;
tmp_queue_array(3) = 42.0;
tmp_queue_array(4) = 24.8;
tmp_queue_array(5) = 26.6;
tmp_queue_array(6) = 20.5;
tmp_queue_array(7) = 31.0;
tmp_queue_array(8) = 28.8;
tmp_queue_array(9) = 65.2;

tmp_struct.queue = tmp_queue_array;

tmp_delay_array = zeros(1, 9);
tmp_delay_array(1) = 20.8;
tmp_delay_array(2) = 18.9;
tmp_delay_array(3) = 24.5;
tmp_delay_array(4) = 17.9;
tmp_delay_array(5) = 19.3;
tmp_delay_array(6) = 16.4;
tmp_delay_array(7) = 20.8;
tmp_delay_array(8) = 18.3;
tmp_delay_array(9) = 28.0;

tmp_struct.delay = tmp_delay_array;

PhaseNumPerformanceMap('4') = tmp_struct;

% 8フェーズについて
tmp_struct = [];

tmp_queue_array = zeros(1, 9);
tmp_queue_array(1) = 25.4;
tmp_queue_array(2) = 28.1;
tmp_queue_array(3) = 50.9;
tmp_queue_array(4) = 19.9;
tmp_queue_array(5) = 35.6;
tmp_queue_array(6) = 14.2;
tmp_queue_array(7) = 36.3;
tmp_queue_array(8) = 20.2;
tmp_queue_array(9) = 34.9;

tmp_struct.queue = tmp_queue_array;

tmp_delay_array = zeros(1, 9);
tmp_delay_array(1) = 16.4;
tmp_delay_array(2) = 18.3;
tmp_delay_array(3) = 30.1;
tmp_delay_array(4) = 14.9;
tmp_delay_array(5) = 23.4;
tmp_delay_array(6) = 11.3;
tmp_delay_array(7) = 21.5;
tmp_delay_array(8) = 14.8;
tmp_delay_array(9) = 24.0;

tmp_struct.delay = tmp_delay_array;

PhaseNumPerformanceMap('8') = tmp_struct;

% 17フェーズについて
tmp_struct = [];

tmp_queue_array = zeros(1, 9);
tmp_queue_array(1) = 22.3;
tmp_queue_array(2) = 22.2;
tmp_queue_array(3) = 51.0;
tmp_queue_array(4) = 26.0;
tmp_queue_array(5) = 26.0;
tmp_queue_array(6) = 14.8;
tmp_queue_array(7) = 28.0;
tmp_queue_array(8) = 31.3;
tmp_queue_array(9) = 23.4;

tmp_struct.queue = tmp_queue_array;

tmp_delay_array = zeros(1, 9);
tmp_delay_array(1) = 15.9;
tmp_delay_array(2) = 15.4;
tmp_delay_array(3) = 29.0;
tmp_delay_array(4) = 18.6;
tmp_delay_array(5) = 18.6;
tmp_delay_array(6) = 11.1;
tmp_delay_array(7) = 18.5;
tmp_delay_array(8) = 20.1;
tmp_delay_array(9) = 18.5;

tmp_struct.delay = tmp_delay_array;

PhaseNumPerformanceMap('17') = tmp_struct;

% QueueLengthのレーダーチャートを作成
f = figure(1);

% 角度とラベルを生成
theta = linspace(0, 2*pi, 10);
label = {'same', 'left: high', 'straight: high', 'right: high', 'left: low', 'straight: low', 'right: low', 'main-sub', 'irregular'};
legend_label = {'4-phase', '8-phase', '17-phase'};

% 4フェーズについて
tmp_queue_array = PhaseNumPerformanceMap('4').queue;
tmp_queue_array(end + 1) = tmp_queue_array(1);
polarplot(theta, tmp_queue_array, 'LineWidth', 2);

ax = gca;
ax.ThetaTickLabel = label;
ax.ThetaTick = linspace(0, 360, 10);
ax.FontSize = 15;
title('Queue Length [m]');

hold on;

% 8, 17フェーズについて
tmp_queue_array = PhaseNumPerformanceMap('8').queue;
tmp_queue_array(end + 1) = tmp_queue_array(1);
polarplot(theta, tmp_queue_array, 'LineWidth', 2);

tmp_queue_array = PhaseNumPerformanceMap('17').queue;
tmp_queue_array(end + 1) = tmp_queue_array(1);
polarplot(theta, tmp_queue_array, 'LineWidth', 2);

legend(legend_label);


% QueueLengthのレーダーチャートを作成
f = figure(2);

% 4フェーズについて
tmp_delay_array = PhaseNumPerformanceMap('4').delay;
tmp_delay_array(end + 1) = tmp_delay_array(1);
polarplot(theta, tmp_delay_array, 'LineWidth', 2);

ax = gca;
ax.ThetaTickLabel = label;
ax.ThetaTick = linspace(0, 360, 10);
ax.FontSize = 15;
title('Delay Time [s]');

hold on;

% 8, 17フェーズについて
tmp_delay_array = PhaseNumPerformanceMap('8').delay;
tmp_delay_array(end + 1) = tmp_delay_array(1);
polarplot(theta, tmp_delay_array, 'LineWidth', 2);

tmp_delay_array = PhaseNumPerformanceMap('17').delay;
tmp_delay_array(end + 1) = tmp_delay_array(1);
polarplot(theta, tmp_delay_array, 'LineWidth', 2);

legend(legend_label);




