function [T_Emissions_new] = Tank_Mat_Extend_v2(T_Emissions, N_TK, x_divide)

ind = any(isnan(T_Emissions),2);

T_Emissions(ind) = [];
N_TK(ind) = [];

[size_mat,~] = size(T_Emissions);
N_TK = round(N_TK);
total_tanks = sum(N_TK);
T_Emissions_new = zeros(total_tanks,1);

row = 1;
for i = 1:size_mat
    tanks = N_TK(i);
    if tanks == 1
        T_Emissions_new(row,1) = T_Emissions(i,1);
        row = row + 1;
    else
        for j = 1:tanks
            if x_divide == 0
                emissions = T_Emissions(i,1); 
                T_Emissions_new(row,1) = emissions;
                row = row + 1;
            else
                emissions = T_Emissions(i,1); 
                T_Emissions_new(row,1) = emissions/tanks;
                row = row + 1;                
            end
        end
    end
end


end
