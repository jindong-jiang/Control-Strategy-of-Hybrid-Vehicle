
%UNTITLED3 Summary of this function goes here
% 
% C'est pour effectuer le script afin de établir le serial:
global s;
s = serial('COM3');  %定义串口对象
set(s,'BaudRate',9600);  %设置波特率s
fopen(s);  %打开串口对象s
% 
% fwrite(s,u)
% y = str2num(fgetl(s));  %用函数fget(s)从缓冲区读取串口数据，当出现终止符（换行符）停止。
%                         %所以在Arduino程序里要使用Serial.println()
%    
%     
% fclose(s);  %关闭串口对象


