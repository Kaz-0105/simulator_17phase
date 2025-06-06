clear;
close all;

%% configuration (you need to change flags according to your needs)

% the types of figure to be shown
figures_map = containers.Map('KeyType', 'char', 'ValueType', 'int32');
figures_map('total_queue_comparison') = false;
figures_map('total_delay_comparison') = false;
figures_map('total_speed_comparison') = false;
figures_map('total_calc_time_comparison') = false;
figures_map('time_series_queue') = true;
figures_map('time_series_delay') = false;
figures_map('time_series_speed') = false;

% the types of controller to be compared
controllers_map = containers.Map('KeyType', 'char', 'ValueType', 'int32');
controllers_map('scoot') = true;
controllers_map('4-phase') = true;
controllers_map('8-phase') = true;
controllers_map('17-phase') = true;

% the types of relative flow to be compared
relative_flows_map = containers.Map('KeyType', 'char', 'ValueType', 'int32');
relative_flows_map('uniform') = true;
relative_flows_map('left_heavy') = true;
relative_flows_map('straight_heavy') = true;
relative_flows_map('right_heavy') = true;
relative_flows_map('left_light') = true;
relative_flows_map('straight_light') = true;
relative_flows_map('right_light') = true;

% the types of inflow to be compared
inflows_map = containers.Map('KeyType', 'char', 'ValueType', 'int32');
inflows_map('balanced') = true;
inflows_map('unbalanced') = true;
inflows_map('main-minor') = true;

% the order id of inflow and relative flow to be used for time series data
% you can not change now.
time_series_inflow_list = [1, 2, 3];
time_series_relative_flow_list = [3, 4];

% figure specifications
title_font_size = 30;
label_font_size = 30;
axis_font_size = 25;
legend_font_size = 25;
line_width = 5;

%% constants (you do not need to change these.)
controller_order_name_map = containers.Map('KeyType', 'int32', 'ValueType', 'char');
controller_order_name_map(1) = 'scoot';
controller_order_name_map(2) = '4-phase';
controller_order_name_map(3) = '8-phase';
controller_order_name_map(4) = '17-phase';

controller_name_order_map = containers.Map('KeyType', 'char', 'ValueType', 'int32');
controller_name_order_map('scoot') = 1;
controller_name_order_map('4-phase') = 2;
controller_name_order_map('8-phase') = 3;
controller_name_order_map('17-phase') = 4;

relative_flow_order_name_map = containers.Map('KeyType', 'int32', 'ValueType', 'char');
relative_flow_order_name_map(1) = 'uniform';
relative_flow_order_name_map(2) = 'left_heavy';
relative_flow_order_name_map(3) = 'straight_heavy';
relative_flow_order_name_map(4) = 'right_heavy';
relative_flow_order_name_map(5) = 'left_light';
relative_flow_order_name_map(6) = 'straight_light';
relative_flow_order_name_map(7) = 'right_light';

relative_flow_name_order_map = containers.Map('KeyType', 'char', 'ValueType', 'int32');
relative_flow_name_order_map('uniform') = 1;
relative_flow_name_order_map('left_heavy') = 2;
relative_flow_name_order_map('straight_heavy') = 3;
relative_flow_name_order_map('right_heavy') = 4;
relative_flow_name_order_map('left_light') = 5;
relative_flow_name_order_map('straight_light') = 6;
relative_flow_name_order_map('right_light') = 7;

inflow_order_name_map = containers.Map('KeyType', 'int32', 'ValueType', 'char');
inflow_order_name_map(1) = 'balanced';
inflow_order_name_map(2) = 'unbalanced';
inflow_order_name_map(3) = 'main-minor';

inflow_name_order_map = containers.Map('KeyType', 'char', 'ValueType', 'int32');
inflow_name_order_map('balanced') = 1;
inflow_name_order_map('unbalanced') = 2;
inflow_name_order_map('main-minor') = 3;

%% data loading (you do not need to change these.)
inflow_controller_data_map = containers.Map('KeyType', 'char', 'ValueType', 'any');

scoot_results = readtable('results/1-1_network/scoot.csv');
scoot_results = sortrows(scoot_results, {'inflows_id', 'rel_flows_id'}, {'ascend', 'ascend'});

for inflow_id = 1: inflows_map.Count
    % skip if the inflow is not selected
    if ~inflows_map(inflow_order_name_map(inflow_id))
        continue;
    end

    inflow_name = inflow_order_name_map(inflow_id);
    results = readtable("results/1-1_network/" + inflow_name + ".csv");
    results = sortrows( ...
        results, ...
        {'relflow1', 'relflow2', 'relflow3', 'relflow4', 'num_phases'}, ... 
        {'ascend', 'ascend', 'ascend', 'ascend', 'ascend'} ...
    );

    controller_data_map = containers.Map('KeyType', 'char', 'ValueType', 'any');
    for num_phases = unique(results.num_phases)'
        % skip if the controller flag is false
        if ~controllers_map([num2str(num_phases), '-phase'])
            continue;
        end

        % push mpc data into controller_data_map
        controller_data_map([num2str(num_phases), '-phase']) = struct(...
            'relflows_id', results.relflow1(results.num_phases == num_phases), ...
            'queue', results.queue(results.num_phases == num_phases), ...
            'delay', results.delay(results.num_phases == num_phases), ...
            'speed', results.speed(results.num_phases == num_phases), ...
            'calc_time', results.calc_time(results.num_phases == num_phases) ...
        );

        % validation of the number of relative flow types
        if sum(results.num_phases == num_phases) ~= relative_flows_map.Count
            error('Number of %d-phase experiments in the %s situation is lower or higher than expected.', num_phases, inflow_name);
        end
    end

    controller_data_map('scoot') = struct(...
        'relflows_id', scoot_results.rel_flows_id(scoot_results.inflows_id == inflow_id), ...
        'queue', scoot_results.queue_length(scoot_results.inflows_id == inflow_id), ...
        'delay', scoot_results.delay_time(scoot_results.inflows_id == inflow_id), ...
        'speed', scoot_results.speed(scoot_results.inflows_id == inflow_id)...
    );

    % push controller_data_map into inflow_controller_data_map
    inflow_controller_data_map(inflow_name) = controller_data_map;
end

controller_time_series_data_map = containers.Map('KeyType', 'char', 'ValueType', 'any');
for controller_id = 1: controllers_map.Count
    % skip if the controller is not selected
    controller_name = controller_order_name_map(controller_id);
    if ~controllers_map(controller_name)
        continue; 
    end

    time_series_data_map = containers.Map('KeyType', 'char', 'ValueType', 'any');
    
    for inflow_id = time_series_inflow_list
        for relative_flow_id = time_series_relative_flow_list
            file_name = [controller_name, '_', num2str(inflow_id), '_', num2str(relative_flow_id)];
            file_path = fullfile(pwd, 'results', '1-1_network', 'time_series', file_name);
            if isfile([file_path, '.mat'])
                load([file_path, '.mat']);
                time_series_data_map([num2str(inflow_id), '_', num2str(relative_flow_id)]) = struct(...
                    'queue', IntersectionRoadQueueMap.average('all'),...
                    'delay', IntersectionRoadDelayMap.average('all'),...
                    'speed', AverageSpeedsMap(0),...
                    'time', time...
                );
            elseif isfile([file_path, '.csv'])
                data = readtable([file_path, '.csv']);
                time_series_data_map([num2str(inflow_id), '_', num2str(relative_flow_id)]) = struct(...
                    'queue', data.queue_length,...
                    'delay', data.delay_time,...
                    'speed', data.speed,...
                    'time', data.time...
                );
            end
        end
    end
    controller_time_series_data_map(controller_name) = time_series_data_map;
end

%% total queue comparison
if figures_map('total_queue_comparison')
    for inflow_id = 1: inflows_map.Count
        inflow_name = inflow_order_name_map(inflow_id);
        controller_data_map = inflow_controller_data_map(inflow_name);

        % prepare x-axis labels
        x_labels = [];
        row_ids = [];
        for relative_flow_id = 1: relative_flows_map.Count
            relative_flow_name = relative_flow_order_name_map(relative_flow_id);
            if relative_flows_map(relative_flow_name)
                x_labels = [x_labels, string(strrep(relative_flow_name, '_', ' '))];
                row_ids = [row_ids; relative_flow_id];
            end
        end

        % prepare y-axis values and each controller's legend
        y_data = [];
        legends = [];
        for controller_id = 1: controllers_map.Count
            controller_name = controller_order_name_map(controller_id);
            if controllers_map(controller_name)
                data = controller_data_map(controller_name);
                y_data = horzcat(y_data, data.queue);
                legends = horzcat(legends, string(controller_name));
            end
        end
        y_data = y_data(row_ids, :);

        % plot the bar chart
        figure;
        bar(y_data);
        xticklabels(x_labels);
        xlabel('Relative Flow Type', 'FontSize', label_font_size);
        ylabel('Average Queue Length [m]', 'FontSize', label_font_size);
        title(['Total Queue Length Comparison - Type: ', inflow_name], 'FontSize', title_font_size);
        legend(legends, 'FontSize', legend_font_size);
        set(gca, 'FontSize', axis_font_size);
    end
end

%% total delay comparison
if figures_map('total_delay_comparison')
    for inflow_id = 1: inflows_map.Count
        inflow_name = inflow_order_name_map(inflow_id);
        controller_data_map = inflow_controller_data_map(inflow_name);

        % prepare x-axis labels
        x_labels = [];
        row_ids = [];
        for relative_flow_id = 1: relative_flows_map.Count
            relative_flow_name = relative_flow_order_name_map(relative_flow_id);
            if relative_flows_map(relative_flow_name)
                x_labels = [x_labels, string(strrep(relative_flow_name, '_', ' '))];
                row_ids = [row_ids; relative_flow_id];
            end
        end

        % prepare y-axis values and each controller's legend
        y_data = [];
        legends = [];
        for controller_id = 1: controllers_map.Count
            controller_name = controller_order_name_map(controller_id);
            if controllers_map(controller_name)
                data = controller_data_map(controller_name);
                y_data = horzcat(y_data, data.delay);
                legends = horzcat(legends, string(controller_name));
            end
        end
        y_data = y_data(row_ids, :);

        % plot the bar chart
        figure;
        bar(y_data);
        xticklabels(x_labels);
        xlabel('Relative Flow Type', 'FontSize', label_font_size);
        ylabel('Average Delay Time [s]', 'FontSize', label_font_size);
        title(['Total Delay Time Comparison - Type: ', inflow_name], 'FontSize', title_font_size);
        legend(legends, 'FontSize', legend_font_size);
        set(gca, 'FontSize', axis_font_size);
    end
end

%% total speed comparison
if figures_map('total_speed_comparison')
    for inflow_id = 1: inflows_map.Count
        inflow_name = inflow_order_name_map(inflow_id);
        controller_data_map = inflow_controller_data_map(inflow_name);

        % prepare x-axis labels
        x_labels = [];
        row_ids = [];
        for relative_flow_id = 1: relative_flows_map.Count
            relative_flow_name = relative_flow_order_name_map(relative_flow_id);
            if relative_flows_map(relative_flow_name)
                x_labels = [x_labels, string(strrep(relative_flow_name, '_', ' '))];
                row_ids = [row_ids; relative_flow_id];
            end
        end

        % prepare y-axis values and each controller's legend
        y_data = [];
        legends = [];
        for controller_id = 1: controllers_map.Count
            controller_name = controller_order_name_map(controller_id);
            if controllers_map(controller_name)
                data = controller_data_map(controller_name);
                y_data = horzcat(y_data, data.speed);
                legends = horzcat(legends, string(controller_name));
            end
        end
        y_data = y_data(row_ids, :);

        % plot the bar chart
        figure;
        bar(y_data);
        xticklabels(x_labels);
        xlabel('Relative Flow Type', 'FontSize', label_font_size);
        ylabel('Average Speed [m/s]', 'FontSize', label_font_size);
        title(['Total Speed Comparison - Type: ', inflow_name], 'FontSize', title_font_size);
        legend(legends, 'FontSize', legend_font_size, 'Location', 'southeast');
        set(gca, 'FontSize', axis_font_size);
    end
end

%% total calculation time comparison
if figures_map('total_calc_time_comparison')
    for inflow_id = 1: inflows_map.Count
        inflow_name = inflow_order_name_map(inflow_id);
        controller_data_map = inflow_controller_data_map(inflow_name);

        % prepare x-axis labels
        x_labels = [];
        row_ids = [];
        for relative_flow_id = 1: relative_flows_map.Count
            relative_flow_name = relative_flow_order_name_map(relative_flow_id);
            if relative_flows_map(relative_flow_name)
                x_labels = [x_labels, string(strrep(relative_flow_name, '_', ' '))];
                row_ids = [row_ids; relative_flow_id];
            end
        end

        % prepare y-axis values and each controller's legend
        y_data = [];
        legends = [];
        for controller_id = 1: controllers_map.Count
            controller_name = controller_order_name_map(controller_id);

            if strcmp(controller_name, 'scoot')
                % SCOOT does not have calculation time data
                continue;
            end

            if controllers_map(controller_name)
                data = controller_data_map(controller_name);
                y_data = horzcat(y_data, data.calc_time);
                legends = horzcat(legends, string(controller_name));
            end
        end
        y_data = y_data(row_ids, :);

        % plot the bar chart
        figure;
        bar(y_data);
        xticklabels(x_labels);
        xlabel('Relative Flow Type', 'FontSize', label_font_size);
        ylabel('Average Calculation Time [s]', 'FontSize', label_font_size);
        title(['Total Calculation Time Comparison - Type: ', inflow_name], 'FontSize', title_font_size);
        legend(legends, 'FontSize', legend_font_size);
        set(gca, 'FontSize', axis_font_size);
    end
end

%% time series queue data
if figures_map('time_series_queue')
    for inflow_id = time_series_inflow_list
        for relative_flow_id = time_series_relative_flow_list
            figure;

            legends = {};
            for controller_id = 1: controllers_map.Count
                controller_name = controller_order_name_map(controller_id);
                if ~controllers_map(controller_name)
                    continue;
                end

                time_series_data_map = controller_time_series_data_map(controller_name);
                time_series_data = time_series_data_map([num2str(inflow_id), '_', num2str(relative_flow_id)]);
                legends{end + 1} = controller_name;

                plot(time_series_data.time, time_series_data.queue, 'LineWidth', line_width);
                hold on;
            end

            inflow_name = strrep(inflow_order_name_map(inflow_id), '_', ' ');
            relative_flow_name = strrep(relative_flow_order_name_map(relative_flow_id), '_', ' ');

            xlabel('Time [s]', 'FontSize', label_font_size);
            ylabel('Average Queue Length [m]', 'FontSize', label_font_size);
            title(['Time Series of Queue Length - Inflow: ', inflow_name, ', Relative Flow: ', relative_flow_name], 'FontSize', title_font_size);
            legend(legends, 'FontSize', legend_font_size);
            set(gca, 'FontSize', axis_font_size);
            xlim([0, time_series_data.time(end)]);
            hold off;
        end
    end
end

%% time series delay data
if figures_map('time_series_delay')
    for inflow_id = time_series_inflow_list
        for relative_flow_id = time_series_relative_flow_list
            figure;

            legends = {};
            for controller_id = 1: controllers_map.Count
                controller_name = controller_order_name_map(controller_id);
                if ~controllers_map(controller_name)
                    continue;
                end

                time_series_data_map = controller_time_series_data_map(controller_name);
                time_series_data = time_series_data_map([num2str(inflow_id), '_', num2str(relative_flow_id)]);
                legends{end + 1} = controller_name;

                plot(time_series_data.time, time_series_data.delay, 'LineWidth', line_width);
                hold on;
            end

            inflow_name = strrep(inflow_order_name_map(inflow_id), '_', ' ');
            relative_flow_name = strrep(relative_flow_order_name_map(relative_flow_id), '_', ' ');

            xlabel('Time [s]', 'FontSize', label_font_size);
            ylabel('Average Delay Time [s]', 'FontSize', label_font_size);
            title(['Time Series of Delay Time - Inflow: ', inflow_name, ', Relative Flow: ', relative_flow_name], 'FontSize', title_font_size);
            legend(legends, 'FontSize', legend_font_size);
            set(gca, 'FontSize', axis_font_size);
            xlim([0, time_series_data.time(end)]);
            hold off;
        end
    end
end

%% time series speed data
if figures_map('time_series_speed')
    for inflow_id = time_series_inflow_list
        for relative_flow_id = time_series_relative_flow_list
            figure;

            legends = {};
            for controller_id = 1: controllers_map.Count
                controller_name = controller_order_name_map(controller_id);
                if ~controllers_map(controller_name)
                    continue;
                end

                time_series_data_map = controller_time_series_data_map(controller_name);
                time_series_data = time_series_data_map([num2str(inflow_id), '_', num2str(relative_flow_id)]);
                legends{end + 1} = controller_name;

                plot(time_series_data.time, time_series_data.speed, 'LineWidth', line_width);
                hold on;
            end

            inflow_name = strrep(inflow_order_name_map(inflow_id), '_', ' ');
            relative_flow_name = strrep(relative_flow_order_name_map(relative_flow_id), '_', ' ');

            xlabel('Time [s]', 'FontSize', label_font_size);
            ylabel('Average Speed [m/s]', 'FontSize', label_font_size);
            title(['Time Series of Speed - Inflow: ', inflow_name, ', Relative Flow: ', relative_flow_name], 'FontSize', title_font_size);
            legend(legends, 'FontSize', legend_font_size, 'Location', 'southeast');
            set(gca, 'FontSize', axis_font_size);
            xlim([0, time_series_data.time(end)]);
            hold off;
        end
    end
end