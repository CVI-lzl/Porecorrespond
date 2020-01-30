function FPP_RANSAC_BT(length, output, K)
%   使用RANSAC（WRANSAC）来去伪，生成精调后的对应列表
%   此处显示详细说明
    if K==1
        correspondroot=fullfile('E:\OCT\匹配汗孔_Small\粗匹配对\',[num2str(length),'_',num2str(output)]);
        cordinateroot=fullfile('E:\OCT\提取汗孔\Small\',['NEW_ASS_',num2str(floor(length/2))]);
        outpath=fullfile('E:\OCT\匹配汗孔_Small\RANSAC\',[num2str(length),'_',num2str(output)]);
        mkdir(fullfile(outpath,'GP'));
        mkdir(fullfile(outpath,'IP'));
    elseif K==2
        correspondroot=fullfile('E:\OCT\匹配汗孔_Small\粗匹配对\',num2str(length));
        cordinateroot=fullfile('E:\OCT\提取汗孔\Small\',['NEW_ASS_',num2str(floor(length/2))]);
        outpath=fullfile('E:\OCT\匹配汗孔_Small\RANSAC\',num2str(length));
        mkdir(fullfile(outpath,'GP'));
        mkdir(fullfile(outpath,'IP'));
    elseif K==3
        correspondroot=fullfile('E:\OCT\匹配汗孔_Small\粗匹配对\',num2str(output));
        cordinateroot=fullfile('E:\OCT\提取汗孔\Small\',['NEW_ASS_',num2str(15)]);
        outpath=fullfile('E:\OCT\匹配汗孔_Small\RANSAC\',num2str(output));
        mkdir(fullfile(outpath,'GP'));
        mkdir(fullfile(outpath,'IP'));
    end
    %RANSAC
    GP=load('E:\OCT\匹配汗孔_Small\GP.txt');
    IP=load('E:\OCT\匹配汗孔_Small\IP.txt');
    threshold=10;           %距离允许的误差
    miter=100;
    threshold_refine = 50
    %GP
    for count=3701:3700
        %clear
        fp1=fullfile(cordinateroot,[num2str(GP(count,1)),'_',num2str(GP(count,2)),'_',num2str(GP(count,3)),'.txt']);
        fp2=fullfile(cordinateroot,[num2str(GP(count,4)),'_',num2str(GP(count,5)),'_',num2str(GP(count,6)),'.txt']);
        % pore汗孔表示坐标读取
        pore1=load(fp1);
        pore2=load(fp2);
        corres=load(fullfile(correspondroot,'GP',[num2str(count),'.txt']));
        upth=size(corres,1);
        %算法M迭代次数
        finalcorr=zeros(upth,2);
        maxcount=0;
        if upth>3
             flag=0;
            for iter=1:miter
                p1=unidrnd(upth);
                while(1)
                    p2=unidrnd(upth);
                    if p2~=p1
                        break;
                    end
                end    
                while(1)
                    p3=unidrnd(upth);
                    if (p3~=p2 && p3~=p1)
                        break;
                    end
                end
                x1=pore1(corres(p1,1),1);
                y1=pore1(corres(p1,1),2);
                xp1=pore2(corres(p1,2),1);
                yp1=pore2(corres(p1,2),2);
                dx=xp1-x1;
                dy=yp1-y1;
                x2=pore1(corres(p2,1),1);
                y2=pore1(corres(p2,1),2);
                xp2=pore2(corres(p2,2),1);
                yp2=pore2(corres(p2,2),2);
                x3=pore1(corres(p3,1),1);
                y3=pore1(corres(p3,1),2);
                xp3=pore2(corres(p3,2),1);
                yp3=pore2(corres(p3,2),2);
                if (norm([xp2-(x2+dx) yp2-(y2+dy)])<threshold_refine && norm([xp3-(x3+dx) yp3-(y3+dy)])<threshold_refine)
                    flag=1;
                    %方程组
                    syms a11 a12 a21 a22 tx ty;
                    e1=a11*x1 + a12*y1 + tx - xp1;
                    e2=a21*x1 + a22*y1 + ty - yp1;
                    e3=a11*x2 + a12*y2 + tx - xp2;
                    e4=a21*x2 + a22*y2 + ty - yp2;
                    e5=a11*x3 + a12*y3 + tx - xp3;
                    e6=a21*x3 + a22*y3 + ty - yp3;
                    [a11,a12,a21,a22,tx,ty]=solve(e1,e2,e3,e4,e5,e6,a11,a12,a21,a22,tx,ty);
                    a11=double(a11);
                    a12=double(a12);
                    a21=double(a21);
                    a22=double(a22);
                    tx=double(tx);
                    ty=double(ty);
                    ccount=0;
                    tempcorres=zeros(upth,2);
                    for j=1:upth
                        x=pore1(corres(j,1),1);
                        y=pore1(corres(j,1),2);
                        xp=pore2(corres(j,2),1);
                        yp=pore2(corres(j,2),2);
                        xr=round(a11*x+a12*y+tx,4);
                        yr=round(a21*x+a22*y+ty,4);
                        if(norm([xp-xr yp-yr])<threshold && norm([xr-(xp+dx) yr-(yp+dy)]<threshold_refine))
                            ccount=ccount+1;
                            tempcorres(ccount,:)=corres(j,:);
                        end
                    end
                    if(ccount>maxcount)
                        maxcount=ccount;
                        finalcorr=tempcorres;
                    end
                end
            end
            if(flag==0)
                finalcorr(1,:)=corres(p1,:);
                finalcorr(2,:)=corres(p2,:);
                finalcorr(3,:)=corres(p3,:);
                maxcount=3;
                dlmwrite(fullfile(outpath,'GP',[num2str(count),'.txt']),finalcorr(1:maxcount,:));
            elseif(flag==1)
                dlmwrite(fullfile(outpath,'GP',[num2str(count),'.txt']),finalcorr(1:maxcount,:));
            end
        elseif upth<=3
            maxcount=upth;
            finalcorr(1:maxcount,:)=corres(:,:);
        end
        fprintf('GP第%d个完成\n',count);
        dlmwrite(fullfile(outpath,'GP',[num2str(count),'.txt']),finalcorr(1:maxcount,:));
    end
    fprintf('GP完成\n');
    %IP
    for count=1:21756
        fp1=fullfile(cordinateroot,[num2str(IP(count,1)),'_',num2str(IP(count,2)),'_',num2str(IP(count,3)),'.txt']);
        fp2=fullfile(cordinateroot,[num2str(IP(count,4)),'_',num2str(IP(count,5)),'_',num2str(IP(count,6)),'.txt']);
        % pore汗孔表示坐标读取
        pore1=load(fp1);
        pore2=load(fp2);
        corres=load(fullfile(correspondroot,'IP',[num2str(count),'.txt']));
        upth=size(corres,1);
        %算法M迭代次数
        finalcorr=zeros(upth,2);
        maxcount=0;
        if upth>3
            %标记有无找到最小的三对RANSAC值
            flag=0;
            for iter=1:miter
                p1=unidrnd(upth);
                while(1)
                    p2=unidrnd(upth);
                    if p2~=p1
                        break;
                    end
                end    
                while(1)
                    p3=unidrnd(upth);
                    if (p3~=p2 && p3~=p1)
                        break;
                    end
                end
                x1=pore1(corres(p1,1),1);
                y1=pore1(corres(p1,1),2);
                xp1=pore2(corres(p1,2),1);
                yp1=pore2(corres(p1,2),2);
                dx=xp1-x1;
                dy=yp1-y1;
                x2=pore1(corres(p2,1),1);
                y2=pore1(corres(p2,1),2);
                xp2=pore2(corres(p2,2),1);
                yp2=pore2(corres(p2,2),2);
                x3=pore1(corres(p3,1),1);
                y3=pore1(corres(p3,1),2);
                xp3=pore2(corres(p3,2),1);
                yp3=pore2(corres(p3,2),2);
                if (norm([xp2-(x2+dx) yp2-(y2+dy)])<threshold_refine && norm([xp3-(x3+dx) yp3-(y3+dy)])<threshold_refine)
                    flag=1;
                    %方程组
                    syms a11 a12 a21 a22 tx ty;
                    e1=a11*x1 + a12*y1 + tx - xp1;
                    e2=a21*x1 + a22*y1 + ty - yp1;
                    e3=a11*x2 + a12*y2 + tx - xp2;
                    e4=a21*x2 + a22*y2 + ty - yp2;
                    e5=a11*x3 + a12*y3 + tx - xp3;
                    e6=a21*x3 + a22*y3 + ty - yp3;
                    [a11,a12,a21,a22,tx,ty]=solve(e1,e2,e3,e4,e5,e6,a11,a12,a21,a22,tx,ty);
                    a11=double(a11);
                    a12=double(a12);
                    a21=double(a21);
                    a22=double(a22);
                    tx=double(tx);
                    ty=double(ty);
                    ccount=0;
                    tempcorres=zeros(upth,2);
                    for j=1:upth
                        x=pore1(corres(j,1),1);
                        y=pore1(corres(j,1),2);
                        xp=pore2(corres(j,2),1);
                        yp=pore2(corres(j,2),2);
                        xr=round(a11*x+a12*y+tx,4);
                        yr=round(a21*x+a22*y+ty,4);
                        if(norm([xp-xr yp-yr])<threshold  && norm([xr-(xp+dx) yr-(yp+dy)]<threshold_refine))
                            ccount=ccount+1;
                            tempcorres(ccount,:)=corres(j,:);
                        end
                    end
                    if(ccount>maxcount)
                        maxcount=ccount;
                        finalcorr=tempcorres;
                    end
                end
            end            
            if(flag==0)
                finalcorr(1,:)=corres(p1,:);
                finalcorr(2,:)=corres(p2,:);
                finalcorr(3,:)=corres(p3,:);
                maxcount=3;
                dlmwrite(fullfile(outpath,'IP',[num2str(count),'.txt']),finalcorr(1:maxcount,:));
            elseif(flag==1)
                dlmwrite(fullfile(outpath,'IP',[num2str(count),'.txt']),finalcorr(1:maxcount,:));
            end
        elseif upth<=3
            maxcount=upth;
            finalcorr(1:maxcount,:)=corres(:,:);
            dlmwrite(fullfile(outpath,'IP',[num2str(count),'.txt']),finalcorr(1:maxcount,:));
        end
        fprintf('IP第%d个完成\n',count);
    end
    fprintf('IP完成\n');
end