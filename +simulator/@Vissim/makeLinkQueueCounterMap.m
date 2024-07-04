function makeLinkQueueCounterMap(obj)
    obj.LinkQueueCounterMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

    for QueueCounter = obj.Com.Net.QueueCounters.GetAll()'
        % QueueCounterのCOMオブジェクトを取得
        QueueCounter = QueueCounter{1};

        % link_idとqueue_counter_idを取得
        link_id = QueueCounter.Link.get('AttValue', 'No');
        queue_counter_id = QueueCounter.get('AttValue', 'No');

        % LinkQueueCounterMapに格納
        obj.LinkQueueCounterMap(link_id) = queue_counter_id;
    end
end