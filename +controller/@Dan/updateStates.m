function updateStates(obj, IntersectionStructMap, VissimData)
    % 計算に必要な自動車の位置情報と進行方向の情報を更新する関数
    obj.makeVehiclesData(IntersectionStructMap, VissimData); % 自動車の位置情報と進行方向の情報を更新
    obj.makeMld();                                           % 混合論理動的システムの係数行列を更新
    obj.makeVariablesList();                                 % 決定変数の種類ごとのリストを更新
    obj.makeMilp();                                          % 混合整数線形計画問題の係数行列を更新
end