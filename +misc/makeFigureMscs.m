clear;
close all;

NUM_EXPERIMENT_CONDITIONS = 7;

relflow_labels = [...
    "Uniform", ...
    "Left Heavy", ...
    "Straight Heavy", ...
    "Right Heavy", ...
    "Left Light", ...
    "Straight Light", ...
    "Right Light" ...
];

file_names = [
    "balanced", ...
    "unbalanced",... 
    "main_sub" ...
];

FileTitleMap = containers.Map( ...
    {'balanced', 'unbalanced', 'main_sub'}, ...
    {'Balanced', 'Unbalanced', 'Main-Sub'} ...
);

TITLE_FONT_SIZE = 30;
LABEL_FONT_SIZE = 30;
AXIS_FONT_SIZE = 25;
LEGEND_FONT_SIZE = 25;
LINEWIDTH = 5;

% scootのデータを読み込む
scoot_results = readtable("results/1-1_network/scoot.csv");
scoot_results = sortrows( ...
    scoot_results, ...
    {'inflows_id', 'rel_flows_id'}, ...
    {'ascend', 'ascend'} ...
);

for file_name = file_names
    % csvから実験データを読み込む
    results = readtable("results/1-1_network/" + file_name + ".csv");
    fields = {
        'num_phases', 'relflow1', 'relflow2', 'relflow3', 'relflow4', 'queue', 'delay', 'speed', 'calc_time'
    };
    results = results(:, fields);
    results = sortrows( ...
        results, ...
        {'relflow1', 'relflow2', 'relflow3', 'relflow4', 'num_phases'}, ... 
        {'ascend', 'ascend', 'ascend', 'ascend', 'ascend'} ...
    );

    PhaseDataMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
    for num_phases = unique(results.num_phases)'
        PhaseDataMap(num_phases) = struct(...
            'relflows_id', results.relflow1(results.num_phases == num_phases), ...
            'queue', results.queue(results.num_phases == num_phases), ...
            'delay', results.delay(results.num_phases == num_phases), ...
            'speed', results.speed(results.num_phases == num_phases), ...
            'calc_time', results.calc_time(results.num_phases == num_phases) ...
        );

        if sum(results.num_phases == num_phases) ~= NUM_EXPERIMENT_CONDITIONS
            error('Number of %d-phase experiments in the %s situation is lower or higher than expected.', num_phases, file_name);
        end
    end

    if strcmp(file_name, 'balanced')
        inflows_id = 1;
    elseif strcmp(file_name, 'unbalanced')
        inflows_id = 2;
    elseif strcmp(file_name, 'main_sub')
        inflows_id = 3;
    end
    scoot_data = struct(...
        'relflows_id', scoot_results.rel_flows_id(scoot_results.inflows_id == inflows_id), ...
        'queue', scoot_results.queue_length(scoot_results.inflows_id == inflows_id), ...
        'delay', scoot_results.delay_time(scoot_results.inflows_id == inflows_id), ...
        'speed', scoot_results.speed(scoot_results.inflows_id == inflows_id)...
    );

    % 信号待ちの車列の結果のプロット
    figure;
    bar([scoot_data.queue, PhaseDataMap(4).queue, PhaseDataMap(8).queue, PhaseDataMap(17).queue]);
    xticklabels(relflow_labels(PhaseDataMap(4).relflows_id));
    xlabel('Route Selection Type', 'FontSize', LABEL_FONT_SIZE);
    ylabel('Average Queue Length [m]', 'FontSize', LABEL_FONT_SIZE);
    title(FileTitleMap(file_name), 'FontSize', TITLE_FONT_SIZE);
    legend({'SCOOT', '4-Phase MPC', '8-Phase MPC', '17-Phase MPC'}, 'FontSize', LEGEND_FONT_SIZE);
    set(gca, 'FontSize', AXIS_FONT_SIZE);

    % 遅れ時間の結果のプロット
    figure;
    bar([scoot_data.delay, PhaseDataMap(4).delay, PhaseDataMap(8).delay, PhaseDataMap(17).delay]);
    xticklabels(relflow_labels(PhaseDataMap(4).relflows_id));
    xlabel('Route Selection Type', 'FontSize', LABEL_FONT_SIZE);
    ylabel('Average Delay Time [s]', 'FontSize', LABEL_FONT_SIZE);
    title(FileTitleMap(file_name), 'FontSize', TITLE_FONT_SIZE);
    legend({'SCOOT', '4-Phase MPC', '8-Phase MPC', '17-Phase MPC'}, 'FontSize', LEGEND_FONT_SIZE);
    set(gca, 'FontSize', AXIS_FONT_SIZE);

    % 速度の結果のプロット
    figure;
    bar([scoot_data.speed, PhaseDataMap(4).speed, PhaseDataMap(8).speed, PhaseDataMap(17).speed]);
    xticklabels(relflow_labels(PhaseDataMap(4).relflows_id));
    xlabel('Route Selection Type', 'FontSize', LABEL_FONT_SIZE);
    ylabel('Average Speed [m/s]', 'FontSize', LABEL_FONT_SIZE);
    title(FileTitleMap(file_name), 'FontSize', TITLE_FONT_SIZE);
    legend({'SCOOT', '4-Phase MPC', '8-Phase MPC', '17-Phase MPC'}, 'FontSize', LEGEND_FONT_SIZE, 'Location', 'southeast');
    set(gca, 'FontSize', AXIS_FONT_SIZE);

    % 計算時間の結果のプロット
    figure;
    bar([PhaseDataMap(4).calc_time, PhaseDataMap(8).calc_time, PhaseDataMap(17).calc_time]);
    xticklabels(relflow_labels(PhaseDataMap(4).relflows_id));
    xlabel('Route Selection Type', 'FontSize', LABEL_FONT_SIZE);
    ylabel('Average Calculation Time [s]', 'FontSize', LABEL_FONT_SIZE);
    title(FileTitleMap(file_name), 'FontSize', TITLE_FONT_SIZE);
    legend({'4-Phase MPC', '8-Phase MPC', '17-Phase MPC'}, 'FontSize', LEGEND_FONT_SIZE);
    set(gca, 'FontSize', AXIS_FONT_SIZE);

    % 平均のキューの長さ，遅れ時間，計算時間を表示
    fprintf('Route Selection Type: %s\n', FileTitleMap(file_name));
    fprintf('SCOOT\n');
    fprintf('Average Queue Length: %.2f\n', mean(scoot_data.queue));
    fprintf('Average Delay Time: %.2f\n', mean(scoot_data.delay));

    fprintf('4-Phase MPC\n');
    fprintf('Average Queue Length: %.2f\n', mean(PhaseDataMap(4).queue));
    fprintf('Average Delay Time: %.2f\n', mean(PhaseDataMap(4).delay));
    fprintf('Average Calculation Time: %.2f\n', mean(PhaseDataMap(4).calc_time));

    fprintf('8-Phase MPC\n');
    fprintf('Average Queue Length: %.2f\n', mean(PhaseDataMap(8).queue));
    fprintf('Average Delay Time: %.2f\n', mean(PhaseDataMap(8).delay));
    fprintf('Average Calculation Time: %.2f\n', mean(PhaseDataMap(8).calc_time));
    
    fprintf('17-Phase MPC\n');
    fprintf('Average Queue Length: %.2f\n', mean(PhaseDataMap(17).queue));
    fprintf('Average Delay Time: %.2f\n', mean(PhaseDataMap(17).delay));
    fprintf('Average Calculation Time: %.2f\n', mean(PhaseDataMap(17).calc_time));

    fprintf('Improvement Rate: %.2f\n', (mean(scoot_data.queue) - mean(PhaseDataMap(17).queue)) / mean(scoot_data.queue) * 100);
end

% 時系列データを作成
PhaseTimeSeriesMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
for num_phases = unique(results.num_phases)'
    load(pwd + "/results/1-1_network/time_series/time_series" + num2str(num_phases));
    time_series = struct(...
        'queue', IntersectionRoadQueueMap.average('all'),...
        'delay', IntersectionRoadDelayMap.average('all'),...
        'time', time...
    );
    PhaseTimeSeriesMap(num_phases) = time_series;
end

time_series_scoot = readtable("results/1-1_network/time_series/time_series_scoot.csv");

% 時系列データをプロット
figure;
hold on;
plot(time_series_scoot.time, time_series_scoot.queue_length, 'LineWidth', LINEWIDTH);
for num_phases = unique(results.num_phases)'
    time_series = PhaseTimeSeriesMap(num_phases);
    plot(time_series.time, time_series.queue, 'LineWidth', LINEWIDTH);
end
xlabel('Time [s]', 'FontSize', LABEL_FONT_SIZE);
ylabel('Average Queue Length [m]', 'FontSize', LABEL_FONT_SIZE);
title('Time Series of Queue Length', 'FontSize', TITLE_FONT_SIZE);
legend({'SCOOT', '4-Phase MPC', '8-Phase MPC', '17-Phase MPC'}, 'FontSize', LEGEND_FONT_SIZE);
set(gca, 'FontSize', AXIS_FONT_SIZE);
xlim([0, 500]);
hold off;

figure;
hold on;
plot(time_series_scoot.time, time_series_scoot.delay_time, 'LineWidth', LINEWIDTH);
for num_phases = unique(results.num_phases)'
    time_series = PhaseTimeSeriesMap(num_phases);
    plot(time_series.time, time_series.delay, 'LineWidth', LINEWIDTH);
end
xlabel('Time [s]', 'FontSize', LABEL_FONT_SIZE);
ylabel('Average Delay Time [s]', 'FontSize', LABEL_FONT_SIZE);
title('Time Series of Delay Time', 'FontSize', TITLE_FONT_SIZE);
legend({'SCOOT', '4-Phase MPC', '8-Phase MPC', '17-Phase MPC'}, 'FontSize', LEGEND_FONT_SIZE);
set(gca, 'FontSize', AXIS_FONT_SIZE);
xlim([0, 500]);
hold off;