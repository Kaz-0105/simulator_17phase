% B1行列を作成する関数
function makeB1(obj, pos_vehs)
    num_veh = length(pos_vehs);
    obj.mld_matrices.B1 = [obj.mld_matrices.B1; zeros(num_veh, obj.signal_num)];
end