function p=permutestpaired(x,y,ntest)
% paired permutation test
% derived from permutest
% INPUT:
% - x: vector
% - y: vector
% - ntest: scalar, number of permutation test to perform, default = 100.
%  Set ntest to zero if you
% want to perform all possible combination (limited to 100000).
% x and y should have the same size.
% test for mean x bigger than mean y
% OUTPUT:
% - p: the probability that the difference of the mean of x and y was
% drawed by chance in a distribution of x and y
% author: Quentin Noirhomme, Cyclotron Research Center, University of Liege
if nargin <2,
    error('Not enough input argument! See help permutest for more explainations')
end
if nargin<3,
    ntest=100; % number of permutation test to perform
end

[lx,tx]=size(x);
if tx>lx && lx==1, % row vector
    x=x';
    lx=tx;
end
[ly,ty]=size(y);
if ty>ly && ly==1, % row vector
    y=y';
    ly=ty;
end

if  lx~=ly,
    disp('Error: x and y should have the same length!');
    p=1;
    return
end

mdxy=mean(x)-mean(y);
lldt=[x y]; % concatenate all data
if ntest > 0,

    mcdf=zeros(ntest,1);
    mcdf(1)=mdxy; % original value is also a permutation
    for i=2:ntest,
        tpx=zeros(1,lx);
        tpy=zeros(1,lx);
        for j=1:lx, % randomize the labels
            tpi=ceil(rand(1)*2);
            tpx(j)=lldt(j,tpi);
            tpy(j)=lldt(j,3-tpi);
        end
        mcdf(i)=mean(tpx)-mean(tpy); % compute mean
    end

    p=(sum(mcdf>=mdxy))/(ntest);
else
    allc=pick(1:2,lx,'or'); % all possible combinations
    ntest=length(allc);
    if ntest>100000,
        tpin=randperm(ntest);
        allc=allc(tpin(1:100000),:);
        ntest=length(allc);
    end
    mcdf=zeros(ntest,1);
    for i=1:ntest,
        tpx=zeros(1,lx);
        tpy=zeros(1,lx);
        for j=1:lx,
            tpi=allc(i,j);
            tpx(j)=lldt(j,tpi);
            tpy(j)=lldt(j,3-tpi);
        end
        mcdf(i)=mean(tpx)-mean(tpy);
    end
    p=(sum(mcdf>=mdxy))/(ntest);
end