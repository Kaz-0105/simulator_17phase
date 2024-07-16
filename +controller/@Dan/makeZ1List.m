function makeZ1List(obj)
    % 信号機の変数の最後のインデックスを取得
    last_index = obj.signal_num;

    % z_1の変数のリストを作成
    z1_list = [];

    for road_id = 1: obj.road_num
        for link_id = 1: obj.RoadNumLinksMap(road_id)
            % LaneFirstVehsMapを取得
            LaneFirstVehsMap = obj.RoadLinkLaneFirstVehsMap.get(road_id, link_id);

            for veh_id = 1: obj.RoadLinkNumVehsMap.get(road_id, link_id)
                if veh_id == 1
                    % z1_listに追加
                    z1_list = [z1_list, last_index + 1];

                    % last_indexを更新
                    last_index = last_index + 1;

                elseif veh_id == LaneFirstVehsMap(1)
                    % z1_listに追加
                    z1_list = [z1_list, last_index + 1];

                    % last_indexを更新
                    last_index = last_index + 3;
                    
                elseif veh_id == LaneFirstVehsMap(2)
                    % z1_listに追加
                    z1_list = [z1_list, last_index + 1];

                    % last_indexを更新
                    last_index = last_index + 3;
                    
                elseif veh_id == LaneFirstVehsMap(3)
                    % z1_listに追加
                    z1_list = [z1_list, last_index + 1];

                    % last_indexを更新
                    last_index = last_index + 3;
                    
                else
                    % z1_listに追加
                    z1_list = [z1_list, last_index + 1];

                    % last_indexを更新
                    last_index = last_index + 5;
                    
                end
            end
        end
    end

    % VariableListMapにz_1の変数のリストを追加
    obj.VariableListMap('z_1') = z1_list;
end