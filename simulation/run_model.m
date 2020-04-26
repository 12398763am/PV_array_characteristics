tic
clear
%���÷�������������¶ȡ����յķ�Χ������
minT = -40;
maxT = 80;
stepT = 5;
minIr = 0;
maxIr = 1400;
stepIr = 100;
model = 'PV_array_model';
%�����������������Դ�Ԥ����data���ڴ�ռ�
cnt = 0;
for T = minT:stepT:maxT
    for Ir = minIr:stepIr:maxIr
        for diffIr2 = minIr:stepIr:Ir
            for diffIr1 = minIr:stepIr:diffIr2
                cnt = cnt + 1;
            end
        end
    end
end
tot = cnt;
cnt = 0;
%Ԥ����data�ڴ�ռ�
data(tot).T = 0;
data(tot).Ir = 0;
data(tot).diffIr1 = 0;
data(tot).diffIr2 = 0;
data(tot).p = [];
data(tot).u = [];
data(tot).i = [];
data(tot).mpp = 0;
data(tot).mppu = 0;
%��ʼ����
set_param(model, 'FastRestart', 'off');
rate=waitbar(0, '������0������,���0%');
for T = minT:stepT:maxT
    set_param(model, 'FastRestart', 'on');
    for Ir = minIr:stepIr:maxIr
        for diffIr2 = minIr:stepIr:Ir
            for diffIr1 = minIr:stepIr:diffIr2
                cnt = cnt + 1;
                sim(model);
                %������ʵ㼰���Ӧ��ѹ
                p = load('P.mat');
                u = load('U.mat');
                i = load('I.mat');
                [data(cnt).mpp,index]=max(p.ans.Data);
                data(cnt).mppu=u.ans.Data(index);
                %��¼��������
                data(cnt).T = T;
                data(cnt).Ir = Ir;
                data(cnt).diffIr1 = diffIr1;
                data(cnt).diffIr2 = diffIr2;
                data(cnt).p = p.ans.Data;
                data(cnt).u = u.ans.Data;
                data(cnt).i = i.ans.Data;
            end
        end
    end
    set_param(model, 'FastRestart', 'off');
    waitbar(cnt/tot, rate, sprintf('������%d������, ���%.1f%%', cnt, cnt/tot*100));
end
close(rate);
%���������
save result data
fprintf('�������!�� %d ������\n', cnt);
toc