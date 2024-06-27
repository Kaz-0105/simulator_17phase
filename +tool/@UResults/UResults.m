classdef UResults < handle
    properties(GetAccess = private)
        N_p;
        N_c;
        N_s;
        signal_num;
    end

    properties(GetAccess = private)
        % リスト
        past_data;
        future_data;
    end

    methods(Access = public)
        function obj = UResults(signal_num, N_p, N_c)
            obj.N_p = N_p;
            obj.N_c = N_c;
            obj.signal_num = signal_num;
            obj.past_data = zeros(signal_num, N_c);
            obj.future_data = zeros(signal_num, N_p - N_c);
        end

        function setInitialFutureData(obj, vec)
            for col_id = 1: length(obj.future_data(1, :))
                obj.future_data(:, col_id) = vec;
            end
        end

        function value = get(obj, property_name)
            value = obj.(property_name);
        end

        function updateData(obj, u_opt)
            u_past = u_opt(:, 1: obj.N_c);
            u_future = u_opt(:, obj.N_c + 1: obj.N_p);

            obj.past_data = u_past;
            obj.future_data = u_future;
        end
    end
end