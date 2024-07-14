function updateStates(obj)
    % 自動車の位置と進行方向と先頭車の情報を更新
    obj.makeVehiclesData();  

    % MLDの係数行列を更新
    obj.makeMld();     
    
    % 決定変数のリストを更新
    obj.makeVariablesList(); 
    
    % 混合整数線形計画問題の係数行列を更新
    obj.makeMilp();                                          
end