function makeObjectiveFunction(obj, template_id)
    f = zeros(1, obj.variables_size);
    delta1_list = obj.VariableListMap('delta_1');
    delta4_list = obj.VariableListMap('delta_4');
    if template_id == 1
        % delta_1を使用、重みはなし
        for delta1_num = delta1_list
            for step = 1: obj.N_p
                f(delta1_num + obj.v_length*(step-1)) = 1;
            end
        end
    elseif template_id == 2
        % delta_1を使用、重みをつける
        obj.makeWeight();
        for i = 1: length(delta1_list)
            delta1_num = delta1_list(i);
            for step = 1: obj.N_p
                f(delta1_num + obj.v_length*(step-1)) = obj.milp_matrices.w.delta1(i);
            end
        end
    elseif template_id == 3
        % delta_1とdelta_4を使用、重みはなし
        for delta1_num = delta1_list
            for step = 1: obj.N_p
                f(delta1_num + obj.v_length*(step-1)) = 1;
            end
        end
        for delta4_num = delta4_list
            for step = 1: obj.N_p
                f(delta4_num + obj.v_length*(step-1)) = 1;
            end
        end

    elseif template_id == 4
        % delta_1とdelta_4を使用、重みをつける
        obj.makeWeight();
        for i = 1: length(delta1_list)
            delta1_num = delta1_list(i);
            for step = 1: obj.N_p
                f(delta1_num + obj.v_length*(step-1)) = obj.milp_matrices.w.delta1(i);
            end
        end

        for i = 1: length(delta4_list)
            delta4_num = delta4_list(i);
            for step = 1: obj.N_p
                f(delta4_num + obj.v_length*(step-1)) = obj.milp_matrices.w.delta4(i);
            end
        end
    end

    obj.milp_matrices.f = f;
end