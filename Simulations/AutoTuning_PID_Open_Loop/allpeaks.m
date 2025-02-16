function P=allpeaks(y)

peak=0;
for k = 2:length(y)-1
   if y(k) > y(k-1)
       if y(k) > y(k+1)
           peak = peak + 1;
           P(peak,:)=[k  y(k)];
       end
   end  
end