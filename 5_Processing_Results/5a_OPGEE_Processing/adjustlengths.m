function [sitedata, sitedatainit] = adjustlengths(sitedata,sitedatainit, i)

if i > 1
    [sizemat1,~] = size(sitedatainit.drygas);
    [sizemat2,~] = size(sitedata.drygas);
    if sizemat1 < sizemat2
        sitedata.drygas = sitedata.drygas(1:sizemat1,:);
    else
        sitedata.drygas = vertcat(sitedata.drygas, zeros((sizemat1 - sizemat2),6));
    end
else
    sitedatainit.drygas = sitedata.drygas;
end

if i > 1
    [sizemat1,~] = size(sitedatainit.gaswoil);
    [sizemat2,~] = size(sitedata.gaswoil);
    if sizemat1 < sizemat2
        sitedata.gaswoil = sitedata.gaswoil(1:sizemat1,:);
    else
        sitedata.gaswoil = vertcat(sitedata.gaswoil, zeros((sizemat1 - sizemat2),6));
    end
else
    sitedatainit.gaswoil = sitedata.gaswoil;
end

if i > 1
    [sizemat1,~] = size(sitedatainit.assoc);
    [sizemat2,~] = size(sitedata.assoc);
    if sizemat1 < sizemat2
        sitedata.assoc = sitedata.assoc(1:sizemat1,:);
    else
        sitedata.assoc = vertcat(sitedata.assoc, zeros((sizemat1 - sizemat2),6));
    end
else
    sitedatainit.assoc = sitedata.assoc;
end

% if i > 1
%     [sizemat1,~] = size(sitedatainit.oil);
%     [sizemat2,~] = size(sitedata.oil);
%     if sizemat1 < sizemat2
%         sitedata.oil = sitedata.oil(1:sizemat1,:);
%     else
%         sitedata.oil = vertcat(sitedata.oil, zeros((sizemat1 - sizemat2),6));
%     end
% else
%     sitedatainit.oil = sitedata.oil;
% end