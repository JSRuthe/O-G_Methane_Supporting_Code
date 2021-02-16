% Vectorizing HARC study

data=importdata('HARC_v2.csv');

PercentilesHARC = prctile(data,[0.1:0.1:100]);

csvFileName = ['HARCout.csv'];
csvwrite(csvFileName,PercentilesHARC);