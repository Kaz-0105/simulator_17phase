function makeDeltaF3List(obj)
    % uとzの変数を合わせたときの最後のインデックスを取得
    last_index = obj.u_length + obj.z_length;

    % delta_f3の変数のリストを作成
    deltaf3_list = [];

    for road_id = 1: obj.road_num
        for link_id = 1: obj.RoadNumLinksMap(road_id)
            % LaneFirstVehsMapを取得
            LaneFirstVehsMap = obj.RoadLinkLaneFirstVehsMap.get(road_id, link_id);

            for veh_id = 1: obj.RoadLinkNumVehsMap.get(road_id, link_id)
                if veh_id == 1
                    % last_indexを更新
                    last_index = last_index + 4;

                elseif veh_id == LaneFirstVehsMap(1)
                    % last_indexを更新
                    last_index = last_index + 7;
                    
                elseif veh_id == LaneFirstVehsMap(2)
                    % last_indexを更新
                    last_index = last_index + 7;
                    
                elseif veh_id == LaneFirstVehsMap(3)
                    % last_indexを更新
                    last_index = last_index + 7;
                    
                else
                    % deltaf3_listに追加
                    deltaf3_list = [deltaf3_list, last_index + 4];

                    % last_indexを更新
                    last_index = last_index + 10;
                    
                end
            end
        end
    end

    % VariableListMapにdelta_f3の変数のリストを追加
    obj.VariableListMap('delta_f3') = deltaf3_list;


end