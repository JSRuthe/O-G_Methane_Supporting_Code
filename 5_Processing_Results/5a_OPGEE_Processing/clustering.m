function [startrow, endrow, site_iteration, reset, testcount] = clustering(startrow, endrow, site_iteration, reset, tranche_set, well_iteration, totalrows, testcount)

% This script clusters well level data into site level data. Output is
% "site_iteration" where columns are:
% (1) tranche iteration (1-74)
% (2) summed site level emissions [kg/day]
% (3) well draw

test = 10;

RandomIndex = ceil(rand*size(tranche_set,1));
welldraw = tranche_set(RandomIndex, 3);
welldraw = round(welldraw);
welldraw = double(welldraw);
endrow = startrow + welldraw - 1;
proddraw = tranche_set(RandomIndex, 2);

if endrow > totalrows
    endrow = totalrows;
end

cluster = well_iteration(startrow:endrow,:);

if isempty(cluster)
    x = 1
end

matadd(1,2) = sum(cluster(:,2));
matadd(1,1) = cluster(1,1);
matadd(1,3) = welldraw;
matadd(1,4) = proddraw;
matadd(1,5) = proddraw * 1000 * ((16.6 * 1.202 * 0.794) / 1000);

matadd(1,6) = matadd(1,2)/ matadd(1,5);
test = matadd(1,6);

% Only advance and update if test < 1 and welldraw is reasonable
if test < 1 && welldraw < 100 || testcount >= 100
    
    startrow = endrow + 1;
    testcount = 1;
    
    if reset == true
        site_iteration = matadd;
        reset = false;
    else
        site_iteration = vertcat(site_iteration,matadd);
    end
else
    testcount = testcount + 1;
end