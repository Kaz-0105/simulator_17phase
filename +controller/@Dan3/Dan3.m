classdef Dan3 < handle
    properties(GetAccess = private)
        id; % 交差点のID
        signal_num; % 信号機の数
        dt; % タイムステップ
        N_p; % 予測ホライゾン
        N_c; % 制御ホライゾン
        N_s; % 最低の連続回数
        eps; % 微小量
        m; % ホライゾン内の最大変化回数
        fix_num; % 固定するステップ数
        phase_num = 4; % 信号機のフェーズ数

        road_prms; % 交差点を構成する東西南北の道路のパラメータを収納する構造体

        PhiResults; % 全体として信号現示が変化したことを示すバイナリphiの結果を格納するクラス
        UResults; % 信号現示のバイナリuの結果を格納するクラス

        pos_vehs; % 自動車の位置情報をまとめた構造体
        route_vehs; % 自動車の進行方向の情報をまとめた構造体
        num_vehs; % 自動車の数をまとめた構造体
        first_veh_ids; % 先頭車の情報をまとめた構造体

        mld_matrices; % 混合論理動的システムの係数行列を収納する構造体
        milp_matrices; % 混合整数線形計画問題の係数行列を収納する構造体

        VariableListMap; % 決定変数の種類ごとのリストを収納するdictionary
        u_length;           % uの決定変数の数
        z_length;           % zの決定変数の数
        delta_length;       % deltaの決定変数の数

        v_length; % MLDの決定変数の長さ
        variables_size; % 決定変数の数
        prediction_count = 0; % 予測回数

        x_opt; % 最適解
        fval; % 最適解の目的関数の値
        exitflag;
        calc_time = 0; % 計算時間

        u_opt; % 最適解から次の最適化に必要な信号現示の部分
        phi_opt; % 最適解から次の最適化に必要な全体として信号現示が変化したことを示すバイナリphiの部分


    end

    methods(Access = public)
        function obj = dan_3fork(id, Config, maps)
            obj.id = id; % 交差点のID
            obj.signal_num = 6; % 信号機の数（今回は各道路2車線なので6）
            obj.u_length = obj.signal_num;
            obj.dt = Config.time_step; % タイムステップ
            obj.N_p = Config.predictive_horizon; % 予測ホライゾン
            obj.N_c = Config.control_horizon; % 制御ホライゾン
            obj.N_s = Config.model_prms.N_s; % 最低の連続回数
            obj.eps = Config.model_prms.eps; % 微小量
            obj.m = Config.model_prms.m; % ホライゾン内の最大変化回数
            obj.fix_num = Config.model_prms.fix_num; % 固定するステップ数

            obj.makeRoadPrms(maps) % 交差点の東西南北の道路のパラメータを収納する構造体を作成

            obj.PhiResults = tool.PhiResults(obj.N_p, obj.N_c, obj.N_s); % PhiResultsクラスの初期化
            obj.UResults = tool.UResults(obj.signal_num, obj.N_p, obj.N_c); % UResultsクラスの初期化
            obj.UResults.setInitialFutureData([1,0,1,0,1,0]'); % モデルに出てくる前回の信号現示の部分でエラーを起こさないために設定

            obj.prediction_count = 0; % 予測回数の初期化

            obj.VariableListMap = dictionary(string.empty, cell.empty); % 決定変数の種類ごとのリストを収納するdictionaryの初期化
        end

        % 混合整数線形計画問題を解く関数
        function sig = optimize(obj)

            % 混合整数線形計画問題を解く

            f = obj.milp_matrices.f;
            intcon = obj.milp_matrices.intcon;
            P = obj.milp_matrices.P;
            q = obj.milp_matrices.q;
            Peq = obj.milp_matrices.Peq;
            qeq = obj.milp_matrices.qeq;
            lb = obj.milp_matrices.lb;
            ub = obj.milp_matrices.ub;

            if ~isempty(P)
                % 交差点内に自動車が存在するとき

                options = optimoptions('intlinprog');
                options.IntegerTolerance = 1e-3;
                options.ConstraintTolerance = 1e-3;
                options.RelativeGapTolerance = 1e-3;
                options.MaxTime = 10;
                options.Display = 'final';

                tic;

                [obj.x_opt, obj.fval, obj.exitflag] = intlinprog(f', intcon, P, q, Peq, qeq, lb, ub, options);

                obj.calc_time = toc;

                if ~isempty(obj.x_opt)
                    % 実行可能解が見つかったとき
                    % 最適解から次の最適化に必要な決定変数を抽出
                    obj.makeUOpt();
                    obj.makePhiOpt();
                else
                    % 実行可能解が見つからなかったとき
                    % 自動車台数が多いところを出す

                    obj.emergencyTreatment();
                    obj.calc_time = 0;
                end
            else
                % 交差点内に自動車が存在しないとき
                % 今の信号現示を維持する

                u_future = obj.UResults.get('future_data');
                obj.u_opt = [];

                for step = 1:obj.N_p
                    obj.u_opt = [obj.u_opt, u_future(:, 1)];
                end

                obj.phi_opt = zeros(1, obj.N_p -1);
                obj.calc_time = 0;
            end

            obj.UResults.updateData(obj.u_opt); % 信号現示のバイナリuの結果を更新
            obj.PhiResults.updateData(obj.phi_opt) % 全体として信号現示が変化したことを示すバイナリphiの結果を更新

            sig = obj.u_opt;
            
            obj.prediction_count = obj.prediction_count + 1; % 予測回数をカウント

            fprintf('交差点%dの最適化結果:\n', obj.id);
            disp(sig);

        end
    end

    methods(Access = public)
        value = get(obj, property_name);
        updateStates(obj, IntersectionStructMap, VissimData);
    end

    methods(Access = private)
        makeRoadPrms(obj, maps);
        makeVehiclesData(obj, intersection_struct_map, vis_data);

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
        front_veh_id = getFrontVehId(veh_id, route_vehs);
    end
end