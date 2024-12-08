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
    {'Balanced Traffic Condition', 'Unbalanced Traffic Condition', 'Main-Sub Traffic Condition'} ...
);

TITLE_FONT_SIZE = 20;
LABEL_FONT_SIZE = 20;
AXIS_FONT_SIZE = 20;
LEGEND_FONT_SIZE = 20;

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
        'num_phases', 'relflow1', 'relflow2', 'relflow3', 'relflow4', 'queue', 'delay', 'calc_time'
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
        'delay', scoot_results.delay_time(scoot_results.inflows_id == inflows_id)...
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

    % 計算時間の結果のプロット
    figure;
    bar([PhaseDataMap(4).calc_time, PhaseDataMap(8).calc_time, PhaseDataMap(17).calc_time]);
    xticklabels(relflow_labels(PhaseDataMap(4).relflows_id));
    xlabel('Route Selection Type', 'FontSize', LABEL_FONT_SIZE);
    ylabel('Average Calculation Time [s]', 'FontSize', LABEL_FONT_SIZE);
    title(FileTitleMap(file_name), 'FontSize', TITLE_FONT_SIZE);
    legend({'4-Phase MPC', '8-Phase MPC', '17-Phase MPC'}, 'FontSize', LEGEND_FONT_SIZE);
    set(gca, 'FontSize', AXIS_FONT_SIZE);

    % 時系列データを作成
    PhaseTimeSeriesMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
    for num_phases = unique(results.num_phases)'
        load(pwd + "/results/1-1_network/time_series/time_series" + num_str(num_phases));
        time_series = struct(...
            'queue', IntersectionRoadQueueMap.average('all'),...
            'delay', IntersectionRoadDelayMap.average('all'),...
            'time', time...
        );
        PhaseTimeSeriesMap(num_phases) = time_series;
    end

end