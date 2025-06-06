% 混合整数線形計画問題を解く関数
function optimize(obj)
    % 予測回数をインクリメント
    obj.prediction_count = obj.prediction_count + 1;


    if obj.phase_comparison_flg && obj.road_num == 4
        empty_flg = false;

        % intlinprogのオプションを設定
        options = optimoptions('intlinprog');
        options.AbsoluteGapTolerance = 1e-2;
        options.RelativeGapTolerance = 0;
        options.IntegerTolerance = 1e-3;
        options.MaxTime = obj.max_time;
        options.Display = 'final';

        % 最適化計算をそれぞれのフェーズで行う
        for num_phases = obj.comparison_phases
            tmp_matrices = obj.MILPMatrixMap(num_phases);
            f = tmp_matrices.f;
            intcon = tmp_matrices.intcon;
            P = tmp_matrices.P;
            q = tmp_matrices.q;
            Peq = tmp_matrices.Peq;
            qeq = tmp_matrices.qeq;
            lb = tmp_matrices.lb;
            ub = tmp_matrices.ub;

            if (isempty(P))
                empty_flg = true;
                break;
            end

            % 計算時間の測定の開始
            tic;

            % intlinprogでMILPを解く
            if (num_phases == obj.comparison_phases(1))
                [obj.x_opt, obj.fval, obj.exitflag] = intlinprog(f', intcon, P, q, Peq, qeq, lb, ub, options);
                obj.FunctionValueMap(num_phases) = [obj.FunctionValueMap(num_phases), obj.fval];
            else
                [~, fval, ~] = intlinprog(f', intcon, P, q, Peq, qeq, lb, ub, options);
                obj.FunctionValueMap(num_phases) = [obj.FunctionValueMap(num_phases), fval];
            end

            if obj.model_error_flg && (num_phases == obj.comparison_phases(1))
                current_time = obj.Vissim.get('current_time');
                time_queue_data = [];
                for step = 1:obj.N_p
                    time = current_time + (step - 1) * obj.dt;
                    num_queues = obj.fs_by_step(step) * obj.x_opt;
                    time_queue_data = [time_queue_data, [time; num_queues]];                    
                end
                obj.TimeNumQueuesMap(current_time) = time_queue_data;
            end

            % 計算時間の測定の終了
            obj.calc_time = toc;

            if (num_phases == obj.comparison_phases(1))
                % 終了ステータスによって処理が異なる

                % exitflagの値の意味
                %  3 : The solution is feasible with respect to the relative ConstraintTolerance tolerance, but is not feasible with respect to the absolute tolerance.
                %  2 : intlinprog stopped prematurely. Integer feasible point found.
                %  1 : intlinprog converged to the solution x.
                %  0 : intlinprog stopped prematurely. No integer feasible point found.
                % -1 : intlinprog stopped by an output function or plot function.
                % -2 : No feasible point found.
                % -3 : Root LP problem is unbounded.
                % -9 : Solver lost feasibility.

                if obj.exitflag >= 1
                    % x_optからu_optとphi_optを作成
                    obj.makeUOpt();
                    obj.makePhiOpt();

                    % 最適解が見つかった回数をインクリメント
                    obj.success_count = obj.success_count + 1;
                else
                    % 例外処理によってu_optとphi_optを作成
                    obj.emergencyTreatment();
                end
            end
        end

        if (empty_flg)
            % 今の信号現示を維持する
            u_future = obj.UResults.get('future_data');
            obj.u_opt = [];

            for step = 1:obj.N_s
                obj.u_opt = [obj.u_opt, u_future(:, step)];
            end

            for step = obj.N_s + 1:obj.N_p
                obj.u_opt = [obj.u_opt, u_future(:, obj.N_s)];
            end

            obj.phi_opt = zeros(1, obj.N_p -1);
            obj.calc_time = 0;
        end
    else
        % 混合整数線形計画問題を解く
        f = obj.milp_matrices.f;
        intcon = obj.milp_matrices.intcon;
        P = obj.milp_matrices.P;
        q = obj.milp_matrices.q;
        Peq = obj.milp_matrices.Peq;
        qeq = obj.milp_matrices.qeq;
        lb = obj.milp_matrices.lb;
        ub = obj.milp_matrices.ub;

        % 交差点内に自動車が存在するかどうかで場合分け
        if ~isempty(P)
            % intlinprogのオプションを設定
            options = optimoptions('intlinprog');
            options.AbsoluteGapTolerance = 0;
            options.RelativeGapTolerance = 0;
            options.MaxTime = obj.max_time;
            options.Display = 'final';

            % 計算時間の測定の開始
            tic;

            % intlinprogでMILPを解く
            [obj.x_opt, obj.fval, obj.exitflag] = intlinprog(f', intcon, P, q, Peq, qeq, lb, ub, options);
            obj.function_values = [obj.function_values, obj.fval];

            if obj.model_error_flg
                current_time = obj.Vissim.get('current_time');
                time_queue_data = [];
                for step = 1:obj.N_p
                    time = current_time + (step - 1) * obj.dt;
                    num_queues = obj.fs_by_step(step) * obj.x_opt;
                    time_queue_data = [time_queue_data, [time; num_queues]];                    
                end
                obj.TimeNumQueuesMap(current_time) = time_queue_data;
            end

            % 計算時間の測定の終了
            obj.calc_time = toc;

            % 終了ステータスによって処理が異なる

            % exitflagの値の意味
            %  3 : The solution is feasible with respect to the relative ConstraintTolerance tolerance, but is not feasible with respect to the absolute tolerance.
            %  2 : intlinprog stopped prematurely. Integer feasible point found.
            %  1 : intlinprog converged to the solution x.
            %  0 : intlinprog stopped prematurely. No integer feasible point found.
            % -1 : intlinprog stopped by an output function or plot function.
            % -2 : No feasible point found.
            % -3 : Root LP problem is unbounded.
            % -9 : Solver lost feasibility.

            if obj.exitflag >= 1
                % x_optからu_optとphi_optを作成
                obj.makeUOpt();
                obj.makePhiOpt();

                % 最適解が見つかった回数をインクリメント
                obj.success_count = obj.success_count + 1;

                % フェーズ数の再設定
                if obj.road_num == 4
                    obj.tmp_phase_num = obj.phase_num;
                elseif obj.road_num == 5
                    obj.tmp_phase_num = obj.phase_num;
                end
            else
                % フェーズ数の再設定
                if obj.road_num == 4
                    if obj.phase_num == 4
                        obj.tmp_phase_num = 4;
                    else
                        obj.tmp_phase_num = 8;
                    end
                elseif obj.road_num == 5
                    obj.tmp_phase_num = 10;
                end
                
                % 例外処理によってu_optとphi_optを作成
                obj.emergencyTreatment();
            end
        else
            % 今の信号現示を維持する
            u_future = obj.UResults.get('future_data');
            obj.u_opt = [];

            for step = 1:obj.N_s
                obj.u_opt = [obj.u_opt, u_future(:, step)];
            end

            for step = obj.N_s + 1:obj.N_p
                obj.u_opt = [obj.u_opt, u_future(:, obj.N_s)];
            end

            obj.phi_opt = zeros(1, obj.N_p -1);
            obj.calc_time = 0;
        end
    end

    % u_optとphi_optを記録
    obj.UResults.updateData(obj.u_opt); 
    obj.PhiResults.updateData(obj.phi_opt);

    % 結果を表示
    fprintf('交差点%dの最適化結果:\n', obj.id);
    disp(obj.u_opt);

    % 最適化成功率を表示
    fprintf('最適化成功率：\n');
    obj.success_rate = obj.success_count / obj.prediction_count;
    disp(obj.success_rate);
end