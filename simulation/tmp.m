tic
clear
cnt = 0;
model = 'PV_array_model';
tot = 101;
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
for T = 25:25:25
    set_param(model, 'FastRestart', 'on');
    for Ir = 1100:1:1200
        for diffIr2 = Ir - 500:1:Ir - 500
            for diffIr1 = Ir - 800:1:Ir - 800
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
save tmp_result data
fprintf('�������!�� %d ������\n', cnt);
toc

lastdiff = 0;
diff = 0;
for i = 1:101
    cnt = 1;
    for j = 2:length([data(i).p])
        lastdiff = diff;
        diff = data(i).p(j) - data(i).p(j - 1);
        if lastdiff > 0 && diff < 0
            peak_p(i,cnt) = data(i).p(j - 1);
            peak_u(i,cnt) = data(i).u(j - 1);
            cnt = cnt + 1;
        end
    end
end

plot(peak(1:101,3))
hold on
plot([data.mpp])
plot(predict_p)
legend({'�絼����','�������ֵ','������Ԥ��'});