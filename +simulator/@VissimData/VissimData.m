classdef VissimData<handle
    properties
        % クラス
        Vissim;
        Com;
    end

    properties(GetAccess = private)
        % Map
        RoadLaneVehsDataMap;    % キー１：道路ID、キー２：車線のID、値：その車線上の自動車のデータ
        RoadLanePosVehsMap;     % キー１：道路ID、キー２：車線のID、値：その車線上の自動車の位置
        RoadLaneRouteVehsMap;   % キー１：道路ID、キー２：車線のID、値：その車線上の自動車の進路
        RoadIntersectionMap;    % キー：道路ID、値：その道路が流入道路となる交差点のID
        RoadNumVehsMap;         % キー：道路ID、値：その道路上の自動車の数
    end

    methods(Access = public)
        function obj = VissimData(Vissim)
            % Vissimクラスを取得
            obj.Vissim = Vissim;

            % VissimのCOMオブジェクトを取得
            obj.Com = obj.Vissim.get('Com');

            % RoadIntersectionMapを作成する
            obj.makeRoadIntersectionMap();

            % RoadLaneVehsDataMapを作成
            obj.makeRoadLaneVehsDataMap();

            % RoadLanePosVehsMapを作成
            obj.makeRoadLanePosVehsMap();

            % RoadLaneRouteVehsMapを作成
            obj.makeRoadLaneRouteVehsMap();
        end    
    end

    methods(Access = public)
        value = get(obj, property_name);
    end

    methods(Access = private)
        makeMaps(obj);
        makeIntersectionNumRoadMap(obj);
        makeRoadIntersectionMap(obj);
        makeRoadLaneFirstVehMap(obj);
    end
end