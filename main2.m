north = 9;
east = 5;

left = 1;
straight = 1;
right = 1;

lane = zeros(4, 1);
lane(1) = north * (left + straight)/ (left + straight + right);
lane(2) = north * (right)/ (left + straight + right);

lane(3) = east * (left + straight)/ (left + straight + right);
lane(4) = east * (right)/ (left + straight + right);

[~, id] = min(lane);

time = zeros(4, 1);

for i = 1:4
    time(i) = 8 * lane(i) / lane(id);
end



