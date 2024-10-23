clear;
close all;

% csvからデータを読み込む
file_name = 'results/1-1_network/database_horizon.csv';
data_table = readtable(file_name);

% 取り出すデータの設定
record_condition = data_table.N_s == 5;
column_condition = {'num_phases', 'N_p', 'queue','calc_time'};

% データの取り出し
tmp_data_table = data_table(record_condition, column_condition);

% テーブルをソート
tmp_data_table = sortrows(tmp_data_table, {'num_phases', 'N_p'}, {'ascend', 'ascend'});

% データの定義
queue_4 = tmp_data_table.queue(tmp_data_table.num_phases == 4);
calc_time_4 = tmp_data_table.calc_time(tmp_data_table.num_phases == 4);

queue_8 = tmp_data_table.queue(tmp_data_table.num_phases == 8);
calc_time_8 = tmp_data_table.calc_time(tmp_data_table.num_phases == 8);

queue_17 = tmp_data_table.queue(tmp_data_table.num_phases == 17);
calc_time_17 = tmp_data_table.calc_time(tmp_data_table.num_phases == 17);

N_p_list = [];

for N_p = tmp_data_table.N_p'
    if ~ismember(N_p, N_p_list)
        N_p_list = [N_p_list, N_p];
    end
end

% データのプロット
figure;

bar(N_p_list, [queue_4, queue_8, queue_17]);
xlabel('Horizon');
ylabel('Queue');
title('Queue - Horizon');
legend({'4-phase', '8-phase', '17-phase'}, 'Location', 'northwest');

figure;

bar(N_p_list, [calc_time_4, calc_time_8, calc_time_17]);
xlabel('Horizon');
ylabel('Calculation Time');
title('Calculation Time - Horizon');
legend({'4-phase', '8-phase', '17-phase'}, 'Location', 'northwest');

