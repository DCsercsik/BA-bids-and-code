
gen_Aggr_bids_toy_1.m - generate example data structure

derive_nom_aggr.m - matlab code to derive a nominal aggregation. Usage:
[bid_data] =gen_Aggr_bids_toy_1;
[bid_data_out,aggreg_pattern_D,aggreg_pattern_S]=derive_nom_aggr(bid_data)

derive_MD_aggr.m - matlab code to derive maximally deffierent aggrgations

market_clearing.mod - the AMPL model file of the market clearing problem

bid_sets_setup_x - the test bids of setup x used in the numerical tests in .csv format (for standard bids and block orders)

struct_2_LP_AMPL.m, txt2bids - files to convert data from MATLAB struct format to AMPL .dat format