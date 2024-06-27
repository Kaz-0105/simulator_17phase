function makeObjectiveFunction(obj, templete_id)
    f = zeros(1, obj.variables_size);
    delta1_list = obj.VariableListMap('delta_1');
    if (templete_id == 1)
        for delta1_num = delta1_list
            for step = 1: obj.N_p
                f(delta1_num + obj.v_length*(step-1)) = 1;
            end
        end
    elseif (templete_id == 2)
        % delta_1に重みをつける
        obj.makeWeight();
        for i = 1: length(delta1_list)
            delta1_num = delta1_list(i);
            for step = 1: obj.N_p
                f(delta1_num + obj.v_length*(step-1)) = obj.milp_matrices.w(i);
            end
        end
    elseif (templete_id == 3)
        % delta_1, delta_3を使う
        deltaf3_list = obj.VariableListMap('delta_f3');

        for delta1_num = delta1_list
            for step = 1: obj.N_p
                f(delta1_num + obj.v_length*(step-1)) = 1;
            end
        end
        for deltaf3_num = deltaf3_list
            for step = 1: obj.N_p
                f(deltaf3_num + obj.v_length*(step-1)) = 1;
            end
        end
    end

    obj.milp_matrices.f = f;
end