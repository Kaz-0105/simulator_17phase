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

    if obj.phase_comparison_flg && obj.road_num == 4
        for num_phases = [4, 8, 17]
            obj.tmp_phase_num = num_phases;

            % P、qに代入
            tmp_matrices = obj.MILPMatrixMap(num_phases);
            tmp_matrices.P = [tmp_matrices.P; C_bar*B_bar + D_bar];
            tmp_matrices.q = [tmp_matrices.q; E_bar - C_bar*A_bar*obj.pos_vehs_init];

            % 信号機制約を追加していく
            % 信号機の変数が増えた分の変数を追加
            [row_num, ~] = size(tmp_matrices.P);
            tmp_matrices.P = [tmp_matrices.P, zeros(row_num, obj.tmp_phase_num*obj.N_p + (obj.signal_num + 1)*(obj.N_p-1))];
            [~, obj.variables_size] = size(tmp_matrices.P);

            % フェーズの変数の定義
            for phase_id = 1: obj.tmp_phase_num
                phase_group = obj.PhaseSignalGroupMap(phase_id);

                for step = 1:obj.N_p
                    P_tmp = zeros(2, obj.variables_size);

                    for order = 1: obj.road_num
                        P_tmp(:, phase_group(order) + obj.v_length*(step-1)) = [-1; 1];
                    end
                    P_tmp(:, obj.v_length*obj.N_p + phase_id + obj.tmp_phase_num*(step-1)) = [obj.road_num; -1];

                    q_tmp = [0; obj.road_num - 1];

                    % P、qにプッシュ
                    tmp_matrices.P = [tmp_matrices.P; P_tmp];
                    tmp_matrices.q = [tmp_matrices.q; q_tmp];
                end
            end

            % 信号現示の変化のバイナリ変数を定義 
            for step = 1:(obj.N_p - 1)
                P_tmp = [];
                q_tmp = [];
                for signal_id = 1: obj.signal_num
                    p_tmp = zeros(4, obj.variables_size);
                    p_tmp(:, signal_id + obj.v_length*(step - 1)) = [1; -1; -1; 1];
                    p_tmp(:, signal_id + obj.v_length*step) = [1; -1; 1; -1];
                    p_tmp(:, obj.v_length*obj.N_p + obj.tmp_phase_num*obj.N_p + signal_id + (obj.signal_num + 1)*(step - 1)) = [1; 1; -1; -1];

                    P_tmp = [P_tmp; p_tmp];
                    q_tmp = [q_tmp; 2; 0; 0; 0];
                end

                tmp_matrices.P = [tmp_matrices.P; P_tmp];
                tmp_matrices.q = [tmp_matrices.q; q_tmp];
            end

            % 青になっていい信号の数の制限
            for step = 1:obj.N_p
                P_tmp = zeros(1, obj.variables_size);
                P_tmp(1, 1 + obj.v_length*(step-1): obj.signal_num +obj.v_length*(step-1)) = ones(1, obj.signal_num);
                tmp_matrices.P = [tmp_matrices.P; P_tmp];
                tmp_matrices.q = [tmp_matrices.q; obj.road_num];
            end

            % 青になっていいフェーズの数の制限
            for step = 1:obj.N_p
                P_tmp = zeros(1, obj.variables_size);
                for phase_id = 1: obj.tmp_phase_num
                    P_tmp(1, obj.v_length*obj.N_p + phase_id + obj.tmp_phase_num*(step-1)) = 1;
                end
                tmp_matrices.Peq = [tmp_matrices.Peq; P_tmp];
                tmp_matrices.qeq = [tmp_matrices.qeq; 1];
            end

            % 信号の変化の回数の制限
            P_tmp = zeros(1, obj.variables_size);

            for step = 1:(obj.N_p-1)
                P_tmp(1, obj.v_length*obj.N_p + obj.tmp_phase_num*obj.N_p + (obj.signal_num + 1)*step) = 1;
            end

            tmp_matrices.P = [tmp_matrices.P; P_tmp];
            tmp_matrices.q = [tmp_matrices.q; obj.m];

            % delta_cの固定
            deltac_list = obj.VariableListMap('delta_c');
            
            for veh_id = 1:length(deltac_list)
                for step = 1:obj.N_p
                    P_tmp = zeros(1, obj.variables_size);
                    P_tmp(deltac_list(veh_id) + obj.v_length*(step-1)) = 1;
                    tmp_matrices.Peq = [tmp_matrices.Peq; P_tmp];

                    q_tmp = 1;
                    tmp_matrices.qeq = [tmp_matrices.qeq; q_tmp];
                end
            end

            % 信号機全体で変化しているかのバイナリの定義
            for step = 1:(obj.N_p-1)
                P_tmp = zeros(2, obj.variables_size);

                for signal_id = 1: obj.signal_num
                    P_tmp(:, obj.v_length*obj.N_p + obj.tmp_phase_num*obj.N_p + signal_id + (obj.signal_num + 1)*(step - 1)) = [-1; 1];
                end

                P_tmp(:, obj.v_length*obj.N_p + obj.tmp_phase_num*obj.N_p + (obj.signal_num + 1)*step) = [1; -obj.road_num*(obj.road_num - 1)];

                q_tmp = [0; 0];

                tmp_matrices.P = [tmp_matrices.P; P_tmp];
                tmp_matrices.q = [tmp_matrices.q; q_tmp];
            end 

            % 初期値の固定
            for step = 1:obj.num_fix_steps
                P_tmp = zeros(obj.signal_num, obj.variables_size);
                for signal_id = 1:obj.signal_num
                    P_tmp(signal_id, signal_id + obj.v_length*(step -1)) = 1;
                end
                tmp_matrices.Peq = [tmp_matrices.Peq; P_tmp];

                u_data = obj.UResults.get('future_data');
                q_tmp = u_data(:, step);
                tmp_matrices.qeq = [tmp_matrices.qeq; q_tmp];
            end

            % 最小連続回数について
            for step = 1: obj.N_p -1
                P_tmp = zeros(1, obj.variables_size);
                q_tmp = 1;

                for i = 1: step
                    P_tmp(1, obj.v_length*obj.N_p + obj.tmp_phase_num*obj.N_p + (obj.signal_num + 1)*i) = 1;
                end

                phi_past_data = obj.PhiResults.get('past_data');

                for j = 1: obj.N_s - step
                    q_tmp = q_tmp - phi_past_data(end - j + 1);
                end

                tmp_matrices.P = [tmp_matrices.P; P_tmp];
                tmp_matrices.q = [tmp_matrices.q; q_tmp];
            end

            % MILPMatrixMapに格納
            obj.MILPMatrixMap(num_phases) = tmp_matrices;
        end
    else
        % P、qに代入  
        obj.milp_matrices.P = [obj.milp_matrices.P; C_bar*B_bar + D_bar];
        obj.milp_matrices.q = [obj.milp_matrices.q; E_bar - C_bar*A_bar*obj.pos_vehs_init];

        % 信号機制約を追加していく
        % 信号機の変数が増えた分の変数を追加
        [row_num, ~] = size(obj.milp_matrices.P);
        obj.milp_matrices.P = [obj.milp_matrices.P, zeros(row_num, obj.tmp_phase_num*obj.N_p + (obj.signal_num + 1)*(obj.N_p-1))];
        [~, obj.variables_size] = size(obj.milp_matrices.P);

        % フェーズの変数の定義
        for phase_id = 1: obj.tmp_phase_num
            phase_group = obj.PhaseSignalGroupMap(phase_id);

            for step = 1:obj.N_p
                P_tmp = zeros(2, obj.variables_size);

                for order = 1: obj.road_num
                    P_tmp(:, phase_group(order) + obj.v_length*(step-1)) = [-1; 1];
                end
                P_tmp(:, obj.v_length*obj.N_p + phase_id + obj.tmp_phase_num*(step-1)) = [obj.road_num; -1];

                q_tmp = [0; obj.road_num - 1];

                % P、qにプッシュ
                obj.milp_matrices.P = [obj.milp_matrices.P; P_tmp];
                obj.milp_matrices.q = [obj.milp_matrices.q; q_tmp];
            end
        end

        % 信号現示の変化のバイナリ変数を定義 
        for step = 1:(obj.N_p - 1)
            P_tmp = [];
            q_tmp = [];
            for signal_id = 1: obj.signal_num
                p_tmp = zeros(4, obj.variables_size);
                p_tmp(:, signal_id + obj.v_length*(step - 1)) = [1; -1; -1; 1];
                p_tmp(:, signal_id + obj.v_length*step) = [1; -1; 1; -1];
                p_tmp(:, obj.v_length*obj.N_p + obj.tmp_phase_num*obj.N_p + signal_id + (obj.signal_num + 1)*(step - 1)) = [1; 1; -1; -1];

                P_tmp = [P_tmp; p_tmp];
                q_tmp = [q_tmp; 2; 0; 0; 0];
            end

            obj.milp_matrices.P = [obj.milp_matrices.P; P_tmp];
            obj.milp_matrices.q = [obj.milp_matrices.q; q_tmp];
        end

        % 青になっていい信号の数の制限
        for step = 1:obj.N_p
            P_tmp = zeros(1, obj.variables_size);
            P_tmp(1, 1 + obj.v_length*(step-1): obj.signal_num +obj.v_length*(step-1)) = ones(1, obj.signal_num);
            obj.milp_matrices.P = [obj.milp_matrices.P; P_tmp];

            obj.milp_matrices.q = [obj.milp_matrices.q; obj.road_num];
        end

        % 青になっていいフェーズの数の制限
        for step = 1:obj.N_p
            P_tmp = zeros(1, obj.variables_size);
            for phase_id = 1: obj.tmp_phase_num
                P_tmp(1, obj.v_length*obj.N_p + phase_id + obj.tmp_phase_num*(step-1)) = 1;
            end
            obj.milp_matrices.Peq = [obj.milp_matrices.Peq; P_tmp];
            obj.milp_matrices.qeq = [obj.milp_matrices.qeq; 1];
        end

        % 信号の変化の回数の制限
        P_tmp = zeros(1, obj.variables_size);

        for step = 1:(obj.N_p-1)
            P_tmp(1, obj.v_length*obj.N_p + obj.tmp_phase_num*obj.N_p + (obj.signal_num + 1)*step) = 1;
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

        % 信号機全体で変化しているかのバイナリの定義
        for step = 1:(obj.N_p-1)
            P_tmp = zeros(2, obj.variables_size);

            for signal_id = 1: obj.signal_num
                P_tmp(:, obj.v_length*obj.N_p + obj.tmp_phase_num*obj.N_p + signal_id + (obj.signal_num + 1)*(step - 1)) = [-1; 1];
            end

            P_tmp(:, obj.v_length*obj.N_p + obj.tmp_phase_num*obj.N_p + (obj.signal_num + 1)*step) = [1; -obj.road_num*(obj.road_num - 1)];

            q_tmp = [0; 0];

            obj.milp_matrices.P = [obj.milp_matrices.P; P_tmp];
            obj.milp_matrices.q = [obj.milp_matrices.q; q_tmp];
        end 

        % 初期値の固定
        for step = 1:obj.num_fix_steps
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
                P_tmp(1, obj.v_length*obj.N_p + obj.tmp_phase_num*obj.N_p + (obj.signal_num + 1)*i) = 1;
            end

            phi_past_data = obj.PhiResults.get('past_data');

            for j = 1: obj.N_s - step
                q_tmp = q_tmp - phi_past_data(end - j + 1);
            end

            obj.milp_matrices.P = [obj.milp_matrices.P; P_tmp];
            obj.milp_matrices.q = [obj.milp_matrices.q; q_tmp];
        end
    end
end