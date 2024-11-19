clear;
close all;

EXPERIMENT_CONDITION_NUM = 7;

TITLE_FONT_SIZE = 20;
LABEL_FONT_SIZE = 20;
AXIS_FONT_SIZE = 20;
LEGEND_FONT_SIZE = 20;

% csvからデータを読み込む
file_name = 'results/1-1_network/database_unbalanced.csv';
data_table = readtable(file_name);

% 必要なデータの取得
column_condition = {'num_phases',  'relflow1', 'relflow2', 'relflow3', 'relflow4', 'queue', 'delay', 'calc_time'};
tmp_data_table = data_table(:, column_condition);

% テーブルをソート
tmp_data_table = sortrows(tmp_data_table, {'relflow1', 'num_phases'}, {'ascend', 'ascend'});

% データの定義
queue_4 = tmp_data_table.queue(tmp_data_table.num_phases == 4);
delay_4 = tmp_data_table.delay(tmp_data_table.num_phases == 4);
calc_time_4 = tmp_data_table.calc_time(tmp_data_table.num_phases == 4);

queue_8 = tmp_data_table.queue(tmp_data_table.num_phases == 8);
delay_8 = tmp_data_table.delay(tmp_data_table.num_phases == 8);
calc_time_8 = tmp_data_table.calc_time(tmp_data_table.num_phases == 8);

queue_17 = tmp_data_table.queue(tmp_data_table.num_phases == 17);
delay_17 = tmp_data_table.delay(tmp_data_table.num_phases == 17);
calc_time_17 = tmp_data_table.calc_time(tmp_data_table.num_phases == 17);

queue_scoot = [39.6, 20.7, 32.3, 35.2, 33.6, 49.6, 34.8]';
delay_scoot = [32.2, 22.9, 30.7, 36.9, 30.4, 40.1, 34.6]';

% データのバリデーション
if length(queue_4) ~= EXPERIMENT_CONDITION_NUM
    error('Number of 4-phase experiments is lower than expected.');
elseif length(queue_8) ~= EXPERIMENT_CONDITION_NUM
    error('Number of 8-phase experiments is lower than expected.');
elseif length(queue_17) ~= EXPERIMENT_CONDITION_NUM
    error('Number of 17-phase experiments is lower than expected.');
end

% 棒グラフのラベルの作成
relflow1_list = [];

for relflow1 = tmp_data_table.relflow1'
    if ~ismember(relflow1, relflow1_list)
        relflow1_list = [relflow1_list, relflow1];
    end
end

relflow1_labels = {};

for relflow1 = relflow1_list
    if relflow1 == 1
        relflow1_labels = [relflow1_labels, 'All-same'];
    elseif relflow1 == 2
        relflow1_labels = [relflow1_labels, 'Left-high'];
    elseif relflow1 == 3
        relflow1_labels = [relflow1_labels, 'Straight-high'];
    elseif relflow1 == 4
        relflow1_labels = [relflow1_labels, 'Right-high'];
    elseif relflow1 == 5
        relflow1_labels = [relflow1_labels, 'Left-low'];
    elseif relflow1 == 6
        relflow1_labels = [relflow1_labels, 'Straight-low'];
    elseif relflow1 == 7
        relflow1_labels = [relflow1_labels, 'Right-low'];
    else
        error('relflow1 is invalid');
    end
end

% データのプロット
figure;

bar([queue_scoot, queue_4, queue_8, queue_17]);
xticklabels(relflow1_labels);
xlabel('Route selection type', 'FontSize', LABEL_FONT_SIZE);
ylabel('Queue', 'FontSize', LABEL_FONT_SIZE);
title('Queue - Route selection type', 'FontSize', TITLE_FONT_SIZE);
legend({'scoot', '4-phase', '8-phase', '17-phase'}, 'FontSize', LEGEND_FONT_SIZE);
set(gca, 'FontSize', AXIS_FONT_SIZE);

figure;

bar([delay_scoot, delay_4, delay_8, delay_17]);
xticklabels(relflow1_labels);
xlabel('Route selection type', 'FontSize', LABEL_FONT_SIZE);
ylabel('Delay Time', 'FontSize', LABEL_FONT_SIZE);
title('Delay Time - Route selection type', 'FontSize', TITLE_FONT_SIZE);
legend({'scoot', '4-phase', '8-phase', '17-phase'}, 'FontSize', LEGEND_FONT_SIZE);
set(gca, 'FontSize', AXIS_FONT_SIZE);

figure;

bar([calc_time_4, calc_time_8, calc_time_17]);
xticklabels(relflow1_labels);
xlabel('Route selection type', 'FontSize', LABEL_FONT_SIZE);
ylabel('Calculation Time', 'FontSize', LABEL_FONT_SIZE);
title('Calculation Time - Route selection type', 'FontSize', TITLE_FONT_SIZE);
legend({'4-phase', '8-phase', '17-phase'}, 'FontSize', LEGEND_FONT_SIZE);
set(gca, 'FontSize', AXIS_FONT_SIZE);







