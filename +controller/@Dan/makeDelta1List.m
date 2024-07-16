function makeDelta1List(obj)
    % uとzの変数の最後のインデックスを取得
    last_index = obj.u_length + obj.z_length;

    % delta_1の変数のリストを作成
    delta1_list = [];

    for road_id = 1: obj.road_num
        for link_id = 1: obj.RoadNumLinksMap(road_id)
            % LaneFirstVehsMapを取得
            LaneFirstVehsMap = obj.RoadLinkLaneFirstVehsMap.get(road_id, link_id);

            for veh_id = 1: obj.RoadLinkNumVehsMap.get(road_id, link_id)
                if veh_id == 1
                    % delta1_listに追加
                    delta1_list = [delta1_list, last_index + 3];

                    % last_indexを更新
                    last_index = last_index + 4;

                elseif veh_id == LaneFirstVehsMap(1)
                    % delta1_listに追加
                    delta1_list = [delta1_list, last_index + 5];

                    % last_indexを更新
                    last_index = last_index + 7;
                    
                elseif veh_id == LaneFirstVehsMap(2)
                    % delta1_listに追加
                    delta1_list = [delta1_list, last_index + 5];

                    % last_indexを更新
                    last_index = last_index + 7;
                    
                elseif veh_id == LaneFirstVehsMap(3)
                    % delta1_listに追加
                    delta1_list = [delta1_list, last_index + 5];

                    % last_indexを更新
                    last_index = last_index + 7;
                    
                else
                    % delta1_listに追加
                    delta1_list = [delta1_list, last_index + 6];

                    % last_indexを更新
                    last_index = last_index + 9;

                end
            end
        end
    end

    % VariableListMapにdelta_1の変数のリストを追加
    obj.VariableListMap('delta_1') = delta1_list;
end