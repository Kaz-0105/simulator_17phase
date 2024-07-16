% A行列を作成する関数
function makeA(obj)
    % A行列を初期化
    obj.mld_matrices.A = [];

    % 道路ごとに計算
    for road_id = 1: obj.road_num
        % リンクごとに計算
        for link_id = 1: obj.RoadNumLinksMap(road_id)
            % 車両の数を取得
            num_vehs = obj.RoadLinkNumVehsMap.get(road_id, link_id);

            % A行列に追加
            obj.mld_matrices.A = blkdiag(obj.mld_matrices.A, eye(num_vehs));
        end
    end
end