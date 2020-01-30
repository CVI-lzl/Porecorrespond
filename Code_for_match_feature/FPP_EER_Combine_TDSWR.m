clear

GP_DBI_m = importdata('GP(3).txt');
IP_DBI_m = importdata('IP(3).txt');
GP_DBII_m = importdata('GP(2).txt');
IP_DBII_m = importdata('IP(2).txt'); 

load('./TDSWR result/TDSWR result/Tangent_I.mat');
load('./TDSWR result/TDSWR result/Tangent_Partial.mat');
load('./TDSWR result/TDSWR result/Tangent_G.mat');

GP_DBI_T = G_P_NUM;
IP_DBI_T = I_P_NUM;
GP_DBII_T = G_F_NUM;
IP_DBII_T = I_F_NUM;

%% DBI fusion
DBI_m = [GP_DBI_m;IP_DBI_m];
DBI_T = [GP_DBI_T;IP_DBI_T];
[ans1,a1,b1,IFAR,IFRR] = getFusion(DBI_m,DBI_T,length(DBI_m),3700);

%% DBII fusion
DBII_m = [GP_DBII_m;IP_DBII_m];
DBII_T = [GP_DBII_T;IP_DBII_T];
[ans2,a2,b2,IIFAR,IIFRR] = getFusion(DBII_m,DBII_T,length(DBII_m),3700);

[IFAR_m,IFRR_m,~]= cal(DBI_m,length(DBI_m),3700);
[IFAR_T,IFRR_T,~]= cal(DBI_T,length(DBI_T),3700);
val1 = getEER(IFAR_m,IFRR_m,length(IFAR_m));%
val2 = getEER(IFAR_T,IFRR_T,length(IFRR_T));

[IIFAR_m,IIFRR_m,~]= cal(DBII_m,length(DBII_m),3700);
[IIFAR_T,IIFRR_T,~]= cal(DBII_T,length(DBII_T),3700);
val3 = getEER(IIFAR_m,IIFRR_m,length(IIFRR_m));
val4 = getEER(IIFAR_T,IIFRR_T,length(IIFRR_T));

function [minEER, wa, wb, rFAR, rFRR]=getFusion(S1,S2,Total,nums)
minEER = 1;
wa = 1;
wb = 0;
for a = 0.01 : 0.01 : 1
   b= 1-a;
        sumScore =a*S1 + b*S2;
 
        [FAR,FRR,Maxim]= cal(sumScore,Total,nums);
        
        pos = Maxim;
        for i = 1 : Maxim
            if FAR(i) >= FRR(i) && FAR(i+1) <= FRR(i+1)
                pos = i;
                break;
            end
        end
        
        lb = max(FRR(pos),FAR(pos+1));
        rb = min(FRR(pos+1),FAR(pos));
        if((lb+rb)/2 <= minEER)
            minEER = (lb+rb)/2;
            wa = a;
            wb = b;
            rFAR = FAR;
            rFRR = FRR;
        end
    %end
end
end

function [FAR,FRR,Maxim]= cal(sumScore,Total,nums)
        Maxim = ceil(max(sumScore));
        step = 1;
        res = zeros(Maxim + 1,4); % 1 -> True postive 2-> False postive 3-> False N 4 -> True N
        for thres = 0 : step : Maxim
           nS = sumScore >= thres;
          
           for i = 1 : Total
            if(i <= nums)  
                if(nS(i) == 1) % TP
                    res(thres+1,1) = res(thres+1,1) + 1;
                else % FP
                    res(thres+1,2) = res(thres+1,2) + 1;
                end
            else
                if(nS(i) == 0) % TN
                    res(thres+1,4) = res(thres+1,4) + 1;
                else % FP
                    res(thres+1,3) = res(thres+1,3) + 1;
                end
            end
           end
        end

        FRR = (res(:,2))/nums;
        FAR = (res(:,3)/(Total-nums));

end

function [EER] = getEER(FAR,FRR,Maxim)
EER=1;
 pos = Maxim;
        for i = 1 : Maxim
            if FAR(i) >= FRR(i) && FAR(i+1) <= FRR(i+1)
                pos = i;
                break;
            end
        end
        
        lb = max(FRR(pos),FAR(pos+1));
        rb = min(FRR(pos+1),FAR(pos));
       
            EER = (lb+rb)/2;
        
end