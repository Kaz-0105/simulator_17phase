function makeMilp(obj)
    % MILPの行列を作成する
    matrices_template = struct('f', [], 'w', [], 'P', [], 'q', [], 'Peq', [], 'qeq', [], 'intcon', [], 'intcon_binary', [], 'lb', [], 'ub', []);
    if obj.phase_comparison_flg && obj.road_num == 4
        for num_phases = [4, 8, 17]
            obj.MILPMatrixMap(num_phases) = matrices_template;
        end
    else
        obj.milp_matrices = matrices_template;
    end

    % 系に一台も自動車が存在しない場合は計算の必要がないため空の行列を返す
    if isempty(obj.mld_matrices.A)
        return;
    end
   
    % 等式制約と不等式制約の作成
    obj.makeConstraints();

    % 目的関数の作成
    obj.makeObjectiveFunction(3);

    % 整数制約の作成
    obj.makeIntcon();

    % 決定変数の上下限の作成
    obj.makeBoundary();
end
