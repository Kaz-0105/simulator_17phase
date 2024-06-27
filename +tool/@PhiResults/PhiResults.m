classdef PhiResults < handle
    properties(GetAccess = private)
        N_s;
        N_c;
        past_data;
        N_p;

    end

    methods(Access = public)
        function obj = PhiResults(N_p, N_c, N_s)
            obj.N_s = N_s;
            obj.N_c = N_c;
            obj.N_p = N_p;
            obj.past_data = zeros(1, N_s);
            
        end

        function updateData(obj, phi_opt)
            obj.past_data = [obj.past_data(obj.N_c + 1:end), phi_opt(1:obj.N_c)];
        end

        function value = get(obj, property_name)
            value = obj.(property_name);
        end
    end

end