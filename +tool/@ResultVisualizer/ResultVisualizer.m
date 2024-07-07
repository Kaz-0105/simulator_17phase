classdef ResultVisualizer < handle
    properties
        % クラス
        Vissim;              % Vissimクラスの変数
        VissimMeasurements;  % VissimMeasurementsクラスの変数
        Config;              % Configクラスの変数
    end

    properties
        CompareDataPathMap; % 比較するデータのパスのマップ
    end

    properties
        line_width;          % 線の太さ
        font_size;           % ラベルのフォントサイズ

        queue_length_flag; % キューの長さの表示の有無に関するフラグ
        num_vehs_flag;     % 自動車台数の表示の有無に関するフラグ
        delay_time_flag;   % 遅れ時間の表示の有無に関するフラグ
        calc_time_flag;    % 計算時間の表示の有無に関するフラグ
        compare_flag;      % 結果の比較の有無に関するフラグ
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

            % queue_length_flagの設定
            obj.queue_length_flag = Config.result.contents.queue_length.active;

            % num_vehs_flagの設定
            obj.num_vehs_flag = Config.result.contents.num_vehs.active;

            % delay_time_flagの設定
            obj.delay_time_flag = Config.result.contents.delay_time.active;

            % calc_time_flagの設定
            obj.calc_time_flag = Config.result.contents.calc_time.active;

            % compare_flagの設定
            obj.compare_flag = Config.result.compare.active;

            % Config.result.compare.PathMapの取得
            obj.CompareDataPathMap = Config.result.compare.PathMap;
        end
    end

    methods(Access = public)
        value = get(obj, property_name);
        run(obj);
    end

    methods(Access = private)
        showResult(obj);

        showQueueLength(obj);
        showNumVehs(obj);
        showDelayTime(obj);
        showCalcTime(obj);
    end
end