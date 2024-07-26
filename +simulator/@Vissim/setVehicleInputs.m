function setVehicleInputs(obj)
    % GroupsMapの取得
    GroupsMap = obj.Config.network.GroupsMap;

    for group_id = cell2mat(GroupsMap.keys)
        % group構造体の取得
        group = GroupsMap(group_id);

        % VehicleInputsMapの取得
        VehicleInputsMap = group.PrmsMap('vehicle_inputs');

        % VISSIMにパラメータを設定
        for vehicle_input_id = cell2mat(VehicleInputsMap.keys)
            % VehicleInputのCOMオブジェクトを取得
            VehicleInput = obj.Com.Net.VehicleInputs.ItemByKey(vehicle_input_id);

            % パラメータをセット
            VehicleInput.set('AttValue', 'Volume(1)', VehicleInputsMap(vehicle_input_id).volume);
        end
    end
end