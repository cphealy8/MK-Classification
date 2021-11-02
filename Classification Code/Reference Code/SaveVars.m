
% Store
nkn = nkn+1;
dat.nUp{nkn}=nUp;
dat.T{nkn}=T;
dat.ValAccu{nkn}=ValAccu;
dat.r{nkn}=r; 
dat.DevAccu{nkn}=DevAccu;
dat.ValBest(nkn) = max(ValAccu(:));
dat.TBest(nkn)=TBest;
dat.nUpBest{nkn} = nUpBest;
dat.maxDevAccu{nkn}=maxDevAccu;
dat.TestAccu{nkn}=TestAccu;
clearvars -except dat nkn
close all
