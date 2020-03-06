function p=permutest(x,y,ntest,DISP)
% permutation test
% INPUT:
% - x: vector
% - y: vector
% - ntest: scalar, number of permutation test to perform, default = 100.
% - DISP: boolean, display messages
% OUTPUT:
% - p: the probability that the difference of the mean of x and y was
% drawed by chance in a distribution of x and y, value close to zero
% indicate x significantly bigger than y. Value close to 1 indicate a
% higher y. In the last case, rerun the permutation test with inverted x
% and y to get the y pvalue.
% author: Quentin Noirhomme, Cyclotron Research Center, University of Liege

MAXLPERM = 24; % maximum length of the data to use exact permutation scheme
if nargin <2,
    error('Not enough input argument! See help permutest for more explainations')
end
if nargin<3,
    ntest=99; % number of permutation test to perform
end
if nargin<4,
    DISP=0;
end

[lx,tx]=size(x);
if tx>lx && lx==1, % row vector
    x=x';
    lx=tx;
end
[ly,ty]=size(y);
if ty>ly && ly==1, % row vector
    y=y';
    % ly=ty;
end

mdxy=mean(x)-mean(y);
lldt=[x;y]; % concatenate all data
leda=length(lldt);

if leda<=MAXLPERM,
    % check for computing exact number of permuation
    C=combnk(1:leda,lx); % number of possible permutation knowing the data
    nperm=length(C);
    if nperm>ntest,
        tprm=randperm(nperm); % randomly select which permutation to test
        nperm=ntest;
        pprm=C(tprm(1:nperm),:);
    else
        pprm=C;
        if DISP,
        disp(['Computing an exact permutation test with ' num2str(nperm) ' permutations'])
        end
    end
    
    mcdf=zeros(nperm,1);
    for i=1:nperm,
        mcdf(i)=mean(lldt(pprm(i,:)))-mean(lldt(setdiff(1:leda,pprm(i,:))));
    end
    p=(sum(mcdf>=mdxy))/(nperm);
else
    
    mcdf=zeros(ntest,1);
    for i=1:ntest,
        tpdt=lldt(randperm(leda)); % permute value
        mcdf(i)=mean(tpdt(1:lx))-mean(tpdt(lx+1:end)); % compute mean
    end
    p=(sum(mcdf>=mdxy)+1)/(ntest+1);
end

% tuio=sort(mcdf);
% fp=find(tuio<mdxy,1,'last');
% if isempty(fp), % mdxy is before the first value of the distribution
%     p=0.0;
%     return
% else
%     fp=fp+1;
% end
% if fp>ntest/2,
%     fp=find(tuio>mdxy,1,'first');
% end
% if isempty(fp), % mdxy is after the last value of the distribution
%     p=1.0;
%     return
% else
%     fp=fp-1;
% end
% p=fp/ntest;
% p=(sum(mcdf>=mdxy)+1)/(ntest+1);