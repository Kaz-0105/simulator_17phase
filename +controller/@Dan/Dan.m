classdef Dan < handle
    properties
        %　クラス
        Config; % Configクラスの変数
        Vissim; % Vissimクラスの変数
        Com;    % COMのオブジェクト

        PhiResults; % phiの結果を格納するクラス
        UResults;   % uの結果を格納するクラス
    end

    properties
        % 普通のプロパティ
        id;            % 交差点のID
        signal_num;    % 信号機の数
        phase_num;     % フェーズの数   
        tmp_phase_num; % フェーズの数
        road_num;      % 道路の数
        
        dt;       % サンプリング時間
        N_p;      % 予測ホライゾン
        N_c;      % 制御ホライゾン
        max_time; % 最適化時間の上限

        N_s;     % 最低の連続回数
        m;       % ホライゾン内の最大変化回数
        fix_num; % 固定するステップ数

        eps; % 微小量

        u_length;           % uの決定変数の数
        z_length;           % zの決定変数の数
        delta_length;       % deltaの決定変数の数
        v_length;           % vの決定変数の数
        variables_size;     % 決定変数の数

        fval;      % 最適解の目的関数の値
        exitflag;  % 最適解の終了ステータス
        calc_time; % 計算時間

        prediction_count; % 予測回数
        success_count;    % 最適解が見つかった回数
        success_rate;         % 最適解が見つかった割合
    end

    properties
        % 構造体
        mld_matrices;  % 混合論理動的システムの係数行列を収納する構造体
        milp_matrices; % 混合整数線形計画問題の係数行列を収納する構造体
    end

    properties
        % リスト
        pos_vehs_init; % 自動車の初期位置のリスト
        pos_vehs_result;  % 予測の最終結果のリスト

        x_opt;   % 最適解のリスト
        u_opt;   % uの最適解のリスト
        phi_opt; % phiの最適解のリスト 
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
        function obj = Dan(id, Vissim, road_num) 
            % ConfigクラスとVissimクラスの変数の設定
            obj.Config = Vissim.get('Config');
            obj.Vissim = Vissim;
            obj.Com = Vissim.get('Com');

            % 交差点のID、SignalGroupの数、道路の数を設定
            obj.id = id;
            obj.road_num = road_num;
            obj.signal_num = obj.road_num * (obj.road_num -1);

            % フェーズの数を設定
            if obj.road_num == 3
                obj.phase_num = 4;
                obj.tmp_phase_num = 4;

            elseif obj.road_num == 4
                obj.phase_num = 8;
                obj.tmp_phase_num = 8;

            end

            % サンプリング時間
            obj.dt = obj.Config.mpc.time_step;

            % 予測ホライゾンと制御ホライゾン
            obj.N_p = obj.Config.mpc.predictive_horizon;
            obj.N_c = obj.Config.mpc.control_horizon; 

            % 最適化時間の上限
            obj.max_time = obj.Config.mpc.max_time;

            % 最低の連続回数、ホライゾン内の最大変化回数、固定するステップ数
            obj.N_s = obj.Config.model.dan.N_s;
            obj.m = obj.Config.model.dan.m;
            obj.fix_num = obj.Config.model.dan.fix_num;

            % 微小量
            obj.eps = obj.Config.model.dan.eps; 
            
            % 制御入力の変数の長さ
            obj.u_length = obj.signal_num;

            % 道路に関するパラメータを格納する構造体を作成
            obj.makeRoadPrmsMap();

            % PhaseとSignalGroupのMapを作成
            obj.makePhaseSignalGroupMap();

            % RoadRouteSignalGroupMapの作成
            obj.makeRoadRouteSignalGroupMap();

            % phiとuの結果を格納するクラスの初期化
            obj.PhiResults = tool.PhiResults(obj.N_p, obj.N_c, obj.N_s);
            obj.UResults = tool.UResults(obj.signal_num, obj.N_p, obj.N_c);
            
            % 余った予測分を計算時間確保に利用するために最初だけ結果を固定しておく
            u_0 = zeros(obj.signal_num, 1);
            u_0(obj.PhaseSignalGroupMap(1)) = ones(obj.road_num, 1);
            obj.UResults.setInitialFutureData(u_0);

            % 予測回数の初期化
            obj.prediction_count = 0; 
            obj.success_count = 0;
            obj.calc_time = 0;

            % 決定変数の種類とそれに該当するリストを作成
            obj.VariableListMap = containers.Map('KeyType', 'char', 'ValueType', 'any'); 

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
        makeA(obj);
        makeB1(obj);
        makeB2(obj);
        makeB3(obj);
        makeC(obj);    
        makeD1(obj);
        makeD2(obj);
        makeD3(obj);
        makeE(obj);

        % 先行車を見つける関数
        value = getFrontVehicle(obj, veh_id, road_id, link_id);
        value = getDifferentRouteVehicle(obj, veh_id, road_id, link_id);

        % 決定変数の種類ごとのリストを作成する関数群

        makeVariablesList(obj);

        makeDelta1List(obj);
        makeDelta2List(obj);
        makeDelta3List(obj);

        makeDeltaDList(obj);
        makeDeltaPList(obj);
        makeDeltaF2List(obj);
        makeDeltaF3List(obj);
        makeDeltaBList(obj);
        
        makeDeltaCList(obj);

        makeZ1List(obj);
        makeZ2List(obj);
        makeZ3List(obj);
        makeZ4List(obj);
        makeZ5List(obj);

        % 混合整数線形計画問題の形にMLDの係数と信号機制約の係数を変形する関数群
        makeMilp(obj);
        makeObjectiveFunction(obj, templete_id);
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