function position1(Arduino,Sensor_Pin,Ex_Pin,Re_Pin,Dis_Des)
Ts=1000;
Kp=0.7;
Ki=0;
Kd=0.08;
A=Kp+((Ki*Ts)/2)+(Kd/Ts);
B=((Ki*Ts)/2)-(Kd/Ts);
C=Ki;
en=0;
en_1=0;
Intprev=0;
xn=0;
limit_pwm=110;
Lowest_pwm=80;



 sensor =  readVoltage(Arduino,Sensor_Pin);
 displacement = ((sensor* 500.0)/5.0)-40;
 
  if (Dis_Des >350)
      Dis_Des=350;
  else if (Dis_Des<50)
          Dis_Des=50;
      end
  end

en = Dis_Des - displacement;
xn = (A*en)+(B*en_1)+(C*Intprev);

if (en<10 && en>-10)
writePWMVoltage(Arduino,Ex_Pin, (0));
writePWMVoltage(Arduino,Re_Pin, 0);
xn=0;
else

if (xn > limit_pwm)
xn = limit_pwm;
else if(xn < -limit_pwm)
xn = -limit_pwm;
    end
if(xn>-Lowest_pwm && xn ~=0 && en<0)
xn=-Lowest_pwm;
end
end

if( xn< Lowest_pwm && xn ~= 0 && en>=0)
xn=Lowest_pwm;
end
 X = [num2str(displacement),' displacement ',num2str(Dis_Des),' Dis_Des  ',num2str(Ex_Pin),'PWM  ',num2str(xn)];
  disp(X);

if (xn>0)
writePWMVoltage(Arduino,Ex_Pin, (xn/51));
writePWMVoltage(Arduino,Re_Pin, 0);
else 
writePWMVoltage(Arduino,Re_Pin,(-xn/51));
writePWMVoltage(Arduino,Ex_Pin,0);

end
end
% Intprev=Intprev+(((en+en_1)/2)*Ts); 
% en_1=en;
end
