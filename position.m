function position(Arduino,Ex_Pin,Re_Pin,Dis_Des,displacement)
Ts=1;
Kp=2;
Ki=0;
Kd=0.5;
A=Kp+((Ki*Ts)/2)+(Kd/Ts);
B=((Ki*Ts)/2)-(Kd/Ts);
C=Ki;
en=0;
en_1=0;
Intprev=0;
xn=0;
limit_pwm=80;
Lowest_pwm=60;



% sensor =  readVoltage(Arduino,Sensor_Pin);
% % voltage = sensor * (5.0/1023.0); %to convert the analog reading to a voltage from (0-24v)
% displacement = (sensor* 500.0)/5.0;

 if (Dis_Des >450)
     Dis_Des=450;
 else if (Dis_Des<0)
         Dis_Des=0;
     end
 end

en = Dis_Des - displacement;
xn = (A*en)+(B*en_1)+(C*Intprev);

if (en<20 && en>-20)
writePWMVoltage(Arduino,Ex_Pin, (0));
writePWMVoltage(Arduino,Re_Pin, 0);
xn=0;
else

if (xn > limit_pwm)
xn = limit_pwm;
else if(xn < -limit_pwm)
xn = -limit_pwm;
    end
end

if( xn< Lowest_pwm && xn ~= 0 && en>=0)
xn=Lowest_pwm;
end
if(xn>-Lowest_pwm && xn ~=0 && en<0)
xn=-Lowest_pwm;
end
disp(displacement);
disp(xn);
if (xn>0)
writePWMVoltage(Arduino,Ex_Pin, (xn/51));
writePWMVoltage(Arduino,Re_Pin, 0);
else 
writePWMVoltage(Arduino,Re_Pin,(-xn/51));
writePWMVoltage(Arduino,Ex_Pin,0);

end
end
Intprev=Intprev+(((en+en_1)/2)*Ts);
en_1=en;
end
