clear all;
A ='p511d511e511f511';
a = arduino('COM25', 'Mega2560');
   s=instrfind('Type','serial','Port','COM3');
while(1)                                                                                                      
    
% a=instrfind('Type','serial','Port','COM20');
 if isempty(s)
     s=serial('COM3');
     
 else
     
     fclose(s);
     s=s(1);
     
 end

  if isempty(a)
     a=serial('COM25');
 else
     fclose(serial(a.Port));
     a=a(1);
  end  

set(s,'BaudRate',9600);
% s=serial('COM2','BaudRate',9600,'DataBits',8);
 fopen(s);
%  fopen(serial(a.Port));
A=fscanf(s,'%s',12);
disp(A);



P=A(1:3);
Y=A(4:6);
R=A(7:9);
Pitch=(511-str2double(P))/5.5;
Yaw=(511-str2double(Y))/5.5;
Roll=(511-str2double(R))/5.5;

CY=cosd(Yaw);
SY=sind(Yaw);

CP=cosd(Pitch);
SP=sind(Pitch);

CR=cosd(Roll);
SR=sind(Roll);

X = [00;00;710];%Frame P translation w.r.t frame origin
R = [(CP*CY)+(SR*SP*SY) -(CP*SY)+(SR*SP*CY) (CR*SP);(CR*SY) (CR*CY) -(SR);-(SP*CY)+(SR*CP*SY) (SP*SY)+(SR*CP*CY) CR*CP];%Rotation Matrix

P1 = [333.984818522;242.098461958;0];%Hub 1 upper coordinates w.r.t Frame P
P2 = [376.488874554;168.479082007;0];%Hub 2 upper coordinates w.r.t Frame P
P3 = [42.504404028;-410.000000000;0];%Hub 3 upper coordinates w.r.t Frame P
P4 = [-42.504404028;-408.911115471;0];%Hub 4 upper coordinates w.r.t Frame P
P5 = [-376.488874554;168.479082007;0];%Hub 5 upper coordinates w.r.t Frame P
P6 = [-333.984818522;242.098461958;0];%Hub 6 upper coordinates w.r.t Frame P

B1 = [42.535857425;828.879028572;0];%Hub 1 lower coordinates w.r.t Frame O
B2 = [739.102305725;-377.661018085;0];%Hub 2 lower coordinates w.r.t Frame O
B3 = [696.666118475;-451.281951688;0];%Hub 3 lower coordinates w.r.t Frame O
B4 = [-696.618677954;-451.191320599;0];%Hub 4 lower coordinates w.r.t Frame O
B5 = [-739.101284593;-377.662887859;0];%Hub 5 lower coordinates w.r.t Frame O
B6= [-42.486070533;828.911876838;0];%Hub 6 lower coordinates w.r.t Frame O



  Result = X+(R*P1);
  L=Result-B1;
  Len=sqrt( (L(1)*L(1)) + (L(2)*L(2)) );
  Length=sqrt((Len*Len)+(L(3)*L(3)) )-815;
  position1(a,'A0','D2','D3',Length);
 

  Result = X+(R*P2);
  L=Result-B2;
  Len=sqrt( (L(1)*L(1)) + (L(2)*L(2)) );
  Length2=sqrt((Len*Len)+(L(3)*L(3)) )-815;
  position2(a,'A1','D6','D7',Length2); 

 
  Result = X+(R*P3);
  L=Result-B3;
  Len=sqrt( (L(1)*L(1)) + (L(2)*L(2)) );
  Length3=sqrt((Len*Len)+(L(3)*L(3)) )-815;
  position3(a,'A2','D8','D9',Length3);


  Result = X+(R*P4);
  L=Result-B4;
  Len=sqrt( (L(1)*L(1)) + (L(2)*L(2)) );
  Length4=sqrt((Len*Len)+(L(3)*L(3)) )-815;
  position4(a,'A3','D12','D13',Length4);


  Result = X+(R*P5);
  L=Result-B5;
  Len=sqrt( (L(1)*L(1)) + (L(2)*L(2)) );
  Length5=sqrt((Len*Len)+(L(3)*L(3)) )-815;
  position5(a,'A4','D10','D11',Length5);

  Result = X+(R*P6);
  L=Result-B6;
  Len=sqrt( (L(1)*L(1)) + (L(2)*L(2)) );
  Length6=sqrt((Len*Len)+(L(3)*L(3)) )-815;
  position6(a,'A5','D4','D5',Length6);

end