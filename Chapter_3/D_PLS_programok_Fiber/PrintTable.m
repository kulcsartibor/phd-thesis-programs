classdef PrintTable < handle
% PrintTable: Class that allows table-like output spaced by tabs for multiple rows
%
% Allows to create a table-like output for multiple values and columns.
% A spacer can be used to distinguish different columns (PrintTable.ColSep) and a flag
% (PrintTable.HasHeader) can be set to insert a line of dashes after the first row.
% The table can be printed directly to the console or be written to a file.
%
% LaTeX support:
% Additionally, LaTeX is supported via the property PrintTable.Format. The default value is
% 'plain', which means simple output as formatted string. If set to 'tex', the table is printed
% in a LaTeX table environment (PrintTable.ColSep is ignored and '& ' used automatically).
%
% Cell contents:
% The cell content values can be anything that is straightforwardly parseable. You can pass
% char array arguments directly or numeric values; even function handles and classes (handle
% subclasses) can be passed and will automatically be converted to a string representation.
%
% Custom cell content formatting:
% However, if you need to have a customized string representation, you can specifiy a cell
% array of strings as the last argument, containing custom formats to apply for each passed
% argument.
% Two conditions apply for this case: 
% # There must be one format string for each columns of the PrintTable
% # The column contents and the format string must be valid arguments for sprintf.
%
% Example:
% % Simply run
% PrintTable.test_PrintTable;
%
% % Or copy & paste
% t = PrintTable;
% t.addRow('123','456','789');
% t.addRow('1234567','1234567','789');
% t.addRow('1234567','12345678','789');
% t.addRow('12345678','123','789');
% % sprintf-format compatible strings can also be passed as last argument:
% t.addRow(123.456789,pi,789,{'%3.4f','%g','format. dec.:%d'});
% t.addRow('123456789','12345678910','789');
% t.addRow('adgag',uint8(4),4.6);
% t.addRow(@(mu)mu*4+56*245647869,t,'adgag');
% t.addRow('adgag',4,4.6);
% % Call display
% t.display;
% t.HasHeader = true;
% % or simply state the variable to print
% t
% t.ColSep = ' -@- ';
% t
%
% % Latex output
% t.Format = 'tex';
% t.Caption = 'My PrintTable in LaTeX!';
% t.print;
%
% % Printing the table:
% % You can also print the table to a file. Any MatLab file handle can be used (any first
% % argument for fprintf). Run the above example, then type
% fid = fopen('mytable.txt','w');
% t.print(fid);
% fclose(fid);
% % this is actually equivalent to calling
% t.saveToFile('mytable.txt');
%
% @note Of course, any editor might have its own setting regarding tab spacing. As the default
% in MatLab and e.g. KWrite is 8 characters, this is what is used here. Change the TabCharLen
% constant to fit to your platform/editor/requirements.
% 
% See also: fprintf sprintf
%
% @author Daniel Wirtz @date 2011-11-17
%
% @new{0,6,dw,2011-12-01}
% - Added support for LaTeX output
% - New properties PrintTable.Format and PrintTable.Caption
% - Optional caption can be added to the Table
% - Some improvements and fixed display for some special cases
% - Updated the documentation and test case
%
% @new{0,6,dw,2011-11-17} Added this class.
%
% This class has originally been developed as part of the framework
% KerMor - Model Order Reduction using Kernels:
% - \c Homepage http://www.agh.ians.uni-stuttgart.de/research/software/kermor.html
% - \c Documentation http://www.agh.ians.uni-stuttgart.de/documentation/kermor/
%
% Copyright (c) 2011, Daniel Wirtz
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without modification, are
% permitted only in compliance with the BSD license, see
% http://www.opensource.org/licenses/bsd-license.php
    
    properties(Constant)
        % Equivalent length of a tab character in single-space characters
        %
        % @default 8 @type integer
        TabCharLen = 8;
    end
    
    properties
        % A char sequence to separate the different columns.
        %
        % @default ' | ' @type char
        ColSep = ' | ';
        
        % Flag that determines if the first row should be used as table header.
        %
        % If true, a separate line with dashes will be inserted after the first printed row.
        %
        % @default false @type logical
        HasHeader = false;
        
        % The output format of the table.
        %
        % Currently the values 'plain' for plaintext and 'tex' for LaTeX output are available.
        %
        % @default 'plain' @type enum<'plain', 'tex'>
        Format = 'plain';
        
        % A caption for the table.
        %
        % Depending on the output the caption is added: 
        % plain: First line above table
        % tex: Inserted into the \\caption command
        %
        % @default '' @type char
        Caption = '';
    end
    
    %properties(Access=private)
    properties
        % The string cell data
        data;
        % Maximum content length for each colummn
        contlen;
    end
    
    methods
        function this = PrintTable
            % Creates a new PrintTable instance.
            this.data = {};
            this.contlen = [];
        end
        
        function display(this)
            % Overload for the default builtin display method.
            %
            % Calls print with argument 1, i.e. standard output.
            this.printPlain(1);
        end
        
        function print(this, outfile)
            % Prints the current table to a file pointer.
            %
            % Parameters:
            % outfile: The file pointer to print to. Must either be a valid MatLab 'fileID'
            % or can be 1 or 2, for stdout or stderr, respectively. @type integer @default 1
            %
            % See also: fprintf
            if nargin == 1
                outfile = 1;
            end
            if strcmp(this.Format,'plain')
                this.printPlain(outfile);
            elseif strcmp(this.Format,'tex')
                this.printTex(outfile);
            else
                error('Unsupported format: %s',this.Format);
            end
        end
        
        function saveToFile(this, filename)
            % Prints the current table to a file.
            %
            % Parameters:
            % filename: The file to print to. If the file exists, any contents are discarded.
            % If the file does not exist, an attempt to create a new one is made. @type char
            fid = fopen(filename,'w');
            this.print(fid);
            fclose(fid);
        end
        
        function addRow(this, varargin)
            % Adds a row to the current table.
            %
            % Parameters:
            % varargin: Any number of arguments >= 1, each corresponding to a column of the
            % table. Each argument must be a char array.
            if isempty(varargin)
                error('Not enough input arguments.');
            end
            hasformat = iscell(varargin{end});
            if iscell(varargin{1})
                error('Invalid input argument. Cells cannot be added to the PrintTable, and if you wanted to specify a sprintf format you forgot the actual value to add.');
            elseif hasformat && length(varargin)-1 ~= length(varargin{end})
                error('Input argument mismatch. If you specify a format string cell the number of arguments (=%d) to add must equal the number of format strings (=%d).',length(varargin)-1,length(varargin{end}));
            end
            if isempty(this.data)
                this.data{1} = this.stringify(varargin);
                this.contlen = ones(1,length(varargin));
            else
                % Check new number of columns
                newlen = length(varargin);
                if hasformat
                    newlen = newlen-1;
                end
                if length(this.data{1}) ~= newlen 
                    error('Inconsistent row length. Current length: %d, passed: %d',length(this.data{1}),length(varargin));
                end
                % Add all values
                this.data{end+1} = this.stringify(varargin);
            end
            % Record content length while building the table
            this.contlen = max([this.contlen; cellfun(@length,this.data{end})]);
        end
        
        function set.ColSep(this, value)
            if ~isempty(value) && ~isa(value,'char')
                error('ColSep must be a char array.');
            end
            this.ColSep = value;
        end
        
        function set.HasHeader(this, value)
            if ~islogical(value) || ~isscalar(value)
                error('HasHeader must be a logical scalar.');
            end
            this.HasHeader = value;
        end
        
        function set.Caption(this, value)
            if ~isempty(value) && ~ischar(value)
                error('Caption must be a character array.');
            end
            this.Caption = value;
        end
        
        function set.Format(this, value)
            if ~any(strcmp({'plain','tex'},value))
                error('Format must be either ''plain'' or ''tex''.');
            end
            this.Format = value;
        end
    end
    
    methods(Access=private)
        
        function printPlain(this, outfile)
            % Prints the table as plain text
            if ~isempty(this.Caption)
                fprintf(outfile,'Table ''%s'':\n',this.Caption);
            end
            for ridx = 1:length(this.data)
                row = this.data{ridx};
                this.printRow(row,outfile,this.ColSep);
                fprintf(outfile,'%s\n',row{end});
                if ridx == 1 && this.HasHeader
                    fprintf(outfile,'%s\n',repmat('_',1,sum(this.contlen) + length(this.ColSep)*length(this.data)));
                end
            end
        end
        
        function printTex(this, outfile)
            % Prints the table in LaTeX format

            % Add comment
            if ~isempty(this.Caption)
                fprintf(outfile,'%% PrintTable "%s" generated on %s\n',this.Caption,datestr(clock));
            else
                fprintf(outfile,'%% PrintTable generated on %s\n',datestr(clock));
            end
            cols = 0;
            if ~isempty(this.data)
                cols = length(this.data{1});
            end
            fprintf(outfile,'\\begin{table}[!hb]\n\t\\centering\n\t');
            fprintf(outfile,'\\begin{tabular}{%s}\n',repmat('l',1,cols));
            % Print all rows
            for ridx = 1:length(this.data)
                row = this.data{ridx};
                fprintf(outfile,'\t\t');
                this.printRow(row,outfile,'& ');
                fprintf(outfile,'%s\\\\\n',row{end});
                if ridx == 1 && this.HasHeader
                    fprintf(outfile,'\t\t\\hline\\\\\n');
                end
            end
            fprintf(outfile, '\t\\end{tabular}\n');
            if ~isempty(this.Caption)
                fprintf(outfile,'\t\\caption{%s}\n',this.Caption);
            end
            fprintf(outfile, '\\end{table}\n');
        end
        
        function printRow(this, row, outfile, sep)
            % Prints a table row using a given separator whilst inserting appropriate amounts
            % of tabs
            sl = length(sep);
            for i = 1:length(row)-1
                str = row{i};
                fillstabs = floor((sl*(i~=1)+length(str))/PrintTable.TabCharLen);
                tottabs = ceil((sl*(i~=1)+this.contlen(i))/PrintTable.TabCharLen);
                fprintf(outfile,'%s%s',[str repmat(char(9),1,tottabs-fillstabs)],sep);
            end
        end
        
        function str = stringify(~, data)
            % Converts any datatype to a string
            
            % Format cell array given
            if iscell(data{end})
               str = cell(1,length(data)-1);
               for i=1:length(data)-1
                   str{i} = sprintf(data{end}{i},data{i});
               end
            else % convert to strings if no specific format is given
               str = cell(1,length(data));
                for i=1:length(data)
                    el = data{i};
                    if isa(el,'char')
                        str{i} = el;
                    elseif isinteger(el)
                        str{i} = sprintf('%d',el);
                    elseif isnumeric(el)
                        str{i} = sprintf('%e',el);
                    elseif isa(el,'function_handle')
                        str{i} = func2str(el);
                    elseif isa(el,'handle')
                        mc = metaclass(el);
                        str{i} = mc.Name;
                    else
                        error('Cannot automatically convert an argument of type %s for PrintTable display.',class(el));
                    end
                end 
            end
        end
    end
    
    methods(Static)
        function t = test_PrintTable
            % A simple test for PrintTable
            t = PrintTable;
            t.Caption = 'This is my PrintTable test.';
            t.addRow('A','B','C');
            t.addRow('123','456','789');
            t.addRow('1234567','12345','789');
            t.addRow('1234567','123456','789');
            t.addRow('1234567','1234567','789');
            t.addRow('foo','bar',datestr(clock));
            t.addRow(123.45678,pi,789,{'%2.3f','$%4.4g$','decimal: %d'});
            t.addRow('12345678','123','789');
            t.addRow('123456789','123','789');
            t.addRow('attention: inserting tabs per format','\t','destroys the table tabbing',{'%s','1\t2%s3\t','%s'});
            t.display;
            
            t.Format = 'tex';
            t.print;
            t.HasHeader = true;
            t.print;
        end
    end
    
end