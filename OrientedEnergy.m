% show the SVD application in oriented energy

x=randn(10000,1);
y=0.5*randn(10000,1);
x2=0.7071*(x-y); % 45 degree
y2=0.7071*(x+y); % 45 degree
clear x;
clear y;
[U,S,V]=svd([x2,y2],0);
plot(x2,y2,'.');
hold on;
L1=S(1)^2/10000;
L2=S(4)^2/10000;
h=quiver(0,0,L1*V(1,1),L1*V(2,1));
set(h,'color','red');
h=quiver(0,0,L2*V(1,2),L2*V(2,2));
set(h,'color','red');
