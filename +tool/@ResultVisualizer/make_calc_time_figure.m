function make_calc_time_figure(obj)
    CalcTimeDataMap = obj.measurements.get('CalcTimeDataMap');
    NumVehsDataMap = obj.measurements.get('NumVehsDataMap');

    % 系全体
    
    for plot_member = obj.plot_list
        plot_member = plot_member{1};

        if strcmp(plot_member.data, 'calc_time') && strcmp(plot_member.type, 'all')
            figure_struct = [];
            figure('Name', 'Calculation Time');
            grid on;

            calc_time_data_all = [];
            num_vehs_data_all = [];

            for intersection_id = cell2mat(keys(CalcTimeDataMap))
                calc_time_data = CalcTimeDataMap(intersection_id);
                calc_time_data_all = [calc_time_data_all, calc_time_data];

                num_vehs_data = NumVehsDataMap(intersection_id);
                num_vehs_data_all = [num_vehs_data_all, num_vehs_data];
            end

            scatter(num_vehs_data_all, calc_time_data_all, 'filled');

            set(gca, 'FontSize', obj.gca_font_size);
            xlabel('Number of Vehicles [veh]', 'FontSize', obj.label_font_size);
            ylabel('Calculation Time [s]', 'FontSize', obj.label_font_size);
            title('Calculation Time', 'FontSize', obj.title_font_size);

            figure_struct.x_data = num_vehs_data_all;
            figure_struct.y_data = calc_time_data_all;

            obj.figure_structs('calc_time_all') = figure_struct;
        end
    end

    % 各交差点

    for plot_member = obj.plot_list
        plot_member = plot_member{1};
        if strcmp(plot_member.data, 'calc_time') && strcmp(plot_member.type, 'one')
            for intersection_id = keys(CalcTimeDataMap)'
                calc_time_data = CalcTimeDataMap(intersection_id);
                num_vehs_data = NumVehsDataMap(intersection_id);

                figure_struct = [];
                figure('Name', 'Calculation Time');
                grid on;

                scatter(num_vehs_data, calc_time_data, 'filled');

                set(gca, 'FontSize', obj.gca_font_size);
                xlabel('Number of Vehicles [veh]', 'FontSize', obj.label_font_size);
                ylabel('Calculation Time [s]', 'FontSize', obj.label_font_size);
                title('Calculation Time', 'FontSize', obj.title_font_size);

                figure_struct.x_data = num_vehs_data;
                figure_struct.y_data = calc_time_data;

                obj.figure_structs('calc_time_' + num2str(intersection_id)) = figure_struct;
            end
        end
    end
end