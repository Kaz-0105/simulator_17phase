function makeSimulationStruct(obj, data)
    % MPCのサイクルのループの回数
    obj.simulation.time = data.simulation.time;

    % シミュレーションの回数
    obj.simulation.count = data.simulation.count;
end