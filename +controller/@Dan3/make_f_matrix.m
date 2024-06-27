function makeObjectiveFunction(obj)
    f = zeros(1, obj.variables_size);

    delta1_list = obj.VariableListMap('delta_1');

    for delta1_num = delta1_list
        for step = 1: obj.N_p
            f(delta1_num + obj.v_length*(step-1)) = 1;
        end
    end

    obj.milp_matrices.f = f;
end