function makeBoundary(obj)

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