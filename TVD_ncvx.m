function [x, cost] = TVD_ncvx(y, lam, pen, Nit)
% [x, cost] = TVD_ncvx(y, lam, pen, Nit)
% Total variation denoising with non-convex penalty.
%%
% INPUT
% y - noisy signal
% lam - regularization parameter (lam > 0)
% pen - penalty ('log', 'atan', 'L1')
% Nit - number of iterations
%%
% OUTPUT
% x - denoised signal
% cost - cost function history
% Reference:
% Convex 1-D Total Variation Denoising with Non-convex Regularization
% Ivan W. Selesnick, Ankit Parekh, and Ilker Bayram
% IEEE Signal Processing Letters, 2014
y = y(:); % Ensure column vector
cost = zeros(1, Nit); % Cost function history
N = length(y);
a = 1 / (4 * lam);
switch pen
case 'L1'
phi = @(x) abs(x);
dphi = @(x) sign(x);
wfun = @(x) abs(x);
case 'log'
phi = @(x) 1/a * log(1 + a*abs(x));
dphi = @(x) 1 ./(1 + a*abs(x)) .* sign(x);
wfun = @(x) abs(x) .* (1 + a*abs(x));
case 'atan'
phi = @(x) 2./(a*sqrt(3)) .* (atan((2*a.*abs(x)+1)/sqrt(3)) - pi/6);
wfun = @(x) abs(x) .* (1 + a.*abs(x) + a.^2.*abs(x).^2);
dphi = @(x) 1 ./(1 + a*abs(x) + a.^2.*abs(x).^2) .* sign(x);
end
e = ones(N-1, 1);
DDT = spdiags([-e 2*e -e], [-1 0 1], N-1, N-1); % D*D' (banded matrix)
D = @(x) diff(x); % D (operator)
DT = @(x) [-x(1); -diff(x); x(end)]; % D'
x = y; % Initialization
Dx = D(x);
Dy = D(y);
for k = 1:Nit
F = (1/lam) * spdiags(wfun(Dx), 0, N-1, N-1) + DDT; % F : Sparse matrix structure
x = y - DT(F\Dy); % Solve banded linear system
Dx = D(x);
cost(k) = 0.5*sum(abs(x-y).^2) + lam*sum(phi(Dx)); % Save cost function history
end