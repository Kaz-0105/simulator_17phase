classdef ResultVisualizer < handle
    properties
        % クラス
        Vissim;              % Vissimクラスの変数
        VissimMeasurements;  % VissimMeasurementsクラスの変数
        Config;              % Configクラスの変数
    end

    properties
        % マップ
        ComparePathMap; % キー：比較するデータのID、バリュー：比較するデータの相対パス
        GraphSettingMap; % キー：グラフの種類、バリュー：設定をまとめた構造体のマップ
    end

    properties
        % 構造体
        flags;      % 表示の有無に関するフラグの構造体
        font_sizes; % フォントサイズの構造体
    end

    properties
        % フラグ
        phase_comparison_flg; % フェーズごとの比較の有無のフラグ
        model_error_flg;      % モデル誤差の調査の有無のフラグ

        % 配列
        comparison_phases; % 比較するフェーズの種類
    end

    properties
        tmp_figure_id; % 現在のfigureの番号
    end

    methods(Access = public)

        function obj = ResultVisualizer(Vissim, Config)
            % ConfigクラスとVissimクラスの変数を設定
            obj.Config = Config;
            obj.Vissim = Vissim;

            % フェーズごとの比較の有無
            obj.phase_comparison_flg = obj.Config.vissim.phase_comparison_flg;
            obj.comparison_phases = obj.Config.vissim.comparison_phases;

            % モデル誤差の調査の有無
            obj.model_error_flg = obj.Config.vissim.model_error_flg;

            % VissimMeasurementsクラスの変数を設定
            obj.VissimMeasurements = Vissim.get('VissimMeasurements');

            % フォントサイズの設定
            obj.font_sizes = Config.graph.font_size;

            % 表示の有無のフラグの設定
            obj.flags.queue_length = Config.result.contents.queue_length.active;
            obj.flags.num_vehs = Config.result.contents.num_vehs.active;
            obj.flags.delay_time = Config.result.contents.delay_time.active;
            obj.flags.calc_time = Config.result.contents.calc_time.active;
            obj.flags.speed = Config.result.contents.speed.active;
            obj.flags.compare = Config.result.compare.active;
            obj.flags.database = Config.result.database.active;

            % ComparePathMapの設定
            obj.ComparePathMap = Config.result.compare.PathMap;

            % GraphSettingMapの設定
            obj.makeGraphSettingMap();

            % tmp_figure_idの初期化
            obj.tmp_figure_id = 0;
        end
    end

    methods(Access = public)
        value = get(obj, property_name);
        run(obj);
    end

    methods(Access = private)
        makeGraphSettingMap(obj);

        showResult(obj);

        showQueueLength(obj);
        showNumVehs(obj);
        showDelayTime(obj);
        showCalcTime(obj);
        updateDatabase(obj)
    end

    methods(Access = private)
        % 速度のプロットを行うメソッド
        function showSpeed(obj)
            VehicleSpeedsMap = obj.VissimMeasurements.VehicleSpeedsMap;

            vehicle_average_speeds = [];
            for vehicle_id = cell2mat(VehicleSpeedsMap.keys())
                vehicle_average_speeds = [vehicle_average_speeds; mean(VehicleSpeedsMap(vehicle_id))];
            end 

            histogram(vehicle_average_speeds, 'BinWidth', 5);
        end

        % フェーズごとの比較を行うメソッド
        function makePhaseComparisonGraph(obj)
            % LineGraphの設定
            setting = obj.GraphSettingMap('line_graph');

            IntersectionControllerMap = obj.Vissim.IntersectionControllerMap;

            for intersection_id = cell2mat(IntersectionControllerMap.keys())
                Controller = IntersectionControllerMap(intersection_id);

                if (~isa(Controller ,'controller.Dan'))
                    continue;
                end

                FunctionValueMap = Controller.FunctionValueMap;

                figure;
                hold on;
                
                for num_phases = obj.comparison_phases
                    function_values = FunctionValueMap(num_phases);
                    plot(function_values, 'DisplayName', ['NumPhases: ' num2str(num_phases)], 'LineWidth', setting.line_width);

                    if (num_phases == obj.comparison_phases(1))
                        x_max = size(function_values, 2);
                    end
                end

                title(['Objective Function Values for Intersection' num2str(intersection_id)], 'FontSize', obj.font_sizes.label); 
                xlabel('Optimization Iteration', 'FontSize', obj.font_sizes.label);
                ylabel('Objective Function Value [veh]', 'FontSize', obj.font_sizes.label);
                xlim([1, x_max]);

                ax = gca;
                ax.FontSize = obj.font_sizes.axis;

                legend('show', 'Location', 'best');
            end
        end

        % モデル誤差の調査を行うメソッド
        function makeModelErrorGraph(obj)
            setting = obj.GraphSettingMap('line_graph');
            IntersectionControllerMap = obj.Vissim.get('IntersectionControllerMap');
            IntersectionRoadNumQueuesMap = obj.VissimMeasurements.get('IntersectionRoadNumQueuesMap');
            
            for intersection_id = cell2mat(IntersectionControllerMap.keys())
                Controller = IntersectionControllerMap(intersection_id);

                if (~isa(Controller ,'controller.Dan'))
                    continue;
                end

                RoadNumQueuesMap = IntersectionRoadNumQueuesMap(intersection_id);

                intersection_num_queues = [];
                for road_id = cell2mat(RoadNumQueuesMap.keys())
                    if isempty(intersection_num_queues)
                        intersection_num_queues = RoadNumQueuesMap(road_id);
                    else
                        intersection_num_queues = intersection_num_queues + RoadNumQueuesMap(road_id);
                    end
                end

                figure;
                hold on;

                plot(obj.VissimMeasurements.time, intersection_num_queues, 'LineWidth', setting.line_width, 'Color', 'b');
                title(['Intersection ' num2str(intersection_id) ' - Model Error'], 'FontSize', obj.font_sizes.label);
                xlabel('Time [s]', 'FontSize', obj.font_sizes.label);
                ylabel('Number of vehicles in queue', 'FontSize', obj.font_sizes.label);
                xlim([0, obj.VissimMeasurements.time(end)]);

                TimeNumQueuesMap = Controller.get('TimeNumQueuesMap');
                count = 0;
                for time = cell2mat(TimeNumQueuesMap.keys())
                    time_num_queues_data = TimeNumQueuesMap(time);
                    times = time_num_queues_data(1, :);
                    num_queues = time_num_queues_data(2, :);

                    if (mod(count, 2) == 0) 
                        plot(times, num_queues, 'LineWidth', setting.line_width, 'Color', 'r');
                    else
                        plot(times, num_queues, 'LineWidth', setting.line_width, 'Color', 'r');
                    end
                    count = count + 1;
                end
            end 
        end
    end
end