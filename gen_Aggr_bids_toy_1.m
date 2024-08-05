function [bid_data] =gen_Aggr_bids_toy_1;

% aggreg dummy pelda

% number of time periods
T=1;

bid_data.T=T;
%==============================================================ENERGY DEMAND==============

%[ID, period, amount, price, 0, 0] supply a negativ

 bids_DP_step(1,:)=[1,1,35,78,0,0];
 bids_DP_step(2,:)=[2,1,27,69,0,0];
 bids_DP_step(3,:)=[3,1,56,67,0,0];
 bids_DP_step(4,:)=[4,1,19,61,0,0];
 bids_DP_step(5,:)=[5,1,63,57,0,0];
 bids_DP_step(6,:)=[6,1,46,50,0,0];
 bids_DP_step(7,:)=[7,1,32,37,0,0];
 bids_DP_step(8,:)=[8,1,53,31,0,0];
 bids_DP_step(9,:)=[9,1,31,26,0,0];
 bids_DP_step(10,:)=[10,1,37,15,0,0];
 
 
%==========================
if ~isempty(bids_DP_step);
    for i=1:T
        m_DP_step(1,i)=sum(bids_DP_step(:,2)==i);
    end
else
    for i=1:T
        m_DP_step(1,i)=0;
    end
end

bid_data.bids_DP_step=bids_DP_step;
bid_data.m_DP_step=m_DP_step;



%=================

%period, amount, price,
bids_SP_step(1,:)=[11,1,-31,18,0,0];
bids_SP_step(2,:)=[12,1,-46,29,0,0];
bids_SP_step(3,:)=[13,1,-24,41,0,0];
bids_SP_step(4,:)=[14,1,-38,47,0,0];
bids_SP_step(5,:)=[15,1,-35,51,0,0];
bids_SP_step(6,:)=[16,1,-24,59,0,0];
bids_SP_step(7,:)=[17,1,-41,64,0,0];
bids_SP_step(8,:)=[18,1,-29,73,0,0];
bids_SP_step(9,:)=[19,1,-34,89,0,0];
bids_SP_step(10,:)=[20,1,-28,93,0,0];




if ~isempty(bids_SP_step);
    for i=1:T
        m_SP_step(1,i)=sum(bids_SP_step(:,2)==i);
    end
else
    for i=1:T
        m_SP_step(1,i)=0;
    end
end

bid_data.bids_SP_step=bids_SP_step;
bid_data.m_SP_step=m_SP_step;

%====================
% kezdo periodus, vegperiodus, mennyiseg, ar (tfh minden periodusra UA), total TSW contribution

%bids_SP_block=[1 1 40 35];
%bids_SP_block=[];

%for i=1:size(bids_SP_block,1)
%      bids_SP_block(i,5)=(bids_SP_block(i,2)-bids_SP_block(i,1)+1)*bids_SP_block(i,3)*bids_SP_block(i,4);
%end


%bid_data.bids_SP_block=bids_SP_block;
%bid_data.m_SP_block=size(bids_SP_block,1);

bid_data.bids_BB_step{1,1}=[];
bid_data.m_SP_block=0;



%=================

bid_data.MCP_S_max=100;
bid_data.MCP_S_min=0;
bid_data.MCP_D_max=100;
bid_data.MCP_D_min=0;


