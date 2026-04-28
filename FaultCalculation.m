clear all;

clc;

format long g

function z = p2c(mag, angle_deg)
    theta_rad = deg2rad(angle_deg);
    z = mag * (cos(theta_rad) + 1i * sin(theta_rad));
end

function [mag, phase] = rect2polar(z, angleUnit)

    % Input validation
    if nargin < 1
        error('At least one input argument is required.');
    end
    
    % Compute magnitude
    mag = abs(z);
    
    % Compute phase angle in radians
    phase = angle(z);  % returns values in range (-pi, pi]
    
    % Convert to degrees if requested (default)
    if nargin < 2 || strcmpi(angleUnit, 'deg')
        phase = rad2deg(phase);
    elseif strcmpi(angleUnit, 'rad')
        % Keep radians
    else
        error('angleUnit must be either ''deg'' or ''rad''.');
    end
end

C=(1/3)*[1,1,1;1,p2c(1,120),p2c(1,240);1,p2c(1,240),p2c(1,120)];
C_inv=[1,1,1;1,p2c(1,240),p2c(1,120);1,p2c(1,120),p2c(1,240)];

%Vabc=[p2c(57.735,-30);p2c(46.6499,-151.44);p2c(51.9615,100)]

%V012=C*Vabc

YBusPositive = [59.76-1j*130.62, -13.97+1j*28.77, -15.79+1j*32.51, -11.94+1j*24.58, -7.16+1j*14.74, -10.55+1j*21.71;
-13.97+1j*28.77, 50.09-1j*102.60, -16.46+1j*33.90, 0, 0, -19.36+1j*39.83;
-15.79+1j*32.51, -16.46+1j*33.90, 32.57-1j*66.52, 0, 0, 0;
-11.94+1j*24.58, 0, 0, 30.15-1j*68.79, -17.35+1j*35.72, 0;
-7.16+1j*14.74, 0, 0, -17.35+1j*35.72, 24.66-1j*50.51, 0;
-10.55+1j*21.71, -19.36+1j*39.83, 0, 0, 0, 30.09-1j*61.60];


YBusNegative = [61.34-1j*129.47, -13.97+1j*28.77, -15.79+1j*32.51, -11.94+1j*24.58, -7.16+1j*14.74, -10.55+1j*21.71;
-13.97+1j*28.77, 50.09-1j*102.60, -16.46+1j*33.90, 0, 0, -19.36+1j*39.83;
-15.79+1j*32.51, -16.46+1j*33.90, 32.57-1j*66.52, 0, 0, 0;
-11.94+1j*24.58, 0, 0, 31.73-1j*67.65, -17.35+1j*35.72, 0;
-7.16+1j*14.74, 0, 0, -17.35+1j*35.72, 24.66-1j*50.51, 0;
-10.55+1j*21.71, -19.36+1j*39.83, 0, 0, 0, 30.09-1j*61.60];

YBusZero = [23.76-1j*68.92, -5.59+1j*11.51, -6.32+1j*13.00, -4.78+1j*9.83, -2.86+1j*5.89, -4.22+1j*8.68;
-5.59+1j*11.51, 19.91-1j*41.00, -6.58+1j*13.56, 0, 0, -7.74+1j*15.93;
-6.32+1j*13.00, -6.58+1j*13.56, 12.90-1j*26.56, 0, 0, 0;
-4.78+1j*9.83, 0, 0, 11.72-1j*44.12, -6.94+1j*14.29, 0;
-2.86+1j*5.89, 0, 0, -6.94+1j*14.29, 9.80-1j*20.18, 0;
-4.22+1j*8.68, -7.74+1j*15.93, 0, 0, 0, 11.96-1j*24.61];

ZBusPositive = inv(YBusPositive);
ZBusNegative = inv(YBusNegative);
ZBusZero     = inv(YBusZero);

%SLG Bolted Fault @ Chan_Ipswich (12622401)

If_SLG_ChanBus_0= 1/(ZBusPositive(6,6)+ZBusNegative(6,6)+ZBusZero(6,6));

If_SLG_ChanBus_1=If_SLG_ChanBus_0;

If_SLG_ChanBus_2=If_SLG_ChanBus_0;

If_SLG_ChanBus_012=[If_SLG_ChanBus_0;If_SLG_ChanBus_1;If_SLG_ChanBus_2];

If_SLG_ChanBus_abc=C_inv*If_SLG_ChanBus_012;

[Mag_slg_Chan_Ipswich, theta_slg_Chan_Ipswich] = rect2polar(If_SLG_ChanBus_abc);       
fprintf('SLG Bolted Fault @ Chan_Ipswich (12622401)\n\n')
fprintf('Phase A Fault Current: %.4f ∠ %.4f°\n', Mag_slg_Chan_Ipswich(1,1), theta_slg_Chan_Ipswich(1,1))
fprintf('Phase B Fault Current: %.4f ∠ %.4f°\n', Mag_slg_Chan_Ipswich(2,1), theta_slg_Chan_Ipswich(2,1))
fprintf('Phase C Fault Current: %.4f ∠ %.4f°\n', Mag_slg_Chan_Ipswich(3,1), theta_slg_Chan_Ipswich(3,1))

%3-ph Symmetrical Bolted Fault @ Chan_Ipswich (12622401)

If_3_ph_ChanBus = 1/ZBusPositive(6,6);

[Mag_3_ph_Chan_Ipswich, theta_3_ph_Chan_Ipswich] = rect2polar(If_3_ph_ChanBus);        
fprintf('\n\n3-ph Symmetrical Bolted Fault @ Chan_Ipswich (12622401)\n\n')
fprintf('Phase A Fault Current: %.4f ∠ %.4f°\n', Mag_3_ph_Chan_Ipswich(1,1), theta_3_ph_Chan_Ipswich(1,1))
fprintf('Phase B Fault Current: %.4f ∠ %.4f°\n', Mag_3_ph_Chan_Ipswich(1,1), theta_3_ph_Chan_Ipswich(1,1))
fprintf('Phase C Fault Current: %.4f ∠ %.4f°\n', Mag_3_ph_Chan_Ipswich(1,1), theta_3_ph_Chan_Ipswich(1,1))

%LL Bolted Fault @ Chan_Ipswich (12622401)
If_LL_ChanBus_0 = 0;

If_LL_ChanBus_1= 1/(ZBusPositive(6,6)+ZBusNegative(6,6));

If_LL_ChanBus_2=-1*If_LL_ChanBus_1;

If_LL_ChanBus_012=[If_LL_ChanBus_0;If_LL_ChanBus_1;If_LL_ChanBus_2];

If_LL_ChanBus_abc=C_inv*If_LL_ChanBus_012;

[Mag_ll_Chan_Ipswich, theta_ll_Chan_Ipswich] = rect2polar(If_LL_ChanBus_abc);       
fprintf('\n\nLL Bolted Fault @ Chan_Ipswich (12622401)\n\n')
fprintf('Phase A Fault Current: %.4f ∠ %.4f°\n', Mag_ll_Chan_Ipswich(1,1), theta_ll_Chan_Ipswich(1,1))
fprintf('Phase B Fault Current: %.4f ∠ %.4f°\n', Mag_ll_Chan_Ipswich(2,1), theta_ll_Chan_Ipswich(2,1))
fprintf('Phase C Fault Current: %.4f ∠ %.4f°\n', Mag_ll_Chan_Ipswich(3,1), theta_ll_Chan_Ipswich(3,1))

%LLE Bolted Fault @ Chan_Ipswich (12622401)

If_LLE_ChanBus_1= 1/(ZBusPositive(6,6)+inv(inv(ZBusNegative(6,6))+inv(ZBusZero(6,6))));

If_LLE_ChanBus_2=-1*If_LLE_ChanBus_1*((ZBusZero(6,6))/(ZBusNegative(6,6)+ZBusZero(6,6)));

If_LLE_ChanBus_0=-1*If_LLE_ChanBus_1*((ZBusNegative(6,6))/(ZBusNegative(6,6)+ZBusZero(6,6)));

If_LLE_ChanBus_012=[If_LLE_ChanBus_0;If_LLE_ChanBus_1;If_LLE_ChanBus_2];

If_LLE_ChanBus_abc=C_inv*If_LLE_ChanBus_012;

[Mag_LLE_Chan_Ipswich, theta_LLE_Chan_Ipswich] = rect2polar(If_LLE_ChanBus_abc);       
fprintf('\n\nLLE Bolted Fault @ Chan_Ipswich (12622401)\n\n')
fprintf('Phase A Fault Current: %.4f ∠ %.4f°\n', Mag_LLE_Chan_Ipswich(1,1), theta_LLE_Chan_Ipswich(1,1))
fprintf('Phase B Fault Current: %.4f ∠ %.4f°\n', Mag_LLE_Chan_Ipswich(2,1), theta_LLE_Chan_Ipswich(2,1))
fprintf('Phase C Fault Current: %.4f ∠ %.4f°\n', Mag_LLE_Chan_Ipswich(3,1), theta_LLE_Chan_Ipswich(3,1))