function makeConstraints(obj)
    % MLDの式を一つの不等式制約にまとめる

    % MLDの係数を取得
    A = obj.mld_matrices.A;
    B1 = obj.mld_matrices.B1;
    B2 = obj.mld_matrices.B2;
    B3 = obj.mld_matrices.B3;
    C = obj.mld_matrices.C;
    D1 = obj.mld_matrices.D1;
    D2 = obj.mld_matrices.D2;
    D3 = obj.mld_matrices.D3;
    E = obj.mld_matrices.E;

    % B1, B2, B3をまとめる
    B = [B1, B2, B3];

    % D1, D2, D3をまとめる
    D = [D1, D2, D3];

    % MLDの1ステップ分の決定変数の数を取得
    [~, obj.v_length] = size(D);

    % 交差点内の全ての自動車の位置情報をまとめる
    obj.pos_vehs_init = [];
    
    for road_id = 1: obj.road_num
        for link_id = 1: obj.RoadNumLinksMap(road_id)
            % pos_vehsを取得
            pos_vehs = obj.RoadLinkPosVehsMap.get(road_id, link_id);

            % pos_vehs_initに追加
            obj.pos_vehs_init = [obj.pos_vehs_init; pos_vehs];
        end
    end

    % A_bar, B_bar, C_bar, D_bar, E_barを計算
    A_bar = kron(ones(obj.N_p, 1), A); 
    B_bar = kron(tril(ones(obj.N_p), -1), B); 
    C_bar = kron(eye(obj.N_p), C); 
    D_bar = kron(eye(obj.N_p), D);
    E_bar = kron(ones(obj.N_p, 1), E);

    % P、qに代入  
    obj.milp_matrices.P = [obj.milp_matrices.P; C_bar*B_bar + D_bar];
    obj.milp_matrices.q = [obj.milp_matrices.q; E_bar - C_bar*A_bar*obj.pos_vehs_init];

    % 信号機制約を追加していく

    % 信号機の変数が増えた分の変数を追加
    [row_num, ~] = size(obj.milp_matrices.P);
    obj.milp_matrices.P = [obj.milp_matrices.P, zeros(row_num, obj.tmp_phase_num*obj.N_p + (obj.tmp_phase_num + 1)*(obj.N_p-1))];
    [~, obj.variables_size] = size(obj.milp_matrices.P);
    
    for phase_id = 1: obj.tmp_phase_num
        phase_group = obj.PhaseSignalGroupMap(phase_id);

        for step = 1:obj.N_p
            P_tmp = zeros(obj.road_num + 1, obj.variables_size);

            if obj.road_num == 4
                P_tmp(:, phase_group(1) + obj.v_length*(step-1)) = [-1; 0; 0; 0; 1];
                P_tmp(:, phase_group(2) + obj.v_length*(step-1)) = [0; -1; 0; 0; 1];
                P_tmp(:, phase_group(3) + obj.v_length*(step-1)) = [0; 0; -1; 0; 1];
                P_tmp(:, phase_group(4) + obj.v_length*(step-1)) = [0; 0; 0; -1; 1];
                P_tmp(:, obj.v_length*obj.N_p + phase_id + obj.tmp_phase_num*(step-1)) = [1; 1; 1; 1; -1];

                q_tmp = [0; 0; 0; 0; 3];
            elseif obj.road_num == 3
                P_tmp(:, phase_group(1) + obj.v_length*(step-1)) = [-1; 0; 0; 1];
                P_tmp(:, phase_group(2) + obj.v_length*(step-1)) = [0; -1; 0; 1];
                P_tmp(:, phase_group(3) + obj.v_length*(step-1)) = [0; 0; -1; 1];
                P_tmp(:, obj.v_length*obj.N_p + phase_id + obj.tmp_phase_num*(step-1)) = [1; 1; 1; -1];

                q_tmp = [0; 0; 0; 2];

            elseif obj.road_num == 5
                P_tmp(:, phase_group(1) + obj.v_length*(step-1)) = [-1; 0; 0; 0; 0; 1];
                P_tmp(:, phase_group(2) + obj.v_length*(step-1)) = [0; -1; 0; 0; 0; 1];
                P_tmp(:, phase_group(3) + obj.v_length*(step-1)) = [0; 0; -1; 0; 0; 1];
                P_tmp(:, phase_group(4) + obj.v_length*(step-1)) = [0; 0; 0; -1; 0; 1];
                P_tmp(:, phase_group(5) + obj.v_length*(step-1)) = [0; 0; 0; 0; -1; 1];
                P_tmp(:, obj.v_length*obj.N_p + phase_id + obj.tmp_phase_num*(step-1)) = [1; 1; 1; 1; 1; -1];

                q_tmp = [0; 0; 0; 0; 0; 4];
            end

            % P、qにプッシュ
            obj.milp_matrices.P = [obj.milp_matrices.P; P_tmp];
            obj.milp_matrices.q = [obj.milp_matrices.q; q_tmp];
        end
    end

    % 信号現示の変化のバイナリ変数を定義 
    for step = 1:(obj.N_p-1)
        P_tmp = zeros(4*obj.tmp_phase_num, obj.variables_size);

        for phase_id = 1: obj.tmp_phase_num
            P_tmp((1 + 4*(phase_id -1): 4*phase_id), obj.v_length*obj.N_p + phase_id + obj.tmp_phase_num*(step -1)) = [1;-1;-1;1];
            P_tmp((1 + 4*(phase_id -1): 4*phase_id), obj.v_length*obj.N_p + phase_id + obj.tmp_phase_num*step) = [1;-1;1;-1];
            P_tmp((1 + 4*(phase_id -1): 4*phase_id), obj.v_length*obj.N_p + obj.tmp_phase_num*obj.N_p + phase_id + (obj.tmp_phase_num + 1)*(step - 1)) = [1;1;-1;-1];
        end

        obj.milp_matrices.P = [obj.milp_matrices.P; P_tmp];

        q_tmp = zeros(4*obj.tmp_phase_num, 1);

        for phase_id = 1: obj.tmp_phase_num
            q_tmp(1 + 4*(phase_id -1),1) = 2;    
        end

        obj.milp_matrices.q = [obj.milp_matrices.q; q_tmp];
    end


    % 青になっていい信号の数の制限
    for step = 1:obj.N_p
        P_tmp = zeros(1, obj.variables_size);
        P_tmp(1, 1 + obj.v_length*(step-1): obj.signal_num +obj.v_length*(step-1)) = ones(1, obj.signal_num);
        obj.milp_matrices.P = [obj.milp_matrices.P; P_tmp];

        obj.milp_matrices.q = [obj.milp_matrices.q; obj.road_num];
    end

    % 信号の変化の回数の制限
    P_tmp = zeros(1, obj.variables_size);

    for step = 1:(obj.N_p-1)
        P_tmp(1, obj.v_length*obj.N_p + obj.tmp_phase_num*obj.N_p + (obj.tmp_phase_num + 1)*step) = 1;
    end

    obj.milp_matrices.P = [obj.milp_matrices.P; P_tmp];

    obj.milp_matrices.q = [obj.milp_matrices.q; obj.m];

    % delta_cの固定
    deltac_list = obj.VariableListMap('delta_c');
    
    for veh_id = 1:length(deltac_list)
        for step = 1:obj.N_p
            P_tmp = zeros(1, obj.variables_size);
            P_tmp(deltac_list(veh_id) + obj.v_length*(step-1)) = 1;
            obj.milp_matrices.Peq = [obj.milp_matrices.Peq; P_tmp];

            q_tmp = 1;
            obj.milp_matrices.qeq = [obj.milp_matrices.qeq; q_tmp];
        end
    end


    % 増えた変数の定義その２ 
    for step = 1:(obj.N_p-1)
        P_tmp = zeros(1, obj.variables_size);
        P_tmp(obj.v_length*obj.N_p + obj.tmp_phase_num*obj.N_p + (obj.tmp_phase_num + 1)*(step -1) + 1 : obj.v_length*obj.N_p + obj.tmp_phase_num*obj.N_p+ (obj.tmp_phase_num + 1)*step) = [-ones(1, obj.tmp_phase_num), 2];
        obj.milp_matrices.Peq = [obj.milp_matrices.Peq; P_tmp];
        obj.milp_matrices.qeq = [obj.milp_matrices.qeq; 0];
    end
    

    % 初期値の固定
    for step = 1:obj.fix_num
        P_tmp = zeros(obj.signal_num, obj.variables_size);
        for signal_id = 1:obj.signal_num
            P_tmp(signal_id, signal_id + obj.v_length*(step -1)) = 1;
        end
        obj.milp_matrices.Peq = [obj.milp_matrices.Peq; P_tmp];

        u_data = obj.UResults.get('future_data');
        q_tmp = u_data(:, step);
        obj.milp_matrices.qeq = [obj.milp_matrices.qeq; q_tmp];
    end

    % 最小連続回数について
    for step = 1: obj.N_p -1
        P_tmp = zeros(1, obj.variables_size);
        q_tmp = 1;

        for i = 1: step
            P_tmp(1, obj.v_length*obj.N_p + obj.tmp_phase_num*obj.N_p + (obj.tmp_phase_num + 1)*i) = 1;
        end

        phi_past_data = obj.PhiResults.get('past_data');

        for j = 1: obj.N_s - step
            q_tmp = q_tmp - phi_past_data(end - j + 1);
        end

        obj.milp_matrices.P = [obj.milp_matrices.P; P_tmp];
        obj.milp_matrices.q = [obj.milp_matrices.q; q_tmp];

    end


end