function [ F ] = frobenius( A,B )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
F = sqrt(trace((A-B)*(A-B)'));

end

