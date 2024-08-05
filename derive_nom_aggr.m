function [bid_data_out,aggreg_pattern_D,aggreg_pattern_S]=derive_nom_aggr(bid_data)

bid_data_out=[];


%===================

aggreg_pattern_D=[bid_data.bids_DP_step(:,1) zeros(size(bid_data.bids_DP_step,1),1)];
aggreg_pattern_S=[bid_data.bids_SP_step(:,1) zeros(size(bid_data.bids_SP_step,1),1)];

T = bid_data.T;

%meret_D = size(bid_data.bids_DP_step, 1);
%bid_data_aggregalt = {};
%osszevont_licitek_szama_periodusonkent = zeros(1,T);


ID_akt=0;

     
      %==================================== demand ===================

for t = 1 : T      
      
      ind_1 = bid_data.bids_DP_step(:,2) == t;
      bid_indices_takt_D=find(ind_1);
      
      data_akt = bid_data.bids_DP_step(ind_1, :);

      Y = pdist(data_akt(:,4));
      Z = linkage(Y);
      %dendrogram(Z)
      I = inconsistent(Z);
      I = I(:,end);
      incon = I(I > 0);
      % minél kisebb a cutoff, annál több aggregált licit keletkezik
      cutoff = median(incon); %- while_szama*0.05;   %+
      c_ind = cluster(Z,'cutoff',cutoff);
      
      c_ind_2=postprocess_clustering(c_ind);
      c_ind=c_ind_2;
      
      maxind=max(c_ind);
      %indexek = cluster(Z,'maxclust',ceil(sqrt(meret)));

      %indexek 
      for i=1:maxind
                    
            ID_akt=ID_akt+1;
            
            ind_2=bid_indices_takt_D(c_ind==i);
            aggreg_pattern_D(ind_2,2)=ID_akt;
 
      end

end
      

      %===================== supply
for t = 1 : T      
      
      ind_1 = bid_data.bids_SP_step(:,2) == t;
      bid_indices_takt_S=find(ind_1);
      
      data_akt = bid_data.bids_SP_step(ind_1, :);

      Y = pdist(data_akt(:,4));
      Z = linkage(Y);
      %dendrogram(Z)
      I = inconsistent(Z);
      I = I(:,end);
      incon = I(I > 0);
      % minél kisebb a cutoff, annál több aggregált licit keletkezik
      cutoff = median(incon); %- while_szama*0.05;   %+
      c_ind = cluster(Z,'cutoff',cutoff);
      
      c_ind_2=postprocess_clustering(c_ind);
      c_ind=c_ind_2;
      
      maxind=max(c_ind);
      %indexek = cluster(Z,'maxclust',ceil(sqrt(meret)));

      %indexek 
      for i=1:maxind
                    
            ID_akt=ID_akt+1;
            
            ind_2=bid_indices_takt_S(c_ind==i);
            aggreg_pattern_S(ind_2,2)=ID_akt;
 
      end

end


bid_data_out=derive_bid_data_from_aggreg_pattern(bid_data,aggreg_pattern_D,aggreg_pattern_S);

end



 function y=postprocess_clustering(A) % orders bid_data.bids_SP_step according to t and ascending price
 
 s_A=size(A,1);
 
[C,IA,IC] = unique(A);

blokkhatarok=sort(IA);

for i=1:max(A)
   if i==max(A)
         y(blokkhatarok(end):s_A,1)=i;
         
   else
         y(blokkhatarok(i):blokkhatarok(i+1)-1,1)=i;
   end
      
      
end
 
 end





