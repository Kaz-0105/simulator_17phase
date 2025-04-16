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
                
                for num_phases = [4, 8, 17]
                    function_values = FunctionValueMap(num_phases);
                    plot(function_values, 'DisplayName', ['NumPhases: ' num2str(num_phases)], 'LineWidth', setting.line_width);
                end

                title(['Objective Function Values for Intersection' num2str(intersection_id)], 'FontSize', obj.font_sizes.label); 
                xlabel('Optimization Iteration', 'FontSize', obj.font_sizes.label);
                ylabel('Objective Function Value [veh]', 'FontSize', obj.font_sizes.label);

                ax = gca;
                ax.FontSize = obj.font_sizes.axis;

                legend('show', 'Location', 'best');
            end
        end
    end
end