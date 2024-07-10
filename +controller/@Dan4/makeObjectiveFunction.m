function makeObjectiveFunction(obj, templete_id)
    f = zeros(1, obj.variables_size);
    delta1_list = obj.VariableListMap('delta_1');
    delta3_list = obj.VariableListMap('delta_3');
    if templete_id == 1
        % delta_1を使用、重みはなし
        for delta1_num = delta1_list
            for step = 1: obj.N_p
                f(delta1_num + obj.v_length*(step-1)) = 1;
            end
        end
    elseif templete_id == 2
        % delta_1を使用、重みをつける
        obj.makeWeight();
        for i = 1: length(delta1_list)
            delta1_num = delta1_list(i);
            for step = 1: obj.N_p
                f(delta1_num + obj.v_length*(step-1)) = obj.milp_matrices.w(i);
            end
        end
    elseif templete_id == 3
        % delta_3を使用、重みはなし
        for i = 1: length(delta3_list)
            delta3_num = delta3_list(i);
            for step = 1: obj.N_p
                f(delta3_num + obj.v_length*(step-1)) = 1;
            end
        end
    end

    obj.milp_matrices.f = f;
end