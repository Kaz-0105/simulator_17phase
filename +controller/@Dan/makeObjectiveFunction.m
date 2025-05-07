function makeObjectiveFunction(obj, template_id)
    delta1_list = obj.VariableListMap('delta_1');
    delta4_list = obj.VariableListMap('delta_4');

    if obj.phase_comparison_flg && obj.road_num == 4
        for num_phases = obj.comparison_phases
            tmp_matrices = obj.MILPMatrixMap(num_phases);
            obj.variables_size = size(tmp_matrices.P, 2);
            f = zeros(1, obj.variables_size);

            if template_id == 1
                % delta_1を使用、重みはなし
                for delta1_num = delta1_list
                    for step = 1: obj.N_p
                        f(delta1_num + obj.v_length*(step-1)) = 1;
                    end
                end

                if obj.model_error_flg && num_phases == obj.comparison_phases(1)
                    for step = 1: obj.N_p
                        tmp_f = zeros(1, obj.variables_size);
                        for delta1_num = delta1_list
                            tmp_f(delta1_num + obj.v_length*(step-1)) = 1;
                        end
                        obj.fs_by_step(step) = tmp_f;
                    end
                end
            elseif template_id == 2
                % delta_1を使用、重みをつける
                obj.makeWeight(1);
                for i = 1: length(delta1_list)
                    delta1_num = delta1_list(i);
                    for step = 1: obj.N_p
                        f(delta1_num + obj.v_length*(step-1)) = obj.milp_matrices.w.delta1(i);
                    end
                end

                if obj.model_error_flg && num_phases == obj.comparison_phases(1)
                    for step = 1: obj.N_p
                        tmp_f = zeros(1, obj.variables_size);
                        for delta1_num = delta1_list
                            tmp_f(delta1_num + obj.v_length*(step-1)) = 1;
                        end
                        obj.fs_by_step(step) = tmp_f;
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

                if obj.model_error_flg && num_phases == obj.comparison_phases(1)
                    for step = 1: obj.N_p
                        tmp_f = zeros(1, obj.variables_size);
                        for delta1_num = delta1_list
                            tmp_f(delta1_num + obj.v_length*(step-1)) = 1;
                        end

                        for delta4_num = delta4_list
                            tmp_f(delta4_num + obj.v_length*(step-1)) = 1;
                        end
                        obj.fs_by_step(step) = tmp_f;
                    end
                end
    
            elseif template_id == 4
                % delta_1とdelta_4を使用、重みをつける
                obj.makeWeight(1);
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

                if obj.model_error_flg && num_phases == obj.comparison_phases(1)
                    for step = 1: obj.N_p
                        tmp_f = zeros(1, obj.variables_size);
                        for delta1_num = delta1_list
                            tmp_f(delta1_num + obj.v_length*(step-1)) = 1;
                        end

                        for delta4_num = delta4_list
                            tmp_f(delta4_num + obj.v_length*(step-1)) = 1;
                        end
                        obj.fs_by_step(step) = tmp_f;
                    end
                end

            elseif template_id == 5
                % delta_1とdelta_4とphiを使用、重みはなし
                phi_list = obj.VariableListMap(['phi', num2str(num_phases)]);

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
                for phi_num = phi_list
                    f(phi_num) = obj.N_p;
                end

                if obj.model_error_flg && num_phases == obj.comparison_phases(1)
                    for step = 1: obj.N_p
                        tmp_f = zeros(1, obj.variables_size);
                        for delta1_num = delta1_list
                            tmp_f(delta1_num + obj.v_length*(step-1)) = 1;
                        end

                        for delta4_num = delta4_list
                            tmp_f(delta4_num + obj.v_length*(step-1)) = 1;
                        end

                        obj.fs_by_step(step) = tmp_f;
                    end
                end
            end

            tmp_matrices.f = f;
            obj.MILPMatrixMap(num_phases) = tmp_matrices;
        end
    else
        f = zeros(1, obj.variables_size);
        if template_id == 1
            % delta_1を使用、重みはなし
            for delta1_num = delta1_list
                for step = 1: obj.N_p
                    f(delta1_num + obj.v_length*(step-1)) = 1;
                end
            end

            if obj.model_error_flg
                for step = 1: obj.N_p
                    tmp_f = zeros(1, obj.variables_size);
                    for delta1_num = delta1_list
                        tmp_f(delta1_num + obj.v_length*(step-1)) = 1;
                    end
                    obj.fs_by_step(step) = tmp_f;
                end
            end
        elseif template_id == 2
            % delta_1を使用、重みをつける
            obj.makeWeight(1);
            for i = 1: length(delta1_list)
                delta1_num = delta1_list(i);
                for step = 1: obj.N_p
                    f(delta1_num + obj.v_length*(step-1)) = obj.milp_matrices.w.delta1(i);
                end
            end

            if obj.model_error_flg
                for step = 1: obj.N_p
                    tmp_f = zeros(1, obj.variables_size);
                    for delta1_num = delta1_list
                        tmp_f(delta1_num + obj.v_length*(step-1)) = 1;
                    end
                    obj.fs_by_step(step) = tmp_f;
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

            if obj.model_error_flg
                for step = 1: obj.N_p
                    tmp_f = zeros(1, obj.variables_size);
                    for delta1_num = delta1_list
                        tmp_f(delta1_num + obj.v_length*(step-1)) = 1;
                    end

                    for delta4_num = delta4_list
                        tmp_f(delta4_num + obj.v_length*(step-1)) = 1;
                    end
                    obj.fs_by_step(step) = tmp_f;
                end
            end
        elseif template_id == 4
            % delta_1とdelta_4を使用、重みをつける
            obj.makeWeight(1);
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

            if obj.model_error_flg
                for step = 1: obj.N_p
                    tmp_f = zeros(1, obj.variables_size);
                    for delta1_num = delta1_list
                        tmp_f(delta1_num + obj.v_length*(step-1)) = 1;
                    end

                    for delta4_num = delta4_list
                        tmp_f(delta4_num + obj.v_length*(step-1)) = 1;
                    end
                    obj.fs_by_step(step) = tmp_f;
                end
            end

        elseif template_id == 5
            % delta_1とdelta_4とphiを使用、重みはなし
            phi_list = obj.VariableListMap('phi');

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
            for phi_num = phi_list
                f(phi_num) = obj.N_p;
            end

            if obj.model_error_flg
                for step = 1: obj.N_p
                    tmp_f = zeros(1, obj.variables_size);
                    for delta1_num = delta1_list
                        tmp_f(delta1_num + obj.v_length*(step-1)) = 1;
                    end

                    for delta4_num = delta4_list
                        tmp_f(delta4_num + obj.v_length*(step-1)) = 1;
                    end

                    obj.fs_by_step(step) = tmp_f;
                end
            end
        end

        obj.milp_matrices.f = f;
    end
    
end