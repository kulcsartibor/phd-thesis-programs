
%SOM_DEMO2 Basic usage of the SOM Toolbox.

% Contributed to SOM Toolbox 2.0, February 11th, 2000 by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 1.0beta juuso 071197 
% Version 2.0beta juuso 070200

clf reset;
figure(gcf)
echo on



clc
%    ==========================================================
%    SOM_DEMO2 - BASIC USAGE OF SOM TOOLBOX
%    ==========================================================

%    som_data_struct    - Create a data struct.
%    som_read_data      - Read data from file.
%
%    som_normalize      - Normalize data.
%    som_denormalize    - Denormalize data.
%
%    som_make           - Initialize and train the map. 
%
%    som_show           - Visualize map.
%    som_show_add       - Add markers on som_show visualization.
%    som_grid           - Visualization with free coordinates.
%
%    som_autolabel      - Give labels to map.
%    som_hits           - Calculate hit histogram for the map.

%    BASIC USAGE OF THE SOM TOOLBOX

%    The basic usage of the SOM Toolbox proceeds like this: 
%      1. construct data set
%      2. normalize it
%      3. train the map
%      4. visualize map
%      5. analyse results

%    The four first items are - if default options are used - very
%    simple operations, each executable with a single command.  For
%    the last, several different kinds of functions are provided in
%    the Toolbox, but as the needs of analysis vary, a general default
%    function or procedure does not exist. 

pause % Strike any key to construct data...



clc
%    STEP 1: CONSTRUCT DATA
%    ======================

			
%    Another option is to read the data directly from an ASCII file.
%    Here, the IRIS data set is loaded from a file (please make sure
%    the file can be found from the current path):

  sDiris = som_read_data('pHdata.txt');
  
clc
%    STEP 2: DATA NORMALIZATION
%    ==========================

%    Since SOM algorithm is based on Euclidian distances, the scale of
%    the variables is very important in determining what the map will
%    be like. If the range of values of some variable is much bigger
%    than of the other variables, that variable will probably dominate
%    the map organization completely. 

%    For this reason, the components of the data set are usually
%    normalized, for example so that each component has unit
%    variance. This can be done with function SOM_NORMALIZE:

sDiris = som_normalize(sDiris,'var');

%    The function has also other normalization methods.

%    However, interpreting the values may be harder when they have
%    been normalized. Therefore, the normalization operations can be
%    reversed with function SOM_DENORMALIZE:

x = sDiris.data(1,:)
orig_x = som_denormalize(x,sDiris)
sMap = som_make(sDiris);
sMap = som_autolabel(sMap,sDiris,'vote');
%colormap(1-gray)
som_show(sMap,'norm','d')

h=zeros(sMap.topol.msize); h(1,2) = 1;

som_show_add('hit',h(:),'markercolor','r','markersize',0.5,'subplot','all')

%som_show(sMap,'umat','all','empty','Labels')

%som_show_add('label',sMap,'Textsize',8,'TextColor','r','Subplot',2)


h = som_hits(sMap,sDiris);
som_show_add('hit',h,'MarkerColor','w','Subplot',1)

som_show_clear('hit',1)


[qe,te] = som_quality(sMap,sDiris)

%    People have contributed a number of functions to the Toolbox
%    which can be used for the analysis. These include functions for 
%    vector projection, clustering, pdf-estimation, modeling,
%    classification, etc. However, ultimately the use of these
%    tools is up to you.

%    More about visualization is presented in SOM_DEMO3.
%    More about data analysis is presented in SOM_DEMO4.

echo off
warning on




