function [MD_data]=derive_MD_aggr(bid_data,bid_data_nom_aggr,aggreg_pattern_NA_D,aggreg_pattern_NA_S)


size_sample=50;

MD_data=[];

% pl aggreg_pattern_D_MD_D - aggreg pattern of demand bids, which is most
% different from the nominal aggregation (NA) regarding the demand side

num_D_bids=sum(bid_data.m_DP_step);
num_S_bids=sum(bid_data.m_SP_step);

bid_data_out_MD_S=[];
bid_data_out_MD_D=[];
bid_data_out_MD_both=[];

aggreg_pattern_S_MD_S=[];
aggreg_pattern_D_MD_D=[];
aggreg_pattern_D_both=[];
aggreg_pattern_S_both=[];

T=bid_data.T;

[osztopontok_D_NA,osztopontok_S_NA]=derive_aggr_curve_breakpoints(bid_data,aggreg_pattern_NA_D,aggreg_pattern_NA_S);

%osztopontok_D_NA
%osztopontok_S_NA

MoAPs=[]; % matrix of aggregation p[atterns

for i=1:size_sample

      ID_aggr_bid_akt=0;      
      
      for t=1:T

            %========================= demand ====================
            ind_1_D =  find(bid_data.bids_DP_step(:,2) == t);

            data_akt_D = bid_data.bids_DP_step(ind_1_D, :);
            num_D_bids_takt=size(data_akt_D,1);

            num_aggreg_bids_D_ref_akt=size(unique(aggreg_pattern_NA_D(ind_1_D,2)),1);
            
            aggreg_bid_num_D_akt_min=max([round(num_aggreg_bids_D_ref_akt/1.5) 3]);
            aggreg_bid_num_D_akt_max=min([round(num_aggreg_bids_D_ref_akt*1.5) num_D_bids_takt-3]);

            %[aggreg_bid_num_D_akt_min aggreg_bid_num_D_akt_max]

            aggreg_bid_num_D_akt=randi([aggreg_bid_num_D_akt_min aggreg_bid_num_D_akt_max]);
            
            [prices_D_sorted,ind_sort_D]=sort(data_akt_D(:,4),'descend');
            
            bin_limits_D=sort(randsample(num_D_bids_takt-2,aggreg_bid_num_D_akt-1)+1,'ascend');
            
            %num_D_bids_takt
            %aggreg_bid_num_D_akt
                        
            bin_limits_D=[1;bin_limits_D;num_D_bids_takt];
 %           bin_limits
            
            for j=1:(aggreg_bid_num_D_akt)
                  ID_aggr_bid_akt=ID_aggr_bid_akt+1;
                  MoAPs(ind_1_D(ind_sort_D(bin_limits_D(j):bin_limits_D(j+1))),i)=ID_aggr_bid_akt;
            end
      end
            %======================= supply=============
      for t=1:T

            ind_1_S =  find(bid_data.bids_SP_step(:,2) == t);

            data_akt_S = bid_data.bids_SP_step(ind_1_S, :);      
            num_S_bids_takt=size(data_akt_S,1);

            num_aggreg_bids_S_ref_akt=size(unique(aggreg_pattern_NA_S(ind_1_S,2)),1);

            aggreg_bid_num_S_akt_min=max([round(num_aggreg_bids_S_ref_akt/1.5) 3]);
            aggreg_bid_num_S_akt_max=min([round(num_aggreg_bids_S_ref_akt*1.5) num_S_bids_takt-3]);

            %[aggreg_bid_num_D_akt_min aggreg_bid_num_D_akt_max]

            aggreg_bid_num_S_akt=randi([aggreg_bid_num_S_akt_min aggreg_bid_num_S_akt_max]);
            
            [prices_S_sorted,ind_sort_S]=sort(data_akt_S(:,4),'ascend');
            
            bin_limits_S=sort(randsample(num_S_bids_takt-2,aggreg_bid_num_S_akt-1)+1,'ascend');
            
            %num_D_bids_takt
            %aggreg_bid_num_S_akt
                        
            bin_limits_S=[1;bin_limits_S;num_S_bids_takt];
 %           bin_limits
            
            for j=1:(aggreg_bid_num_S_akt)
                  ID_aggr_bid_akt=ID_aggr_bid_akt+1;
                  MoAPs(num_D_bids+ind_1_S(ind_sort_S(bin_limits_S(j):bin_limits_S(j+1))),i)=ID_aggr_bid_akt;
            end
            
      %osztopontok_D_akt
      %osztopontok_S_akt
         
      end

      %MoAPs
      
      [osztopontok_D_akt,osztopontok_S_akt]=derive_aggr_curve_breakpoints(bid_data,[[1:num_D_bids]' MoAPs(1:num_D_bids,i)],[[1:num_S_bids]' MoAPs(num_D_bids+1:end,i)]);
      
      %osztopontok_D_akt
      %osztopontok_S_akt
      
      for t=1:T
            
           dist_from_NA_D(t,i)=dist_max_min_1(osztopontok_D_akt(t,:),osztopontok_D_NA(t,:));
           dist_from_NA_S(t,i)=dist_max_min_1(osztopontok_S_akt(t,:),osztopontok_S_NA(t,:));
           osztopontok_D{i}=osztopontok_D_akt;
           osztopontok_S{i}=osztopontok_S_akt;   
      end
     % dist_from_NA_D
     % dist_from_NA_S

      
end
 
aggreg_pattern_D_MD_D=[[1:num_D_bids]' zeros(num_D_bids,1)];
aggreg_pattern_S_MD_D=aggreg_pattern_NA_S;

aggreg_pattern_D_MD_S=aggreg_pattern_NA_D;
aggreg_pattern_S_MD_S=[[num_D_bids+1:num_D_bids+num_S_bids]' zeros(num_S_bids,1)];

aggreg_pattern_D_MD_both=[[1:num_D_bids]' zeros(num_D_bids,1)];
aggreg_pattern_S_MD_both=[[num_D_bids+1:num_D_bids+num_S_bids]' zeros(num_S_bids,1)];

%aggreg_pattern_D_MD_D

%aggreg_pattern_S_MD_S

%aggreg_pattern_D_MD_both
%aggreg_pattern_S_MD_both

      %dist_from_NA_D
      %dist_from_NA_S

for t=1:T
   [maxdist_D_akt,ind_AGP_D_akt]=max(dist_from_NA_D(t,:)); % index of he aggregation pattern
   [maxdist_S_akt,ind_AGP_S_akt]=max(dist_from_NA_S(t,:));
   
   ind_1_D =  find(bid_data.bids_DP_step(:,2) == t);
   ind_1_S =  find(bid_data.bids_SP_step(:,2) == t);
      
   aggreg_pattern_D_MD_D(ind_1_D,2)  = MoAPs(ind_1_D,ind_AGP_D_akt);
   aggreg_pattern_S_MD_S(ind_1_S,2)  = MoAPs(num_D_bids+ind_1_S,ind_AGP_S_akt);
     
   aggreg_pattern_D_MD_both(ind_1_D,2)=aggreg_pattern_D_MD_D(ind_1_D,2);
   aggreg_pattern_S_MD_both(ind_1_S,2)=aggreg_pattern_S_MD_S(ind_1_S,2);
      
end

%aggreg_pattern_D_MD_D
%aggreg_pattern_S_MD_S

%============================== postprocessing ==================================

[aggreg_pattern_D_MD_D(:,2),aggreg_pattern_S_MD_D(:,2)]=postprocess_BA_patterns(bid_data,aggreg_pattern_D_MD_D(:,2),aggreg_pattern_S_MD_D(:,2));
[aggreg_pattern_D_MD_S(:,2),aggreg_pattern_S_MD_S(:,2)]=postprocess_BA_patterns(bid_data,aggreg_pattern_D_MD_S(:,2),aggreg_pattern_S_MD_S(:,2));
[aggreg_pattern_D_MD_both(:,2),aggreg_pattern_S_MD_both(:,2)]=postprocess_BA_patterns(bid_data,aggreg_pattern_D_MD_both(:,2),aggreg_pattern_S_MD_both(:,2));


%[aggreg_pattern_NA_D aggreg_pattern_D_MD_D(:,2) aggreg_pattern_D_MD_S(:,2) aggreg_pattern_D_MD_both(:,2)]
%[aggreg_pattern_NA_S aggreg_pattern_S_MD_D(:,2) aggreg_pattern_S_MD_S(:,2) aggreg_pattern_S_MD_both(:,2)]

MD_data.aggreg_pattern_D_MD_D=aggreg_pattern_D_MD_D;
MD_data.aggreg_pattern_S_MD_D=aggreg_pattern_S_MD_D;

MD_data.aggreg_pattern_D_MD_S=aggreg_pattern_D_MD_S;
MD_data.aggreg_pattern_S_MD_S=aggreg_pattern_S_MD_S;

MD_data.aggreg_pattern_D_MD_both=aggreg_pattern_D_MD_both;
MD_data.aggreg_pattern_S_MD_both=aggreg_pattern_S_MD_both;


MD_data.bid_data_MDDA=derive_bid_data_from_aggreg_pattern(bid_data,aggreg_pattern_D_MD_D,aggreg_pattern_S_MD_D);
MD_data.bid_data_MDSA=derive_bid_data_from_aggreg_pattern(bid_data,aggreg_pattern_D_MD_S,aggreg_pattern_S_MD_S);
MD_data.bid_data_MDBA=derive_bid_data_from_aggreg_pattern(bid_data,aggreg_pattern_D_MD_both,aggreg_pattern_S_MD_both);

%bid_data.bids_DP_step
%bid_data.bids_SP_step

 %[osztopontok_D_akt,osztopontok_S_akt]=derive_aggr_curve_breakpoints(bid_data,aggreg_pattern_D_MD_D,aggreg_pattern_S_MD_S);
 %osztopontok_D_NA
 %osztopontok_D_akt
 
 %osztopontok_S_NA
 %osztopontok_S_akt

end

function y=dist_max_min_1(x1,x2)
   
y=[];

x1=clearzeros(x1);
x2=clearzeros(x2);

D=pdist2(x1',x2');

y=min(min(D));

end
      
function [y1,y2]=postprocess_BA_patterns(bid_data,x1,x2);
   
T=bid_data.T;

y1=[];
y2=[];

ID_akt=0;

%========================= demand ====================

for t=1:T

       ind_1_D =  find(bid_data.bids_DP_step(:,2) == t);
           
       orig_IDs_x1_akt=unique(x1(ind_1_D));
       
      for i=1:length(orig_IDs_x1_akt);
            orig_ID_akt=orig_IDs_x1_akt(i);
      
            rel_indices=find(x1(ind_1_D)==orig_ID_akt);
      
            ID_akt=ID_akt+1;
      
            y1(ind_1_D(rel_indices))=ID_akt;
            
      end
            
end
         
%========================= supply ====================

for t=1:T

       ind_1_S =  find(bid_data.bids_SP_step(:,2) == t);
           
       orig_IDs_x2_akt=unique(x2(ind_1_S));
       
      for i=1:length(orig_IDs_x2_akt);
            orig_ID_akt=orig_IDs_x2_akt(i);
      
            rel_indices=find(x2(ind_1_S)==orig_ID_akt);
      
            ID_akt=ID_akt+1;
      
            y2(ind_1_S(rel_indices))=ID_akt;
            
      end
            
end


end
      
      
      