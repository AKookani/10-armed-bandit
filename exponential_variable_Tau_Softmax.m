% No. of runs= 2000
% Time steps per run: 1000
% Q*(h)= n(0,1)
% R(t) for At= n(Q*(At),1)
% Tau= exp(t)

% close all
% clear
% clc

global ar br t

for n=1:2000
    A= zeros(10,1000); %Action register
    R= zeros(10,1000); %Reward register
    Q= zeros(10,1000); %Value register
    
    for i=1:10
        a(i)= normrnd(0,1);
    end
    %Inital
    Q(:,1)= a.';
%   Softmax select with Tau=exp(t)
    for i=1:10
        a(i)= exp((Q(i,1))/(exp(1)));
    end
    total= sum(a.');
    f= randsrc(1,1,[1:10;(exp((Q(1,1))/(exp(1))))/total,(exp((Q(2,1))/(exp(1))))/total,(exp((Q(3,1))/(exp(1))))/total,(exp((Q(4,1))/(exp(1))))/total,...
        (exp((Q(5,1))/(exp(1))))/total,(exp((Q(6,1))/(exp(1))))/total,(exp((Q(7,1))/(exp(1))))/total,(exp((Q(8,1))/(exp(1))))/total,(exp((Q(9,1))/(exp(1))))/total,...
            (exp((Q(10,1))/(exp(1))))/total]);
        
    A(f,1)=1;%Action Register
    R(f,1)= normrnd(Q(f,1),1); %Reward register
    opt(1)= ((R(f,1))*100)/4.7; %percent select of optimal action
    
    %After initial 
    for t=2:1000
        %Determine Action Value estimate using sample average method
        %Reward matrix * 1(Action matrix) (hadamard product)
        for i=1:10
            if nnz(A(i,:))-A(i,t)~=0 
                Q(i,t)=(sum(R(i,:))-R(i,t))/(nnz(A(i,:))-A(i,t)); %Sample Average till t-1
            end
            if nnz(A(i,:))-A(i,t)==0 
                Q(i,t)=0;
            end
        end
        
%       Softmax select with Tau=exp(t)
        for i=1:10
            a(i)= exp((Q(i,t))/(exp(t)));
        end
        total= sum(a.');
        f= randsrc(1,1,[1:10;(exp((Q(1,t))/(exp(t))))/total,(exp((Q(2,t))/(exp(t))))/total,(exp((Q(3,t))/(exp(t))))/total,(exp((Q(4,t))/(exp(t))))/total,...
            (exp((Q(5,t))/(exp(t))))/total,(exp((Q(6,t))/(exp(t))))/total,(exp((Q(7,t))/(exp(t))))/total,(exp((Q(8,t))/(exp(t))))/total,(exp((Q(9,t))/(exp(t))))/total,...
            (exp((Q(10,t))/(exp(t))))/total]);
        
        A(f,t)=1;%Action Register
        R(f,t)= normrnd(Q(f,t),1); %Reward register
        opt(t)= ((R(f,t))*100)/4.7; %percent select of optimal action
    end

    %Total reward
RewardG(n,:)=sum(R);
OPT(n,:)= opt;

end

%Average and Plot
for t=1:1000
   RewPas(t)= mean(RewardG(:,t));
   OptPas(t)= mean(OPT(:,t));
end
t=1:1000;
% figure
% subplot(2,1,1);
% plot(t,RewPas)
% title('Softmax with Tau=exp(t) Reward')
% xlabel('steps')
% ylabel('Average reward')
% 
% subplot(2,1,2);
% plot(t,OptPas)
% title('Softmax with Tau=exp(t) Optimal Action')
% xlabel('steps')
% ylabel('%Optimal Actoin')

ar=RewPas;
br=OptPas;
