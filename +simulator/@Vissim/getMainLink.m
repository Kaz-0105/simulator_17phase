function main_link_id = getMainLink(obj, link_ids)
    main_link_id = link_ids(1);
    length = obj.Com.Net.Links.ItemByKey(main_link_id).get('AttValue', 'Length2D');

    for link_id = link_ids(2:end)
        if obj.Com.Net.Links.ItemByKey(link_id).get('AttValue', 'Length2D') > length
            main_link_id = link_id;
            length = obj.Com.Net.Links.ItemByKey(link_id).get('AttValue', 'Length2D');
        end
    end
end