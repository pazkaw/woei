 function direction = getDirection(lat1, lng1, lat2, lng2) 
lat1 = lat1 ./180*pi;
lat2 = lat2 ./180*pi;
lng1 = lng1 ./180*pi;
lng2 = lng2 ./180*pi;


dTeta = log(tan((lat2/2)+(pi/4))/tan((lat1/2)+(pi/4)));
dLon = abs(lng1-lng2);
teta = atan2(dLon,dTeta);
direction = teta*180/pi;

