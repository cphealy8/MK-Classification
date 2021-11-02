function [dat] = libSVMread(csvName)
%LIBSVMREAD Read data in LibSVM format from csv file.
%   [Inds,Vals,Labs] = libSVMread('data.csv') returns the reads the data
%   (in LibSVM format) from the .csv file data. For n samples in
%   the data set it returns the indices and values of the sparse feature
%   vector for each sample as a 1xn cell array and the corresponding label
%   for each sample as a 1xn vector stored in a data structure. 
[~,txt,~] = xlsread(csvName);

for n=1:length(txt)
    splitTxt{n} = strsplit(txt{n},' ');
    Labs(:,n) = str2double(splitTxt{n}{1});
    
    % Initialize
    m = 1; % Reset counter.
    nvals = length(splitTxt{n});
    TempInds = zeros(nvals,1);
    TempVals = TempInds;
    
    
    while m<= nvals-1
        m = m+1;    
        ssTxt = strsplit(splitTxt{n}{m},':');
        TempInds(m-1) = str2double(ssTxt(1));
        TempVals(m-1) = str2double(ssTxt(2));
    end
    % Store
    Inds{n} = TempInds(1:end-1);
    Vals{n} = TempVals(1:end-1);
    
end
splitTxt = splitTxt';

dat.Inds = Inds';
dat.Vals = Vals';
dat.Labs = Labs';

end

