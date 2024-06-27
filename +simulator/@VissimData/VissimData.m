classdef VissimData<handle

    properties(GetAccess = private)
        % Map
        RoadVehsMap;          % キー：道路ID、値：その道路上の自動車の位置と進路をまとめた配列
        RoadFirstVehMap;     % キー：道路ID、値：その道路上の先頭の自動車のID
    end

    methods(Access = public)
        function obj = VissimData(Com, Maps)
            % RoadVehsMap を作成する
            obj.RoadVehsMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

            % RoadFirstVehMap を作成する
            obj.RoadFirstVehMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

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