function [LibOut] = LibIndex(LibIn,inds)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
LibOut.Vals = LibIn.Vals(inds);
LibOut.Inds = LibIn.Inds(inds);
LibOut.Labs = LibIn.Labs(inds);
end

