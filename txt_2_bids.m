function bids = txt_2_bids(dat_file, pd)
%% Function that converts txt representation of bids to struct
%% Inputs:
% - dat_file -> name of file which contains the solution of AMPL clearing
% - pd -> flag that indicates if the clearing was PD

%disp('result file ready')
%pause

if nargin == 1
    pd = 0;
end

global scenario_folder

file_string = fileread([scenario_folder 'outputTXT/' dat_file '.txt']);
bids.T = str2double(strtrim(extractBetween(file_string, 'T = ', '==RESULT')));
bids.TSW = str2double(strtrim(extractBetween(file_string, '==RESULT', '==VARIABLES')));
bids.bids_DP_step = [];
bids.bids_SP_step = [];
bids.bids_BB_step = [];
bids.megoldas = [];
bids.megoldas_BB = [];

bids_table = string(split(strtrim(extractBetween(file_string, 'end_period:', 'MCP')), newline));

for i = 1 : size(bids_table, 1)
    row = str2double(strsplit(strtrim(bids_table(i, :)), " "));
    if row(10) == 0 && row(5) > 0
        bids.bids_DP_step(size(bids.bids_DP_step, 1) + 1, :) = [row(1), row(2), row(5), row(6), row(8), row(9)];
        bids.megoldas(size(bids.megoldas, 1) + 1, 1) = row(3);
    elseif row(10) == 0 && row(5) < 0
        bids.bids_SP_step(size(bids.bids_SP_step, 1) + 1, :) = [row(1), row(2), row(5), row(6), row(8), row(9)];
        bids.megoldas(size(bids.megoldas, 1) + 1, 1) = row(3);
    else
        acting_periods = row(2) : row(10);
        num_of_acting_periods = length(acting_periods);
        bids.bids_BB_step{1, end + 1} = zeros(bids.T, 6);
        % id, periods
        bids.bids_BB_step{1, end}(:, 1:2) = [ones(bids.T, 1) * row(1), [1:bids.T]'];
        % quantity, price, min. alloc., startup
        bids.bids_BB_step{1, end}(acting_periods, 3:6) = [...
            ones(num_of_acting_periods, 1) * row(5), ...
            ones(num_of_acting_periods, 1) * row(6), ...
            ones(num_of_acting_periods, 1) * row(8), ...
            ones(num_of_acting_periods, 1) * row(9)];
        bids.bids_BB_step{2, end} = acting_periods;
        % U_i
        bids.megoldas_BB(size(bids.megoldas_BB, 1) + 1, 1) = row(4);
    end
end

if pd
    %% demand, supply
    bids.mcp = zeros(max(bids.bids_DP_step(:, 2)), 2);
    MCPs = string(split(strtrim(extractBetween(file_string, 'MCP ', ';')), newline));
    for i = 1 : size(MCPs, 1)
        row = str2double(strsplit(strtrim(MCPs(i, :)), " "));
        bids.mcp(i, :) = row;
    end
else
bids.mcp = str2double(strsplit(strtrim(string(extractBetween(file_string, 'MCP', newline))), " "))';
end

exitflag = strtrim(string(extractBetween(file_string, 'solve_result = ', newline)));
if strcmp(exitflag, 'solved') || strcmp(exitflag, 'solved?')
    bids.exitflag = 1;
else
    bids.exitflag = -1;
    fprintf('%s: %s\n', dat_file, exitflag);
end
end