function makeVariablesList(obj)
    obj.makeZ1List();
    obj.makeZ2List();
    obj.makeZ3List();
    obj.makeZ4List();
    obj.makeZ5List();
    
    obj.makeDelta1List();
    obj.makeDelta2List();
    obj.makeDelta3List();
    obj.makeDelta4List();

    obj.makeDeltaDList();
    obj.makeDeltaPList();
    obj.makeDeltaF2List();
    obj.makeDeltaF3List();
    obj.makeDeltaBList();

    obj.makeDeltaCList();

    obj.v_length = obj.u_length + obj.z_length + obj.delta_length;

    obj.makePhiList();
end