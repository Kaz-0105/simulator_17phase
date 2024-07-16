function makeDelta2List(obj)
    % uとzの変数を合わせたときの最後のインデックスを取得
    last_index = obj.u_length + obj.z_length;

    % delta_2の変数のリストを作成
    delta2_list = [];

    for road_id = 1: obj.road_num
        for link_id = 1: obj.RoadNumLinksMap(road_id)
            % LaneFirstVehsMapを取得
            LaneFirstVehsMap = obj.RoadLinkLaneFirstVehsMap.get(road_id, link_id);

            for veh_id = 1: obj.RoadLinkNumVehsMap.get(road_id, link_id)
                if veh_id == 1
                    % last_indexを更新
                    last_index = last_index + 4;

                elseif veh_id == LaneFirstVehsMap(1)
                    % delta2_listに追加
                    delta2_list = [delta2_list, last_index + 6];

                    % last_indexを更新
                    last_index = last_index + 7;
                    
                elseif veh_id == LaneFirstVehsMap(2)
                    % delta2_listに追加
                    delta2_list = [delta2_list, last_index + 6];

                    % last_indexを更新
                    last_index = last_index + 7;
                    
                elseif veh_id == LaneFirstVehsMap(3)
                    % delta2_listに追加
                    delta2_list = [delta2_list, last_index + 6];

                    % last_indexを更新
                    last_index = last_index + 7;
                    
                else
                    % delta2_listに追加
                    delta2_list = [delta2_list, last_index + 7];

                    % last_indexを更新
                    last_index = last_index + 9;
                end
            end
        end
    end

    % VariableListMapにdelta_2の変数のリストを追加
    obj.VariableListMap('delta_2') = delta2_list;
end