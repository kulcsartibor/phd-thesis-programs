%% Spektrumok beolvasása
% MOL spektrum adatok beolvasása matlabba
% Kulcsár Tibor
% 2012.11.05
%%

clear all;close all; clc;
addpath('ExprEval');

%%
Agr.Rsat	= topnir2mat('(W4260+W4332)/(W4040+W4484+W4384)');
Agr.Karo	= topnir2mat('((W4060*W4672/W4332/W4484)-0.103)*7.3+5.8');
Agr.Kiso	= topnir2mat('((W4304-W4332+0.7)/(3*W4672+W4332)-47.11)*3.43+39.08');
Agr.Kene	= topnir2mat('((W4304*W4484/W4100)-0.00147)*16308+24.16');
Agr.Nola	= topnir2mat('((W4032+W4000+W4720)/(W4060+W4040)-0.637)*171+50');
Agr.Nolef	= topnir2mat('((7*W4720+W4484)/(W4084+W4020)-0.1586)*165+35.2');
Agr.Naro	= topnir2mat('(W4444/(20*W4720+W4332)-0.0686)*550-12.22');
Agr.Kox		= topnir2mat('((W4332-W4304)/(W4060-W4172)-1.214)*8+34.7');
Agr.Parox	= topnir2mat('((W4332/W4304)-1.2462)*130+55');
Agr.Karo3	= topnir2mat('(W4040/W4212-0.93)*23+3.385');
Agr.Kcy		= topnir2mat('(W4260/W4416-1.539)*64+24.5');
Agr.Ksatu	= topnir2mat('(W4260/(W4616+W4672)-5.402)*2+10.8');
Agr.KeroH	= topnir2mat('((15400.58*W4072+2435597*W4764+223117.5*W4232-94580.45*W4320+217092.6*W4528-1169338*W4740))-1000');
Agr.AKaro	= topnir2mat('(0.429531*W4656-0.586484*W4480+0.946330*W4272)*W4288*100000');

save('TpAgr.mat','Agr')