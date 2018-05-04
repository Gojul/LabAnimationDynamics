function [ Xd ] = eom( t,X )
 %Takes a state X and outputs the derivative of X (Xd)

Xd = zeros(8,1);


Xd(1) = X(5);
Xd(2) = X(6);
Xd(3) = X(7);
Xd(4) = X(8);
Xd(5) = t; %plug in alpha eqn here
Xd(6) = t; %plug in beta eqn here
Xd(7) = t; %plug in gamma eqn here
Xd(8) = t; %plug in delta eqn here

end
