function updateNumVehsData(obj, IntersectionControllerMap)
    % IntersectionControllerMapのキーを取得
    keys_intersection_controller_map = keys(IntersectionControllerMap);
    keys_intersection_controller_map = [keys_intersection_controller_map{:}];
    
    for intersection_id = keys_intersection_controller_map
        Controller = IntersectionControllerMap(intersection_id);
        num_vehs = Controller.get('num_vehs');

        if isempty(num_vehs)
            num_vehs_all = 0;
        else
            if ~isfield(num_vehs, 'north')
                num_vehs_all = sum([num_vehs.east, num_vehs.south, num_vehs.west]);
            elseif ~isfield(num_vehs, 'south')
                num_vehs_all = sum([num_vehs.north, num_vehs.east, num_vehs.west]);
            elseif ~isfield(num_vehs, 'east')
                num_vehs_all = sum([num_vehs.north, num_vehs.south, num_vehs.west]);
            elseif ~isfield(num_vehs, 'west')
                num_vehs_all = sum([num_vehs.north, num_vehs.east, num_vehs.south]);
            else
                num_vehs_all = sum([num_vehs.north, num_vehs.east, num_vehs.south, num_vehs.west]);
            end
        end

        if ~ismember(intersection_id, cell2mat(keys(obj.NumVehsDataMap)))
            obj.NumVehsDataMap(intersection_id) = [num_vehs_all];
        else
            tmp_num_vehs_data = obj.NumVehsDataMap(intersection_id);
            tmp_num_vehs_data = [tmp_num_vehs_data, num_vehs_all];

            obj.NumVehsDataMap(intersection_id) = tmp_num_vehs_data;
        end
    end
end