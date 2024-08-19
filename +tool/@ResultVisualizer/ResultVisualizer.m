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
        tmp_figure_id; % 現在のfigureの番号
    end

    methods(Access = public)

        function obj = ResultVisualizer(Vissim, Config)
            % ConfigクラスとVissimクラスの変数を設定
            obj.Config = Config;
            obj.Vissim = Vissim;

            % VissimMeasurementsクラスの変数を設定
            obj.VissimMeasurements = Vissim.get('VissimMeasurements');

            % フォントサイズの設定
            obj.font_sizes = Config.graph.font_size;

            % 表示の有無のフラグの設定
            obj.flags.queue_length = Config.result.contents.queue_length.active;
            obj.flags.num_vehs = Config.result.contents.num_vehs.active;
            obj.flags.delay_time = Config.result.contents.delay_time.active;
            obj.flags.calc_time = Config.result.contents.calc_time.active;
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
    end
end