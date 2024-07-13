classdef VissimData<handle
    properties
        % クラス
        Vissim;
        Com;
    end

    properties(GetAccess = private)
        % Map
        RoadPosVehsMap;         % キー：道路ID、値：その道路上の自動車の位置
        RoadRouteVehsMap;       % キー：道路ID、値：その道路上の自動車の進路
        RoadRouteFirstVehMap;   % キー１：道路のID、キー２：進路のID、値：先頭車のID
        RoadLaneFirstVehMap;    % キー１：道路のID、キー２：車線のID、値：先頭車のID
        IntersectionNumRoadMap; % キー：交差点ID、値：その交差点に流入する道路の数
        RoadIntersectionMap;    % キー：道路ID、値：その道路が流入道路となる交差点のID
    end

    methods(Access = public)
        function obj = VissimData(Vissim)
            % Vissimクラスを取得
            obj.Vissim = Vissim;

            % VissimのCOMオブジェクトを取得
            obj.Com = obj.Vissim.get('Com');

            % IntersectionNumRoadMapを作成する
            obj.makeIntersectionNumRoadMap();

            % RoadIntersectionMapを作成する
            obj.makeRoadIntersectionMap();

            % RoadPosVehsMapとRoadRouteVehsMapとRoadRouteFirstVehMapを作成する
            obj.makeVehicleData();

            % RoadLaneFirstVehMapを作成する
            obj.makeRoadLaneFirstVehMap();
        end    
    end

    methods(Access = public)
        value = get(obj, property_name);
    end

    methods(Access = private)
        makeVehicleData(obj);
        makeIntersectionNumRoadMap(obj);
        makeRoadIntersectionMap(obj);
        makeRoadLaneFirstVehMap(obj);
    end
end