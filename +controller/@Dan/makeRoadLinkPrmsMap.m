function makeRoadLinkPrmsMap(obj)
    % RoadPrmsMapの初期化
    obj.RoadLinkPrmsMap = tool.HierarchicalMap('KeyType1', 'int32', 'KeyType2', 'int32', 'ValueType', 'any');
    
    % RoadNumLinksMapを初期化（後々使う）
    obj.RoadNumLinksMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

    % Vissimクラスからデータを取得
    IntersectionStructMap = obj.Vissim.get('IntersectionStructMap');
    RoadLinkStructMap = obj.Vissim.get('RoadLinkStructMap'); 
    RoadNumLanesMap = obj.Vissim.get('RoadNumLanesMap');
    RoadBranchMap = obj.Vissim.get('RoadBranchMap');
    RoadMainLinkMap = obj.Vissim.get('RoadMainLinkMap');

    % intersection構造体の取得
    intersection = IntersectionStructMap(obj.id);

    % RoadNumLinksMapの作成
    for road_id = intersection_struct.input_road_ids
        % 道路の順番を取得
        order_id = intersection.InputRoadOrderMap(road_id);

        % メインリンクのIDを取得
        main_link_id = RoadMainLinkMap(road_id);

        % メインリンクのCOMオブジェクトを取得
        MainLink = obj.Com.Net.Links.ItemByKey(main_link_id);

        % メインリンクのレーン数を取得
        num_links = MainLink.Lanes.Count;

        % RoadNumLinksMapに追加
        obj.RoadNumLinksMap(order_id) = num_links;
    end

    % RoadLinkPrmsMapの作成
    for road_id = intersection.input_road_ids
        % 道路の順番を取得
        order_id = intersection.InputRoadOrderMap(road_id);

        % branch構造体を取得
        branch = RoadBranchMap(road_id);

        % リンクの数を取得
        num_links = obj.RoadNumLinksMap(order_id);

        % LinkStructMapを取得
        LinkStructMap = RoadLinkStructMap.getInnerMap(road_id);

        if num_links == 1
            % prms構造体の初期化
            prms = [];

            % 速度を取得
            prms.v = 



        else 
            for link_id = 1: num_links
                % prms構造体を初期化
                prms = [];
            end
        end



    end


    for irid = intersection_struct.input_road_ids
        % road構造体を取得
        road_struct = RoadStructMap(irid);

        % 速度の単位変更（km/h -> m/s）
        road_struct.v = road_struct.v * 1000 / 3600;

        % 道路の順番を取得（交差点ごとに1,2,3,4にする）
        order = intersection_struct.InputRoadOrderMap(irid);

        % RoadPrmsMapに格納
        obj.RoadLinkPrmsMap(order) = road_struct;
    end
end

% if isfield(road, 'signal_controller_id')
%     road_struct.D_b = road_struct.main_link_length - road_struct.from_pos;
%     road_struct.D_f = road.speed - 15;
%     road_struct.D_s = road.speed;
%     road_struct.d_s = 0;
%     road_struct.d_f = 5;
%     road_struct.p_s = obj.Com.Net.SignalHeads.ItemByKey(road.signal_head_ids(1)).get('AttValue', 'Pos') + road_struct.main_link_length;
%     road_struct.v = road.speed;
% end