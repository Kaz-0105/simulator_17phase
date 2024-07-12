% B1行列を作成する関数
function makeB1(obj)
    % B1行列の初期化
    obj.mld_matrices.B1 = [];

    % 道路ごとに計算
    for road_id = 1: obj.road_num
        % 自動車の数を取得
        num_veh = obj.RoadNumVehsMap(road_id);

        % B1行列に追加
        obj.mld_matrices.B1 = [obj.mld_matrices.B1; zeros(num_veh, obj.signal_num)];
    end
end