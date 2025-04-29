function makeBoundary(obj)

    if obj.phase_comparison_flg && obj.road_num == 4
        for num_phases = obj.comparison_phases
            tmp_matrices = obj.MILPMatrixMap(num_phases);
            obj.variables_size = size(tmp_matrices.P, 2);
            lb = zeros(1, obj.variables_size);
            ub = ones(1, obj.variables_size);

            intcon_binary = tmp_matrices.intcon_binary;
            for variables_id = 1: obj.variables_size
                if intcon_binary(variables_id) == 0
                    ub(variables_id) = Inf;
                end
            end

            tmp_matrices.lb = lb;
            tmp_matrices.ub = ub;
            obj.MILPMatrixMap(num_phases) = tmp_matrices;
        end
    else
        lb = zeros(1, obj.variables_size);
        ub = ones(1, obj.variables_size);
    
        intcon_binary = obj.milp_matrices.intcon_binary;
        for variables_id = 1: obj.variables_size
            if intcon_binary(variables_id) == 0
                ub(variables_id) = Inf;
            end
        end
    
        obj.milp_matrices.lb = lb;
        obj.milp_matrices.ub = ub; 
    end
    
end