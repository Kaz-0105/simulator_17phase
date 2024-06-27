% A行列を作成する関数
function makeA(obj, pos_vehs)
    num_veh = length(pos_vehs);
    obj.mld_matrices.A = blkdiag(obj.mld_matrices.A, eye(num_veh));
end