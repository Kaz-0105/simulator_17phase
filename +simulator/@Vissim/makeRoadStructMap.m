function makeRoadStructMap(obj)
    % RoadStructMapの初期化
    obj.RoadStructMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
    
    % RoadStructMapの作成
    for group_id = cell2mat(keys(obj.Config.network.GroupsMap))
        group = obj.Config.network.GroupsMap(group_id);
        
        for road_id = cell2mat(keys(group.RoadsMap))
            road_struct = [];
            road = group.RoadsMap(road_id);

            for  link_id = road.link_ids
                % LinkTypeMapからリンクの種類を取得
                type = obj.LinkTypeMap(link_id);

                % LinkのCOMオブジェクトを取得
                Link = obj.Com.Net.Links.ItemByKey(link_id);

                % road構造体を作成（距離などのモデリングに必要な情報を取得）
                if strcmp(type, 'main') || strcmp(type, 'output')
                    road_struct.main = Link.get('AttValue', 'Length2D');
                elseif strcmp(type, 'sub')
                    road_struct.sub = Link.get('AttValue', 'Length2D');
                elseif strcmp(type, 'connector')
                    road_struct.con = Link.get('AttValue', 'Length2D');
                    road_struct.to_pos = Link.get('AttValue', 'ToPos');
                    road_struct.from_pos = Link.get('AttValue', 'FromPos');
                end
            end

            if isfield(road_struct, 'con')
                road_struct.rel_con = road_struct.main - road_struct.from_pos - (road_struct.sub - road_struct.to_pos);
            end

            % モデルのパラメータを定義
            if isfield(road, 'signal_controller_id')
                road_struct.D_b = road_struct.main - road_struct.from_pos;
                road_struct.D_f = road.speed - 15;
                road_struct.D_s = road.speed;
                road_struct.d_s = 0;
                road_struct.d_f = 7;
                road_struct.p_s = obj.Com.Net.SignalHeads.ItemByKey(road.signal_head_ids(1)).get('AttValue', 'Pos') + road_struct.main;
                road_struct.v = road.speed;
            end

            obj.RoadStructMap(road.id) = road_struct;
        end    
    end
end