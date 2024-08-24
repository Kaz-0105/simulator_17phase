% 評価のレーダーチャートを作る関数
close all;
clear;

% csvからデータを読み込む
data_table = readtable('results/1-1_network/database500.csv');

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

        % relflowsを定義
        relflows = [record.relflow1, record.relflow2, record.relflow3, record.relflow4];

        if isequal(inputs, 700*ones(1, 4))
            % レコードを作成
            if isequal(relflows, ones(1, 4))
                new_record = {'same', 'same', record.queue, record.delay};
            elseif isequal(relflows, 2*ones(1, 4))
                new_record = {'same', 'left: high', record.queue, record.delay};
            elseif isequal(relflows, 3*ones(1, 4))
                new_record = {'same', 'straight: high', record.queue, record.delay};
            elseif isequal(relflows, 4*ones(1, 4))
                new_record = {'same', 'right: high', record.queue, record.delay};
            elseif isequal(relflows, 5*ones(1, 4))
                new_record = {'same', 'left: low', record.queue, record.delay};
            elseif isequal(relflows, 6*ones(1, 4))
                new_record = {'same', 'straight: low', record.queue, record.delay};
            elseif isequal(relflows, 7*ones(1, 4))
                new_record = {'same', 'right: low', record.queue, record.delay};
            elseif isequal(relflows, 8*ones(1, 4))
                new_record = {'same', 'left only', record.queue, record.delay};
            else
                continue;
            end

        elseif isequal(inputs, [900, 500, 900, 500])
            % レコードを作成
            if isequal(relflows, ones(1, 4))
                new_record = {'main-sub', 'same', record.queue, record.delay};
            elseif isequal(relflows, 2*ones(1, 4))
                new_record = {'main-sub', 'left: high', record.queue, record.delay};
            elseif isequal(relflows, 3*ones(1, 4))
                new_record = {'main-sub', 'straight: high', record.queue, record.delay};
            elseif isequal(relflows, 4*ones(1, 4))
                new_record = {'main-sub', 'right: high', record.queue, record.delay};
            elseif isequal(relflows, 5*ones(1, 4))
                new_record = {'main-sub', 'left: low', record.queue, record.delay};
            elseif isequal(relflows, 6*ones(1, 4))
                new_record = {'main-sub', 'straight: low', record.queue, record.delay};
            elseif isequal(relflows, 7*ones(1, 4))
                new_record = {'main-sub', 'right: low', record.queue, record.delay};
            elseif isequal(relflows, 8*ones(1, 4))
                new_record = {'main-sub', 'left only', record.queue, record.delay};
            else
                continue;
            end
        elseif isequal(inputs, [900, 900, 500, 500])
            % レコードを作成
            if isequal(relflows, ones(1, 4))
                new_record = {'irregular', 'same', record.queue, record.delay};
            elseif isequal(relflows, 2*ones(1, 4))
                new_record = {'irregular', 'left: high', record.queue, record.delay};
            elseif isequal(relflows, 3*ones(1, 4))
                new_record = {'irregular', 'straight: high', record.queue, record.delay};
            elseif isequal(relflows, 4*ones(1, 4))
                new_record = {'irregular', 'right: high', record.queue, record.delay};
            elseif isequal(relflows, 5*ones(1, 4))
                new_record = {'irregular', 'left: low', record.queue, record.delay};
            elseif isequal(relflows, 6*ones(1, 4))
                new_record = {'irregular', 'straight: low', record.queue, record.delay};
            elseif isequal(relflows, 7*ones(1, 4))
                new_record = {'irregular', 'right: low', record.queue, record.delay};
            elseif isequal(relflows, 8*ones(1, 4))
                new_record = {'irregular', 'left only', record.queue, record.delay};
            else
                continue;
            end
        else
            continue;
        end

        % レコードを追加
        tmp_performance_table(end + 1, :) = new_record;
    end
    % レコードのカラム名を設定
    tmp_performance_table.Properties.VariableNames = {'inflow_type', 'route_type', 'queue', 'delay'};

    NumPhasesPerformanceMap(num2str(num_phases)) = tmp_performance_table;
end
% 流入量と旋回率のタイプを取得
route_types = unique(NumPhasesPerformanceMap('4').route_type)';
inflow_types = unique(NumPhasesPerformanceMap('4').inflow_type)';

for inflow_type = inflow_types
    % セル配列から取り出し
    inflow_type = inflow_type{1};

    % QueueLengthのレーダーチャートを作成
    figure();

    % 角度とラベルを生成
    theta = linspace(0, 2*pi, length(route_types) + 1);
    legend_labels = {};

    % 制御方式ごとに処理
    for control_method = ["4", "8", "17"]
        control_method = char(control_method);

        tmp_performance_table = NumPhasesPerformanceMap(control_method);
        condition = strcmp(tmp_performance_table.inflow_type, inflow_type);
        tmp_performance_table = tmp_performance_table(condition, :);

        queue_array = zeros(1, length(route_types));

        for route_type = route_types
            % セル配列から取り出し
            route_type = route_type{1};

            condition = strcmp(tmp_performance_table.route_type, route_type);

            record = tmp_performance_table(condition, :);

            if ~isempty(record)
                condition = strcmp(route_types, route_type);
                queue_array(find(condition)) = record.queue;
            end
        end

        queue_array(end + 1) = queue_array(1);
        legend_labels{end + 1} = control_method;

        polarplot(theta, queue_array, 'LineWidth', 2);
        hold on;
    end

    ax = gca;
    ax.ThetaTickLabel = route_types;
    ax.ThetaTick = linspace(0, 360, length(route_types) + 1);
    ax.FontSize = 20;
    title('Queue Length [m]');
    legend(legend_labels, 'FontSize', 15);

    hold off;

    % Delay Timeのレーダーチャートを作成
    figure();

    % 制御方式ごとに処理
    for control_method = ["4", "8", "17"]
        control_method = char(control_method);

        tmp_performance_table = NumPhasesPerformanceMap(control_method);
        condition = strcmp(tmp_performance_table.inflow_type, inflow_type);
        tmp_performance_table = tmp_performance_table(condition, :);

        delay_array = zeros(1, length(route_types));

        for route_type = route_types
            route_type = route_type{1};

            condition = strcmp(tmp_performance_table.route_type, route_type);
            
            record = tmp_performance_table(condition, :);

            if ~isempty(record)
                condition = strcmp(route_types, route_type);
                delay_array(find(condition)) = record.delay;
            end
        end

        delay_array(end + 1) = delay_array(1);

        polarplot(theta, delay_array, 'LineWidth', 2);
        hold on;
    end

    ax = gca;
    ax.ThetaTickLabel = route_types;
    ax.ThetaTick = linspace(0, 360, length(route_types) + 1);
    ax.FontSize = 20;
    title('Delay Time [s]');
    fprintf('Inflow Type: %s\n', inflow_type);
    legend(legend_labels, 'FontSize', 15);

    hold off;
end





