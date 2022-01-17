% Basic integrate-and-fire neuron with IPSP
clear
% input current
I_1 = 4; % nA  1
I_2 = 4;
I_3 = 4;
I_4 = 4;


I_1_start       = 10;
I_2_start       = 30;
I_3_start       = 50;
I_4_start       = 70;


I_1_duration    = 2;
I_2_duration    = 2;
I_3_duration    = 2;
I_4_duration    = 2;


IPSP_start      =   46;
IPSP_duration   =   2;
R_IPSP          =   1;

% capacitance and leak resistance
C = 1; % nF  1
R = 20; % M ohms  40

% I & F implementation dV/dt = - V/RC + I/C
% Using h = 1 ms step size, Euler method

V = 0;
tstop = 200;
abs_ref = 15; % absolute refractory period 5
ref = 0; % absolute refractory period counter
V_trace = []; % voltage trace for plotting
V_th = 10; % spike threshold  10
V_spike = 50;

time = 1:tstop;

input = I_1*(time>=I_1_start).*(time<(I_1_start+I_1_duration)) + I_2*(time>=I_2_start).*(time<(I_2_start+I_2_duration)) + I_3*(time>=I_3_start).*(time<(I_3_start+I_3_duration)) + I_4*(time>=I_4_start).*(time<(I_4_start+I_4_duration));

R_time = R - (R-R_IPSP)*(time>=IPSP_start).*(time<(IPSP_start+IPSP_duration));

for t = 1:tstop
  
   if ~ref
     V = V - (V/(R_time(t)*C)) + (input(t)/C);
   else
     ref = ref - 1;
     V = 0.2*V_th; % reset voltage
   end
   
   if (V > V_th)
     V = V_spike;  % emit spike
     ref = abs_ref; % set refractory counter
   end

   V_trace = [V_trace V];

end

figure(3);
j=subplot(311); set(j,'FontSize',10);
plot(V_trace, 'LineWidth', 3);
axis([0 tstop 0 V_spike]);
ylabel('Voltage', 'FontSize', 10);

j=subplot(312); set(j,'FontSize',10);
plot(input, 'LineWidth', 3);
axis([0 tstop 0 10]);
ylabel('Input Current', 'FontSize', 10);

j=subplot(313); set(j,'FontSize',10);
plot(R_time, 'LineWidth', 3);
axis([0 tstop 0 40]);
xlabel('Time (ms)', 'FontSize', 10);
ylabel('Leak Resistance', 'FontSize', 10);
