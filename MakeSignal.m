function sig = MakeSignal(Name,n)
% MakeSignal -- Make artificial signal
% Usage
% sig = MakeSignal(Name,n)
% Inputs
% Name string: 'Bumps', 'Blocks',
% 'Ramp', 'Piece-Regular' (Piece-Wise Smooth),
% 'Piece-Polynomial' (Piece-Wise 3rd degree polynomial)
% n desired signal length
% Outputs
% sig 1-d signal
%%
% References
% Various articles of D.L. Donoho and I.M. Johnstone
%%
% Modifiee par Gregoire Morin 2018
%
if nargin > 1,
t = (1:n) ./n;
end
if strcmp(Name,'Bumps'),
pos = [ .1 .13 .15 .23 .25 .40 .44 .65 .76 .78 .81];
hgt = [ 4 5 3 4 5 4.2 2.1 4.3 3.1 5.1 4.2];
wth = [.005 .005 .006 .01 .01 .03 .01 .01 .005 .008 .005];
sig = zeros(size(t));
for j =1:length(pos)
sig = sig + hgt(j)./( 1 + abs((t - pos(j))./wth(j))).^4;
end
elseif strcmp(Name,'Blocks'),
pos = [ .1 .13 .15 .23 .25 .40 .44 .65 .76 .78 .81];
hgt = [4 (-5) 3 (-4) 5 (-4.2) 2.1 4.3 (-3.1) 2.1 (-4.2)];
sig = zeros(size(t));
for j=1:length(pos)
sig = sig + (1 + sign(t-pos(j))).*(hgt(j)/2) ;
end
elseif strcmp(Name,'Ramp'),
sig = t - (t >= .37);
elseif strcmp(Name,'Piece-Regular'),
sig1=-15*MakeSignal('Bumps',n);
t = (1:fix(n/12)) ./fix(n/12);
sig2=-exp(4*t);
t = (1:fix(n/7)) ./fix(n/7);
sig5=exp(4*t)-exp(4);
t = (1:fix(n/3)) ./fix(n/3);
sigma=6/40;
sig6=-70*exp(-((t-1/2).*(t-1/2))/(2*sigma^2));
sig(1:fix(n/7))= sig6(1:fix(n/7));
107
sig((fix(n/7)+1):fix(n/5))=0.5*sig6((fix(n/7)+1):fix(n/5));
sig((fix(n/5)+1):fix(n/3))=sig6((fix(n/5)+1):fix(n/3));
sig((fix(n/3)+1):fix(n/2))=sig1((fix(n/3)+1):fix(n/2));
sig((fix(n/2)+1):(fix(n/2)+fix(n/12)))=sig2;
sig((fix(n/2)+2*fix(n/12)):-1:(fix(n/2)+fix(n/12)+1))=sig2;
sig(fix(n/2)+2*fix(n/12)+fix(n/20)+1:(fix(n/2)+2*fix(n/12)+3*fix(n/20)))=...
-ones(1,fix(n/2)+2*fix(n/12)+3*fix(n/20)-fix(n/2)-2*fix(n/12)-fix(n/20))*25;
k=fix(n/2)+2*fix(n/12)+3*fix(n/20);
sig((k+1):(k+fix(n/7)))=sig5;
diff=n-5*fix(n/5);
sig(5*fix(n/5)+1:n)=sig(diff:-1:1);
% zero-mean
bias=sum(sig)/n;
sig=bias-sig;
elseif strcmp(Name,'Piece-Polynomial'),
t = (1:fix(n/5)) ./fix(n/5);
sig1=20*(t.^3+t.^2+4);
sig3=40*(2.*t.^3+t) + 100;
sig2=10.*t.^3 + 45;
sig4=16*t.^2+8.*t+16;
sig5=20*(t+4);
sig6(1:fix(n/10))=ones(1,fix(n/10));
sig6=sig6*20;
sig(1:fix(n/5))=sig1;
sig(2*fix(n/5):-1:(fix(n/5)+1))=sig2;
sig((2*fix(n/5)+1):3*fix(n/5))=sig3;
sig((3*fix(n/5)+1):4*fix(n/5))=sig4;
sig((4*fix(n/5)+1):5*fix(n/5))=sig5(fix(n/5):-1:1);
diff=n-5*fix(n/5);
sig(5*fix(n/5)+1:n)=sig(diff:-1:1);
sig((fix(n/20)+1):(fix(n/20)+fix(n/10)))=ones(1,fix(n/10))*10;
sig((n-fix(n/10)+1):(n+fix(n/20)-fix(n/10)))=ones(1,fix(n/20))*150;
% zero-mean
bias=sum(sig)/n;
sig=sig-bias;
else
disp(sprintf('MakeSignal: I don*t recognize <<%s>>',Name))
disp('Allowable Names are:')
disp('Bumps'),
disp('Blocks'),
disp('Ramp'),
disp('Piece-Regular');
disp('Piece-Polynomial');
end
% Originally made by David L. Donoho.
% Function has been enhanced.
% Part of Wavelab Version 850
% Built Tue Jan 3 13:20:39 EST 2006
% This is Copyrighted Material
% For Copying permissions see COPYING.m
% Comments? e-mail wavelab@stat.stanford.edu