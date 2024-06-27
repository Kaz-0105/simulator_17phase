% D1行列を作成する関数
function makeD1(obj, route_vehs, first_veh_ids, direction)

    % D1_rを初期化
    D1_r = [];

    % 自動車が存在しない場合は何もしない
    if isempty(route_vehs)
        return;
    end

    % 方向と対応する信号のバイナリのIDを取得
    if strcmp(direction,"north")
        signal_id = [1, 2, 3];
    elseif strcmp(direction, "east")
        signal_id = [4, 5, 6];
    elseif strcmp(direction, "south")
        signal_id = [7, 8, 9];
    elseif strcmp(direction, "west")
        signal_id = [10, 11, 12];
    end

    % パラメータを取得
    num_veh = length(route_vehs); % 自動車台数

    % D1_rを計算
    if first_veh_ids.straight == 1
        % IDが1の自動車が直進車線の先頭の場合
        for veh_id = 1: num_veh
            if veh_id == 1
                % IDが1の自動車の場合
                d1 = zeros(12, obj.signal_num);
                if route_vehs(veh_id) == 1
                    d1(1:2,signal_id(1)) = [-1;1];
                elseif route_vehs(veh_id) == 2
                    d1(1:2,signal_id(2)) = [-1;1];
                else
                    disp("Error: route_veh is not 1 or 2");
                end

            elseif veh_id == first_veh_ids.right
                % 右折車線の先頭車（IDが１ではないかつ先頭車）の場合
                d1 = zeros(28,obj.signal_num);
                if route_vehs(veh_id) == 3
                    d1(1:2,signal_id(3)) = [-1;1];
                else
                    disp("Error: route_veh is not 3");
                end
            else
                % それ以外の場合
                d1 = zeros(42,obj.signal_num);
                if route_vehs(veh_id) == 1
                    d1(1:2,signal_id(1)) = [-1;1];
                elseif route_vehs(veh_id) == 2
                    d1(1:2,signal_id(2)) = [-1;1];
                elseif route_vehs(veh_id) == 3
                    d1(1:2,signal_id(3)) = [-1;1];
                else 
                    disp("Error: route_veh is not 1, 2 or 3");
                end
            end
            % D1_rに追加
            D1_r = [D1_r;d1];
        end

    elseif first_veh_ids.right == 1
        % IDが1の自動車が右折車線の先頭の場合
        for veh_id = 1: num_veh
            if veh_id == 1
                % IDが1の自動車の場合
                d1 = zeros(12, obj.signal_num);
                if route_vehs(veh_id) == 3
                    d1(1:2,signal_id(3)) = [-1;1];
                else
                    disp("Error: route_veh is not 3");
                end
                
            elseif veh_id == first_veh_ids.straight
                % 直進車線の先頭車（IDが１ではないかつ先頭車）の場合
                d1 = zeros(28,obj.signal_num);
                if route_vehs(veh_id) == 1
                    d1(1:2,signal_id(1)) = [-1;1];
                elseif route_vehs(veh_id) == 2
                    d1(1:2,signal_id(2)) = [-1;1];
                else
                    disp("Error: route_veh is not 1 or 2");
                end

            else
                % それ以外の場合
                d1 = zeros(42,obj.signal_num);
                if route_vehs(veh_id) == 1
                    d1(1:2,signal_id(1)) = [-1;1];
                elseif route_vehs(veh_id) == 2
                    d1(1:2,signal_id(2)) = [-1;1];
                elseif route_vehs(veh_id) == 3
                    d1(1:2,signal_id(3)) = [-1;1];
                else 
                    disp("Error: route_veh is not 1, 2 or 3");
                end
                
            end
            % D1_rに追加
            D1_r = [D1_r;d1];
        end
    end
    
    % D1に追加
    obj.mld_matrices.D1 = [obj.mld_matrices.D1; D1_r];
end
