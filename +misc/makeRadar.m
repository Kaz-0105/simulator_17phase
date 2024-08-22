% 評価のレーダーチャートを作る関数
close all;
clear;

% csvからデータを読み込む
data_table = readtable('results/1-1_network/database.csv');

% NumPhasesTableMapの初期化
NumPhasesTableMap = containers.Map('KeyType', 'char', 'ValueType', 'any');

% 4, 8, 17フェーズのデータを取り出す
for num_phases = [4, 8, 17]
    NumPhasesTableMap(num2str(num_phases)) = data_table(data_table.num_phases == num_phases, :);
end

% NumPhasesPerformanceMapの初期化
NumPhasesPerformanceMap = containers.Map('KeyType', 'char', 'ValueType', 'any');

% 固定式について
% レコードを作成
queues = [50.1, 55.7, 65.0, 46.0, 76.7, 54.6, 60.7, 51.6, 107.4];
delays = [33.5, 33.0, 38.1, 33.2, 47.2, 34.6, 34.4, 34.9, 49.0];
types = {'same', 'left: high', 'straight: high', 'right: high', 'left: low', 'straight: low', 'right: low', 'main-sub', 'irregular'};

NumPhasesPerformanceMap('fix') = table(types', queues', delays', 'VariableNames', {'type', 'queue', 'delay'});


% 4、8、17フェーズについて
for num_phases = [4, 8, 17]
    % テーブルを作成
    tmp_performance_table = table();

    % データのテーブルを取得
    tmp_data_table = NumPhasesTableMap(num2str(num_phases));

    % レコードの数を取得
    num_records = height(tmp_data_table);

    % データを繰り返し処理で追加
    for record_id = 1:num_records
        % レコードを取得
        record = tmp_data_table(record_id, :);

        % inputsを定義
        inputs = [record.input1, record.input2, record.input3, record.input4];

        % input_flagを定義
        input_flag = isequal(inputs, inputs(1)*ones(1, 4));

        % relflowsを定義
        relflows = [record.relflow1, record.relflow2, record.relflow3, record.relflow4];

        % relflow_flagを定義
        relflow_flag = isequal(relflows, relflows(1)*ones(1, 4));

        if input_flag
            % レコードを作成
            if isequal(relflows, ones(1, 4))
                new_record = {'same', record.queue, record.delay};
            elseif isequal(relflows, 2*ones(1, 4))
                new_record = {'left: high', record.queue, record.delay};
            elseif isequal(relflows, 3*ones(1, 4))
                new_record = {'straight: high', record.queue, record.delay};
            elseif isequal(relflows, 4*ones(1, 4))
                new_record = {'right: high', record.queue, record.delay};
            elseif isequal(relflows, 5*ones(1, 4))
                new_record = {'left: low', record.queue, record.delay};
            elseif isequal(relflows, 6*ones(1, 4))
                new_record = {'straight: low', record.queue, record.delay};
            elseif isequal(relflows, 7*ones(1, 4))
                new_record = {'right: low', record.queue, record.delay};
            else
                continue;
            end

            % レコードを追加
            tmp_performance_table(end + 1, :) = new_record;
        elseif relflow_flag
            % レコードを作成
            if isequal(inputs, [900, 500, 900, 500])
                new_record = {'main-sub', record.queue, record.delay};
            elseif isequal(inputs, [900, 900, 500, 500])
                new_record = {'irregular', record.queue, record.delay};
            else
                continue;
            end

            % レコードを追加
            tmp_performance_table(end + 1, :) = new_record;
        end
    end
    % レコードのカラム名を設定
    tmp_performance_table.Properties.VariableNames = {'type', 'queue', 'delay'};

    NumPhasesPerformanceMap(num2str(num_phases)) = tmp_performance_table;
end

% QueueLengthのレーダーチャートを作成
f = figure(1);

% 角度とラベルを生成
labels = (NumPhasesPerformanceMap('fix').type)';
theta = linspace(0, 2*pi, length(labels) + 1);
legend_labels = {};

% 制御方式ごとに処理
for control_method = ["fix", "4", "8", "17"]
    control_method = char(control_method);

    tmp_performance_table = NumPhasesPerformanceMap(control_method);

    queue_array = zeros(1, length(labels));

    for label = labels
        label = label{1};

        record = tmp_performance_table(strcmp(tmp_performance_table.type, label), :);

        if ~isempty(record)
            queue_array(find(strcmp(labels, label))) = record.queue;
        end
    end

    queue_array(end + 1) = queue_array(1);
    legend_labels{end + 1} = control_method;

    polarplot(theta, queue_array, 'LineWidth', 2);
    hold on;
end

ax = gca;
ax.ThetaTickLabel = labels;
ax.ThetaTick = linspace(0, 360, length(labels) + 1);
ax.FontSize = 15;
title('Queue Length [m]');
legend(legend_labels, 'FontSize', 15);

hold off;

% Delay Timeのレーダーチャートを作成
f = figure(2);

% 制御方式ごとに処理
for control_method = ["fix", "4", "8", "17"]
    control_method = char(control_method);

    tmp_performance_table = NumPhasesPerformanceMap(control_method);

    delay_array = zeros(1, length(labels));

    for label = labels
        label = label{1};

        record = tmp_performance_table(strcmp(tmp_performance_table.type, label), :);

        if ~isempty(record)
            delay_array(find(strcmp(labels, label))) = record.delay;
        end
    end

    delay_array(end + 1) = delay_array(1);

    polarplot(theta, delay_array, 'LineWidth', 2);
    hold on;
end

ax = gca;
ax.ThetaTickLabel = labels;
ax.ThetaTick = linspace(0, 360, length(labels) + 1);
ax.FontSize = 15;
title('Delay Time [s]');
legend(legend_labels, 'FontSize', 15);

hold off;





