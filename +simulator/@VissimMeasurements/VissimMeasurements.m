classdef VissimMeasurements < handle

    properties
        % クラス
        Com; % VissimのCOMオブジェクト
        Vissim; % Vissimクラスの変数
    end

    properties
        % Map
        RoadInputMap;                      % ネットワークに流入する車両数のマップ    
        RoadOutputMap;                     % ネットワークから流出する車両数のマップ                           
        IntersectionRoadQueueMap;          % 信号待ちの長さのマップ
        IntersectionCalcTimeMap;           % 計算時間のマップ
        IntersectionRoadNumVehsMap;        % 車両数のマップ
        IntersectionRoadDelayMap;          % 遅れ時間のマップ
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
            obj.initMaps();
            
            % timeの初期化
            obj.time = 0;
        end
    end

    methods
        value = get(obj, property_name);
        update(obj);
    end

    methods(Access = private)
        % マップを初期化する関数
        initMaps(obj)
        
        % 計測データの更新を行う関数
        updateRoadInputMap(obj)
        updateRoadOutputMap(obj)
        updateIntersectionRoadQueueMap(obj)
        updateIntersectionCalcTimeMap(obj)
        updateIntersectionRoadNumVehsMap(obj)

    end
end