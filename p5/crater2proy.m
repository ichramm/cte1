function Lpiscale=crater2proy(Dfinal,rhoproj,v,theta,rhotarget,g,targtype);
% Dfinal - km
% rhoproj, ,rhotarget - kg/m3
% v - km/s
% theta - degrees
% g - m/s2
% enter the target type, (1-3):
% type 1 = liquid water
% type 2 = loose sand  
% type 3 = competent rock or saturated soil
% Lpiscale - diam. projectile - m

Cd=[1.88,1.54 ,1.6];
beta=[0.22,0.165,0.22];
gearth=9.8;
gmoon=1.67;
rhomoon=2700.;
Dstarmoon=1.8e4;
Dprmoon=1.4e5;
third=1/3;
v=1000.*v;                        %km/sec to m/sec
Dfinal=1000.*Dfinal;               %km to m
theta=theta*(pi/180.);             %degrees to radians
anglefac=(sin(theta))^third;      %impact angle factor
densfac=(rhoproj^0.16667)/sqrt(rhotarget);
pifac=(1.61*g)/v^2;               %inverse froude length factor
Ct=0.80;                           %coefficient for formation time
if targtype==1
    Ct=1.3;
end
Dstar=(gmoon*rhomoon*Dstarmoon)/(g*rhotarget); %transition crater diameter
Dpr  =(gmoon*rhomoon*Dprmoon  )/(g*rhotarget); %peak-ring crater diameter

sel=find(Dfinal<Dstar);
Dt=zeros(size(Dfinal));
Dt(sel)=0.64*Dfinal(sel);
sel=find(Dfinal>=Dstar);
Dt(sel)=0.64*(Dfinal(sel)*Dstar^0.18).^0.8475;
% if Dfinal<Dstar
%  Dt=0.64*Dfinal;
% else
%  Dt=0.64*(Dfinal*Dstar^0.18)^0.8475;
% end
dscale=((6.*rhotarget)/(pi*rhoproj))^third;

%
%    Pi Scaling (Schmidt and Holsapple 1987)
%
Dstd=Dt/anglefac;
Lpiscale=(Dstd*dscale*pifac^beta(targtype))/Cd(targtype);
Lpiscale=Lpiscale.^(1./(1.-beta(targtype)));

