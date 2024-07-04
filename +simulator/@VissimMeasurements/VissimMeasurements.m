classdef VissimMeasurements < handle

    properties
        % クラス
        Com; % VissimのCOMオブジェクト
        Vissim; % Vissimクラスの変数
    end

    properties
        % Map
        RoadInputMap;    % 末端道路ごとの流入量の時系列データ格納するMap
        RoadOutputMap;   % 末端道路ごとの流出量の時系列データ格納するMap
        IntersectionRoadQueueMap;    % 交差点ごとの待ち行列の時系列データを格納するMap
        IntersectionCalcTimeMap; % 交差点ごとの計算時間の時系列データを格納するMap
        RoadNumVehsMap;  % 交差点ごとの車両数の時系列データを格納するMap

        LinkDataCollectionMeasurementMap; % キー：リンクのID、バリュー：DataCollectionMeasurementのIDのMap
    end

    properties
        % リスト
        time; % 時間のリスト
    end

    methods(Access = public)

        function obj = VissimMeasurements(Vissim)
            % VissimのCOMオブジェクトを設定
            obj.Com = Vissim.Com;

            % Vissimクラスの変数を設定
            obj.Vissim = Vissim;

            % Mapの初期化
            obj.RoadInputMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
            obj.RoadOutputMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
            obj.IntersectionRoadQueueMap = tool.HierarchicalMap('KeyType1', 'int32', 'KeyType2', 'int32', 'ValueType', 'any');
            obj.IntersectionCalcTimeMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
            obj.RoadNumVehsMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

            % timeの初期化
            obj.time = [];

            % LinkDataCollectionMeasurementMapの作成
            obj.makeLinkDataCollectionMeasurementMap();
        end
    end

    methods
        value = get(obj, property_name);
        updateData(obj);
    end

    methods(Access = private)

        % Data Collection Pointのリンクごとのディクショナリを作成する関数
        makeLinkDataCollectionMeasurementMap(obj)

        % 計測データの更新を行う関数
        updateInputOutputData(obj)
        updateQueueData(obj)
        updateCalcTimeData(obj)
        updateNumVehsData(obj)

    end
end