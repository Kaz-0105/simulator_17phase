clear;
close all;

% csvからデータを読み込む
file_name = 'results/1-1_network/database_horizon.csv';
data_table = readtable(file_name);

% 取り出すデータの設定
record_condition = data_table.N_p == 4;
column_condition = {'num_phases', 'N_s', 'queue', 'delay', 'calc_time'};

% データの取り出し
tmp_data_table = data_table(record_condition, column_condition);

% テーブルをソート
tmp_data_table = sortrows(tmp_data_table, {'num_phases', 'N_s'}, {'ascend', 'ascend'});

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

N_s_list = [];

for N_s = tmp_data_table.N_s'
    if ~ismember(N_s, N_s_list)
        N_s_list = [N_s_list, N_s];
    end
end

% データのプロット
figure;

bar(N_s_list, [queue_4, queue_8, queue_17]);
xlabel('Minimum Cosecutive Green Steps');
ylabel('Queue');
title('Queue - Minimum Cosecutive Green Steps');
legend({'4-phase', '8-phase', '17-phase'});

figure;

bar(N_s_list, [delay_4, delay_8, delay_17]);
xlabel('Minimum Cosecutive Green Steps');
ylabel('Delay Time');
title('Delay Time - Minimum Cosecutive Green Steps');
legend({'4-phase', '8-phase', '17-phase'});
figure;

bar(N_s_list, [calc_time_4, calc_time_8, calc_time_17]);
xlabel('Minimum Cosecutive Green Steps');
ylabel('Calculation Time');
title('Calculation Time - Minimum Cosecutive Green Steps');
legend({'4-phase', '8-phase', '17-phase'});