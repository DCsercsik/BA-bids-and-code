function [eltelt_ido, megoldas, megoldas_BB, MCP, fval, exitflag] = struct_2_LP_AMPL(bid_data, num_of_thread, termeles_fogyasztas_kulonbseg)
ido = tic;

% bid_data.bids_DP_step
% bid_data.bids_SP_step
% 
% for i=1: bid_data.m_SP_block
% ID_BBs(i,1)=bid_data.bids_BB_step{1,i}(1,1);
% end
% 
% ID_BBs
% 
% [bid_data.m_DP_step sum(bid_data.m_DP_step) size(bid_data.bids_DP_step,1)]
% [bid_data.m_SP_step sum(bid_data.m_SP_step) size(bid_data.bids_SP_step,1)]
% 
% [size(bid_data.bids_BB_step) bid_data.m_SP_block]







if nargin == 1
    termeles_fogyasztas_kulonbseg = zeros(1, bid_data.T);
    num_of_thread = '';
elseif nargin == 2
    termeles_fogyasztas_kulonbseg = zeros(1, bid_data.T);
end

dat_file = 'pelda_aggregated_';
modrun_file = 'onlystep_';

bid_data.power_balance = termeles_fogyasztas_kulonbseg;
bids_2_dat(bid_data, [dat_file int2str(num_of_thread)]);

%disp('dat file ready')
%pause

res = executeAMPL(dat_file, modrun_file, modrun_file, 'print', 0, int2str(num_of_thread));
bids = txt_2_bids([dat_file int2str(num_of_thread)]);

megoldas = bids.megoldas;
fval = bids.TSW;
MCP = bids.mcp;
megoldas_BB = bids.megoldas_BB;
exitflag = bids.exitflag;
eltelt_ido = toc(ido);

% AMPL info
% https://portal.ampl.com/docs/archive/first-website/BOOK/CHAPTERS/17-solvers.pdf
end