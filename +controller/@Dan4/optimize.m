% 混合整数線形計画問題を解く関数
function optimize(obj)

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
        options.MaxTime = 15;
        options.Display = 'final';

        tic;

        [obj.x_opt, obj.fval, obj.exitflag] = intlinprog(f', intcon, P, q, Peq, qeq, lb, ub, options);

        obj.calc_time = toc;

        if ~isempty(obj.x_opt)
            % 実行可能解が見つかったとき
            % 最適解から次の最適化に必要な決定変数を抽出
            obj.makeUOpt();
            obj.makePhiOpt();

            obj.success_count = obj.success_count + 1;
            obj.makePosVehsResult();
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
    
    obj.prediction_count = obj.prediction_count + 1; % 予測回数をカウント

    fprintf('交差点%dの最適化結果:\n', obj.id);
    disp(obj.u_opt);

    fprintf('最適化成功率：\n');
    obj.success_rate = obj.success_count / obj.prediction_count;
    disp(obj.success_rate);
end