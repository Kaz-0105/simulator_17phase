function makePhiOpt(obj)
    phi_opt = zeros(1, obj.N_p-1);

    if obj.phase_comparison_flg && obj.road_num == 4
        obj.tmp_phase_num = obj.comparison_phases(1);
    end

    for step = 1:obj.N_p-1
        phi_opt(step) = obj.x_opt(obj.v_length*obj.N_p + obj.tmp_phase_num*obj.N_p + (obj.signal_num + 1)*step);
    end

    obj.phi_opt = round(phi_opt);
end