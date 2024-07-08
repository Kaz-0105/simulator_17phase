function makeGraphSettingMap(obj)
    % Mapの初期化
    obj.GraphSettingMap = containers.Map('KeyType', 'char', 'ValueType', 'any');

    % LineGraphの設定
    obj.GraphSettingMap('line_graph') = obj.Config.graph.line_graph;

    % Histogramの設定
    obj.GraphSettingMap('histogram') = obj.Config.graph.histogram;
end