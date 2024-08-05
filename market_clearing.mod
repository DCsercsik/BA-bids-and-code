# constants for Big-M
param price_cap_min default -500;
param price_cap_max default 3000;

param bids_per_hour default 0;
param order_number default 0;
set order_numbers := 1..order_number;
set bid_type;

#eps
param eps = 1e-7;
param MCP_up = 88;

#az oras ajanlatok mennyisege, ara. min alloc., startup cost es power_balance
param period {i in order_numbers};
param quantity {i in order_numbers}; 
param price {i in order_numbers};
param min_alloc {i in order_numbers};
param startup {i in order_numbers};
param end_period {i in order_numbers};
param T = max {i in order_numbers} period[i];
param power_balance {t in 1..T};

# MCP constraints
param MCP_lower_bound {t in 1..T};
param MCP_upper_bound {t in 1..T};


# variables
var U {i in order_numbers} binary;      # acceptance binary variables
var X {i in order_numbers} in [0,1];    # acceptance variables
var MCP {i in 1..T};  # MCP over periods

# Big-M auxilary variables
var ANY_ACCEPTED_Esp {i in order_numbers} binary; # indicator
var ANY_REJECTED_Esp {i in order_numbers} binary; # indicator

# objective
maximize WELFARE: 
sum {t in 1..T} 
    (sum {i in order_numbers: end_period[i] == 0 && period[i] = t} 
    (X[i]*price[i]*quantity[i] - U[i]*startup[i])
    + sum {i in order_numbers: end_period[i] != 0 && period[i] <= t <= end_period[i]}
    (U[i]*price[i]*quantity[i] - U[i]*startup[i]));
 
# power balance
subject to BALANCE {t in 1..T}: 
    sum {i in order_numbers: end_period[i] == 0 && period[i] = t} 
        (X[i]*quantity[i])
        + sum {i in order_numbers: end_period[i] != 0 && period[i] <= t <= end_period[i]}
        (U[i]*quantity[i])
        = power_balance[t];

# mcp CON
subject to MCP_con_upper {t in 1..T}: MCP[t] <= MCP_upper_bound[t];
subject to MCP_con_lower {t in 1..T}: MCP[t] >= MCP_lower_bound[t];

#min. alloc. 
subject to Limit {i in order_numbers: min_alloc[i] > 0}: min_alloc[i]*U[i] <= X[i];
subject to Limit2 {i in order_numbers: min_alloc[i] > 0}: X[i] <= U[i];

# MCP implications (esetleg sgn q) 
subject to impl_1_1 {i in order_numbers: end_period[i] == 0 && min_alloc[i] == 0 && startup[i] == 0}:
    X[i] <= ANY_ACCEPTED_Esp[i];
subject to impl_1_2 {i in order_numbers: end_period[i] == 0 && min_alloc[i] == 0 && startup[i] == 0}:
    quantity[i] * MCP[period[i]] 
    - ANY_ACCEPTED_Esp[i] * (quantity[i] * price[i] - max(quantity[i] * price_cap_min, quantity[i] * price_cap_max))
	<= quantity[i] * price[i] 
	- (quantity[i] * price[i] - max(quantity[i] * price_cap_min, quantity[i] * price_cap_max));
subject to impl_2_1 {i in order_numbers: end_period[i] == 0 && min_alloc[i] == 0 && startup[i] == 0}:
    1 - X[i] <= ANY_REJECTED_Esp[i];
subject to impl_2_2 {i in order_numbers: end_period[i] == 0 && min_alloc[i] == 0 && startup[i] == 0}:
    quantity[i] * MCP[period[i]]
    + ANY_REJECTED_Esp[i] * (- quantity[i] * price[i] + min(quantity[i] * price_cap_min, quantity[i] * price_cap_max))
    >= quantity[i] * price[i] 
    + (- quantity[i] * price[i] + min(quantity[i] * price_cap_min, quantity[i] * price_cap_max));

# BB
# U>0 -> mean(MCP)>= P <=> U<=0 or mean(MCP)>= P <=> U-(1-Z) <= 0 & Mz+mean(MCP)>=P <=> U+z<=1 & -zM - mean(MCP) <= -P
subject to impl_3_1 {i in order_numbers: end_period[i] != 0}:
    U[i] + ANY_ACCEPTED_Esp[i] <= 1;
subject to impl_3_2 {i in order_numbers: end_period[i] != 0}:
-price_cap_max*(end_period[i]-period[i]+1)*ANY_ACCEPTED_Esp[i]- sum {j in order_numbers: j >= period[i] && j <= end_period[i]} MCP[j] <= -price[i]*(end_period[i]-period[i]+1)
