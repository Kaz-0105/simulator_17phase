function makeModelStruct(obj, data)
    % 最低の連続ステップ数、最大変化回数について
    obj.model.dan.N_s = data.model.dan.N_s;
    obj.model.dan.m = data.model.dan.m;

    % 微小量について
    obj.model.dan.eps = data.model.dan.eps;

    % 固定するステップ数について
    obj.model.dan.num_fix_steps = data.model.dan.num_fix_steps;

    % NumRoadsNumPhasesMapの作成
    obj.model.dan.NumRoadsNumPhasesMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

    % 設定ファイルの読み込み
    for tmp_phase_info = data.model.dan.phase
        % セル配列から中身の取り出し
        tmp_phase_info = tmp_phase_info{1};

        % マップにプッシュ
        obj.model.dan.NumRoadsNumPhasesMap(tmp_phase_info.roads) = tmp_phase_info.num;
    end
end