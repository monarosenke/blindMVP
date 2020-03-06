% establish group differences of the odRSM
%
% run withinGroupCorrelations_final_corr.m to generate rsms_blind,
% *sighted_a and *sighted_v


% blind
for i = 1:1000
y = randsample(14,2);
rall = corrcoef(rsms_blind(:,y(1)),rsms_blind(:,y(2)));
r_b(i) = rall(1,2);
end

a = nchoosek(1:14,2)


% sighted_a
for i = 1:1000
y = randsample(18,2);
rall = corrcoef(rsms_sighted_a(:,y(1)),rsms_sighted_a(:,y(2)));
r_sa(i) = rall(1,2);
end

% sighted_v
for i = 1:1000
y = randsample(20,2);
rall = corrcoef(rsms_sighted_v(:,y(1)),rsms_sighted_v(:,y(2)));
r_sv(i) = rall(1,2);
end


% v_bl
for i = 1:1000
y = randsample(20,1);
z = randsample(14,1);
rall = corrcoef(rsms_sighted_v(:,y),rsms_blind(:,z));
r_sv_b(i) = rall(1,2);
end

% a_bl
for i = 1:1000
y = randsample(18,1);
z = randsample(14,1);
rall = corrcoef(rsms_sighted_a(:,y),rsms_blind(:,z));
r_sa_b(i) = rall(1,2);
end

% a_v
for i = 1:1000
y = randsample(18,1);
z = randsample(20,1);
rall = corrcoef(rsms_sighted_a(:,y),rsms_sighted_v(:,z));
r_sa_sv(i) = rall(1,2);
end

within = [r_b r_sa r_sv];
between = [r_sa_b r_sa_sv r_sv_b];

permutest(within,between,10000)


%% doing it not with 1000 random samples but just nchoosek

% blind
r_b = [];
a = nchoosek(1:14,2);
for i = 1:length(a)
    rall = corrcoef(rsms_blind(:,a(i,1)),rsms_blind(:,a(i,2)));
    r_b(i) = rall(1,2);
end



% sighted_a
r_sa = [];
a = nchoosek(1:18,2);
for i = 1:length(a)
rall = corrcoef(rsms_sighted_a(:,a(i,1)),rsms_sighted_a(:,a(i,2)));
r_sa(i) = rall(1,2);
end

% sighted_v
r_sv = [];
a = nchoosek(1:20,2);
for i = 1:length(a)
rall = corrcoef(rsms_sighted_v(:,a(i,1)),rsms_sighted_v(:,a(i,2)));
r_sv(i) = rall(1,2);
end


% v_bl
c = 0;
r_sv_b = [];
for i = 1:20
    for j = 1:14
        c = c+1;
        rall = corrcoef(rsms_sighted_v(:,i),rsms_blind(:,j));
        r_sv_b(c) = rall(1,2);       
    end
end

% a_bl
c = 0;
r_sa_b = [];
for i = 1:18
    for j = 1:14
        c = c+1;
        rall = corrcoef(rsms_sighted_a(:,i),rsms_blind(:,j));
        r_sa_b(c) = rall(1,2);       
    end
end

% a_v
c = 0;
r_sv_b = [];
for i = 1:20
    for j = 1:18
        c = c+1;
        rall = corrcoef(rsms_sighted_v(:,i),rsms_sighted_a(:,j));
        r_sv_b(c) = rall(1,2);       
    end
end

within = [r_b r_sa r_sv];
between = [r_sa_b r_sa_sv r_sv_b];

permutest(within,between,10000)






