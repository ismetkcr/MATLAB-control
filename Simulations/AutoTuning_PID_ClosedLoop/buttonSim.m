function z = buttonSim(time)
    if time<200
        z = 1;
       
    end
    
    if time>=200 %autotune veri toplar
        z = 2;
    end
    
    if time == 400 %autotune parametre hesaplar
        z = 3;
    end
    if time>400
        z = 1; % cont devreye sokulmal� y_array temizlenmeli bir sonraki update i�in.
        
    end
    
    if time>850
        z = 2; %autotune devrede
    end
    
    if time == 1200 % parametre hesapland�
        z =3;
    end
    
    if time >1200 % controller devreye girdi, y_array temizlendi.
        z = 1;
    end
    
    if time >1400
        z=2; %autotune devrede
    end
    
    if time == 1500 %parametreleri hesapla
        z = 3;
    end
    
    if time >1500
        z =1;
    end
end
 
    