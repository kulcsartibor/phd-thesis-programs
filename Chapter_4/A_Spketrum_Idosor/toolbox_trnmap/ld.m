function [out,row,col] = ld(filename)
% The function: 
%
%       [out,row,col] = ld(filename)
%
% loads the file <filename> in the variable <out>.
%
% The optional string <filename> contains the name (and the path) 
% of a file written in the .dat format.
% If <filename> is not specified, a dialog box is displayed. 
%
% <row> and <col> are such that [row,col] = size(out)
%
% See also sv

if nargin<1,
        [filename,filepath] = uigetfile('*.dat','ld: Load File');
        if filename==0, 
                out = [];
                row = 0;
                col = 0;
                return;
        else,
                filename = strcat(filepath,filename);                
        end;
end;

fid=fopen(filename,'rt');
if fid>=0,
        col = fscanf(fid,'%e',[1,1]);
        fscanf(fid,'%e',[1,col-1]);
        row = fscanf(fid,'%e',[1,1]);
        fscanf(fid,'%e',[1,col-1]);
        out = fscanf(fid,'%e',[col,row])';
        fclose(fid);
else,
        disp(strcat('file <',filename,'> not found!'));
        out = 0;
        row = 0;
        col = 0;
end;        