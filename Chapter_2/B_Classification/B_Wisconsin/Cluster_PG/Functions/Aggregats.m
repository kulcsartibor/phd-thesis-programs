function Agr = Aggregats(X,Name)

% Rsat =	1
% Karo =	2
% Kiso =	3
% Kene =	4
% Nola =	5
% Nolef =	6
% Naro =	7
% Kox =		8
% Parox =	9
% Karo3 =	10
% Kcy =		11
% Ksatu =	12
% KeroH =	13
% AKaro =	14

	switch Name
		case 1
			Agr = (X(:,130)+X(:,112))./(X(:,185)+X(:,74)+X(:,99));
		case 2
			Agr = ((X(:,180).*X(:,27)./X(:,112)./X(:,74))-0.103).*7.3+5.8;
		case 3
			Agr = ((X(:,119)-X(:,112)+0.7)./(3*X(:,27)+X(:,112))-47.11).*3.43+39.08;
		case 4
			Agr = ((X(:,119).*X(:,74)./X(:,170))-0.00147).*16308+24.16;
		case 5
			Agr = ((X(:,187)+X(:,195)+X(:,15))/(X(:,180)+X(:,185))-0.637).*171+50;
		case 6
			Agr = ((7*X(:,15)+X(:,74))./(X(:,174)+X(:,190))-0.1586).*165+35.2;
		case 7
			Agr = (X(:,84)./(20*X(:,15)+X(:,112))-0.0686).*550-12.22;
		case 8
			Agr = ((X(:,112)-X(:,119))./(X(:,180)-X(:,152))-1.214).*8+34.7;
		case 9
			Agr = ((X(:,112)./X(:,119))-1.2462).*130+55;
		case 10
			Agr = (X(:,185)./X(:,142)-0.93).*23+3.385;
		case 11
			Agr = (X(:,130)./X(:,91)-1.539).*64+24.5;
		case 12
			Agr = (X(:,130)./(X(:,42)+X(:,27))-5.402).*2+10.8;
		case 13
			Agr = ((15400.58*X(:,177)+2435597*X(:,29)+223117.5*X(:,137)-94580.45*X(:,115)+217092.6*X(:,63)-1169338*X(:,10)))-1000;
		case 14
			Agr = (0.429531*X(:,31)-0.586484*X(:,75)+0.946330*X(:,127)).*X(:,123).*100000;
	end
Agr = (Agr - min(Agr))./(max(Agr) - min(Agr));
end


