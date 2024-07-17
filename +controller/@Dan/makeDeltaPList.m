function makeDeltaPList(obj)
    % uとzの変数を合わせたときの最後のインデックスを取得
    last_index = obj.u_length + obj.z_length;

    % delta_pの変数のリストを作成
    deltap_list = [];

    for road_id = 1: obj.road_num
        for link_id = 1: obj.RoadNumLinksMap(road_id)
            % LaneFirstVehsMapを取得
            LaneFirstVehsMap = obj.RoadLinkLaneFirstVehsMap.get(road_id, link_id);

            for veh_id = 1: obj.RoadLinkNumVehsMap.get(road_id, link_id)
                if veh_id == 1
                    % deltap_listに追加
                    deltap_list = [deltap_list, last_index + 2];

                    % last_indexを更新
                    last_index = last_index + 4;

                elseif veh_id == LaneFirstVehsMap(1)
                    % deltap_listに追加
                    deltap_list = [deltap_list, last_index + 2];

                    % last_indexを更新
                    last_index = last_index + 7;
                    
                elseif veh_id == LaneFirstVehsMap(2)
                    % deltap_listに追加
                    deltap_list = [deltap_list, last_index + 2];

                    % last_indexを更新
                    last_index = last_index + 7;
                    
                elseif veh_id == LaneFirstVehsMap(3)
                    % deltap_listに追加
                    deltap_list = [deltap_list, last_index + 2];

                    % last_indexを更新
                    last_index = last_index + 7;
                    
                else
                    % deltap_listに追加
                    deltap_list = [deltap_list, last_index + 2];

                    % last_indexを更新
                    last_index = last_index + 10;
                    
                end
            end
        end
    end

    % VariableListMapにdelta_pの変数のリストを追加
    obj.VariableListMap('delta_p') = deltap_list;
end