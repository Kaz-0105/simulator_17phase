classdef VissimMeasurements < handle

    properties
        % クラス
        Com; % VissimのCOMオブジェクト
    end

    properties
        % Map
        InputDataMap;    % 末端道路ごとの流入量の時系列データ格納するMap
        OutputDataMap;   % 末端道路ごとの流出量の時系列データ格納するMap
        QueueDataMap;    % 交差点ごとの待ち行列の時系列データを格納するMap
        CalcTimeDataMap; % 交差点ごとの計算時間の時系列データを格納するMap
        NumVehsDataMap;  % 交差点ごとの車両数の時系列データを格納するMap

        LinkDataCollectionMeasurementMap; % キー：リンクのID、バリュー：DataCollectionMeasurementのIDのMap
    end

    methods(Access = public)

        function obj = VissimMeasurements(Com)
            % コンストラクタ

            % VissimのCOMオブジェクトを設定
            obj.Com = Com;

            % Mapの初期化
            obj.InputDataMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
            obj.OutputDataMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
            obj.QueueDataMap = tool.HierarchicalMap('KeyType1', 'int32', 'KeyType2', 'int32', 'ValueType', 'any');
            obj.CalcTimeDataMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
            obj.NumVehsDataMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

            % LinkDataCollectionMeasurementMapの作成
            obj.makeLinkDataCollectionMeasurementMap();
        end

        function updateData(obj, maps, IntersectionControllerMap)
            % 計測データの更新を行う関数
            obj.updateInputOutputData(maps);
            obj.updateQueueData(maps);
            obj.updateCalcTimeData(IntersectionControllerMap);
            obj.updateNumVehsData(IntersectionControllerMap);
        end

        function value = get(obj, property_name)
            value = obj.(property_name);
        end
    end

    methods(Access = private)

        % Data Collection Pointのリンクごとのディクショナリを作成する関数
        makeLinkDataCollectionMeasurementMap(obj)

        % 計測データの更新を行う関数
        updateInputOutputData(obj, Maps)
        updateQueueData(obj, maps)
        updateCalcTimeData(obj, controllers)
        updateNumVehsData(obj, controllers)

    end
end