M=4; N=4;
B=zeros([4,4]);
for P=1:M
    p=P-1;
    for Q=1:N
        q=Q-1;
        if (p)==0 && (q)==0
            ap=1/sqrt(M);
            aq=1/sqrt(N);
        else
            ap=sqrt(2/M);
            aq=sqrt(2/N);
        end
    
        for x=1:M
            for y=1:N
                B(x,y)=ap*aq*cos((pi*(p)*(2*(x-1)+1))/(2*M))*cos((pi*(q)*(2*(y-1)+1))/(2*N));
            end
        end
        basisimg = ind2rgb(im2uint8(B),copper);
        filename = strcat(num2str(p), num2str(q), '.png');
        imwrite(imresize(basisimg,[16,16],'nearest'),filename);
    end
        
    
end
 
path='C:\Users\USER\Documents\MATLAB';
imds = imageDatastore(fullfile(path,'*.png'));
montage(imds,'BackgroundColor','white','BorderSize',[2,2]);