classdef ResultVisualizer < handle
    properties
        % クラス
        Vissim;              % Vissimクラスの変数
        VissimMeasurements;  % VissimMeasurementsクラスの変数
        Config;              % Configクラスの変数
    end

    properties
        line_width;      % 線の太さ
        font_size; % ラベルのフォントサイズ

        isSave; % データを保存するかどうか
        isCompare; % データを比較するかどうか
    end

    methods(Access = public)

        function obj = ResultVisualizer(Vissim, Config)
            % ConfigクラスとVissimクラスの変数を設定
            obj.Config = Config;
            obj.Vissim = Vissim;

            % VissimMeasurementsクラスの変数を設定
            obj.VissimMeasurements = Vissim.get('VissimMeasurements');

            % line_widthとfont_sizeの設定
            obj.line_width = Config.graph.line_width;
            obj.font_size = Config.graph.font_size;

            % isSaveとisCompareの設定
            obj.isSave = Config.result.save;
            obj.isCompare = Config.result.comparison;
        end

        function save_figure_structs(obj)
            tmp_figure_structs = obj.figure_structs;
        
            fprintf("シミュレーション結果のデータを保存しますか？(y/n)\n")
            answer = string(input('>> ', 's'));
        
            if answer == "y"
                fprintf("保存するフォルダを教えてください。\n");
                save_dir = uigetdir(pwd+"/results/data");
        
                if save_dir == 0
                    fprintf("保存するフォルダが選択されませんでした。\n");
                    return;
                end
        
                fprintf("ファイル名を指定しましょう。\n");
                file_name = input('>> ', 's');
        
                save(fullfile(save_dir, file_name), 'tmp_figure_structs');
        
                fprintf("データの保存が完了しました。\n");
            end
        end

        function compare_results(obj)

            fprintf("シミュレーション結果を比較しますか？(y/n)\n")
            answer = string(input('>> ', 's'));
        
            if answer == "y"
                fprintf("比較するファイルを選択してください。\n");
                [file_names, file_dir] = uigetfile(pwd +"\results\data\comparison", 'MultiSelect', 'on');
        
                if ~iscell(file_names)
                    fprintf("ファイルが選択されませんでした。\n");
                    return;
                end

                num_vehs_map = dictionary(int32.empty, struct.empty);
                calc_time_map = dictionary(int32.empty, struct.empty);
                queue_length_map = dictionary(int32.empty, struct.empty);
        
                data_id = 0;

                for file_name = file_names
                    data_id = data_id + 1;

                    file_name = file_name{1};
                    load(fullfile(file_dir, file_name));

                    num_vehs_map(data_id) = tmp_figure_structs('num_vehs_all');
                    calc_time_map(data_id) = tmp_figure_structs('calc_time_all');
                    queue_length_map(data_id) = tmp_figure_structs('queue_length_all');

                end
            
            else
                return;
            end

            % 車両数の比較

            figure("Name", "Number of Vehicles in the Network (Comparison)");
            grid on;
            hold on;

            for data_id = keys(num_vehs_map)'
                num_vehs_data = num_vehs_map(data_id);
                plot(num_vehs_data.x_data, num_vehs_data.y_data, "LineWidth", obj.line_width);
            end

            set(gca, "FontSize", obj.gca_font_size);
            xlabel("Time [s]", "FontSize", obj.label_font_size);
            ylabel("Number of Vehicles", "FontSize", obj.label_font_size);
            title("Vehicles in the Network (Comparison)", "FontSize", obj.title_font_size);

            xlim([0, obj.time_data(end)]);
            legend(file_names);

            % 車列の比較

            figure("Name", "Queue Length (Comparison)");
            grid on;
            hold on;

            for data_id = keys(queue_length_map)'
                queue_length_data = queue_length_map(data_id);
                plot(queue_length_data.x_data, queue_length_data.y_data, "LineWidth", obj.line_width);
            end

            set(gca, "FontSize", obj.gca_font_size);
            xlabel("Time [s]", "FontSize", obj.label_font_size);
            ylabel("Queue Length [m]", "FontSize", obj.label_font_size);
            title("Queue Length (Comparison)", "FontSize", obj.title_font_size);

            xlim([0, obj.time_data(end)]);
            legend(file_names);        
        end
    end

    methods(Access = public)
        value = get(obj, property_name);
        run(obj);
    end

    methods(Access = private)
        showResult(obj);
        showCompare(obj);
        saveResult(obj);

        showCalcTime(obj, varargin);
        showQueueLength(obj, varargin);
        showNumVehs(obj, varargin);
        showDelay(obj, varargin);
    end
end