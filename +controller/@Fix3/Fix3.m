classdef Fix3 < handle
    properties
        % 配列ではない普通の変数
        id;
        calc_time = 0;
        signal_num;
        phase_num;
        road_num;
    end

    properties
        % 構造体
        pos_vehs;
        route_vehs;
        num_vehs;
    end

    properties
        % クラス
        UResults;
    end

    properties
        % リスト
    end

    properties
        % Map
        Maps;
    end

    methods
        function obj = Fix3(id, Config, Maps)
            % idの設定
            obj.id = id;
            obj.signal_num = 6;
            obj.phase_num = 3;
            obj.road_num = 3;
            
        end
    end

    methods
        value = get(obj, property_name);
    end

    methods
        makeVehiclesData(obj, IntersectionStructMap, VissimData);
    end
end