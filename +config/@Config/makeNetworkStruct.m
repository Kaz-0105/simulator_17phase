function makeNetworkStruct(obj, data)
    % inpxファイルの設定 
    [inpx_dir, inpx_name, inpx_ext] = fileparts(data.network.inpx_file);

    if strlength(inpx_dir) == 0
        obj.network.inpx_file = char(append(file_dir, inpx_name, inpx_ext));
    else
        obj.network.inpx_file = char(append(pwd,'\', data.network.inpx_file));
    end

    % layxファイルの設定
    [layx_dir, layx_name, layx_ext] = fileparts(data.network.layx_file);                    % data.layx_fileをディレクトリ,名前,拡張子に分ける

    if strlength(layx_dir) == 0
        obj.network.layx_file = char(append(file_dir,layx_name,layx_ext));                        % ファイル名のみしかyamlファイルに記載されていない場合は,yamlファイルと同じディレクトリに存在するとする
    else
        obj.network.layx_file = char(append(pwd, '\', data.network.layx_file));                        % ディレクトリまで記載があった場合は,そのまま
    end

    % GroupsMapの初期化
    obj.network.GroupsMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

    % group構造体をエリアごとに作成しGroupsMapにプッシュ
    for group_data = [data.network.groups{:}]
        obj.network.GroupsMap(group_data.id) = obj.parseGroup(group_data);
    end
end