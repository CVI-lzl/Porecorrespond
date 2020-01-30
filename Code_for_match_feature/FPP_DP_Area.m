function FPP_DP_Area(select_size)
%   提取distinctive pore的区域
%   此处显示详细说明
    prootpath = 'E:\OCT\匹配汗孔\FULL\Minu\';
    realID = 'E:\OCT\提取汗孔\Large\ASS\';
    for j=1:168 
        for k=1:2
            for l=1:5
                porepath = fullfile(prootpath,[num2str(j),'_',num2str(k),'_',num2str(l),'.txt']);
                realpath = fullfile(realID,[num2str(j),'_',num2str(k),'_',num2str(l),'.txt']);
                image = zeros(480,640);
                if(exist(realpath, 'file')~=0)
                    pore = load(porepath);
                    row = size(pore, 1);
                    for ii = 1:row
                        x = pore(ii,2);
                        y = pore(ii,1);
                        for xi=1:480
                            for yi=1:640
                                if (norm([xi yi]-[x y])<=select_size)
                                    image(xi,yi)=255;
                                end
                            end
                        end
                    end             
                    imwrite(image,fullfile('E:\OCT\提取汗孔\Large\DP_Area',[num2str(j),'_',num2str(k),'_',num2str(l),'.bmp']));
                    fprintf('第%d_%d_%d个手指完成\n',j,k,l);
                else
                    fprintf('第%d_%d_%d个手指不存在\n',j,k,l);
                end
            end
        end
    end
end