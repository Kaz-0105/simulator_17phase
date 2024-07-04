classdef VissimData<handle
    properties
        % クラス
        Vissim;
        Com;
    end

    properties(GetAccess = private)
        % Map
        RoadVehsMap;            % キー：道路ID、値：その道路上の自動車の位置と進路をまとめた配列
        RoadFirstVehMap;        % キー：道路ID、値：その道路上の先頭の自動車のID
        IntersectionNumRoadMap; % キー：交差点ID、値：その交差点に流入する道路の数
        RoadIntersectionMap;    % キー：道路ID、値：その道路が流入道路となる交差点のID
    end

    methods(Access = public)
        function obj = VissimData(Vissim)
            % Vissimクラスを取得
            obj.Vissim = Vissim;

            % VissimのCOMオブジェクトを取得
            obj.Com = obj.Vissim.get('Com');

            % IntersectionNumRoadMap を作成する
            obj.makeIntersectionNumRoadMap();

            % RoadIntersectionMap を作成する
            obj.makeRoadIntersectionMap();

            % RoadVehsMap と RoadFirstVehMap を作成する
            obj.makeVehicleData();
        end    
    end

    methods(Access = public)
        value = get(obj, property_name);
    end

    methods(Access = private)
        makeVehicleData(obj);
    end
end