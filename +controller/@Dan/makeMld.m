function makeMld(obj)
    obj.mld_matrices.E = [];

    % % どの方向にも車両が存在しない場合は何もしない
    % isVehicle = false;
    % for road_id = 1: obj.road_num
    %     if ~isempty(obj.RoadPosVehsMap(road_id))
    %         isVehicle = true;
    %         break;
    %     end
    % end

    % if ~isVehicle
    %     return
    % end

    % MLDの係数行列を計算
    obj.makeA();
    obj.makeB1();
    obj.makeB2();
    obj.makeB3();
    obj.makeC();
    obj.makeD1();
    obj.makeD2();
    obj.makeD3();
    obj.makeE();
end