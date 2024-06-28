classdef VissimData<handle

    properties(GetAccess = private)
        % Map
        RoadVehsMap;            % キー：道路ID、値：その道路上の自動車の位置と進路をまとめた配列
        RoadFirstVehMap;        % キー：道路ID、値：その道路上の先頭の自動車のID
        IntersectionNumRoadMap; % キー：交差点ID、値：その交差点に流入する道路の数
        RoadIntersectionMap;    % キー：道路ID、値：その道路が流入道路となる交差点のID
    end

    methods(Access = public)
        function obj = VissimData(Com, Maps)
            % IntersectionNumRoadMap を作成する
            obj.makeIntersectionNumRoadMap(Maps);

            % RoadIntersectionMap を作成する
            obj.makeRoadIntersectionMap(Maps);

            % RoadVehsMap と RoadFirstVehMap を作成する
            obj.makeVehicleData(Com, Maps);
        end    
    end

    methods(Access = public)
        value = get(obj, property_name);
    end

    methods(Access = private)
        makeVehicleData(obj, Com, Maps);
    end
end