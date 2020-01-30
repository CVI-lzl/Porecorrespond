function FPP_Selected_DP_Code(length,output)
%   从DP LIST里选取DP Code
%   此处显示详细说明 
    Listroot=fullfile('E:\OCT\匹配汗孔_DP\',['DP_List_Large_',num2str(length)]);
    Coderoot=fullfile('E:\OCT\匹配汗孔\Pore deep feature code',[num2str(length),'_',num2str(output)]);
    outpath=fullfile('E:\OCT\匹配汗孔_DP\Pore deep feature code',[num2str(length),'_',num2str(output)]);
    for j=1:168
        for k=1:2
            for l=1:5
                Listpath=fullfile(Listroot,[num2str(j),'_',num2str(k),'_',num2str(l),'.txt']);
                if(exist(Listpath,'file')~=0)
                    Label=load(Listpath);
                    Cord=load(fullfile(Coderoot,[num2str(j),'_',num2str(k),'_',num2str(l),'.txt']));
                    A=Cord(Label,:);
                    dlmwrite(fullfile(outpath,[num2str(j),'_',num2str(k),'_',num2str(l),'.txt']),A);
                    fprintf('第%d_%d_%d个手指完成\n',j,k,l);
                else
                    fprintf('第%d_%d_%d个手指不存在\n',j,k,l);
                end
            end
        end
    end
    
end