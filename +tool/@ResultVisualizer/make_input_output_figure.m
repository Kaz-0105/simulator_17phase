function make_input_output_figure(obj)
    RoadInputMap = obj.measurements.get('RoadInputMap'); 
    RoadOutputMap = obj.measurements.get('RoadOutputMap');
    
    for plot_member = obj.plot_list
        plot_member = plot_member{1};

        % ネットワーク全体の車両数
        if strcmp(plot_member.data, "num_vehs") && strcmp(plot_member.type, "all")
            figure_struct = [];
            figure('Name', 'Number of Vehicles in the Network');
            
            grid on;

            inflow_data = [];

            for road_id = cell2mat(keys(RoadInputMap))
                input_data = RoadInputMap(road_id);

                if isempty(inflow_data)
                    inflow_data = input_data;
                else
                    inflow_data = inflow_data + input_data;
                end
            end
            inflow_data = [0, inflow_data];

            outflow_data = []; 

            for road_id = cell2mat(keys(RoadOutputMap))
                output_data = RoadOutputMap(road_id);

                if isempty(outflow_data)
                    outflow_data = output_data;
                else
                    outflow_data = outflow_data + output_data;
                end
            end
            outflow_data = [0, outflow_data];

            cumulative_inflow_data = cumsum(inflow_data);
            cumulative_outflow_data = cumsum(outflow_data);

            num_vehs_in_network = cumulative_inflow_data - cumulative_outflow_data;

            plot(obj.time_data, num_vehs_in_network, 'LineWidth', obj.line_width);

            set(gca, 'FontSize', obj.gca_font_size);
            xlabel('Time (s)', 'FontSize', obj.label_font_size);
            ylabel('Number of Vehicles', 'FontSize', obj.label_font_size);
            title('Vehicles in the Network', 'FontSize', obj.title_font_size);

            xlim([0, obj.time_data(end)]);

            figure_struct.x_data = obj.time_data;
            figure_struct.y_data = num_vehs_in_network;

            obj.figure_structs("num_vehs_all") = figure_struct;
        end
    end
end