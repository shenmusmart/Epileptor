close all
clear

%% Implementation of Epileptor

%% Set stepsize and initial conditions for solving the equations
step_size=1/100;
t=0:step_size:2500;
f=linspace(-1/2/step_size, 1/2/step_size, length(t));
y=zeros(6,length(t));
y(:,1)=[0;-5;3;0;0;0];
%% parameters settings in Epileptor
x_0=-1.6;
y_0=1;
tau_0=2857;
tau_1=1;
tau_2=10;
I_rest_1=3.1;
I_rest_2=0.45;
gamma=0.01;

% noise level
sigma_1=0:0.01:0.04;
sigma_2=0:0.01:0.04;

delta_t=step_size;

%% Euler-Maruyama method for updating the solutions 
% please notice that condition (i) is turned into differential form and incorperated into euqations. 
% noise has been added.
figure;
for sim_num=1:4
    rng('shuffle')
    W_t_1=sigma_1(sim_num).*randn(3,length(t));
    W_t_1=W_t_1.*sqrt(delta_t);
    W_t_2=sigma_2(sim_num).*randn(3,length(t));
    W_t_2=W_t_2.*sqrt(delta_t);
    W_t=[W_t_1;W_t_2];
    for i=1:length(t)-1
        if (y(1,i)<0) && (y(4,i)<-0.25)
            y(1,i+1)=y(1,i)+(y(2,i)-(y(1,i)^3-3*y(1,i)^2)-y(3,i)+I_rest_1)*delta_t+W_t(1,i);
            y(2,i+1)=y(2,i)+1/tau_1*(y_0-5*y(1,i)^2-y(2,i))*delta_t+W_t(2,i);
            y(3,i+1)=y(3,i)+(1/tau_0*(4*(y(1,i)-x_0)-y(3,i)))*delta_t+W_t(3,i);
            y(4,i+1)=y(4,i)+(-y(5,i)+y(4,i)-y(4,i)^3+I_rest_2+2*y(6,i)-0.3*(y(3,i)-3.5))*delta_t+W_t(4,i);
            y(5,i+1)=y(5,i)+(1/tau_2*(-y(5,i)+0))*delta_t+W_t(5,i);
            y(6,i+1)=y(6,i)+(-gamma*(y(6,i)-0.1*y(1,i)))*delta_t+W_t(6,i);
        elseif (y(1,i)>=0) && (y(4,i)<-0.25)
            y(1,i+1)=y(1,i)+(y(2,i)-(y(4,i)-0.6*(y(3,i)-4)^2)*y(1,i)-y(3,i)+I_rest_1)*delta_t+W_t(1,i);
            y(2,i+1)=y(2,i)+1/tau_1*(y_0-5*y(1,i)^2-y(2,i))*delta_t+W_t(2,i);
            y(3,i+1)=y(3,i)+(1/tau_0*(4*(y(1,i)-x_0)-y(3,i)))*delta_t+W_t(3,i);
            y(4,i+1)=y(4,i)+(-y(5,i)+y(4,i)-y(4,i)^3+I_rest_2+2*y(6,i)-0.3*(y(3,i)-3.5))*delta_t+W_t(4,i);
            y(5,i+1)=y(5,i)+(1/tau_2*(-y(5,i)+0))*delta_t+W_t(5,i);
            y(6,i+1)=y(6,i)+(-gamma*(y(6,i)-0.1*y(1,i)))*delta_t+W_t(6,i);      
        elseif (y(1,i)<0) && (y(4,i)>=-0.25)
            y(1,i+1)=y(1,i)+(y(2,i)-(y(1,i)^3-3*y(1,i)^2)-y(3,i)+I_rest_1)*delta_t+W_t(1,i);
            y(2,i+1)=y(2,i)+1/tau_1*(y_0-5*y(1,i)^2-y(2,i))*delta_t+W_t(2,i);
            y(3,i+1)=y(3,i)+(1/tau_0*(4*(y(1,i)-x_0)-y(3,i)))*delta_t+W_t(3,i);
            y(4,i+1)=y(4,i)+(-y(5,i)+y(4,i)-y(4,i)^3+I_rest_2+2*y(6,i)-0.3*(y(3,i)-3.5))*delta_t+W_t(4,i);
            y(5,i+1)=y(5,i)+(1/tau_2*(-y(5,i)+6*(y(4,i)+0.25)))*delta_t+W_t(5,i);
            y(6,i+1)=y(6,i)+(-gamma*(y(6,i)-0.1*y(1,i)))*delta_t+W_t(6,i);
        elseif (y(1,i)>=0) && (y(4,i)>=-0.25)
            y(1,i+1)=y(1,i)+(y(2,i)-(y(4,i)-0.6*(y(3,i)-4)^2)*y(1,i)-y(3,i)+I_rest_1)*delta_t+W_t(1,i);
            y(2,i+1)=y(2,i)+1/tau_1*(y_0-5*y(1,i)^2-y(2,i))*delta_t+W_t(2,i);
            y(3,i+1)=y(3,i)+(1/tau_0*(4*(y(1,i)-x_0)-y(3,i)))*delta_t+W_t(3,i);
            y(4,i+1)=y(4,i)+(-y(5,i)+y(4,i)-y(4,i)^3+I_rest_2+2*y(6,i)-0.3*(y(3,i)-3.5))*delta_t+W_t(4,i);
            y(5,i+1)=y(5,i)+(1/tau_2*(-y(5,i)+6*(y(4,i)+0.25)))*delta_t+W_t(5,i);
            y(6,i+1)=y(6,i)+(-gamma*(y(6,i)-0.1*y(1,i)))*delta_t+W_t(6,i);
        end
    end
    fs=1/step_size;
    
    % The seizure-like waveforms are combined with -x_1+x_2
    sum=y(1,:)+y(4,:);
    % Result visulization
    figure;
    subplot(2,1,1)
    plot(t/60,y(1,:)+1,t/60,y(4,:)-1,t/60,y(3,:));
    xlabel('time/min')
    ylabel('Amplitude')
    xlim([t(1)/60 t(end)/60])
    legend('fast discharges','spike and wave events','slow variable','FontSize',12)
    set(gca,'FontSize',16);
    title('Simulated slow variable,fast discharges and spike-wave events with different noise')
    
    subplot(2,1,2)
    plot(t/60,-y(1,:)+y(4,:),'k');
    xlabel('time/min')
    ylabel('Amplitude')
    xlim([t(1)/60 t(end)/60])
    set(gca,'ytick',[],'xtick',[])
    set(gca,'FontSize',16);
    title('Simulation results of Epileptor with different noise')
    
end


