% No. of runs= 2000
% Time steps per run: 1000
% Q*(h)= n(0,1)
% R(t) for At= n(Q*(At),1)

% close all
% clear
% clc

global ar br t

for n=1:2000
    A= zeros(10,1000); %Action register
    R= zeros(10,1000); %Reward register
    Q= zeros(10,1000); %Value register
    
    %Inital
    Q(:,1)= [5;5;5;5;5;5;5;5;5;5];
%   greedy select
    [M,I]= max(Q(:,(1)));

    A(I,1)=1;%Action Register
    R(I,1)= normrnd(Q(I,1),1); %Reward register
    opt(1)= ((R(I,1))*100)/10.5040; %percent select of optimal action
    
    %After initial 
    for t=2:1000
        %Determine Action Value estimate using sample average method
        %Reward matrix * 1(Action matrix) (hadamard product)
        for i=1:10
            for h=1:t
                s= 0.5*(0.5^(t-h))*R(i,h);
            end
            Q(i,t)= ((0.5^t)*5)+s;
        end
        
%       greedy select
        [M,I]= max(Q(:,(t)));

        A(I,t)=1;%Action Register
        R(I,t)= normrnd(Q(I,t),1); %Reward register
        opt(t)= ((R(I,t))*100)/4.7;
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
% title('Optimistic Initial Values Reward')
% xlabel('steps')
% ylabel('Average reward')
% 
% subplot(2,1,2);
% plot(t,OptPas)
% title('Optimistic Initial Values Optimal Action')
% xlabel('steps')
% ylabel('%Optimal Actoin')

ar=RewPas;
br=OptPas;
