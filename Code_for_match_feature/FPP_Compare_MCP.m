function FPP_Compare_MCP(length, output, K)
%   指纹匹配：找到最近匹配对，并列表
%   此处显示详细说明
    if K==1
        porecoderoot=fullfile('E:\OCT\匹配汗孔_Small\Pore deep feature code',[num2str(length),'_',num2str(output)]);
        outpath=fullfile('E:\OCT\匹配汗孔_Small\粗匹配对\',[num2str(length),'_',num2str(output)]); 
        mkdir(fullfile(outpath,'GP'));
        mkdir(fullfile(outpath,'IP'));
        % 求出最近邻的匹配值（TOP-K个，再按阈值取消部分）
        % 找出要比较的两指纹图（）
        GP=load('E:\OCT\匹配汗孔_Small\GP.txt');
        IP=load('E:\OCT\匹配汗孔_Small\IP.txt');
    elseif K==2
        porecoderoot=fullfile('E:\OCT\匹配汗孔_Small\Pore deep feature code',num2str(length));
        outpath=fullfile('E:\OCT\匹配汗孔_Small\粗匹配对',num2str(length)); 
        mkdir(fullfile(outpath,'GP'));
        mkdir(fullfile(outpath,'IP'));
        % 求出最近邻的匹配值（TOP-K个，再按阈值取消部分）
        % 找出要比较的两指纹图（）
        GP=load('E:\OCT\匹配汗孔_Small\GP.txt');
        IP=load('E:\OCT\匹配汗孔_Small\IP.txt'); 
    elseif K==3
        porecoderoot=fullfile('E:\OCT\匹配汗孔_Small\Pore deep feature code',num2str(output));
        outpath=fullfile('E:\OCT\匹配汗孔_Small\粗匹配对',num2str(output)); 
        mkdir(fullfile(outpath,'GP'));
        mkdir(fullfile(outpath,'IP'));
        % 求出最近邻的匹配值（TOP-K个，再按阈值取消部分）
        % 找出要比较的两指纹图（）
        GP=load('E:\OCT\匹配汗孔_Small\GP.txt');
        IP=load('E:\OCT\匹配汗孔_Small\IP.txt');
    end
    %GP列表
    tic
    for count=1:3700
        fp1=fullfile(porecoderoot,[num2str(GP(count,1)),'_',num2str(GP(count,2)),'_',num2str(GP(count,3)),'.txt']);
        fp2=fullfile(porecoderoot,[num2str(GP(count,4)),'_',num2str(GP(count,5)),'_',num2str(GP(count,6)),'.txt']);
        % pore汗孔表示向量读取
        pore1=load(fp1);
        pore2=load(fp2);  
        num1=size(pore1,1);
        num2=size(pore2,1);
        %生成匹配对之表格
        Score=zeros(num1,num2);
        for j=1:num1
            for k=1:num2
                fea1=pore1(j,:);
                fea2=pore2(k,:);            
                %计算欧式距离
                Score(j,k)=sqrt(sum((fea1-fea2).^2));
            end
        end
        %寻找最佳匹配对 
        Pair =[  ];
        %%%%  FOR RANSAC
        for j=1:num1
            [m, in]=min(Score(j,:));
            [mv,inv]=min(Score(:,in));
            if (m==mv && inv ==j)
                Pair = cat(1, Pair, [j in]);
            end
        end
        %%%%  FOR WRANSAC
%         summ=0;
%         for j=1:num1
%             m=min(Score(j,:));
%             summ=summ+m;
%         end
%         threshold=summ/num1;
%         [M,N]=find(Score<=threshold);
%         Pair=[M N];
%         Pair=sortrows(Pair);
        %写入
        dlmwrite(fullfile(outpath,'GP',[num2str(count),'.txt']),Pair);
        fprintf('GP第%d个完成\n',count);
    end
    b=toc;
    fprintf('%f\n',b);
    fprintf('GP完成\n');
    % IP列表
    for count=1:21756
        fp1=fullfile(porecoderoot,[num2str(IP(count,1)),'_',num2str(IP(count,2)),'_',num2str(IP(count,3)),'.txt']);
        fp2=fullfile(porecoderoot,[num2str(IP(count,4)),'_',num2str(IP(count,5)),'_',num2str(IP(count,6)),'.txt']);
        % pore汗孔表示向量读取
        pore1=load(fp1);
        pore2=load(fp2);  
        num1=size(pore1,1);
        num2=size(pore2,1);
        %生成匹配对之表格    
        Score=zeros(num1,num2);
        for j=1:num1
            for k=1:num2
                fea1=pore1(j,:);
                fea2=pore2(k,:);            
                %计算欧式距离
                Score(j,k)=sqrt(sum((fea1-fea2).^2));
            end
        end
        Pair =[ ];       
        %%%%  FOR RANSAC
        for j=1:num1
            [m, in]=min(Score(j,:));
            [mv,inv]=min(Score(:,in));
            if (m==mv && inv ==j) 
                Pair = cat(1, Pair, [j in]);
            end
        end
        %%%%  FOR WRANSAC
%         summ=0;
%         for j=1:num1
%             m=min(Score(j,:));
%             summ=summ+m;
%         end
%         threshold=summ/num1;
%         [M,N]=find(Score<=threshold);
%         Pair=[M N];
%         Pair=sortrows(Pair);
        %写入
        dlmwrite(fullfile(outpath,'IP',[num2str(count),'.txt']),Pair);
        fprintf('IP第%d个完成\n',count);
    end
    fprintf('IP完成\n');
end