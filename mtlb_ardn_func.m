function [ y ] = mtlb_ardn_func( u )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
 global s;
 
 
fwrite(s,u); 
y = str2num(fgetl(s));
%y=fgetl(s);

% interval=7;
% passo=1;
% t=1;
% x=[];xx=[];
% b=-1000;
% xb=u;
% fwrite(s,xb);
% % while(t<interval)
% % while(b<-999)
%     b=str2num(fgetl(s))
% % end
% %     x=[x,b];
% %     plot(x);
%    
% %     xb=b-1;
% %     fwrite(s,xb);
% %     hold on
% %     xx=[xx xb]
% %     plot(xx);
%     
% %     grid
% %     t=t+passo;
% %     drawnow;
% % end
% fclose(s);
% 
% y =b;

end

