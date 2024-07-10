classdef Dan3 < handle
    properties
        % クラス
        Config; % Configクラスの変数
        Vissim; % Vissimクラスの変数

        PhiResults; % phiの結果を格納するクラス
        UResults;   % uの結果を格納するクラス
    end

    properties
        % 普通のプロパティ
        id;         % 交差点のID 
        signal_num; % 信号機の数
        phase_num;  % 信号機のフェーズの数
        road_num;   % 道路の数

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
        success_count;    % 最適化成功回数
        success_rate;     % 最適化成功率
    end

    properties
        % 構造体
        mld_matrices;  % 混合論理動的システムの係数行列を収納する構造体
        milp_matrices; % 混合整数線形計画問題の係数行列を収納する構造体
    end

    properties
        % 構造体
        road_prms;     % 道路に関するパラメータを格納する構造体
        pos_vehs;      % 車の位置情報を格納する構造体
        route_vehs;    % 車の進行方向の情報を格納する構造体
        num_vehs;      % 車の数を格納する構造体
        first_veh_ids; % 先頭車の情報を格納する構造体
    end

    properties
        % リスト
        pos_vehs_initial; % 自動車の初期位置のリスト
        pos_vehs_result;  % 予測の最終結果のリスト

        x_opt;   % 最適解のリスト
        u_opt;   % uの最適解のリスト
        phi_opt; % phiの最適解のリスト 
    end

    properties
        % Map
        VariableListMap;     % 決定変数のリストを格納するMap
        PhaseSignalGroupMap; % フェーズを構成するSignalGroupを収納するMap
        Maps;                % Vissimクラスで作成したMap群
    end

    methods(Access = public)
        function obj = Dan3(id, Config, Maps)
            % 交差点のID、SignalGroupの数、Phaseの数、道路の数を設定
            obj.id = id;
            obj.road_num = 3;
            obj.signal_num = obj.road_num *(obj.road_num -1);
            obj.phase_num = 4;
            
            % サンプリング時間
            obj.dt = Config.time_step;

            % 予測ホライゾン、制御ホライゾン
            obj.N_p = Config.predictive_horizon;
            obj.N_c = Config.control_horizon;

            % 最適化時間の上限
            obj.max_time = Config.max_time;

            % 最低の連続回数、ホライゾン内の最大変化回数、固定するステップ数
            obj.N_s = Config.model_prms.N_s;
            obj.m = Config.model_prms.m;
            obj.fix_num = Config.model_prms.fix_num;

            % 微小量
            obj.eps = Config.model_prms.eps;

            % 制御入力の変数の長さ
            obj.u_length = obj.signal_num;
            
            % Mapsの設定
            obj.Maps = Maps;

            % 道路に関するパラメータを格納する構造体を作成
            obj.makeRoadPrms();

            % PhaseとSignalGroupのMapを作成
            obj.makePhaseSignalGroupMap();

            % phiとuの結果を格納するクラスの初期化
            obj.PhiResults = tool.PhiResults(obj.N_p, obj.N_c, obj.N_s); 
            obj.UResults = tool.UResults(obj.signal_num, obj.N_p, obj.N_c); 

            % 余った予測分を計算時間確保に利用するために最初だけ結果を固定しておく
            u_0 = zeros(obj.signal_num, 1);
            u_0(obj.PhaseSignalGroupMap(1)) = ones(obj.road_num, 1);
            obj.UResults.setInitialFutureData(u_0);

            % 予測回数と最適化の計算にかかった時間の変数を初期化
            obj.prediction_count = 0;
            obj.success_count = 0; 
            obj.calc_time = 0; 

            % それぞれの種類の決定変数に対して該当するリストを作成
            obj.VariableListMap = containers.Map('KeyType', 'char', 'ValueType', 'any'); 

            
        end
    end

    methods(Access = public)
        value = get(obj, property_name);
        updateStates(obj, IntersectionStructMap, VissimData);
        optimize(obj);
    end

    methods(Access = private)
        makeRoadPrms(obj, Maps);
        makeVehiclesData(obj, IntersectionStructMap, VissimData);

        % PhaseとSignalGroupのMapを作成する関数
        makePhaseSignalGroupMap(obj);

        % 混合論理動的システムの係数行列を作成する関数群
        makeMld(obj);
        makeA(obj, pos_vehs);
        makeB1(obj, pos_vehs, route_vehs, first_veh_ids, road_prms);
        makeB2(obj, route_vehs, first_veh_ids, road_prms);
        makeB3(obj, route_vehs, first_veh_ids, road_prms);
        makeC(obj, pos_vehs, route_vehs, first_veh_ids, road_prms);    
        makeD1(obj, route_vehs, first_veh_ids, direction);
        makeD2(obj, pos_vehs, first_veh_ids, road_prms);
        makeD3(obj, pos_vehs, first_veh_ids, road_prms);
        makeE(obj, pos_vehs, first_veh_ids, road_prms);

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
        makeObjectiveFunction(obj);
        makeConstraints(obj, mld_matrices, pos_vehs);
        makeBoundary(obj);
        makeIntcon(obj);

        % 最適解と次の最適化に必要な決定変数を抽出する関数群
        makeUOpt(obj, x_opt);
        makePhiOpt(obj, x_opt);
    end

    methods(Static)
        front_veh_id = getFrontVehicle(veh_id, route_vehs);
    end
end