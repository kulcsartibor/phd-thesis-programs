initialDir = cd; 
directory_name = uigetdir;
cd(directory_name);

Spectra2Export=evalin('base','BCP.LCIR');
Wavenumber=evalin('base','BCP.Wavenumber');
[r,c]=size(Spectra2Export);
for i=1:r;
Spectra_n(1,:)=Wavenumber; 
Spectra_n(2,:)=Spectra2Export(i,:); 
Spectra_n=Spectra_n';
i=i+1000;
fname = sprintf('ExportedSpectra_%d.txt',i);
dlmwrite (fname,Spectra_n,'newline','pc','delimiter','\t');
%i=1-1000; % What's this for? Check it or delete it!
clear Spectra_n;
end
cd(initialDir);%