load result.mat
k = 0;
for i = 1:1:17000
    if data(i).T == 25 && data(i).Ir == 1000 && data(i).diffIr1 == data(i).diffIr2
        k = k + 1;
        result(k) = data(i);
    end
end
hold on
for i = 1:1:5
    plot([result(i).u], [result(i).p])
end
axis([0 45 0 130]);
legend({'0%','10%','20%','30%','40%'}, 'Location', 'northwest');
xlabel('��ѹ / V');
ylabel('���� / W');
title('25��, 1000W/m^2 �²�ͬ�ڵ����¹�����е� P-U ����');