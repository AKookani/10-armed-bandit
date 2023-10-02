% No. of runs= 2000
% Time steps per run: 1000
% Q*(h)= n(0,1)
% R(t) for At= n(Q*(At),1)
% e= 1/t

% close all
% clear
% clc


global ar br t

for n=1:600
    A= zeros(10,1000); %Action register
    R= zeros(10,1000); %Reward register
    Q= zeros(10,1000); %Value register
    
    for i=1:10
        a(i)= normrnd(0,1);
    end
    %Inital
    Q(:,1)= a.';
%   greedy select with e=1/t
    f= randsrc(1,1,[1,2;1-(1/1),(1/1)]);
    if f==1
        [M,I]= max(Q(:,(1)));
        A(I,1)=1;%Action Register
        R(I,1)= normrnd(Q(I,1),1); %Reward register
        opt(1)= ((R(I,1))*100)/4.7; %percent select of optimal action
    end
    if f==2
        [M,I]= max(Q(:,(1)));
        II=I;
        while II==I 
            II= randi(10);
            A(II,1)=1;%Action Register
            R(II,1)= normrnd(Q(II,1),1); %Reward register
            opt(1)= ((R(II,1))*100)/4.7; %percent select of optimal action
       end
    end 
    
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
        
%       greedy select with e=1/t
        f= randsrc(1,1,[1,2;1-(1/t),(1/t)]);
        if f==1
            [M,I]= max(Q(:,(t)));
            A(I,t)=1;%Action Register
            R(I,t)= normrnd(Q(I,t),1); %Reward register
            opt(t)= ((R(I,t))*100)/4.7;
        end
        if f==2
            [M,I]= max(Q(:,(t)));
            II=I;
            while II==I 
                II= randi(10);
                A(II,t)=1;%Action Register
                R(II,t)= normrnd(Q(II,t),1); %Reward register
                opt(t)= ((R(II,t))*100)/4.7;
           end
        end
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
% title('e=1/t-Greedy Reward')
% xlabel('steps')
% ylabel('Average reward')
% 
% subplot(2,1,2);
% plot(t,OptPas)
% title('e=1/t-Greedy Optimal Action')
% xlabel('steps')
% ylabel('%Optimal Actoin')

ar=RewPas;
br=OptPas;