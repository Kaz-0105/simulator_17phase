classdef Fixed < handle
    properties
        %　クラス
        Config; % Configクラスの変数
        Vissim; % Vissimクラスの変数
        Com;    % COMのオブジェクト
    end

    properties
        % 普通のプロパティ
        id;            % 交差点のID
        signal_num;    % 信号機の数
        phase_num;     % フェーズの数   
        tmp_phase_num; % フェーズの数
        road_num;      % 道路の数
        
        calc_time; % 計算時間

        prediction_count; % 予測回数
    end

    

    properties
        % Map
        RoadPrmsMap;           % 道路に関するパラメータを格納するMap
        VariableListMap;       % 決定変数のリストを格納するMap
        RoadLinkDelta1ListMap; % リンクごとのdelta1のリストを格納するMap
        PhaseSignalGroupMap;   % フェーズを構成するSignalGroupを収納するMap

        RoadRouteSignalGroupMap;
        
        RoadLinkPosVehsMap;
        RoadLinkRouteVehsMap;
        RoadLinkLaneVehsMap;

        RoadNumLinksMap;

        RoadLinkLaneFirstVehsMap;

        RoadLinkNumVehsMap;
        RoadNumVehsMap;
    end

    methods(Access = public)
        function obj = Fixed(id, Vissim, road_num) 
            % ConfigクラスとVissimクラスの変数の設定
            obj.Config = Vissim.get('Config');
            obj.Vissim = Vissim;
            obj.Com = Vissim.get('Com');

            % 交差点のID、SignalGroupの数、道路の数を設定
            obj.id = id;
            obj.road_num = road_num;
            obj.signal_num = obj.road_num * (obj.road_num -1);

            % 予測回数の初期化
            obj.prediction_count = 0; 
            

            % RoadNumVehsMapの初期化
            obj.RoadNumVehsMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

            for road_id = 1: obj.road_num
                obj.RoadNumVehsMap(road_id) = 0;
            end
        end
    end

    methods(Access = public)
        value = get(obj, property_name);
        updateStates(obj, IntersectionStructMap, VissimData);
        optimize(obj);
    end

    methods(Access = private)
        makeRoadPrmsMap(obj);
        makeVehiclesData(obj, intersection_struct_map, VissimData);

        % PhaseとSignalGroupのマップを作成する関数
        makePhaseSignalGroupMap(obj);

        % 混合論理動的システムの係数行列を作成する関数群
        makeMld(obj);

        % 先行車を見つける関数
        value = getFrontVehicle(obj, veh_id, road_id, link_id);
        value = getDifferentRouteVehicle(obj, veh_id, road_id, link_id);

        makeRoadNumVehsMap(obj);

        % 混合整数線形計画問題の形にMLDの係数と信号機制約の係数を変形する関数群
        makeMilp(obj);
        makeObjectiveFunction(obj, template_id);
        makeConstraints(obj);
        makeBoundary(obj);
        makeIntcon(obj);
        makeWeight(obj);

        % 最適解と次の最適化に必要な決定変数を抽出する関数群
        makeUOpt(obj, x_opt);
        makePhiOpt(obj, x_opt);

        makePosVehsResult(obj);
    end
end