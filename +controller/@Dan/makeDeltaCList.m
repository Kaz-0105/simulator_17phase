function makeDeltaCList(obj)
    % uとzの変数を合わせたときの最後のインデックスを取得
    last_index = obj.u_length + obj.z_length;

    % delta_cの変数のリストを作成
    deltac_list = [];

    for road_id = 1: obj.road_num
        for link_id = 1: obj.RoadNumLinksMap(road_id)
            % LaneFirstVehsMapを取得
            LaneFirstVehsMap = obj.RoadLinkLaneFirstVehsMap.get(road_id, link_id);

            for veh_id = 1: obj.RoadLinkNumVehsMap.get(road_id, link_id)
                if veh_id == 1
                    % deltac_listに追加
                    deltac_list = [deltac_list, last_index + 4];

                    % last_indexを更新
                    last_index = last_index + 4;

                elseif veh_id == LaneFirstVehsMap(1)
                    % deltac_listに追加
                    deltac_list = [deltac_list, last_index + 7];

                    % last_indexを更新
                    last_index = last_index + 7;
                    
                elseif veh_id == LaneFirstVehsMap(2)
                    % deltac_listに追加
                    deltac_list = [deltac_list, last_index + 7];

                    % last_indexを更新
                    last_index = last_index + 7;
                    
                elseif veh_id == LaneFirstVehsMap(3)
                    % deltac_listに追加
                    deltac_list = [deltac_list, last_index + 7];

                    % last_indexを更新
                    last_index = last_index + 7;
                    
                else
                    % deltac_listに追加
                    deltac_list = [deltac_list, last_index + 10];

                    % last_indexを更新
                    last_index = last_index + 10;
                    
                end
            end
        end
    end
    
    % VariableListMapにdelta_cの変数のリストを追加
    obj.VariableListMap('delta_c') = deltac_list;

    % deltaの変数の長さを取得
    obj.delta_length = last_index - obj.u_length - obj.z_length;


end