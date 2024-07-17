function makeDeltaBList(obj)
    % uとzの変数を合わせたときの最後のインデックスを取得
    last_index = obj.u_length + obj.z_length;

    % delta_bの変数のリストを作成
    deltab_list = [];

    for road_id = 1: obj.road_num
        for link_id = 1: obj.RoadNumLinksMap(road_id)
            % LaneFirstVehsMapを取得
            LaneFirstVehsMap = obj.RoadLinkLaneFirstVehsMap.get(road_id, link_id);

            for veh_id = 1: obj.RoadLinkNumVehsMap.get(road_id, link_id)
                if veh_id == 1
                    % last_indexを更新
                    last_index = last_index + 4;

                elseif veh_id == LaneFirstVehsMap(1)
                    % deltab_listに追加
                    deltab_list = [deltab_list, last_index + 4];

                    % last_indexを更新
                    last_index = last_index + 7;
                    
                elseif veh_id == LaneFirstVehsMap(2)
                    % deltab_listに追加
                    deltab_list = [deltab_list, last_index + 4];

                    % last_indexを更新
                    last_index = last_index + 7;
                    
                elseif veh_id == LaneFirstVehsMap(3)
                    % deltab_listに追加
                    deltab_list = [deltab_list, last_index + 4];

                    % last_indexを更新
                    last_index = last_index + 7;
                    
                else
                    % deltab_listに追加
                    deltab_list = [deltab_list, last_index + 5];

                    % last_indexを更新
                    last_index = last_index + 10;
                    
                end
            end
        end
    end
    
    % VariableListMapにdelta_bの変数のリストを追加
    obj.VariableListMap('delta_b') = deltab_list;


end