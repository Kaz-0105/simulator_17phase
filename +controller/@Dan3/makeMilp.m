function makeMilp(obj)

    
    obj.milp_matrices.f = [];
    obj.milp_matrices.P = [];
    obj.milp_matrices.q = [];
    obj.milp_matrices.Peq = [];
    obj.milp_matrices.qeq = [];
    obj.milp_matrices.intcon = [];
    obj.milp_matrices.intcon_binary = [];
    obj.milp_matrices.lb = [];
    obj.milp_matrices.ub = [];

    % 系に一台も自動車が存在しない場合は計算の必要がないため空の行列を返す
    if isempty(obj.mld_matrices.A)
        return;
    end
   
    % 等式制約と不等式制約の作成
    obj.makeConstraints(obj.mld_matrices, obj.pos_vehs);

    % 目的関数の作成
    obj.makeObjectiveFunction();

    % 整数制約の作成
    obj.makeIntcon();

    % 決定変数の上下限の作成
    obj.makeBoundary();


end
