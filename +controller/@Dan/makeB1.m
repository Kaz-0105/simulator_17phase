% B1行列を作成する関数
function makeB1(obj)
    % B1行列の初期化
    obj.mld_matrices.B1 = [];

    % 道路ごとに計算
    for road_id = 1: obj.road_num
        % リンクごとに計算
        for link_id = 1: obj.RoadNumLinksMap(road_id)
            % 自動車の数を取得
            num_vehs = obj.RoadLinkNumVehsMap.get(road_id, link_id);

            % B1行列に追加
            obj.mld_matrices.B1 = [obj.mld_matrices.B1; eye(num_vehs, obj.signal_num)];
        end
    end
end