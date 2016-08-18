function [ elm_matrix ] = get_nlin_nodes(s)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

index = find(s == 'C');
elm_matrix = ['[' s(index(1)+2:find_matching_paren(s,index(1)+2))];


for i = index(2:end);
	elm_matrix = [elm_matrix, ' ', s(i+2:find_matching_paren(s,i+2))]; %#ok<AGROW>
end
elm_matrix = strcat(elm_matrix, ']');
end

