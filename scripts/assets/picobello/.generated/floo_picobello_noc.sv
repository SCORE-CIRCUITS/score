// Copyright 2026 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// AUTOMATICALLY GENERATED! DO NOT EDIT!

module floo_picobello_noc
  import floo_pkg::*;
  import floo_picobello_noc_pkg::*;
(
  input logic clk_i,
  input logic rst_ni,
  input logic test_enable_i,
  input collective_axi_narrow_in_req_t             [3:0][3:0] cluster_narrow_in_req_i,
  output collective_axi_narrow_in_rsp_t             [3:0][3:0] cluster_narrow_in_rsp_o,
  input collective_axi_wide_in_req_t             [3:0][3:0] cluster_wide_in_req_i,
  output collective_axi_wide_in_rsp_t             [3:0][3:0] cluster_wide_in_rsp_o,
  output collective_axi_narrow_out_req_t             [3:0][3:0] cluster_narrow_out_req_o,
  input collective_axi_narrow_out_rsp_t             [3:0][3:0] cluster_narrow_out_rsp_i,
  output collective_axi_wide_out_req_t             [3:0][3:0] cluster_wide_out_req_o,
  input collective_axi_wide_out_rsp_t             [3:0][3:0] cluster_wide_out_rsp_i,
  input axi_narrow_in_req_t              cheshire_narrow_in_req_i,
  output axi_narrow_in_rsp_t              cheshire_narrow_in_rsp_o,
  output axi_narrow_out_req_t              cheshire_narrow_out_req_o,
  input axi_narrow_out_rsp_t              cheshire_narrow_out_rsp_i,
  output axi_wide_out_req_t              cheshire_wide_out_req_o,
  input axi_wide_out_rsp_t              cheshire_wide_out_rsp_i,
  input axi_narrow_in_req_t              fhg_spu_narrow_in_req_i,
  output axi_narrow_in_rsp_t              fhg_spu_narrow_in_rsp_o,
  input axi_wide_in_req_t              fhg_spu_wide_in_req_i,
  output axi_wide_in_rsp_t              fhg_spu_wide_in_rsp_o,
  output axi_narrow_out_req_t              fhg_spu_narrow_out_req_o,
  input axi_narrow_out_rsp_t              fhg_spu_narrow_out_rsp_i,
  output axi_wide_out_req_t              fhg_spu_wide_out_req_o,
  input axi_wide_out_rsp_t              fhg_spu_wide_out_rsp_i,
  output axi_narrow_out_req_t              top_spm_narrow_narrow_out_req_o,
  input axi_narrow_out_rsp_t              top_spm_narrow_narrow_out_rsp_i,
  output axi_wide_out_req_t              top_spm_wide_wide_out_req_o,
  input axi_wide_out_rsp_t              top_spm_wide_wide_out_rsp_i,
  output axi_narrow_out_req_t             [7:0] l2_spm_narrow_out_req_o,
  input axi_narrow_out_rsp_t             [7:0] l2_spm_narrow_out_rsp_i,
  output axi_wide_out_req_t             [7:0] l2_spm_wide_out_req_o,
  input axi_wide_out_rsp_t             [7:0] l2_spm_wide_out_rsp_i

);

floo_req_t router_left_0_0_to_router_left_0_1_req;
floo_rsp_t router_left_0_1_to_router_left_0_0_rsp;
floo_wide_t router_left_0_0_to_router_left_0_1_wide;

floo_req_t router_left_0_0_to_l2_spm_ni_0_req;
floo_rsp_t l2_spm_ni_0_to_router_left_0_0_rsp;
floo_wide_t router_left_0_0_to_l2_spm_ni_0_wide;

floo_req_t router_left_0_1_to_router_left_0_0_req;
floo_rsp_t router_left_0_0_to_router_left_0_1_rsp;
floo_wide_t router_left_0_1_to_router_left_0_0_wide;

floo_req_t router_left_0_1_to_router_left_0_2_req;
floo_rsp_t router_left_0_2_to_router_left_0_1_rsp;
floo_wide_t router_left_0_1_to_router_left_0_2_wide;

floo_req_t router_left_0_1_to_l2_spm_ni_1_req;
floo_rsp_t l2_spm_ni_1_to_router_left_0_1_rsp;
floo_wide_t router_left_0_1_to_l2_spm_ni_1_wide;

floo_req_t router_left_0_2_to_router_left_0_1_req;
floo_rsp_t router_left_0_1_to_router_left_0_2_rsp;
floo_wide_t router_left_0_2_to_router_left_0_1_wide;

floo_req_t router_left_0_2_to_router_left_0_3_req;
floo_rsp_t router_left_0_3_to_router_left_0_2_rsp;
floo_wide_t router_left_0_2_to_router_left_0_3_wide;

floo_req_t router_left_0_2_to_l2_spm_ni_2_req;
floo_rsp_t l2_spm_ni_2_to_router_left_0_2_rsp;
floo_wide_t router_left_0_2_to_l2_spm_ni_2_wide;

floo_req_t router_left_0_3_to_router_left_0_2_req;
floo_rsp_t router_left_0_2_to_router_left_0_3_rsp;
floo_wide_t router_left_0_3_to_router_left_0_2_wide;

floo_req_t router_left_0_3_to_l2_spm_ni_3_req;
floo_rsp_t l2_spm_ni_3_to_router_left_0_3_rsp;
floo_wide_t router_left_0_3_to_l2_spm_ni_3_wide;

floo_req_t router_center_0_0_to_router_center_0_1_req;
floo_rsp_t router_center_0_1_to_router_center_0_0_rsp;
floo_wide_t router_center_0_0_to_router_center_0_1_wide;

floo_req_t router_center_0_0_to_router_center_1_0_req;
floo_rsp_t router_center_1_0_to_router_center_0_0_rsp;
floo_wide_t router_center_0_0_to_router_center_1_0_wide;

floo_req_t router_center_0_0_to_cluster_ni_0_0_req;
floo_rsp_t cluster_ni_0_0_to_router_center_0_0_rsp;
floo_wide_t router_center_0_0_to_cluster_ni_0_0_wide;

floo_req_t router_center_0_1_to_router_center_0_0_req;
floo_rsp_t router_center_0_0_to_router_center_0_1_rsp;
floo_wide_t router_center_0_1_to_router_center_0_0_wide;

floo_req_t router_center_0_1_to_router_center_0_2_req;
floo_rsp_t router_center_0_2_to_router_center_0_1_rsp;
floo_wide_t router_center_0_1_to_router_center_0_2_wide;

floo_req_t router_center_0_1_to_router_center_1_1_req;
floo_rsp_t router_center_1_1_to_router_center_0_1_rsp;
floo_wide_t router_center_0_1_to_router_center_1_1_wide;

floo_req_t router_center_0_1_to_cluster_ni_0_1_req;
floo_rsp_t cluster_ni_0_1_to_router_center_0_1_rsp;
floo_wide_t router_center_0_1_to_cluster_ni_0_1_wide;

floo_req_t router_center_0_2_to_router_center_0_1_req;
floo_rsp_t router_center_0_1_to_router_center_0_2_rsp;
floo_wide_t router_center_0_2_to_router_center_0_1_wide;

floo_req_t router_center_0_2_to_router_center_0_3_req;
floo_rsp_t router_center_0_3_to_router_center_0_2_rsp;
floo_wide_t router_center_0_2_to_router_center_0_3_wide;

floo_req_t router_center_0_2_to_router_center_1_2_req;
floo_rsp_t router_center_1_2_to_router_center_0_2_rsp;
floo_wide_t router_center_0_2_to_router_center_1_2_wide;

floo_req_t router_center_0_2_to_cluster_ni_0_2_req;
floo_rsp_t cluster_ni_0_2_to_router_center_0_2_rsp;
floo_wide_t router_center_0_2_to_cluster_ni_0_2_wide;

floo_req_t router_center_0_3_to_router_center_0_2_req;
floo_rsp_t router_center_0_2_to_router_center_0_3_rsp;
floo_wide_t router_center_0_3_to_router_center_0_2_wide;

floo_req_t router_center_0_3_to_router_center_1_3_req;
floo_rsp_t router_center_1_3_to_router_center_0_3_rsp;
floo_wide_t router_center_0_3_to_router_center_1_3_wide;

floo_req_t router_center_0_3_to_cluster_ni_0_3_req;
floo_rsp_t cluster_ni_0_3_to_router_center_0_3_rsp;
floo_wide_t router_center_0_3_to_cluster_ni_0_3_wide;

floo_req_t router_center_1_0_to_router_center_0_0_req;
floo_rsp_t router_center_0_0_to_router_center_1_0_rsp;
floo_wide_t router_center_1_0_to_router_center_0_0_wide;

floo_req_t router_center_1_0_to_router_center_1_1_req;
floo_rsp_t router_center_1_1_to_router_center_1_0_rsp;
floo_wide_t router_center_1_0_to_router_center_1_1_wide;

floo_req_t router_center_1_0_to_router_center_2_0_req;
floo_rsp_t router_center_2_0_to_router_center_1_0_rsp;
floo_wide_t router_center_1_0_to_router_center_2_0_wide;

floo_req_t router_center_1_0_to_cluster_ni_1_0_req;
floo_rsp_t cluster_ni_1_0_to_router_center_1_0_rsp;
floo_wide_t router_center_1_0_to_cluster_ni_1_0_wide;

floo_req_t router_center_1_1_to_router_center_0_1_req;
floo_rsp_t router_center_0_1_to_router_center_1_1_rsp;
floo_wide_t router_center_1_1_to_router_center_0_1_wide;

floo_req_t router_center_1_1_to_router_center_1_0_req;
floo_rsp_t router_center_1_0_to_router_center_1_1_rsp;
floo_wide_t router_center_1_1_to_router_center_1_0_wide;

floo_req_t router_center_1_1_to_router_center_1_2_req;
floo_rsp_t router_center_1_2_to_router_center_1_1_rsp;
floo_wide_t router_center_1_1_to_router_center_1_2_wide;

floo_req_t router_center_1_1_to_router_center_2_1_req;
floo_rsp_t router_center_2_1_to_router_center_1_1_rsp;
floo_wide_t router_center_1_1_to_router_center_2_1_wide;

floo_req_t router_center_1_1_to_cluster_ni_1_1_req;
floo_rsp_t cluster_ni_1_1_to_router_center_1_1_rsp;
floo_wide_t router_center_1_1_to_cluster_ni_1_1_wide;

floo_req_t router_center_1_2_to_router_center_0_2_req;
floo_rsp_t router_center_0_2_to_router_center_1_2_rsp;
floo_wide_t router_center_1_2_to_router_center_0_2_wide;

floo_req_t router_center_1_2_to_router_center_1_1_req;
floo_rsp_t router_center_1_1_to_router_center_1_2_rsp;
floo_wide_t router_center_1_2_to_router_center_1_1_wide;

floo_req_t router_center_1_2_to_router_center_1_3_req;
floo_rsp_t router_center_1_3_to_router_center_1_2_rsp;
floo_wide_t router_center_1_2_to_router_center_1_3_wide;

floo_req_t router_center_1_2_to_router_center_2_2_req;
floo_rsp_t router_center_2_2_to_router_center_1_2_rsp;
floo_wide_t router_center_1_2_to_router_center_2_2_wide;

floo_req_t router_center_1_2_to_cluster_ni_1_2_req;
floo_rsp_t cluster_ni_1_2_to_router_center_1_2_rsp;
floo_wide_t router_center_1_2_to_cluster_ni_1_2_wide;

floo_req_t router_center_1_3_to_router_center_0_3_req;
floo_rsp_t router_center_0_3_to_router_center_1_3_rsp;
floo_wide_t router_center_1_3_to_router_center_0_3_wide;

floo_req_t router_center_1_3_to_router_center_1_2_req;
floo_rsp_t router_center_1_2_to_router_center_1_3_rsp;
floo_wide_t router_center_1_3_to_router_center_1_2_wide;

floo_req_t router_center_1_3_to_router_center_2_3_req;
floo_rsp_t router_center_2_3_to_router_center_1_3_rsp;
floo_wide_t router_center_1_3_to_router_center_2_3_wide;

floo_req_t router_center_1_3_to_cluster_ni_1_3_req;
floo_rsp_t cluster_ni_1_3_to_router_center_1_3_rsp;
floo_wide_t router_center_1_3_to_cluster_ni_1_3_wide;

floo_req_t router_center_2_0_to_router_center_1_0_req;
floo_rsp_t router_center_1_0_to_router_center_2_0_rsp;
floo_wide_t router_center_2_0_to_router_center_1_0_wide;

floo_req_t router_center_2_0_to_router_center_2_1_req;
floo_rsp_t router_center_2_1_to_router_center_2_0_rsp;
floo_wide_t router_center_2_0_to_router_center_2_1_wide;

floo_req_t router_center_2_0_to_router_center_3_0_req;
floo_rsp_t router_center_3_0_to_router_center_2_0_rsp;
floo_wide_t router_center_2_0_to_router_center_3_0_wide;

floo_req_t router_center_2_0_to_cluster_ni_2_0_req;
floo_rsp_t cluster_ni_2_0_to_router_center_2_0_rsp;
floo_wide_t router_center_2_0_to_cluster_ni_2_0_wide;

floo_req_t router_center_2_1_to_router_center_1_1_req;
floo_rsp_t router_center_1_1_to_router_center_2_1_rsp;
floo_wide_t router_center_2_1_to_router_center_1_1_wide;

floo_req_t router_center_2_1_to_router_center_2_0_req;
floo_rsp_t router_center_2_0_to_router_center_2_1_rsp;
floo_wide_t router_center_2_1_to_router_center_2_0_wide;

floo_req_t router_center_2_1_to_router_center_2_2_req;
floo_rsp_t router_center_2_2_to_router_center_2_1_rsp;
floo_wide_t router_center_2_1_to_router_center_2_2_wide;

floo_req_t router_center_2_1_to_router_center_3_1_req;
floo_rsp_t router_center_3_1_to_router_center_2_1_rsp;
floo_wide_t router_center_2_1_to_router_center_3_1_wide;

floo_req_t router_center_2_1_to_cluster_ni_2_1_req;
floo_rsp_t cluster_ni_2_1_to_router_center_2_1_rsp;
floo_wide_t router_center_2_1_to_cluster_ni_2_1_wide;

floo_req_t router_center_2_2_to_router_center_1_2_req;
floo_rsp_t router_center_1_2_to_router_center_2_2_rsp;
floo_wide_t router_center_2_2_to_router_center_1_2_wide;

floo_req_t router_center_2_2_to_router_center_2_1_req;
floo_rsp_t router_center_2_1_to_router_center_2_2_rsp;
floo_wide_t router_center_2_2_to_router_center_2_1_wide;

floo_req_t router_center_2_2_to_router_center_2_3_req;
floo_rsp_t router_center_2_3_to_router_center_2_2_rsp;
floo_wide_t router_center_2_2_to_router_center_2_3_wide;

floo_req_t router_center_2_2_to_router_center_3_2_req;
floo_rsp_t router_center_3_2_to_router_center_2_2_rsp;
floo_wide_t router_center_2_2_to_router_center_3_2_wide;

floo_req_t router_center_2_2_to_cluster_ni_2_2_req;
floo_rsp_t cluster_ni_2_2_to_router_center_2_2_rsp;
floo_wide_t router_center_2_2_to_cluster_ni_2_2_wide;

floo_req_t router_center_2_3_to_router_center_1_3_req;
floo_rsp_t router_center_1_3_to_router_center_2_3_rsp;
floo_wide_t router_center_2_3_to_router_center_1_3_wide;

floo_req_t router_center_2_3_to_router_center_2_2_req;
floo_rsp_t router_center_2_2_to_router_center_2_3_rsp;
floo_wide_t router_center_2_3_to_router_center_2_2_wide;

floo_req_t router_center_2_3_to_router_center_3_3_req;
floo_rsp_t router_center_3_3_to_router_center_2_3_rsp;
floo_wide_t router_center_2_3_to_router_center_3_3_wide;

floo_req_t router_center_2_3_to_cluster_ni_2_3_req;
floo_rsp_t cluster_ni_2_3_to_router_center_2_3_rsp;
floo_wide_t router_center_2_3_to_cluster_ni_2_3_wide;

floo_req_t router_center_3_0_to_router_center_2_0_req;
floo_rsp_t router_center_2_0_to_router_center_3_0_rsp;
floo_wide_t router_center_3_0_to_router_center_2_0_wide;

floo_req_t router_center_3_0_to_router_center_3_1_req;
floo_rsp_t router_center_3_1_to_router_center_3_0_rsp;
floo_wide_t router_center_3_0_to_router_center_3_1_wide;

floo_req_t router_center_3_0_to_cluster_ni_3_0_req;
floo_rsp_t cluster_ni_3_0_to_router_center_3_0_rsp;
floo_wide_t router_center_3_0_to_cluster_ni_3_0_wide;

floo_req_t router_center_3_1_to_router_center_2_1_req;
floo_rsp_t router_center_2_1_to_router_center_3_1_rsp;
floo_wide_t router_center_3_1_to_router_center_2_1_wide;

floo_req_t router_center_3_1_to_router_center_3_0_req;
floo_rsp_t router_center_3_0_to_router_center_3_1_rsp;
floo_wide_t router_center_3_1_to_router_center_3_0_wide;

floo_req_t router_center_3_1_to_router_center_3_2_req;
floo_rsp_t router_center_3_2_to_router_center_3_1_rsp;
floo_wide_t router_center_3_1_to_router_center_3_2_wide;

floo_req_t router_center_3_1_to_cluster_ni_3_1_req;
floo_rsp_t cluster_ni_3_1_to_router_center_3_1_rsp;
floo_wide_t router_center_3_1_to_cluster_ni_3_1_wide;

floo_req_t router_center_3_2_to_router_center_2_2_req;
floo_rsp_t router_center_2_2_to_router_center_3_2_rsp;
floo_wide_t router_center_3_2_to_router_center_2_2_wide;

floo_req_t router_center_3_2_to_router_center_3_1_req;
floo_rsp_t router_center_3_1_to_router_center_3_2_rsp;
floo_wide_t router_center_3_2_to_router_center_3_1_wide;

floo_req_t router_center_3_2_to_router_center_3_3_req;
floo_rsp_t router_center_3_3_to_router_center_3_2_rsp;
floo_wide_t router_center_3_2_to_router_center_3_3_wide;

floo_req_t router_center_3_2_to_cluster_ni_3_2_req;
floo_rsp_t cluster_ni_3_2_to_router_center_3_2_rsp;
floo_wide_t router_center_3_2_to_cluster_ni_3_2_wide;

floo_req_t router_center_3_3_to_router_center_2_3_req;
floo_rsp_t router_center_2_3_to_router_center_3_3_rsp;
floo_wide_t router_center_3_3_to_router_center_2_3_wide;

floo_req_t router_center_3_3_to_router_center_3_2_req;
floo_rsp_t router_center_3_2_to_router_center_3_3_rsp;
floo_wide_t router_center_3_3_to_router_center_3_2_wide;

floo_req_t router_center_3_3_to_cluster_ni_3_3_req;
floo_rsp_t cluster_ni_3_3_to_router_center_3_3_rsp;
floo_wide_t router_center_3_3_to_cluster_ni_3_3_wide;

floo_req_t router_right_0_0_to_router_right_0_1_req;
floo_rsp_t router_right_0_1_to_router_right_0_0_rsp;
floo_wide_t router_right_0_0_to_router_right_0_1_wide;

floo_req_t router_right_0_0_to_router_right_1_0_req;
floo_rsp_t router_right_1_0_to_router_right_0_0_rsp;
floo_wide_t router_right_0_0_to_router_right_1_0_wide;

floo_req_t router_right_0_0_to_l2_spm_ni_4_req;
floo_rsp_t l2_spm_ni_4_to_router_right_0_0_rsp;
floo_wide_t router_right_0_0_to_l2_spm_ni_4_wide;

floo_req_t router_right_0_1_to_router_right_0_0_req;
floo_rsp_t router_right_0_0_to_router_right_0_1_rsp;
floo_wide_t router_right_0_1_to_router_right_0_0_wide;

floo_req_t router_right_0_1_to_router_right_0_2_req;
floo_rsp_t router_right_0_2_to_router_right_0_1_rsp;
floo_wide_t router_right_0_1_to_router_right_0_2_wide;

floo_req_t router_right_0_1_to_router_right_1_1_req;
floo_rsp_t router_right_1_1_to_router_right_0_1_rsp;
floo_wide_t router_right_0_1_to_router_right_1_1_wide;

floo_req_t router_right_0_1_to_l2_spm_ni_5_req;
floo_rsp_t l2_spm_ni_5_to_router_right_0_1_rsp;
floo_wide_t router_right_0_1_to_l2_spm_ni_5_wide;

floo_req_t router_right_0_2_to_router_right_0_1_req;
floo_rsp_t router_right_0_1_to_router_right_0_2_rsp;
floo_wide_t router_right_0_2_to_router_right_0_1_wide;

floo_req_t router_right_0_2_to_router_right_0_3_req;
floo_rsp_t router_right_0_3_to_router_right_0_2_rsp;
floo_wide_t router_right_0_2_to_router_right_0_3_wide;

floo_req_t router_right_0_2_to_router_right_1_2_req;
floo_rsp_t router_right_1_2_to_router_right_0_2_rsp;
floo_wide_t router_right_0_2_to_router_right_1_2_wide;

floo_req_t router_right_0_2_to_l2_spm_ni_6_req;
floo_rsp_t l2_spm_ni_6_to_router_right_0_2_rsp;
floo_wide_t router_right_0_2_to_l2_spm_ni_6_wide;

floo_req_t router_right_0_3_to_router_right_0_2_req;
floo_rsp_t router_right_0_2_to_router_right_0_3_rsp;
floo_wide_t router_right_0_3_to_router_right_0_2_wide;

floo_req_t router_right_0_3_to_router_right_1_3_req;
floo_rsp_t router_right_1_3_to_router_right_0_3_rsp;
floo_wide_t router_right_0_3_to_router_right_1_3_wide;

floo_req_t router_right_0_3_to_l2_spm_ni_7_req;
floo_rsp_t l2_spm_ni_7_to_router_right_0_3_rsp;
floo_wide_t router_right_0_3_to_l2_spm_ni_7_wide;

floo_req_t router_right_1_0_to_router_right_0_0_req;
floo_rsp_t router_right_0_0_to_router_right_1_0_rsp;
floo_wide_t router_right_1_0_to_router_right_0_0_wide;

floo_req_t router_right_1_0_to_router_right_1_1_req;
floo_rsp_t router_right_1_1_to_router_right_1_0_rsp;
floo_wide_t router_right_1_0_to_router_right_1_1_wide;

floo_req_t router_right_1_0_to_fhg_spu_ni_req;
floo_rsp_t fhg_spu_ni_to_router_right_1_0_rsp;
floo_wide_t router_right_1_0_to_fhg_spu_ni_wide;

floo_req_t router_right_1_1_to_router_right_0_1_req;
floo_rsp_t router_right_0_1_to_router_right_1_1_rsp;
floo_wide_t router_right_1_1_to_router_right_0_1_wide;

floo_req_t router_right_1_1_to_router_right_1_0_req;
floo_rsp_t router_right_1_0_to_router_right_1_1_rsp;
floo_wide_t router_right_1_1_to_router_right_1_0_wide;

floo_req_t router_right_1_1_to_router_right_1_2_req;
floo_rsp_t router_right_1_2_to_router_right_1_1_rsp;
floo_wide_t router_right_1_1_to_router_right_1_2_wide;

floo_req_t router_right_1_1_to_top_spm_wide_ni_req;
floo_rsp_t top_spm_wide_ni_to_router_right_1_1_rsp;
floo_wide_t router_right_1_1_to_top_spm_wide_ni_wide;

floo_req_t router_right_1_2_to_router_right_0_2_req;
floo_rsp_t router_right_0_2_to_router_right_1_2_rsp;
floo_wide_t router_right_1_2_to_router_right_0_2_wide;

floo_req_t router_right_1_2_to_router_right_1_1_req;
floo_rsp_t router_right_1_1_to_router_right_1_2_rsp;
floo_wide_t router_right_1_2_to_router_right_1_1_wide;

floo_req_t router_right_1_2_to_router_right_1_3_req;
floo_rsp_t router_right_1_3_to_router_right_1_2_rsp;
floo_wide_t router_right_1_2_to_router_right_1_3_wide;

floo_req_t router_right_1_2_to_top_spm_narrow_ni_req;
floo_rsp_t top_spm_narrow_ni_to_router_right_1_2_rsp;
floo_wide_t router_right_1_2_to_top_spm_narrow_ni_wide;

floo_req_t router_right_1_3_to_router_right_0_3_req;
floo_rsp_t router_right_0_3_to_router_right_1_3_rsp;
floo_wide_t router_right_1_3_to_router_right_0_3_wide;

floo_req_t router_right_1_3_to_router_right_1_2_req;
floo_rsp_t router_right_1_2_to_router_right_1_3_rsp;
floo_wide_t router_right_1_3_to_router_right_1_2_wide;

floo_req_t router_right_1_3_to_cheshire_ni_req;
floo_rsp_t cheshire_ni_to_router_right_1_3_rsp;
floo_wide_t router_right_1_3_to_cheshire_ni_wide;

floo_req_t cluster_ni_0_0_to_router_center_0_0_req;
floo_rsp_t router_center_0_0_to_cluster_ni_0_0_rsp;
floo_wide_t cluster_ni_0_0_to_router_center_0_0_wide;

floo_req_t cluster_ni_0_1_to_router_center_0_1_req;
floo_rsp_t router_center_0_1_to_cluster_ni_0_1_rsp;
floo_wide_t cluster_ni_0_1_to_router_center_0_1_wide;

floo_req_t cluster_ni_0_2_to_router_center_0_2_req;
floo_rsp_t router_center_0_2_to_cluster_ni_0_2_rsp;
floo_wide_t cluster_ni_0_2_to_router_center_0_2_wide;

floo_req_t cluster_ni_0_3_to_router_center_0_3_req;
floo_rsp_t router_center_0_3_to_cluster_ni_0_3_rsp;
floo_wide_t cluster_ni_0_3_to_router_center_0_3_wide;

floo_req_t cluster_ni_1_0_to_router_center_1_0_req;
floo_rsp_t router_center_1_0_to_cluster_ni_1_0_rsp;
floo_wide_t cluster_ni_1_0_to_router_center_1_0_wide;

floo_req_t cluster_ni_1_1_to_router_center_1_1_req;
floo_rsp_t router_center_1_1_to_cluster_ni_1_1_rsp;
floo_wide_t cluster_ni_1_1_to_router_center_1_1_wide;

floo_req_t cluster_ni_1_2_to_router_center_1_2_req;
floo_rsp_t router_center_1_2_to_cluster_ni_1_2_rsp;
floo_wide_t cluster_ni_1_2_to_router_center_1_2_wide;

floo_req_t cluster_ni_1_3_to_router_center_1_3_req;
floo_rsp_t router_center_1_3_to_cluster_ni_1_3_rsp;
floo_wide_t cluster_ni_1_3_to_router_center_1_3_wide;

floo_req_t cluster_ni_2_0_to_router_center_2_0_req;
floo_rsp_t router_center_2_0_to_cluster_ni_2_0_rsp;
floo_wide_t cluster_ni_2_0_to_router_center_2_0_wide;

floo_req_t cluster_ni_2_1_to_router_center_2_1_req;
floo_rsp_t router_center_2_1_to_cluster_ni_2_1_rsp;
floo_wide_t cluster_ni_2_1_to_router_center_2_1_wide;

floo_req_t cluster_ni_2_2_to_router_center_2_2_req;
floo_rsp_t router_center_2_2_to_cluster_ni_2_2_rsp;
floo_wide_t cluster_ni_2_2_to_router_center_2_2_wide;

floo_req_t cluster_ni_2_3_to_router_center_2_3_req;
floo_rsp_t router_center_2_3_to_cluster_ni_2_3_rsp;
floo_wide_t cluster_ni_2_3_to_router_center_2_3_wide;

floo_req_t cluster_ni_3_0_to_router_center_3_0_req;
floo_rsp_t router_center_3_0_to_cluster_ni_3_0_rsp;
floo_wide_t cluster_ni_3_0_to_router_center_3_0_wide;

floo_req_t cluster_ni_3_1_to_router_center_3_1_req;
floo_rsp_t router_center_3_1_to_cluster_ni_3_1_rsp;
floo_wide_t cluster_ni_3_1_to_router_center_3_1_wide;

floo_req_t cluster_ni_3_2_to_router_center_3_2_req;
floo_rsp_t router_center_3_2_to_cluster_ni_3_2_rsp;
floo_wide_t cluster_ni_3_2_to_router_center_3_2_wide;

floo_req_t cluster_ni_3_3_to_router_center_3_3_req;
floo_rsp_t router_center_3_3_to_cluster_ni_3_3_rsp;
floo_wide_t cluster_ni_3_3_to_router_center_3_3_wide;

floo_req_t cheshire_ni_to_router_right_1_3_req;
floo_rsp_t router_right_1_3_to_cheshire_ni_rsp;
floo_wide_t cheshire_ni_to_router_right_1_3_wide;

floo_req_t fhg_spu_ni_to_router_right_1_0_req;
floo_rsp_t router_right_1_0_to_fhg_spu_ni_rsp;
floo_wide_t fhg_spu_ni_to_router_right_1_0_wide;

floo_req_t top_spm_narrow_ni_to_router_right_1_2_req;
floo_rsp_t router_right_1_2_to_top_spm_narrow_ni_rsp;
floo_wide_t top_spm_narrow_ni_to_router_right_1_2_wide;

floo_req_t top_spm_wide_ni_to_router_right_1_1_req;
floo_rsp_t router_right_1_1_to_top_spm_wide_ni_rsp;
floo_wide_t top_spm_wide_ni_to_router_right_1_1_wide;

floo_req_t l2_spm_ni_0_to_router_left_0_0_req;
floo_rsp_t router_left_0_0_to_l2_spm_ni_0_rsp;
floo_wide_t l2_spm_ni_0_to_router_left_0_0_wide;

floo_req_t l2_spm_ni_1_to_router_left_0_1_req;
floo_rsp_t router_left_0_1_to_l2_spm_ni_1_rsp;
floo_wide_t l2_spm_ni_1_to_router_left_0_1_wide;

floo_req_t l2_spm_ni_2_to_router_left_0_2_req;
floo_rsp_t router_left_0_2_to_l2_spm_ni_2_rsp;
floo_wide_t l2_spm_ni_2_to_router_left_0_2_wide;

floo_req_t l2_spm_ni_3_to_router_left_0_3_req;
floo_rsp_t router_left_0_3_to_l2_spm_ni_3_rsp;
floo_wide_t l2_spm_ni_3_to_router_left_0_3_wide;

floo_req_t l2_spm_ni_4_to_router_right_0_0_req;
floo_rsp_t router_right_0_0_to_l2_spm_ni_4_rsp;
floo_wide_t l2_spm_ni_4_to_router_right_0_0_wide;

floo_req_t l2_spm_ni_5_to_router_right_0_1_req;
floo_rsp_t router_right_0_1_to_l2_spm_ni_5_rsp;
floo_wide_t l2_spm_ni_5_to_router_right_0_1_wide;

floo_req_t l2_spm_ni_6_to_router_right_0_2_req;
floo_rsp_t router_right_0_2_to_l2_spm_ni_6_rsp;
floo_wide_t l2_spm_ni_6_to_router_right_0_2_wide;

floo_req_t l2_spm_ni_7_to_router_right_0_3_req;
floo_rsp_t router_right_0_3_to_l2_spm_ni_7_rsp;
floo_wide_t l2_spm_ni_7_to_router_right_0_3_wide;



  localparam id_t CLUSTER_NI_0_0_ID = '{x: 4, y: 0, port_id: 0};

floo_nw_chimney  #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .ChimneyCfgN(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .ChimneyCfgW(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .RouteCfg(RouteCfg),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(collective_sam_rule_t),
  .sam_idx_t(collective_idx_t),
  .mask_sel_t(collective_mask_sel_t),
  .Sam(CollectiveSam),
  .user_narrow_struct_t(collective_axi_narrow_in_user_t),
  .user_wide_struct_t(collective_axi_wide_in_user_t),
  .axi_narrow_in_req_t(collective_axi_narrow_in_req_t),
  .axi_narrow_in_rsp_t(collective_axi_narrow_in_rsp_t),
  .axi_narrow_out_req_t(collective_axi_narrow_out_req_t),
  .axi_narrow_out_rsp_t(collective_axi_narrow_out_rsp_t),
  .axi_wide_in_req_t(collective_axi_wide_in_req_t),
  .axi_wide_in_rsp_t(collective_axi_wide_in_rsp_t),
  .axi_wide_out_req_t(collective_axi_wide_out_req_t),
  .axi_wide_out_rsp_t(collective_axi_wide_out_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) cluster_ni_0_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_narrow_in_req_i  ( cluster_narrow_in_req_i[0][0] ),
  .axi_narrow_in_rsp_o  ( cluster_narrow_in_rsp_o[0][0] ),
  .axi_narrow_out_req_o ( cluster_narrow_out_req_o[0][0] ),
  .axi_narrow_out_rsp_i ( cluster_narrow_out_rsp_i[0][0] ),
  .axi_wide_in_req_i  ( cluster_wide_in_req_i[0][0] ),
  .axi_wide_in_rsp_o  ( cluster_wide_in_rsp_o[0][0] ),
  .axi_wide_out_req_o ( cluster_wide_out_req_o[0][0] ),
  .axi_wide_out_rsp_i ( cluster_wide_out_rsp_i[0][0] ),
  .id_i             ( CLUSTER_NI_0_0_ID       ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( cluster_ni_0_0_to_router_center_0_0_req   ),
  .floo_rsp_i       ( router_center_0_0_to_cluster_ni_0_0_rsp   ),
  .floo_wide_o      ( cluster_ni_0_0_to_router_center_0_0_wide  ),
  .floo_req_i       ( router_center_0_0_to_cluster_ni_0_0_req   ),
  .floo_rsp_o       ( cluster_ni_0_0_to_router_center_0_0_rsp   ),
  .floo_wide_i      ( router_center_0_0_to_cluster_ni_0_0_wide  )
);

  localparam id_t CLUSTER_NI_0_1_ID = '{x: 4, y: 1, port_id: 0};

floo_nw_chimney  #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .ChimneyCfgN(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .ChimneyCfgW(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .RouteCfg(RouteCfg),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(collective_sam_rule_t),
  .sam_idx_t(collective_idx_t),
  .mask_sel_t(collective_mask_sel_t),
  .Sam(CollectiveSam),
  .user_narrow_struct_t(collective_axi_narrow_in_user_t),
  .user_wide_struct_t(collective_axi_wide_in_user_t),
  .axi_narrow_in_req_t(collective_axi_narrow_in_req_t),
  .axi_narrow_in_rsp_t(collective_axi_narrow_in_rsp_t),
  .axi_narrow_out_req_t(collective_axi_narrow_out_req_t),
  .axi_narrow_out_rsp_t(collective_axi_narrow_out_rsp_t),
  .axi_wide_in_req_t(collective_axi_wide_in_req_t),
  .axi_wide_in_rsp_t(collective_axi_wide_in_rsp_t),
  .axi_wide_out_req_t(collective_axi_wide_out_req_t),
  .axi_wide_out_rsp_t(collective_axi_wide_out_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) cluster_ni_0_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_narrow_in_req_i  ( cluster_narrow_in_req_i[0][1] ),
  .axi_narrow_in_rsp_o  ( cluster_narrow_in_rsp_o[0][1] ),
  .axi_narrow_out_req_o ( cluster_narrow_out_req_o[0][1] ),
  .axi_narrow_out_rsp_i ( cluster_narrow_out_rsp_i[0][1] ),
  .axi_wide_in_req_i  ( cluster_wide_in_req_i[0][1] ),
  .axi_wide_in_rsp_o  ( cluster_wide_in_rsp_o[0][1] ),
  .axi_wide_out_req_o ( cluster_wide_out_req_o[0][1] ),
  .axi_wide_out_rsp_i ( cluster_wide_out_rsp_i[0][1] ),
  .id_i             ( CLUSTER_NI_0_1_ID       ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( cluster_ni_0_1_to_router_center_0_1_req   ),
  .floo_rsp_i       ( router_center_0_1_to_cluster_ni_0_1_rsp   ),
  .floo_wide_o      ( cluster_ni_0_1_to_router_center_0_1_wide  ),
  .floo_req_i       ( router_center_0_1_to_cluster_ni_0_1_req   ),
  .floo_rsp_o       ( cluster_ni_0_1_to_router_center_0_1_rsp   ),
  .floo_wide_i      ( router_center_0_1_to_cluster_ni_0_1_wide  )
);

  localparam id_t CLUSTER_NI_0_2_ID = '{x: 4, y: 2, port_id: 0};

floo_nw_chimney  #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .ChimneyCfgN(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .ChimneyCfgW(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .RouteCfg(RouteCfg),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(collective_sam_rule_t),
  .sam_idx_t(collective_idx_t),
  .mask_sel_t(collective_mask_sel_t),
  .Sam(CollectiveSam),
  .user_narrow_struct_t(collective_axi_narrow_in_user_t),
  .user_wide_struct_t(collective_axi_wide_in_user_t),
  .axi_narrow_in_req_t(collective_axi_narrow_in_req_t),
  .axi_narrow_in_rsp_t(collective_axi_narrow_in_rsp_t),
  .axi_narrow_out_req_t(collective_axi_narrow_out_req_t),
  .axi_narrow_out_rsp_t(collective_axi_narrow_out_rsp_t),
  .axi_wide_in_req_t(collective_axi_wide_in_req_t),
  .axi_wide_in_rsp_t(collective_axi_wide_in_rsp_t),
  .axi_wide_out_req_t(collective_axi_wide_out_req_t),
  .axi_wide_out_rsp_t(collective_axi_wide_out_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) cluster_ni_0_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_narrow_in_req_i  ( cluster_narrow_in_req_i[0][2] ),
  .axi_narrow_in_rsp_o  ( cluster_narrow_in_rsp_o[0][2] ),
  .axi_narrow_out_req_o ( cluster_narrow_out_req_o[0][2] ),
  .axi_narrow_out_rsp_i ( cluster_narrow_out_rsp_i[0][2] ),
  .axi_wide_in_req_i  ( cluster_wide_in_req_i[0][2] ),
  .axi_wide_in_rsp_o  ( cluster_wide_in_rsp_o[0][2] ),
  .axi_wide_out_req_o ( cluster_wide_out_req_o[0][2] ),
  .axi_wide_out_rsp_i ( cluster_wide_out_rsp_i[0][2] ),
  .id_i             ( CLUSTER_NI_0_2_ID       ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( cluster_ni_0_2_to_router_center_0_2_req   ),
  .floo_rsp_i       ( router_center_0_2_to_cluster_ni_0_2_rsp   ),
  .floo_wide_o      ( cluster_ni_0_2_to_router_center_0_2_wide  ),
  .floo_req_i       ( router_center_0_2_to_cluster_ni_0_2_req   ),
  .floo_rsp_o       ( cluster_ni_0_2_to_router_center_0_2_rsp   ),
  .floo_wide_i      ( router_center_0_2_to_cluster_ni_0_2_wide  )
);

  localparam id_t CLUSTER_NI_0_3_ID = '{x: 4, y: 3, port_id: 0};

floo_nw_chimney  #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .ChimneyCfgN(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .ChimneyCfgW(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .RouteCfg(RouteCfg),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(collective_sam_rule_t),
  .sam_idx_t(collective_idx_t),
  .mask_sel_t(collective_mask_sel_t),
  .Sam(CollectiveSam),
  .user_narrow_struct_t(collective_axi_narrow_in_user_t),
  .user_wide_struct_t(collective_axi_wide_in_user_t),
  .axi_narrow_in_req_t(collective_axi_narrow_in_req_t),
  .axi_narrow_in_rsp_t(collective_axi_narrow_in_rsp_t),
  .axi_narrow_out_req_t(collective_axi_narrow_out_req_t),
  .axi_narrow_out_rsp_t(collective_axi_narrow_out_rsp_t),
  .axi_wide_in_req_t(collective_axi_wide_in_req_t),
  .axi_wide_in_rsp_t(collective_axi_wide_in_rsp_t),
  .axi_wide_out_req_t(collective_axi_wide_out_req_t),
  .axi_wide_out_rsp_t(collective_axi_wide_out_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) cluster_ni_0_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_narrow_in_req_i  ( cluster_narrow_in_req_i[0][3] ),
  .axi_narrow_in_rsp_o  ( cluster_narrow_in_rsp_o[0][3] ),
  .axi_narrow_out_req_o ( cluster_narrow_out_req_o[0][3] ),
  .axi_narrow_out_rsp_i ( cluster_narrow_out_rsp_i[0][3] ),
  .axi_wide_in_req_i  ( cluster_wide_in_req_i[0][3] ),
  .axi_wide_in_rsp_o  ( cluster_wide_in_rsp_o[0][3] ),
  .axi_wide_out_req_o ( cluster_wide_out_req_o[0][3] ),
  .axi_wide_out_rsp_i ( cluster_wide_out_rsp_i[0][3] ),
  .id_i             ( CLUSTER_NI_0_3_ID       ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( cluster_ni_0_3_to_router_center_0_3_req   ),
  .floo_rsp_i       ( router_center_0_3_to_cluster_ni_0_3_rsp   ),
  .floo_wide_o      ( cluster_ni_0_3_to_router_center_0_3_wide  ),
  .floo_req_i       ( router_center_0_3_to_cluster_ni_0_3_req   ),
  .floo_rsp_o       ( cluster_ni_0_3_to_router_center_0_3_rsp   ),
  .floo_wide_i      ( router_center_0_3_to_cluster_ni_0_3_wide  )
);

  localparam id_t CLUSTER_NI_1_0_ID = '{x: 5, y: 0, port_id: 0};

floo_nw_chimney  #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .ChimneyCfgN(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .ChimneyCfgW(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .RouteCfg(RouteCfg),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(collective_sam_rule_t),
  .sam_idx_t(collective_idx_t),
  .mask_sel_t(collective_mask_sel_t),
  .Sam(CollectiveSam),
  .user_narrow_struct_t(collective_axi_narrow_in_user_t),
  .user_wide_struct_t(collective_axi_wide_in_user_t),
  .axi_narrow_in_req_t(collective_axi_narrow_in_req_t),
  .axi_narrow_in_rsp_t(collective_axi_narrow_in_rsp_t),
  .axi_narrow_out_req_t(collective_axi_narrow_out_req_t),
  .axi_narrow_out_rsp_t(collective_axi_narrow_out_rsp_t),
  .axi_wide_in_req_t(collective_axi_wide_in_req_t),
  .axi_wide_in_rsp_t(collective_axi_wide_in_rsp_t),
  .axi_wide_out_req_t(collective_axi_wide_out_req_t),
  .axi_wide_out_rsp_t(collective_axi_wide_out_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) cluster_ni_1_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_narrow_in_req_i  ( cluster_narrow_in_req_i[1][0] ),
  .axi_narrow_in_rsp_o  ( cluster_narrow_in_rsp_o[1][0] ),
  .axi_narrow_out_req_o ( cluster_narrow_out_req_o[1][0] ),
  .axi_narrow_out_rsp_i ( cluster_narrow_out_rsp_i[1][0] ),
  .axi_wide_in_req_i  ( cluster_wide_in_req_i[1][0] ),
  .axi_wide_in_rsp_o  ( cluster_wide_in_rsp_o[1][0] ),
  .axi_wide_out_req_o ( cluster_wide_out_req_o[1][0] ),
  .axi_wide_out_rsp_i ( cluster_wide_out_rsp_i[1][0] ),
  .id_i             ( CLUSTER_NI_1_0_ID       ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( cluster_ni_1_0_to_router_center_1_0_req   ),
  .floo_rsp_i       ( router_center_1_0_to_cluster_ni_1_0_rsp   ),
  .floo_wide_o      ( cluster_ni_1_0_to_router_center_1_0_wide  ),
  .floo_req_i       ( router_center_1_0_to_cluster_ni_1_0_req   ),
  .floo_rsp_o       ( cluster_ni_1_0_to_router_center_1_0_rsp   ),
  .floo_wide_i      ( router_center_1_0_to_cluster_ni_1_0_wide  )
);

  localparam id_t CLUSTER_NI_1_1_ID = '{x: 5, y: 1, port_id: 0};

floo_nw_chimney  #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .ChimneyCfgN(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .ChimneyCfgW(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .RouteCfg(RouteCfg),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(collective_sam_rule_t),
  .sam_idx_t(collective_idx_t),
  .mask_sel_t(collective_mask_sel_t),
  .Sam(CollectiveSam),
  .user_narrow_struct_t(collective_axi_narrow_in_user_t),
  .user_wide_struct_t(collective_axi_wide_in_user_t),
  .axi_narrow_in_req_t(collective_axi_narrow_in_req_t),
  .axi_narrow_in_rsp_t(collective_axi_narrow_in_rsp_t),
  .axi_narrow_out_req_t(collective_axi_narrow_out_req_t),
  .axi_narrow_out_rsp_t(collective_axi_narrow_out_rsp_t),
  .axi_wide_in_req_t(collective_axi_wide_in_req_t),
  .axi_wide_in_rsp_t(collective_axi_wide_in_rsp_t),
  .axi_wide_out_req_t(collective_axi_wide_out_req_t),
  .axi_wide_out_rsp_t(collective_axi_wide_out_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) cluster_ni_1_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_narrow_in_req_i  ( cluster_narrow_in_req_i[1][1] ),
  .axi_narrow_in_rsp_o  ( cluster_narrow_in_rsp_o[1][1] ),
  .axi_narrow_out_req_o ( cluster_narrow_out_req_o[1][1] ),
  .axi_narrow_out_rsp_i ( cluster_narrow_out_rsp_i[1][1] ),
  .axi_wide_in_req_i  ( cluster_wide_in_req_i[1][1] ),
  .axi_wide_in_rsp_o  ( cluster_wide_in_rsp_o[1][1] ),
  .axi_wide_out_req_o ( cluster_wide_out_req_o[1][1] ),
  .axi_wide_out_rsp_i ( cluster_wide_out_rsp_i[1][1] ),
  .id_i             ( CLUSTER_NI_1_1_ID       ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( cluster_ni_1_1_to_router_center_1_1_req   ),
  .floo_rsp_i       ( router_center_1_1_to_cluster_ni_1_1_rsp   ),
  .floo_wide_o      ( cluster_ni_1_1_to_router_center_1_1_wide  ),
  .floo_req_i       ( router_center_1_1_to_cluster_ni_1_1_req   ),
  .floo_rsp_o       ( cluster_ni_1_1_to_router_center_1_1_rsp   ),
  .floo_wide_i      ( router_center_1_1_to_cluster_ni_1_1_wide  )
);

  localparam id_t CLUSTER_NI_1_2_ID = '{x: 5, y: 2, port_id: 0};

floo_nw_chimney  #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .ChimneyCfgN(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .ChimneyCfgW(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .RouteCfg(RouteCfg),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(collective_sam_rule_t),
  .sam_idx_t(collective_idx_t),
  .mask_sel_t(collective_mask_sel_t),
  .Sam(CollectiveSam),
  .user_narrow_struct_t(collective_axi_narrow_in_user_t),
  .user_wide_struct_t(collective_axi_wide_in_user_t),
  .axi_narrow_in_req_t(collective_axi_narrow_in_req_t),
  .axi_narrow_in_rsp_t(collective_axi_narrow_in_rsp_t),
  .axi_narrow_out_req_t(collective_axi_narrow_out_req_t),
  .axi_narrow_out_rsp_t(collective_axi_narrow_out_rsp_t),
  .axi_wide_in_req_t(collective_axi_wide_in_req_t),
  .axi_wide_in_rsp_t(collective_axi_wide_in_rsp_t),
  .axi_wide_out_req_t(collective_axi_wide_out_req_t),
  .axi_wide_out_rsp_t(collective_axi_wide_out_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) cluster_ni_1_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_narrow_in_req_i  ( cluster_narrow_in_req_i[1][2] ),
  .axi_narrow_in_rsp_o  ( cluster_narrow_in_rsp_o[1][2] ),
  .axi_narrow_out_req_o ( cluster_narrow_out_req_o[1][2] ),
  .axi_narrow_out_rsp_i ( cluster_narrow_out_rsp_i[1][2] ),
  .axi_wide_in_req_i  ( cluster_wide_in_req_i[1][2] ),
  .axi_wide_in_rsp_o  ( cluster_wide_in_rsp_o[1][2] ),
  .axi_wide_out_req_o ( cluster_wide_out_req_o[1][2] ),
  .axi_wide_out_rsp_i ( cluster_wide_out_rsp_i[1][2] ),
  .id_i             ( CLUSTER_NI_1_2_ID       ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( cluster_ni_1_2_to_router_center_1_2_req   ),
  .floo_rsp_i       ( router_center_1_2_to_cluster_ni_1_2_rsp   ),
  .floo_wide_o      ( cluster_ni_1_2_to_router_center_1_2_wide  ),
  .floo_req_i       ( router_center_1_2_to_cluster_ni_1_2_req   ),
  .floo_rsp_o       ( cluster_ni_1_2_to_router_center_1_2_rsp   ),
  .floo_wide_i      ( router_center_1_2_to_cluster_ni_1_2_wide  )
);

  localparam id_t CLUSTER_NI_1_3_ID = '{x: 5, y: 3, port_id: 0};

floo_nw_chimney  #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .ChimneyCfgN(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .ChimneyCfgW(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .RouteCfg(RouteCfg),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(collective_sam_rule_t),
  .sam_idx_t(collective_idx_t),
  .mask_sel_t(collective_mask_sel_t),
  .Sam(CollectiveSam),
  .user_narrow_struct_t(collective_axi_narrow_in_user_t),
  .user_wide_struct_t(collective_axi_wide_in_user_t),
  .axi_narrow_in_req_t(collective_axi_narrow_in_req_t),
  .axi_narrow_in_rsp_t(collective_axi_narrow_in_rsp_t),
  .axi_narrow_out_req_t(collective_axi_narrow_out_req_t),
  .axi_narrow_out_rsp_t(collective_axi_narrow_out_rsp_t),
  .axi_wide_in_req_t(collective_axi_wide_in_req_t),
  .axi_wide_in_rsp_t(collective_axi_wide_in_rsp_t),
  .axi_wide_out_req_t(collective_axi_wide_out_req_t),
  .axi_wide_out_rsp_t(collective_axi_wide_out_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) cluster_ni_1_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_narrow_in_req_i  ( cluster_narrow_in_req_i[1][3] ),
  .axi_narrow_in_rsp_o  ( cluster_narrow_in_rsp_o[1][3] ),
  .axi_narrow_out_req_o ( cluster_narrow_out_req_o[1][3] ),
  .axi_narrow_out_rsp_i ( cluster_narrow_out_rsp_i[1][3] ),
  .axi_wide_in_req_i  ( cluster_wide_in_req_i[1][3] ),
  .axi_wide_in_rsp_o  ( cluster_wide_in_rsp_o[1][3] ),
  .axi_wide_out_req_o ( cluster_wide_out_req_o[1][3] ),
  .axi_wide_out_rsp_i ( cluster_wide_out_rsp_i[1][3] ),
  .id_i             ( CLUSTER_NI_1_3_ID       ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( cluster_ni_1_3_to_router_center_1_3_req   ),
  .floo_rsp_i       ( router_center_1_3_to_cluster_ni_1_3_rsp   ),
  .floo_wide_o      ( cluster_ni_1_3_to_router_center_1_3_wide  ),
  .floo_req_i       ( router_center_1_3_to_cluster_ni_1_3_req   ),
  .floo_rsp_o       ( cluster_ni_1_3_to_router_center_1_3_rsp   ),
  .floo_wide_i      ( router_center_1_3_to_cluster_ni_1_3_wide  )
);

  localparam id_t CLUSTER_NI_2_0_ID = '{x: 6, y: 0, port_id: 0};

floo_nw_chimney  #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .ChimneyCfgN(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .ChimneyCfgW(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .RouteCfg(RouteCfg),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(collective_sam_rule_t),
  .sam_idx_t(collective_idx_t),
  .mask_sel_t(collective_mask_sel_t),
  .Sam(CollectiveSam),
  .user_narrow_struct_t(collective_axi_narrow_in_user_t),
  .user_wide_struct_t(collective_axi_wide_in_user_t),
  .axi_narrow_in_req_t(collective_axi_narrow_in_req_t),
  .axi_narrow_in_rsp_t(collective_axi_narrow_in_rsp_t),
  .axi_narrow_out_req_t(collective_axi_narrow_out_req_t),
  .axi_narrow_out_rsp_t(collective_axi_narrow_out_rsp_t),
  .axi_wide_in_req_t(collective_axi_wide_in_req_t),
  .axi_wide_in_rsp_t(collective_axi_wide_in_rsp_t),
  .axi_wide_out_req_t(collective_axi_wide_out_req_t),
  .axi_wide_out_rsp_t(collective_axi_wide_out_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) cluster_ni_2_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_narrow_in_req_i  ( cluster_narrow_in_req_i[2][0] ),
  .axi_narrow_in_rsp_o  ( cluster_narrow_in_rsp_o[2][0] ),
  .axi_narrow_out_req_o ( cluster_narrow_out_req_o[2][0] ),
  .axi_narrow_out_rsp_i ( cluster_narrow_out_rsp_i[2][0] ),
  .axi_wide_in_req_i  ( cluster_wide_in_req_i[2][0] ),
  .axi_wide_in_rsp_o  ( cluster_wide_in_rsp_o[2][0] ),
  .axi_wide_out_req_o ( cluster_wide_out_req_o[2][0] ),
  .axi_wide_out_rsp_i ( cluster_wide_out_rsp_i[2][0] ),
  .id_i             ( CLUSTER_NI_2_0_ID       ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( cluster_ni_2_0_to_router_center_2_0_req   ),
  .floo_rsp_i       ( router_center_2_0_to_cluster_ni_2_0_rsp   ),
  .floo_wide_o      ( cluster_ni_2_0_to_router_center_2_0_wide  ),
  .floo_req_i       ( router_center_2_0_to_cluster_ni_2_0_req   ),
  .floo_rsp_o       ( cluster_ni_2_0_to_router_center_2_0_rsp   ),
  .floo_wide_i      ( router_center_2_0_to_cluster_ni_2_0_wide  )
);

  localparam id_t CLUSTER_NI_2_1_ID = '{x: 6, y: 1, port_id: 0};

floo_nw_chimney  #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .ChimneyCfgN(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .ChimneyCfgW(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .RouteCfg(RouteCfg),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(collective_sam_rule_t),
  .sam_idx_t(collective_idx_t),
  .mask_sel_t(collective_mask_sel_t),
  .Sam(CollectiveSam),
  .user_narrow_struct_t(collective_axi_narrow_in_user_t),
  .user_wide_struct_t(collective_axi_wide_in_user_t),
  .axi_narrow_in_req_t(collective_axi_narrow_in_req_t),
  .axi_narrow_in_rsp_t(collective_axi_narrow_in_rsp_t),
  .axi_narrow_out_req_t(collective_axi_narrow_out_req_t),
  .axi_narrow_out_rsp_t(collective_axi_narrow_out_rsp_t),
  .axi_wide_in_req_t(collective_axi_wide_in_req_t),
  .axi_wide_in_rsp_t(collective_axi_wide_in_rsp_t),
  .axi_wide_out_req_t(collective_axi_wide_out_req_t),
  .axi_wide_out_rsp_t(collective_axi_wide_out_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) cluster_ni_2_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_narrow_in_req_i  ( cluster_narrow_in_req_i[2][1] ),
  .axi_narrow_in_rsp_o  ( cluster_narrow_in_rsp_o[2][1] ),
  .axi_narrow_out_req_o ( cluster_narrow_out_req_o[2][1] ),
  .axi_narrow_out_rsp_i ( cluster_narrow_out_rsp_i[2][1] ),
  .axi_wide_in_req_i  ( cluster_wide_in_req_i[2][1] ),
  .axi_wide_in_rsp_o  ( cluster_wide_in_rsp_o[2][1] ),
  .axi_wide_out_req_o ( cluster_wide_out_req_o[2][1] ),
  .axi_wide_out_rsp_i ( cluster_wide_out_rsp_i[2][1] ),
  .id_i             ( CLUSTER_NI_2_1_ID       ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( cluster_ni_2_1_to_router_center_2_1_req   ),
  .floo_rsp_i       ( router_center_2_1_to_cluster_ni_2_1_rsp   ),
  .floo_wide_o      ( cluster_ni_2_1_to_router_center_2_1_wide  ),
  .floo_req_i       ( router_center_2_1_to_cluster_ni_2_1_req   ),
  .floo_rsp_o       ( cluster_ni_2_1_to_router_center_2_1_rsp   ),
  .floo_wide_i      ( router_center_2_1_to_cluster_ni_2_1_wide  )
);

  localparam id_t CLUSTER_NI_2_2_ID = '{x: 6, y: 2, port_id: 0};

floo_nw_chimney  #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .ChimneyCfgN(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .ChimneyCfgW(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .RouteCfg(RouteCfg),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(collective_sam_rule_t),
  .sam_idx_t(collective_idx_t),
  .mask_sel_t(collective_mask_sel_t),
  .Sam(CollectiveSam),
  .user_narrow_struct_t(collective_axi_narrow_in_user_t),
  .user_wide_struct_t(collective_axi_wide_in_user_t),
  .axi_narrow_in_req_t(collective_axi_narrow_in_req_t),
  .axi_narrow_in_rsp_t(collective_axi_narrow_in_rsp_t),
  .axi_narrow_out_req_t(collective_axi_narrow_out_req_t),
  .axi_narrow_out_rsp_t(collective_axi_narrow_out_rsp_t),
  .axi_wide_in_req_t(collective_axi_wide_in_req_t),
  .axi_wide_in_rsp_t(collective_axi_wide_in_rsp_t),
  .axi_wide_out_req_t(collective_axi_wide_out_req_t),
  .axi_wide_out_rsp_t(collective_axi_wide_out_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) cluster_ni_2_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_narrow_in_req_i  ( cluster_narrow_in_req_i[2][2] ),
  .axi_narrow_in_rsp_o  ( cluster_narrow_in_rsp_o[2][2] ),
  .axi_narrow_out_req_o ( cluster_narrow_out_req_o[2][2] ),
  .axi_narrow_out_rsp_i ( cluster_narrow_out_rsp_i[2][2] ),
  .axi_wide_in_req_i  ( cluster_wide_in_req_i[2][2] ),
  .axi_wide_in_rsp_o  ( cluster_wide_in_rsp_o[2][2] ),
  .axi_wide_out_req_o ( cluster_wide_out_req_o[2][2] ),
  .axi_wide_out_rsp_i ( cluster_wide_out_rsp_i[2][2] ),
  .id_i             ( CLUSTER_NI_2_2_ID       ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( cluster_ni_2_2_to_router_center_2_2_req   ),
  .floo_rsp_i       ( router_center_2_2_to_cluster_ni_2_2_rsp   ),
  .floo_wide_o      ( cluster_ni_2_2_to_router_center_2_2_wide  ),
  .floo_req_i       ( router_center_2_2_to_cluster_ni_2_2_req   ),
  .floo_rsp_o       ( cluster_ni_2_2_to_router_center_2_2_rsp   ),
  .floo_wide_i      ( router_center_2_2_to_cluster_ni_2_2_wide  )
);

  localparam id_t CLUSTER_NI_2_3_ID = '{x: 6, y: 3, port_id: 0};

floo_nw_chimney  #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .ChimneyCfgN(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .ChimneyCfgW(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .RouteCfg(RouteCfg),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(collective_sam_rule_t),
  .sam_idx_t(collective_idx_t),
  .mask_sel_t(collective_mask_sel_t),
  .Sam(CollectiveSam),
  .user_narrow_struct_t(collective_axi_narrow_in_user_t),
  .user_wide_struct_t(collective_axi_wide_in_user_t),
  .axi_narrow_in_req_t(collective_axi_narrow_in_req_t),
  .axi_narrow_in_rsp_t(collective_axi_narrow_in_rsp_t),
  .axi_narrow_out_req_t(collective_axi_narrow_out_req_t),
  .axi_narrow_out_rsp_t(collective_axi_narrow_out_rsp_t),
  .axi_wide_in_req_t(collective_axi_wide_in_req_t),
  .axi_wide_in_rsp_t(collective_axi_wide_in_rsp_t),
  .axi_wide_out_req_t(collective_axi_wide_out_req_t),
  .axi_wide_out_rsp_t(collective_axi_wide_out_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) cluster_ni_2_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_narrow_in_req_i  ( cluster_narrow_in_req_i[2][3] ),
  .axi_narrow_in_rsp_o  ( cluster_narrow_in_rsp_o[2][3] ),
  .axi_narrow_out_req_o ( cluster_narrow_out_req_o[2][3] ),
  .axi_narrow_out_rsp_i ( cluster_narrow_out_rsp_i[2][3] ),
  .axi_wide_in_req_i  ( cluster_wide_in_req_i[2][3] ),
  .axi_wide_in_rsp_o  ( cluster_wide_in_rsp_o[2][3] ),
  .axi_wide_out_req_o ( cluster_wide_out_req_o[2][3] ),
  .axi_wide_out_rsp_i ( cluster_wide_out_rsp_i[2][3] ),
  .id_i             ( CLUSTER_NI_2_3_ID       ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( cluster_ni_2_3_to_router_center_2_3_req   ),
  .floo_rsp_i       ( router_center_2_3_to_cluster_ni_2_3_rsp   ),
  .floo_wide_o      ( cluster_ni_2_3_to_router_center_2_3_wide  ),
  .floo_req_i       ( router_center_2_3_to_cluster_ni_2_3_req   ),
  .floo_rsp_o       ( cluster_ni_2_3_to_router_center_2_3_rsp   ),
  .floo_wide_i      ( router_center_2_3_to_cluster_ni_2_3_wide  )
);

  localparam id_t CLUSTER_NI_3_0_ID = '{x: 7, y: 0, port_id: 0};

floo_nw_chimney  #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .ChimneyCfgN(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .ChimneyCfgW(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .RouteCfg(RouteCfg),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(collective_sam_rule_t),
  .sam_idx_t(collective_idx_t),
  .mask_sel_t(collective_mask_sel_t),
  .Sam(CollectiveSam),
  .user_narrow_struct_t(collective_axi_narrow_in_user_t),
  .user_wide_struct_t(collective_axi_wide_in_user_t),
  .axi_narrow_in_req_t(collective_axi_narrow_in_req_t),
  .axi_narrow_in_rsp_t(collective_axi_narrow_in_rsp_t),
  .axi_narrow_out_req_t(collective_axi_narrow_out_req_t),
  .axi_narrow_out_rsp_t(collective_axi_narrow_out_rsp_t),
  .axi_wide_in_req_t(collective_axi_wide_in_req_t),
  .axi_wide_in_rsp_t(collective_axi_wide_in_rsp_t),
  .axi_wide_out_req_t(collective_axi_wide_out_req_t),
  .axi_wide_out_rsp_t(collective_axi_wide_out_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) cluster_ni_3_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_narrow_in_req_i  ( cluster_narrow_in_req_i[3][0] ),
  .axi_narrow_in_rsp_o  ( cluster_narrow_in_rsp_o[3][0] ),
  .axi_narrow_out_req_o ( cluster_narrow_out_req_o[3][0] ),
  .axi_narrow_out_rsp_i ( cluster_narrow_out_rsp_i[3][0] ),
  .axi_wide_in_req_i  ( cluster_wide_in_req_i[3][0] ),
  .axi_wide_in_rsp_o  ( cluster_wide_in_rsp_o[3][0] ),
  .axi_wide_out_req_o ( cluster_wide_out_req_o[3][0] ),
  .axi_wide_out_rsp_i ( cluster_wide_out_rsp_i[3][0] ),
  .id_i             ( CLUSTER_NI_3_0_ID       ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( cluster_ni_3_0_to_router_center_3_0_req   ),
  .floo_rsp_i       ( router_center_3_0_to_cluster_ni_3_0_rsp   ),
  .floo_wide_o      ( cluster_ni_3_0_to_router_center_3_0_wide  ),
  .floo_req_i       ( router_center_3_0_to_cluster_ni_3_0_req   ),
  .floo_rsp_o       ( cluster_ni_3_0_to_router_center_3_0_rsp   ),
  .floo_wide_i      ( router_center_3_0_to_cluster_ni_3_0_wide  )
);

  localparam id_t CLUSTER_NI_3_1_ID = '{x: 7, y: 1, port_id: 0};

floo_nw_chimney  #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .ChimneyCfgN(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .ChimneyCfgW(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .RouteCfg(RouteCfg),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(collective_sam_rule_t),
  .sam_idx_t(collective_idx_t),
  .mask_sel_t(collective_mask_sel_t),
  .Sam(CollectiveSam),
  .user_narrow_struct_t(collective_axi_narrow_in_user_t),
  .user_wide_struct_t(collective_axi_wide_in_user_t),
  .axi_narrow_in_req_t(collective_axi_narrow_in_req_t),
  .axi_narrow_in_rsp_t(collective_axi_narrow_in_rsp_t),
  .axi_narrow_out_req_t(collective_axi_narrow_out_req_t),
  .axi_narrow_out_rsp_t(collective_axi_narrow_out_rsp_t),
  .axi_wide_in_req_t(collective_axi_wide_in_req_t),
  .axi_wide_in_rsp_t(collective_axi_wide_in_rsp_t),
  .axi_wide_out_req_t(collective_axi_wide_out_req_t),
  .axi_wide_out_rsp_t(collective_axi_wide_out_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) cluster_ni_3_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_narrow_in_req_i  ( cluster_narrow_in_req_i[3][1] ),
  .axi_narrow_in_rsp_o  ( cluster_narrow_in_rsp_o[3][1] ),
  .axi_narrow_out_req_o ( cluster_narrow_out_req_o[3][1] ),
  .axi_narrow_out_rsp_i ( cluster_narrow_out_rsp_i[3][1] ),
  .axi_wide_in_req_i  ( cluster_wide_in_req_i[3][1] ),
  .axi_wide_in_rsp_o  ( cluster_wide_in_rsp_o[3][1] ),
  .axi_wide_out_req_o ( cluster_wide_out_req_o[3][1] ),
  .axi_wide_out_rsp_i ( cluster_wide_out_rsp_i[3][1] ),
  .id_i             ( CLUSTER_NI_3_1_ID       ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( cluster_ni_3_1_to_router_center_3_1_req   ),
  .floo_rsp_i       ( router_center_3_1_to_cluster_ni_3_1_rsp   ),
  .floo_wide_o      ( cluster_ni_3_1_to_router_center_3_1_wide  ),
  .floo_req_i       ( router_center_3_1_to_cluster_ni_3_1_req   ),
  .floo_rsp_o       ( cluster_ni_3_1_to_router_center_3_1_rsp   ),
  .floo_wide_i      ( router_center_3_1_to_cluster_ni_3_1_wide  )
);

  localparam id_t CLUSTER_NI_3_2_ID = '{x: 7, y: 2, port_id: 0};

floo_nw_chimney  #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .ChimneyCfgN(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .ChimneyCfgW(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .RouteCfg(RouteCfg),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(collective_sam_rule_t),
  .sam_idx_t(collective_idx_t),
  .mask_sel_t(collective_mask_sel_t),
  .Sam(CollectiveSam),
  .user_narrow_struct_t(collective_axi_narrow_in_user_t),
  .user_wide_struct_t(collective_axi_wide_in_user_t),
  .axi_narrow_in_req_t(collective_axi_narrow_in_req_t),
  .axi_narrow_in_rsp_t(collective_axi_narrow_in_rsp_t),
  .axi_narrow_out_req_t(collective_axi_narrow_out_req_t),
  .axi_narrow_out_rsp_t(collective_axi_narrow_out_rsp_t),
  .axi_wide_in_req_t(collective_axi_wide_in_req_t),
  .axi_wide_in_rsp_t(collective_axi_wide_in_rsp_t),
  .axi_wide_out_req_t(collective_axi_wide_out_req_t),
  .axi_wide_out_rsp_t(collective_axi_wide_out_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) cluster_ni_3_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_narrow_in_req_i  ( cluster_narrow_in_req_i[3][2] ),
  .axi_narrow_in_rsp_o  ( cluster_narrow_in_rsp_o[3][2] ),
  .axi_narrow_out_req_o ( cluster_narrow_out_req_o[3][2] ),
  .axi_narrow_out_rsp_i ( cluster_narrow_out_rsp_i[3][2] ),
  .axi_wide_in_req_i  ( cluster_wide_in_req_i[3][2] ),
  .axi_wide_in_rsp_o  ( cluster_wide_in_rsp_o[3][2] ),
  .axi_wide_out_req_o ( cluster_wide_out_req_o[3][2] ),
  .axi_wide_out_rsp_i ( cluster_wide_out_rsp_i[3][2] ),
  .id_i             ( CLUSTER_NI_3_2_ID       ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( cluster_ni_3_2_to_router_center_3_2_req   ),
  .floo_rsp_i       ( router_center_3_2_to_cluster_ni_3_2_rsp   ),
  .floo_wide_o      ( cluster_ni_3_2_to_router_center_3_2_wide  ),
  .floo_req_i       ( router_center_3_2_to_cluster_ni_3_2_req   ),
  .floo_rsp_o       ( cluster_ni_3_2_to_router_center_3_2_rsp   ),
  .floo_wide_i      ( router_center_3_2_to_cluster_ni_3_2_wide  )
);

  localparam id_t CLUSTER_NI_3_3_ID = '{x: 7, y: 3, port_id: 0};

floo_nw_chimney  #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .ChimneyCfgN(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .ChimneyCfgW(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .RouteCfg(RouteCfg),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(collective_sam_rule_t),
  .sam_idx_t(collective_idx_t),
  .mask_sel_t(collective_mask_sel_t),
  .Sam(CollectiveSam),
  .user_narrow_struct_t(collective_axi_narrow_in_user_t),
  .user_wide_struct_t(collective_axi_wide_in_user_t),
  .axi_narrow_in_req_t(collective_axi_narrow_in_req_t),
  .axi_narrow_in_rsp_t(collective_axi_narrow_in_rsp_t),
  .axi_narrow_out_req_t(collective_axi_narrow_out_req_t),
  .axi_narrow_out_rsp_t(collective_axi_narrow_out_rsp_t),
  .axi_wide_in_req_t(collective_axi_wide_in_req_t),
  .axi_wide_in_rsp_t(collective_axi_wide_in_rsp_t),
  .axi_wide_out_req_t(collective_axi_wide_out_req_t),
  .axi_wide_out_rsp_t(collective_axi_wide_out_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) cluster_ni_3_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_narrow_in_req_i  ( cluster_narrow_in_req_i[3][3] ),
  .axi_narrow_in_rsp_o  ( cluster_narrow_in_rsp_o[3][3] ),
  .axi_narrow_out_req_o ( cluster_narrow_out_req_o[3][3] ),
  .axi_narrow_out_rsp_i ( cluster_narrow_out_rsp_i[3][3] ),
  .axi_wide_in_req_i  ( cluster_wide_in_req_i[3][3] ),
  .axi_wide_in_rsp_o  ( cluster_wide_in_rsp_o[3][3] ),
  .axi_wide_out_req_o ( cluster_wide_out_req_o[3][3] ),
  .axi_wide_out_rsp_i ( cluster_wide_out_rsp_i[3][3] ),
  .id_i             ( CLUSTER_NI_3_3_ID       ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( cluster_ni_3_3_to_router_center_3_3_req   ),
  .floo_rsp_i       ( router_center_3_3_to_cluster_ni_3_3_rsp   ),
  .floo_wide_o      ( cluster_ni_3_3_to_router_center_3_3_wide  ),
  .floo_req_i       ( router_center_3_3_to_cluster_ni_3_3_req   ),
  .floo_rsp_o       ( cluster_ni_3_3_to_router_center_3_3_rsp   ),
  .floo_wide_i      ( router_center_3_3_to_cluster_ni_3_3_wide  )
);

  localparam id_t CHESHIRE_NI_ID = '{x: 9, y: 3, port_id: 0};

floo_nw_chimney  #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .ChimneyCfgN(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .ChimneyCfgW(set_ports(ChimneyDefaultCfg, 1'b1, 1'b0)),
  .RouteCfg(RouteCfg),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(sam_rule_t),
  .Sam(Sam),
  .axi_narrow_in_req_t(axi_narrow_in_req_t),
  .axi_narrow_in_rsp_t(axi_narrow_in_rsp_t),
  .axi_narrow_out_req_t(axi_narrow_out_req_t),
  .axi_narrow_out_rsp_t(axi_narrow_out_rsp_t),
  .axi_wide_in_req_t(axi_wide_in_req_t),
  .axi_wide_in_rsp_t(axi_wide_in_rsp_t),
  .axi_wide_out_req_t(axi_wide_out_req_t),
  .axi_wide_out_rsp_t(axi_wide_out_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) cheshire_ni (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_narrow_in_req_i  ( cheshire_narrow_in_req_i ),
  .axi_narrow_in_rsp_o  ( cheshire_narrow_in_rsp_o ),
  .axi_narrow_out_req_o ( cheshire_narrow_out_req_o ),
  .axi_narrow_out_rsp_i ( cheshire_narrow_out_rsp_i ),
  .axi_wide_in_req_i  ( '0 ),
  .axi_wide_in_rsp_o  (    ),
  .axi_wide_out_req_o ( cheshire_wide_out_req_o ),
  .axi_wide_out_rsp_i ( cheshire_wide_out_rsp_i ),
  .id_i             ( CHESHIRE_NI_ID       ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( cheshire_ni_to_router_right_1_3_req   ),
  .floo_rsp_i       ( router_right_1_3_to_cheshire_ni_rsp   ),
  .floo_wide_o      ( cheshire_ni_to_router_right_1_3_wide  ),
  .floo_req_i       ( router_right_1_3_to_cheshire_ni_req   ),
  .floo_rsp_o       ( cheshire_ni_to_router_right_1_3_rsp   ),
  .floo_wide_i      ( router_right_1_3_to_cheshire_ni_wide  )
);

  localparam id_t FHG_SPU_NI_ID = '{x: 9, y: 0, port_id: 0};

floo_nw_chimney  #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .ChimneyCfgN(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .ChimneyCfgW(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .RouteCfg(RouteCfg),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(sam_rule_t),
  .Sam(Sam),
  .axi_narrow_in_req_t(axi_narrow_in_req_t),
  .axi_narrow_in_rsp_t(axi_narrow_in_rsp_t),
  .axi_narrow_out_req_t(axi_narrow_out_req_t),
  .axi_narrow_out_rsp_t(axi_narrow_out_rsp_t),
  .axi_wide_in_req_t(axi_wide_in_req_t),
  .axi_wide_in_rsp_t(axi_wide_in_rsp_t),
  .axi_wide_out_req_t(axi_wide_out_req_t),
  .axi_wide_out_rsp_t(axi_wide_out_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) fhg_spu_ni (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_narrow_in_req_i  ( fhg_spu_narrow_in_req_i ),
  .axi_narrow_in_rsp_o  ( fhg_spu_narrow_in_rsp_o ),
  .axi_narrow_out_req_o ( fhg_spu_narrow_out_req_o ),
  .axi_narrow_out_rsp_i ( fhg_spu_narrow_out_rsp_i ),
  .axi_wide_in_req_i  ( fhg_spu_wide_in_req_i ),
  .axi_wide_in_rsp_o  ( fhg_spu_wide_in_rsp_o ),
  .axi_wide_out_req_o ( fhg_spu_wide_out_req_o ),
  .axi_wide_out_rsp_i ( fhg_spu_wide_out_rsp_i ),
  .id_i             ( FHG_SPU_NI_ID       ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( fhg_spu_ni_to_router_right_1_0_req   ),
  .floo_rsp_i       ( router_right_1_0_to_fhg_spu_ni_rsp   ),
  .floo_wide_o      ( fhg_spu_ni_to_router_right_1_0_wide  ),
  .floo_req_i       ( router_right_1_0_to_fhg_spu_ni_req   ),
  .floo_rsp_o       ( fhg_spu_ni_to_router_right_1_0_rsp   ),
  .floo_wide_i      ( router_right_1_0_to_fhg_spu_ni_wide  )
);

  localparam id_t TOP_SPM_NARROW_NI_ID = '{x: 9, y: 2, port_id: 0};

floo_nw_chimney  #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .ChimneyCfgN(set_ports(ChimneyDefaultCfg, 1'b1, 1'b0)),
  .ChimneyCfgW(set_ports(ChimneyDefaultCfg, 1'b0, 1'b0)),
  .RouteCfg(RouteCfg),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(sam_rule_t),
  .Sam(Sam),
  .axi_narrow_in_req_t(axi_narrow_in_req_t),
  .axi_narrow_in_rsp_t(axi_narrow_in_rsp_t),
  .axi_narrow_out_req_t(axi_narrow_out_req_t),
  .axi_narrow_out_rsp_t(axi_narrow_out_rsp_t),
  .axi_wide_in_req_t(axi_wide_in_req_t),
  .axi_wide_in_rsp_t(axi_wide_in_rsp_t),
  .axi_wide_out_req_t(axi_wide_out_req_t),
  .axi_wide_out_rsp_t(axi_wide_out_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) top_spm_narrow_ni (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_narrow_in_req_i  ( '0 ),
  .axi_narrow_in_rsp_o  (    ),
  .axi_narrow_out_req_o ( top_spm_narrow_narrow_out_req_o ),
  .axi_narrow_out_rsp_i ( top_spm_narrow_narrow_out_rsp_i ),
  .axi_wide_in_req_i  ( '0 ),
  .axi_wide_in_rsp_o  (    ),
  .axi_wide_out_req_o (    ),
  .axi_wide_out_rsp_i ( '0 ),
  .id_i             ( TOP_SPM_NARROW_NI_ID       ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( top_spm_narrow_ni_to_router_right_1_2_req   ),
  .floo_rsp_i       ( router_right_1_2_to_top_spm_narrow_ni_rsp   ),
  .floo_wide_o      ( top_spm_narrow_ni_to_router_right_1_2_wide  ),
  .floo_req_i       ( router_right_1_2_to_top_spm_narrow_ni_req   ),
  .floo_rsp_o       ( top_spm_narrow_ni_to_router_right_1_2_rsp   ),
  .floo_wide_i      ( router_right_1_2_to_top_spm_narrow_ni_wide  )
);

  localparam id_t TOP_SPM_WIDE_NI_ID = '{x: 9, y: 1, port_id: 0};

floo_nw_chimney  #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .ChimneyCfgN(set_ports(ChimneyDefaultCfg, 1'b0, 1'b0)),
  .ChimneyCfgW(set_ports(ChimneyDefaultCfg, 1'b1, 1'b0)),
  .RouteCfg(RouteCfg),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(sam_rule_t),
  .Sam(Sam),
  .axi_narrow_in_req_t(axi_narrow_in_req_t),
  .axi_narrow_in_rsp_t(axi_narrow_in_rsp_t),
  .axi_narrow_out_req_t(axi_narrow_out_req_t),
  .axi_narrow_out_rsp_t(axi_narrow_out_rsp_t),
  .axi_wide_in_req_t(axi_wide_in_req_t),
  .axi_wide_in_rsp_t(axi_wide_in_rsp_t),
  .axi_wide_out_req_t(axi_wide_out_req_t),
  .axi_wide_out_rsp_t(axi_wide_out_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) top_spm_wide_ni (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_narrow_in_req_i  ( '0 ),
  .axi_narrow_in_rsp_o  (    ),
  .axi_narrow_out_req_o (    ),
  .axi_narrow_out_rsp_i ( '0 ),
  .axi_wide_in_req_i  ( '0 ),
  .axi_wide_in_rsp_o  (    ),
  .axi_wide_out_req_o ( top_spm_wide_wide_out_req_o ),
  .axi_wide_out_rsp_i ( top_spm_wide_wide_out_rsp_i ),
  .id_i             ( TOP_SPM_WIDE_NI_ID       ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( top_spm_wide_ni_to_router_right_1_1_req   ),
  .floo_rsp_i       ( router_right_1_1_to_top_spm_wide_ni_rsp   ),
  .floo_wide_o      ( top_spm_wide_ni_to_router_right_1_1_wide  ),
  .floo_req_i       ( router_right_1_1_to_top_spm_wide_ni_req   ),
  .floo_rsp_o       ( top_spm_wide_ni_to_router_right_1_1_rsp   ),
  .floo_wide_i      ( router_right_1_1_to_top_spm_wide_ni_wide  )
);

  localparam id_t L2_SPM_NI_0_ID = '{x: 0, y: 0, port_id: 0};

floo_nw_chimney  #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .ChimneyCfgN(set_ports(ChimneyDefaultCfg, 1'b1, 1'b0)),
  .ChimneyCfgW(set_ports(ChimneyDefaultCfg, 1'b1, 1'b0)),
  .RouteCfg(RouteCfg),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(sam_rule_t),
  .Sam(Sam),
  .axi_narrow_in_req_t(axi_narrow_in_req_t),
  .axi_narrow_in_rsp_t(axi_narrow_in_rsp_t),
  .axi_narrow_out_req_t(axi_narrow_out_req_t),
  .axi_narrow_out_rsp_t(axi_narrow_out_rsp_t),
  .axi_wide_in_req_t(axi_wide_in_req_t),
  .axi_wide_in_rsp_t(axi_wide_in_rsp_t),
  .axi_wide_out_req_t(axi_wide_out_req_t),
  .axi_wide_out_rsp_t(axi_wide_out_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) l2_spm_ni_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_narrow_in_req_i  ( '0 ),
  .axi_narrow_in_rsp_o  (    ),
  .axi_narrow_out_req_o ( l2_spm_narrow_out_req_o[0] ),
  .axi_narrow_out_rsp_i ( l2_spm_narrow_out_rsp_i[0] ),
  .axi_wide_in_req_i  ( '0 ),
  .axi_wide_in_rsp_o  (    ),
  .axi_wide_out_req_o ( l2_spm_wide_out_req_o[0] ),
  .axi_wide_out_rsp_i ( l2_spm_wide_out_rsp_i[0] ),
  .id_i             ( L2_SPM_NI_0_ID       ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( l2_spm_ni_0_to_router_left_0_0_req   ),
  .floo_rsp_i       ( router_left_0_0_to_l2_spm_ni_0_rsp   ),
  .floo_wide_o      ( l2_spm_ni_0_to_router_left_0_0_wide  ),
  .floo_req_i       ( router_left_0_0_to_l2_spm_ni_0_req   ),
  .floo_rsp_o       ( l2_spm_ni_0_to_router_left_0_0_rsp   ),
  .floo_wide_i      ( router_left_0_0_to_l2_spm_ni_0_wide  )
);

  localparam id_t L2_SPM_NI_1_ID = '{x: 0, y: 1, port_id: 0};

floo_nw_chimney  #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .ChimneyCfgN(set_ports(ChimneyDefaultCfg, 1'b1, 1'b0)),
  .ChimneyCfgW(set_ports(ChimneyDefaultCfg, 1'b1, 1'b0)),
  .RouteCfg(RouteCfg),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(sam_rule_t),
  .Sam(Sam),
  .axi_narrow_in_req_t(axi_narrow_in_req_t),
  .axi_narrow_in_rsp_t(axi_narrow_in_rsp_t),
  .axi_narrow_out_req_t(axi_narrow_out_req_t),
  .axi_narrow_out_rsp_t(axi_narrow_out_rsp_t),
  .axi_wide_in_req_t(axi_wide_in_req_t),
  .axi_wide_in_rsp_t(axi_wide_in_rsp_t),
  .axi_wide_out_req_t(axi_wide_out_req_t),
  .axi_wide_out_rsp_t(axi_wide_out_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) l2_spm_ni_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_narrow_in_req_i  ( '0 ),
  .axi_narrow_in_rsp_o  (    ),
  .axi_narrow_out_req_o ( l2_spm_narrow_out_req_o[1] ),
  .axi_narrow_out_rsp_i ( l2_spm_narrow_out_rsp_i[1] ),
  .axi_wide_in_req_i  ( '0 ),
  .axi_wide_in_rsp_o  (    ),
  .axi_wide_out_req_o ( l2_spm_wide_out_req_o[1] ),
  .axi_wide_out_rsp_i ( l2_spm_wide_out_rsp_i[1] ),
  .id_i             ( L2_SPM_NI_1_ID       ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( l2_spm_ni_1_to_router_left_0_1_req   ),
  .floo_rsp_i       ( router_left_0_1_to_l2_spm_ni_1_rsp   ),
  .floo_wide_o      ( l2_spm_ni_1_to_router_left_0_1_wide  ),
  .floo_req_i       ( router_left_0_1_to_l2_spm_ni_1_req   ),
  .floo_rsp_o       ( l2_spm_ni_1_to_router_left_0_1_rsp   ),
  .floo_wide_i      ( router_left_0_1_to_l2_spm_ni_1_wide  )
);

  localparam id_t L2_SPM_NI_2_ID = '{x: 0, y: 2, port_id: 0};

floo_nw_chimney  #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .ChimneyCfgN(set_ports(ChimneyDefaultCfg, 1'b1, 1'b0)),
  .ChimneyCfgW(set_ports(ChimneyDefaultCfg, 1'b1, 1'b0)),
  .RouteCfg(RouteCfg),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(sam_rule_t),
  .Sam(Sam),
  .axi_narrow_in_req_t(axi_narrow_in_req_t),
  .axi_narrow_in_rsp_t(axi_narrow_in_rsp_t),
  .axi_narrow_out_req_t(axi_narrow_out_req_t),
  .axi_narrow_out_rsp_t(axi_narrow_out_rsp_t),
  .axi_wide_in_req_t(axi_wide_in_req_t),
  .axi_wide_in_rsp_t(axi_wide_in_rsp_t),
  .axi_wide_out_req_t(axi_wide_out_req_t),
  .axi_wide_out_rsp_t(axi_wide_out_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) l2_spm_ni_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_narrow_in_req_i  ( '0 ),
  .axi_narrow_in_rsp_o  (    ),
  .axi_narrow_out_req_o ( l2_spm_narrow_out_req_o[2] ),
  .axi_narrow_out_rsp_i ( l2_spm_narrow_out_rsp_i[2] ),
  .axi_wide_in_req_i  ( '0 ),
  .axi_wide_in_rsp_o  (    ),
  .axi_wide_out_req_o ( l2_spm_wide_out_req_o[2] ),
  .axi_wide_out_rsp_i ( l2_spm_wide_out_rsp_i[2] ),
  .id_i             ( L2_SPM_NI_2_ID       ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( l2_spm_ni_2_to_router_left_0_2_req   ),
  .floo_rsp_i       ( router_left_0_2_to_l2_spm_ni_2_rsp   ),
  .floo_wide_o      ( l2_spm_ni_2_to_router_left_0_2_wide  ),
  .floo_req_i       ( router_left_0_2_to_l2_spm_ni_2_req   ),
  .floo_rsp_o       ( l2_spm_ni_2_to_router_left_0_2_rsp   ),
  .floo_wide_i      ( router_left_0_2_to_l2_spm_ni_2_wide  )
);

  localparam id_t L2_SPM_NI_3_ID = '{x: 0, y: 3, port_id: 0};

floo_nw_chimney  #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .ChimneyCfgN(set_ports(ChimneyDefaultCfg, 1'b1, 1'b0)),
  .ChimneyCfgW(set_ports(ChimneyDefaultCfg, 1'b1, 1'b0)),
  .RouteCfg(RouteCfg),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(sam_rule_t),
  .Sam(Sam),
  .axi_narrow_in_req_t(axi_narrow_in_req_t),
  .axi_narrow_in_rsp_t(axi_narrow_in_rsp_t),
  .axi_narrow_out_req_t(axi_narrow_out_req_t),
  .axi_narrow_out_rsp_t(axi_narrow_out_rsp_t),
  .axi_wide_in_req_t(axi_wide_in_req_t),
  .axi_wide_in_rsp_t(axi_wide_in_rsp_t),
  .axi_wide_out_req_t(axi_wide_out_req_t),
  .axi_wide_out_rsp_t(axi_wide_out_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) l2_spm_ni_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_narrow_in_req_i  ( '0 ),
  .axi_narrow_in_rsp_o  (    ),
  .axi_narrow_out_req_o ( l2_spm_narrow_out_req_o[3] ),
  .axi_narrow_out_rsp_i ( l2_spm_narrow_out_rsp_i[3] ),
  .axi_wide_in_req_i  ( '0 ),
  .axi_wide_in_rsp_o  (    ),
  .axi_wide_out_req_o ( l2_spm_wide_out_req_o[3] ),
  .axi_wide_out_rsp_i ( l2_spm_wide_out_rsp_i[3] ),
  .id_i             ( L2_SPM_NI_3_ID       ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( l2_spm_ni_3_to_router_left_0_3_req   ),
  .floo_rsp_i       ( router_left_0_3_to_l2_spm_ni_3_rsp   ),
  .floo_wide_o      ( l2_spm_ni_3_to_router_left_0_3_wide  ),
  .floo_req_i       ( router_left_0_3_to_l2_spm_ni_3_req   ),
  .floo_rsp_o       ( l2_spm_ni_3_to_router_left_0_3_rsp   ),
  .floo_wide_i      ( router_left_0_3_to_l2_spm_ni_3_wide  )
);

  localparam id_t L2_SPM_NI_4_ID = '{x: 8, y: 0, port_id: 0};

floo_nw_chimney  #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .ChimneyCfgN(set_ports(ChimneyDefaultCfg, 1'b1, 1'b0)),
  .ChimneyCfgW(set_ports(ChimneyDefaultCfg, 1'b1, 1'b0)),
  .RouteCfg(RouteCfg),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(sam_rule_t),
  .Sam(Sam),
  .axi_narrow_in_req_t(axi_narrow_in_req_t),
  .axi_narrow_in_rsp_t(axi_narrow_in_rsp_t),
  .axi_narrow_out_req_t(axi_narrow_out_req_t),
  .axi_narrow_out_rsp_t(axi_narrow_out_rsp_t),
  .axi_wide_in_req_t(axi_wide_in_req_t),
  .axi_wide_in_rsp_t(axi_wide_in_rsp_t),
  .axi_wide_out_req_t(axi_wide_out_req_t),
  .axi_wide_out_rsp_t(axi_wide_out_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) l2_spm_ni_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_narrow_in_req_i  ( '0 ),
  .axi_narrow_in_rsp_o  (    ),
  .axi_narrow_out_req_o ( l2_spm_narrow_out_req_o[4] ),
  .axi_narrow_out_rsp_i ( l2_spm_narrow_out_rsp_i[4] ),
  .axi_wide_in_req_i  ( '0 ),
  .axi_wide_in_rsp_o  (    ),
  .axi_wide_out_req_o ( l2_spm_wide_out_req_o[4] ),
  .axi_wide_out_rsp_i ( l2_spm_wide_out_rsp_i[4] ),
  .id_i             ( L2_SPM_NI_4_ID       ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( l2_spm_ni_4_to_router_right_0_0_req   ),
  .floo_rsp_i       ( router_right_0_0_to_l2_spm_ni_4_rsp   ),
  .floo_wide_o      ( l2_spm_ni_4_to_router_right_0_0_wide  ),
  .floo_req_i       ( router_right_0_0_to_l2_spm_ni_4_req   ),
  .floo_rsp_o       ( l2_spm_ni_4_to_router_right_0_0_rsp   ),
  .floo_wide_i      ( router_right_0_0_to_l2_spm_ni_4_wide  )
);

  localparam id_t L2_SPM_NI_5_ID = '{x: 8, y: 1, port_id: 0};

floo_nw_chimney  #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .ChimneyCfgN(set_ports(ChimneyDefaultCfg, 1'b1, 1'b0)),
  .ChimneyCfgW(set_ports(ChimneyDefaultCfg, 1'b1, 1'b0)),
  .RouteCfg(RouteCfg),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(sam_rule_t),
  .Sam(Sam),
  .axi_narrow_in_req_t(axi_narrow_in_req_t),
  .axi_narrow_in_rsp_t(axi_narrow_in_rsp_t),
  .axi_narrow_out_req_t(axi_narrow_out_req_t),
  .axi_narrow_out_rsp_t(axi_narrow_out_rsp_t),
  .axi_wide_in_req_t(axi_wide_in_req_t),
  .axi_wide_in_rsp_t(axi_wide_in_rsp_t),
  .axi_wide_out_req_t(axi_wide_out_req_t),
  .axi_wide_out_rsp_t(axi_wide_out_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) l2_spm_ni_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_narrow_in_req_i  ( '0 ),
  .axi_narrow_in_rsp_o  (    ),
  .axi_narrow_out_req_o ( l2_spm_narrow_out_req_o[5] ),
  .axi_narrow_out_rsp_i ( l2_spm_narrow_out_rsp_i[5] ),
  .axi_wide_in_req_i  ( '0 ),
  .axi_wide_in_rsp_o  (    ),
  .axi_wide_out_req_o ( l2_spm_wide_out_req_o[5] ),
  .axi_wide_out_rsp_i ( l2_spm_wide_out_rsp_i[5] ),
  .id_i             ( L2_SPM_NI_5_ID       ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( l2_spm_ni_5_to_router_right_0_1_req   ),
  .floo_rsp_i       ( router_right_0_1_to_l2_spm_ni_5_rsp   ),
  .floo_wide_o      ( l2_spm_ni_5_to_router_right_0_1_wide  ),
  .floo_req_i       ( router_right_0_1_to_l2_spm_ni_5_req   ),
  .floo_rsp_o       ( l2_spm_ni_5_to_router_right_0_1_rsp   ),
  .floo_wide_i      ( router_right_0_1_to_l2_spm_ni_5_wide  )
);

  localparam id_t L2_SPM_NI_6_ID = '{x: 8, y: 2, port_id: 0};

floo_nw_chimney  #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .ChimneyCfgN(set_ports(ChimneyDefaultCfg, 1'b1, 1'b0)),
  .ChimneyCfgW(set_ports(ChimneyDefaultCfg, 1'b1, 1'b0)),
  .RouteCfg(RouteCfg),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(sam_rule_t),
  .Sam(Sam),
  .axi_narrow_in_req_t(axi_narrow_in_req_t),
  .axi_narrow_in_rsp_t(axi_narrow_in_rsp_t),
  .axi_narrow_out_req_t(axi_narrow_out_req_t),
  .axi_narrow_out_rsp_t(axi_narrow_out_rsp_t),
  .axi_wide_in_req_t(axi_wide_in_req_t),
  .axi_wide_in_rsp_t(axi_wide_in_rsp_t),
  .axi_wide_out_req_t(axi_wide_out_req_t),
  .axi_wide_out_rsp_t(axi_wide_out_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) l2_spm_ni_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_narrow_in_req_i  ( '0 ),
  .axi_narrow_in_rsp_o  (    ),
  .axi_narrow_out_req_o ( l2_spm_narrow_out_req_o[6] ),
  .axi_narrow_out_rsp_i ( l2_spm_narrow_out_rsp_i[6] ),
  .axi_wide_in_req_i  ( '0 ),
  .axi_wide_in_rsp_o  (    ),
  .axi_wide_out_req_o ( l2_spm_wide_out_req_o[6] ),
  .axi_wide_out_rsp_i ( l2_spm_wide_out_rsp_i[6] ),
  .id_i             ( L2_SPM_NI_6_ID       ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( l2_spm_ni_6_to_router_right_0_2_req   ),
  .floo_rsp_i       ( router_right_0_2_to_l2_spm_ni_6_rsp   ),
  .floo_wide_o      ( l2_spm_ni_6_to_router_right_0_2_wide  ),
  .floo_req_i       ( router_right_0_2_to_l2_spm_ni_6_req   ),
  .floo_rsp_o       ( l2_spm_ni_6_to_router_right_0_2_rsp   ),
  .floo_wide_i      ( router_right_0_2_to_l2_spm_ni_6_wide  )
);

  localparam id_t L2_SPM_NI_7_ID = '{x: 8, y: 3, port_id: 0};

floo_nw_chimney  #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .ChimneyCfgN(set_ports(ChimneyDefaultCfg, 1'b1, 1'b0)),
  .ChimneyCfgW(set_ports(ChimneyDefaultCfg, 1'b1, 1'b0)),
  .RouteCfg(RouteCfg),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(sam_rule_t),
  .Sam(Sam),
  .axi_narrow_in_req_t(axi_narrow_in_req_t),
  .axi_narrow_in_rsp_t(axi_narrow_in_rsp_t),
  .axi_narrow_out_req_t(axi_narrow_out_req_t),
  .axi_narrow_out_rsp_t(axi_narrow_out_rsp_t),
  .axi_wide_in_req_t(axi_wide_in_req_t),
  .axi_wide_in_rsp_t(axi_wide_in_rsp_t),
  .axi_wide_out_req_t(axi_wide_out_req_t),
  .axi_wide_out_rsp_t(axi_wide_out_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) l2_spm_ni_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_narrow_in_req_i  ( '0 ),
  .axi_narrow_in_rsp_o  (    ),
  .axi_narrow_out_req_o ( l2_spm_narrow_out_req_o[7] ),
  .axi_narrow_out_rsp_i ( l2_spm_narrow_out_rsp_i[7] ),
  .axi_wide_in_req_i  ( '0 ),
  .axi_wide_in_rsp_o  (    ),
  .axi_wide_out_req_o ( l2_spm_wide_out_req_o[7] ),
  .axi_wide_out_rsp_i ( l2_spm_wide_out_rsp_i[7] ),
  .id_i             ( L2_SPM_NI_7_ID       ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( l2_spm_ni_7_to_router_right_0_3_req   ),
  .floo_rsp_i       ( router_right_0_3_to_l2_spm_ni_7_rsp   ),
  .floo_wide_o      ( l2_spm_ni_7_to_router_right_0_3_wide  ),
  .floo_req_i       ( router_right_0_3_to_l2_spm_ni_7_req   ),
  .floo_rsp_o       ( l2_spm_ni_7_to_router_right_0_3_rsp   ),
  .floo_wide_i      ( router_right_0_3_to_l2_spm_ni_7_wide  )
);


floo_req_t [4:0] router_left_0_0_req_in;
floo_rsp_t [4:0] router_left_0_0_rsp_out;
floo_req_t [4:0] router_left_0_0_req_out;
floo_rsp_t [4:0] router_left_0_0_rsp_in;
floo_wide_t [4:0] router_left_0_0_wide_in;
floo_wide_t [4:0] router_left_0_0_wide_out;

    assign router_left_0_0_req_in[0] = router_left_0_1_to_router_left_0_0_req;
    assign router_left_0_0_req_in[1] = '0;
    assign router_left_0_0_req_in[2] = '0;
    assign router_left_0_0_req_in[3] = '0;
    assign router_left_0_0_req_in[4] = l2_spm_ni_0_to_router_left_0_0_req;

    assign router_left_0_0_to_router_left_0_1_rsp = router_left_0_0_rsp_out[0];
    assign router_left_0_0_to_l2_spm_ni_0_rsp = router_left_0_0_rsp_out[4];

    assign router_left_0_0_to_router_left_0_1_req = router_left_0_0_req_out[0];
    assign router_left_0_0_to_l2_spm_ni_0_req = router_left_0_0_req_out[4];

    assign router_left_0_0_rsp_in[0] = router_left_0_1_to_router_left_0_0_rsp;
    assign router_left_0_0_rsp_in[1] = '0;
    assign router_left_0_0_rsp_in[2] = '0;
    assign router_left_0_0_rsp_in[3] = '0;
    assign router_left_0_0_rsp_in[4] = l2_spm_ni_0_to_router_left_0_0_rsp;

    assign router_left_0_0_wide_in[0] = router_left_0_1_to_router_left_0_0_wide;
    assign router_left_0_0_wide_in[1] = '0;
    assign router_left_0_0_wide_in[2] = '0;
    assign router_left_0_0_wide_in[3] = '0;
    assign router_left_0_0_wide_in[4] = l2_spm_ni_0_to_router_left_0_0_wide;

    assign router_left_0_0_to_router_left_0_1_wide = router_left_0_0_wide_out[0];
    assign router_left_0_0_to_l2_spm_ni_0_wide = router_left_0_0_wide_out[4];

  localparam id_t ROUTER_LEFT_0_0_ID = '{x: 0, y: 0, port_id: 0};

floo_nw_router #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .CollectiveCfg(RouteCfg.CollectiveCfg),
  .red_wide_req_t(red_wide_req_t),
  .red_wide_rsp_t(red_wide_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) router_left_0_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i (ROUTER_LEFT_0_0_ID),
  .id_route_map_i ('0),
  .floo_req_i (router_left_0_0_req_in),
  .floo_rsp_o (router_left_0_0_rsp_out),
  .floo_req_o (router_left_0_0_req_out),
  .floo_rsp_i (router_left_0_0_rsp_in),
  .floo_wide_i (router_left_0_0_wide_in),
  .floo_wide_o (router_left_0_0_wide_out)
);


floo_req_t [4:0] router_left_0_1_req_in;
floo_rsp_t [4:0] router_left_0_1_rsp_out;
floo_req_t [4:0] router_left_0_1_req_out;
floo_rsp_t [4:0] router_left_0_1_rsp_in;
floo_wide_t [4:0] router_left_0_1_wide_in;
floo_wide_t [4:0] router_left_0_1_wide_out;

    assign router_left_0_1_req_in[0] = router_left_0_2_to_router_left_0_1_req;
    assign router_left_0_1_req_in[1] = '0;
    assign router_left_0_1_req_in[2] = router_left_0_0_to_router_left_0_1_req;
    assign router_left_0_1_req_in[3] = '0;
    assign router_left_0_1_req_in[4] = l2_spm_ni_1_to_router_left_0_1_req;

    assign router_left_0_1_to_router_left_0_2_rsp = router_left_0_1_rsp_out[0];
    assign router_left_0_1_to_router_left_0_0_rsp = router_left_0_1_rsp_out[2];
    assign router_left_0_1_to_l2_spm_ni_1_rsp = router_left_0_1_rsp_out[4];

    assign router_left_0_1_to_router_left_0_2_req = router_left_0_1_req_out[0];
    assign router_left_0_1_to_router_left_0_0_req = router_left_0_1_req_out[2];
    assign router_left_0_1_to_l2_spm_ni_1_req = router_left_0_1_req_out[4];

    assign router_left_0_1_rsp_in[0] = router_left_0_2_to_router_left_0_1_rsp;
    assign router_left_0_1_rsp_in[1] = '0;
    assign router_left_0_1_rsp_in[2] = router_left_0_0_to_router_left_0_1_rsp;
    assign router_left_0_1_rsp_in[3] = '0;
    assign router_left_0_1_rsp_in[4] = l2_spm_ni_1_to_router_left_0_1_rsp;

    assign router_left_0_1_wide_in[0] = router_left_0_2_to_router_left_0_1_wide;
    assign router_left_0_1_wide_in[1] = '0;
    assign router_left_0_1_wide_in[2] = router_left_0_0_to_router_left_0_1_wide;
    assign router_left_0_1_wide_in[3] = '0;
    assign router_left_0_1_wide_in[4] = l2_spm_ni_1_to_router_left_0_1_wide;

    assign router_left_0_1_to_router_left_0_2_wide = router_left_0_1_wide_out[0];
    assign router_left_0_1_to_router_left_0_0_wide = router_left_0_1_wide_out[2];
    assign router_left_0_1_to_l2_spm_ni_1_wide = router_left_0_1_wide_out[4];

  localparam id_t ROUTER_LEFT_0_1_ID = '{x: 0, y: 1, port_id: 0};

floo_nw_router #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .CollectiveCfg(RouteCfg.CollectiveCfg),
  .red_wide_req_t(red_wide_req_t),
  .red_wide_rsp_t(red_wide_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) router_left_0_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i (ROUTER_LEFT_0_1_ID),
  .id_route_map_i ('0),
  .floo_req_i (router_left_0_1_req_in),
  .floo_rsp_o (router_left_0_1_rsp_out),
  .floo_req_o (router_left_0_1_req_out),
  .floo_rsp_i (router_left_0_1_rsp_in),
  .floo_wide_i (router_left_0_1_wide_in),
  .floo_wide_o (router_left_0_1_wide_out)
);


floo_req_t [4:0] router_left_0_2_req_in;
floo_rsp_t [4:0] router_left_0_2_rsp_out;
floo_req_t [4:0] router_left_0_2_req_out;
floo_rsp_t [4:0] router_left_0_2_rsp_in;
floo_wide_t [4:0] router_left_0_2_wide_in;
floo_wide_t [4:0] router_left_0_2_wide_out;

    assign router_left_0_2_req_in[0] = router_left_0_3_to_router_left_0_2_req;
    assign router_left_0_2_req_in[1] = '0;
    assign router_left_0_2_req_in[2] = router_left_0_1_to_router_left_0_2_req;
    assign router_left_0_2_req_in[3] = '0;
    assign router_left_0_2_req_in[4] = l2_spm_ni_2_to_router_left_0_2_req;

    assign router_left_0_2_to_router_left_0_3_rsp = router_left_0_2_rsp_out[0];
    assign router_left_0_2_to_router_left_0_1_rsp = router_left_0_2_rsp_out[2];
    assign router_left_0_2_to_l2_spm_ni_2_rsp = router_left_0_2_rsp_out[4];

    assign router_left_0_2_to_router_left_0_3_req = router_left_0_2_req_out[0];
    assign router_left_0_2_to_router_left_0_1_req = router_left_0_2_req_out[2];
    assign router_left_0_2_to_l2_spm_ni_2_req = router_left_0_2_req_out[4];

    assign router_left_0_2_rsp_in[0] = router_left_0_3_to_router_left_0_2_rsp;
    assign router_left_0_2_rsp_in[1] = '0;
    assign router_left_0_2_rsp_in[2] = router_left_0_1_to_router_left_0_2_rsp;
    assign router_left_0_2_rsp_in[3] = '0;
    assign router_left_0_2_rsp_in[4] = l2_spm_ni_2_to_router_left_0_2_rsp;

    assign router_left_0_2_wide_in[0] = router_left_0_3_to_router_left_0_2_wide;
    assign router_left_0_2_wide_in[1] = '0;
    assign router_left_0_2_wide_in[2] = router_left_0_1_to_router_left_0_2_wide;
    assign router_left_0_2_wide_in[3] = '0;
    assign router_left_0_2_wide_in[4] = l2_spm_ni_2_to_router_left_0_2_wide;

    assign router_left_0_2_to_router_left_0_3_wide = router_left_0_2_wide_out[0];
    assign router_left_0_2_to_router_left_0_1_wide = router_left_0_2_wide_out[2];
    assign router_left_0_2_to_l2_spm_ni_2_wide = router_left_0_2_wide_out[4];

  localparam id_t ROUTER_LEFT_0_2_ID = '{x: 0, y: 2, port_id: 0};

floo_nw_router #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .CollectiveCfg(RouteCfg.CollectiveCfg),
  .red_wide_req_t(red_wide_req_t),
  .red_wide_rsp_t(red_wide_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) router_left_0_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i (ROUTER_LEFT_0_2_ID),
  .id_route_map_i ('0),
  .floo_req_i (router_left_0_2_req_in),
  .floo_rsp_o (router_left_0_2_rsp_out),
  .floo_req_o (router_left_0_2_req_out),
  .floo_rsp_i (router_left_0_2_rsp_in),
  .floo_wide_i (router_left_0_2_wide_in),
  .floo_wide_o (router_left_0_2_wide_out)
);


floo_req_t [4:0] router_left_0_3_req_in;
floo_rsp_t [4:0] router_left_0_3_rsp_out;
floo_req_t [4:0] router_left_0_3_req_out;
floo_rsp_t [4:0] router_left_0_3_rsp_in;
floo_wide_t [4:0] router_left_0_3_wide_in;
floo_wide_t [4:0] router_left_0_3_wide_out;

    assign router_left_0_3_req_in[0] = '0;
    assign router_left_0_3_req_in[1] = '0;
    assign router_left_0_3_req_in[2] = router_left_0_2_to_router_left_0_3_req;
    assign router_left_0_3_req_in[3] = '0;
    assign router_left_0_3_req_in[4] = l2_spm_ni_3_to_router_left_0_3_req;

    assign router_left_0_3_to_router_left_0_2_rsp = router_left_0_3_rsp_out[2];
    assign router_left_0_3_to_l2_spm_ni_3_rsp = router_left_0_3_rsp_out[4];

    assign router_left_0_3_to_router_left_0_2_req = router_left_0_3_req_out[2];
    assign router_left_0_3_to_l2_spm_ni_3_req = router_left_0_3_req_out[4];

    assign router_left_0_3_rsp_in[0] = '0;
    assign router_left_0_3_rsp_in[1] = '0;
    assign router_left_0_3_rsp_in[2] = router_left_0_2_to_router_left_0_3_rsp;
    assign router_left_0_3_rsp_in[3] = '0;
    assign router_left_0_3_rsp_in[4] = l2_spm_ni_3_to_router_left_0_3_rsp;

    assign router_left_0_3_wide_in[0] = '0;
    assign router_left_0_3_wide_in[1] = '0;
    assign router_left_0_3_wide_in[2] = router_left_0_2_to_router_left_0_3_wide;
    assign router_left_0_3_wide_in[3] = '0;
    assign router_left_0_3_wide_in[4] = l2_spm_ni_3_to_router_left_0_3_wide;

    assign router_left_0_3_to_router_left_0_2_wide = router_left_0_3_wide_out[2];
    assign router_left_0_3_to_l2_spm_ni_3_wide = router_left_0_3_wide_out[4];

  localparam id_t ROUTER_LEFT_0_3_ID = '{x: 0, y: 3, port_id: 0};

floo_nw_router #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .CollectiveCfg(RouteCfg.CollectiveCfg),
  .red_wide_req_t(red_wide_req_t),
  .red_wide_rsp_t(red_wide_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) router_left_0_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i (ROUTER_LEFT_0_3_ID),
  .id_route_map_i ('0),
  .floo_req_i (router_left_0_3_req_in),
  .floo_rsp_o (router_left_0_3_rsp_out),
  .floo_req_o (router_left_0_3_req_out),
  .floo_rsp_i (router_left_0_3_rsp_in),
  .floo_wide_i (router_left_0_3_wide_in),
  .floo_wide_o (router_left_0_3_wide_out)
);


floo_req_t [4:0] router_center_0_0_req_in;
floo_rsp_t [4:0] router_center_0_0_rsp_out;
floo_req_t [4:0] router_center_0_0_req_out;
floo_rsp_t [4:0] router_center_0_0_rsp_in;
floo_wide_t [4:0] router_center_0_0_wide_in;
floo_wide_t [4:0] router_center_0_0_wide_out;

    assign router_center_0_0_req_in[0] = router_center_0_1_to_router_center_0_0_req;
    assign router_center_0_0_req_in[1] = router_center_1_0_to_router_center_0_0_req;
    assign router_center_0_0_req_in[2] = '0;
    assign router_center_0_0_req_in[3] = '0;
    assign router_center_0_0_req_in[4] = cluster_ni_0_0_to_router_center_0_0_req;

    assign router_center_0_0_to_router_center_0_1_rsp = router_center_0_0_rsp_out[0];
    assign router_center_0_0_to_router_center_1_0_rsp = router_center_0_0_rsp_out[1];
    assign router_center_0_0_to_cluster_ni_0_0_rsp = router_center_0_0_rsp_out[4];

    assign router_center_0_0_to_router_center_0_1_req = router_center_0_0_req_out[0];
    assign router_center_0_0_to_router_center_1_0_req = router_center_0_0_req_out[1];
    assign router_center_0_0_to_cluster_ni_0_0_req = router_center_0_0_req_out[4];

    assign router_center_0_0_rsp_in[0] = router_center_0_1_to_router_center_0_0_rsp;
    assign router_center_0_0_rsp_in[1] = router_center_1_0_to_router_center_0_0_rsp;
    assign router_center_0_0_rsp_in[2] = '0;
    assign router_center_0_0_rsp_in[3] = '0;
    assign router_center_0_0_rsp_in[4] = cluster_ni_0_0_to_router_center_0_0_rsp;

    assign router_center_0_0_wide_in[0] = router_center_0_1_to_router_center_0_0_wide;
    assign router_center_0_0_wide_in[1] = router_center_1_0_to_router_center_0_0_wide;
    assign router_center_0_0_wide_in[2] = '0;
    assign router_center_0_0_wide_in[3] = '0;
    assign router_center_0_0_wide_in[4] = cluster_ni_0_0_to_router_center_0_0_wide;

    assign router_center_0_0_to_router_center_0_1_wide = router_center_0_0_wide_out[0];
    assign router_center_0_0_to_router_center_1_0_wide = router_center_0_0_wide_out[1];
    assign router_center_0_0_to_cluster_ni_0_0_wide = router_center_0_0_wide_out[4];

  localparam id_t ROUTER_CENTER_0_0_ID = '{x: 4, y: 0, port_id: 0};

floo_nw_router #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .CollectiveCfg(RouteCfg.CollectiveCfg),
  .red_wide_req_t(red_wide_req_t),
  .red_wide_rsp_t(red_wide_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) router_center_0_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i (ROUTER_CENTER_0_0_ID),
  .id_route_map_i ('0),
  .floo_req_i (router_center_0_0_req_in),
  .floo_rsp_o (router_center_0_0_rsp_out),
  .floo_req_o (router_center_0_0_req_out),
  .floo_rsp_i (router_center_0_0_rsp_in),
  .floo_wide_i (router_center_0_0_wide_in),
  .floo_wide_o (router_center_0_0_wide_out)
);


floo_req_t [4:0] router_center_0_1_req_in;
floo_rsp_t [4:0] router_center_0_1_rsp_out;
floo_req_t [4:0] router_center_0_1_req_out;
floo_rsp_t [4:0] router_center_0_1_rsp_in;
floo_wide_t [4:0] router_center_0_1_wide_in;
floo_wide_t [4:0] router_center_0_1_wide_out;

    assign router_center_0_1_req_in[0] = router_center_0_2_to_router_center_0_1_req;
    assign router_center_0_1_req_in[1] = router_center_1_1_to_router_center_0_1_req;
    assign router_center_0_1_req_in[2] = router_center_0_0_to_router_center_0_1_req;
    assign router_center_0_1_req_in[3] = '0;
    assign router_center_0_1_req_in[4] = cluster_ni_0_1_to_router_center_0_1_req;

    assign router_center_0_1_to_router_center_0_2_rsp = router_center_0_1_rsp_out[0];
    assign router_center_0_1_to_router_center_1_1_rsp = router_center_0_1_rsp_out[1];
    assign router_center_0_1_to_router_center_0_0_rsp = router_center_0_1_rsp_out[2];
    assign router_center_0_1_to_cluster_ni_0_1_rsp = router_center_0_1_rsp_out[4];

    assign router_center_0_1_to_router_center_0_2_req = router_center_0_1_req_out[0];
    assign router_center_0_1_to_router_center_1_1_req = router_center_0_1_req_out[1];
    assign router_center_0_1_to_router_center_0_0_req = router_center_0_1_req_out[2];
    assign router_center_0_1_to_cluster_ni_0_1_req = router_center_0_1_req_out[4];

    assign router_center_0_1_rsp_in[0] = router_center_0_2_to_router_center_0_1_rsp;
    assign router_center_0_1_rsp_in[1] = router_center_1_1_to_router_center_0_1_rsp;
    assign router_center_0_1_rsp_in[2] = router_center_0_0_to_router_center_0_1_rsp;
    assign router_center_0_1_rsp_in[3] = '0;
    assign router_center_0_1_rsp_in[4] = cluster_ni_0_1_to_router_center_0_1_rsp;

    assign router_center_0_1_wide_in[0] = router_center_0_2_to_router_center_0_1_wide;
    assign router_center_0_1_wide_in[1] = router_center_1_1_to_router_center_0_1_wide;
    assign router_center_0_1_wide_in[2] = router_center_0_0_to_router_center_0_1_wide;
    assign router_center_0_1_wide_in[3] = '0;
    assign router_center_0_1_wide_in[4] = cluster_ni_0_1_to_router_center_0_1_wide;

    assign router_center_0_1_to_router_center_0_2_wide = router_center_0_1_wide_out[0];
    assign router_center_0_1_to_router_center_1_1_wide = router_center_0_1_wide_out[1];
    assign router_center_0_1_to_router_center_0_0_wide = router_center_0_1_wide_out[2];
    assign router_center_0_1_to_cluster_ni_0_1_wide = router_center_0_1_wide_out[4];

  localparam id_t ROUTER_CENTER_0_1_ID = '{x: 4, y: 1, port_id: 0};

floo_nw_router #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .CollectiveCfg(RouteCfg.CollectiveCfg),
  .red_wide_req_t(red_wide_req_t),
  .red_wide_rsp_t(red_wide_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) router_center_0_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i (ROUTER_CENTER_0_1_ID),
  .id_route_map_i ('0),
  .floo_req_i (router_center_0_1_req_in),
  .floo_rsp_o (router_center_0_1_rsp_out),
  .floo_req_o (router_center_0_1_req_out),
  .floo_rsp_i (router_center_0_1_rsp_in),
  .floo_wide_i (router_center_0_1_wide_in),
  .floo_wide_o (router_center_0_1_wide_out)
);


floo_req_t [4:0] router_center_0_2_req_in;
floo_rsp_t [4:0] router_center_0_2_rsp_out;
floo_req_t [4:0] router_center_0_2_req_out;
floo_rsp_t [4:0] router_center_0_2_rsp_in;
floo_wide_t [4:0] router_center_0_2_wide_in;
floo_wide_t [4:0] router_center_0_2_wide_out;

    assign router_center_0_2_req_in[0] = router_center_0_3_to_router_center_0_2_req;
    assign router_center_0_2_req_in[1] = router_center_1_2_to_router_center_0_2_req;
    assign router_center_0_2_req_in[2] = router_center_0_1_to_router_center_0_2_req;
    assign router_center_0_2_req_in[3] = '0;
    assign router_center_0_2_req_in[4] = cluster_ni_0_2_to_router_center_0_2_req;

    assign router_center_0_2_to_router_center_0_3_rsp = router_center_0_2_rsp_out[0];
    assign router_center_0_2_to_router_center_1_2_rsp = router_center_0_2_rsp_out[1];
    assign router_center_0_2_to_router_center_0_1_rsp = router_center_0_2_rsp_out[2];
    assign router_center_0_2_to_cluster_ni_0_2_rsp = router_center_0_2_rsp_out[4];

    assign router_center_0_2_to_router_center_0_3_req = router_center_0_2_req_out[0];
    assign router_center_0_2_to_router_center_1_2_req = router_center_0_2_req_out[1];
    assign router_center_0_2_to_router_center_0_1_req = router_center_0_2_req_out[2];
    assign router_center_0_2_to_cluster_ni_0_2_req = router_center_0_2_req_out[4];

    assign router_center_0_2_rsp_in[0] = router_center_0_3_to_router_center_0_2_rsp;
    assign router_center_0_2_rsp_in[1] = router_center_1_2_to_router_center_0_2_rsp;
    assign router_center_0_2_rsp_in[2] = router_center_0_1_to_router_center_0_2_rsp;
    assign router_center_0_2_rsp_in[3] = '0;
    assign router_center_0_2_rsp_in[4] = cluster_ni_0_2_to_router_center_0_2_rsp;

    assign router_center_0_2_wide_in[0] = router_center_0_3_to_router_center_0_2_wide;
    assign router_center_0_2_wide_in[1] = router_center_1_2_to_router_center_0_2_wide;
    assign router_center_0_2_wide_in[2] = router_center_0_1_to_router_center_0_2_wide;
    assign router_center_0_2_wide_in[3] = '0;
    assign router_center_0_2_wide_in[4] = cluster_ni_0_2_to_router_center_0_2_wide;

    assign router_center_0_2_to_router_center_0_3_wide = router_center_0_2_wide_out[0];
    assign router_center_0_2_to_router_center_1_2_wide = router_center_0_2_wide_out[1];
    assign router_center_0_2_to_router_center_0_1_wide = router_center_0_2_wide_out[2];
    assign router_center_0_2_to_cluster_ni_0_2_wide = router_center_0_2_wide_out[4];

  localparam id_t ROUTER_CENTER_0_2_ID = '{x: 4, y: 2, port_id: 0};

floo_nw_router #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .CollectiveCfg(RouteCfg.CollectiveCfg),
  .red_wide_req_t(red_wide_req_t),
  .red_wide_rsp_t(red_wide_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) router_center_0_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i (ROUTER_CENTER_0_2_ID),
  .id_route_map_i ('0),
  .floo_req_i (router_center_0_2_req_in),
  .floo_rsp_o (router_center_0_2_rsp_out),
  .floo_req_o (router_center_0_2_req_out),
  .floo_rsp_i (router_center_0_2_rsp_in),
  .floo_wide_i (router_center_0_2_wide_in),
  .floo_wide_o (router_center_0_2_wide_out)
);


floo_req_t [4:0] router_center_0_3_req_in;
floo_rsp_t [4:0] router_center_0_3_rsp_out;
floo_req_t [4:0] router_center_0_3_req_out;
floo_rsp_t [4:0] router_center_0_3_rsp_in;
floo_wide_t [4:0] router_center_0_3_wide_in;
floo_wide_t [4:0] router_center_0_3_wide_out;

    assign router_center_0_3_req_in[0] = '0;
    assign router_center_0_3_req_in[1] = router_center_1_3_to_router_center_0_3_req;
    assign router_center_0_3_req_in[2] = router_center_0_2_to_router_center_0_3_req;
    assign router_center_0_3_req_in[3] = '0;
    assign router_center_0_3_req_in[4] = cluster_ni_0_3_to_router_center_0_3_req;

    assign router_center_0_3_to_router_center_1_3_rsp = router_center_0_3_rsp_out[1];
    assign router_center_0_3_to_router_center_0_2_rsp = router_center_0_3_rsp_out[2];
    assign router_center_0_3_to_cluster_ni_0_3_rsp = router_center_0_3_rsp_out[4];

    assign router_center_0_3_to_router_center_1_3_req = router_center_0_3_req_out[1];
    assign router_center_0_3_to_router_center_0_2_req = router_center_0_3_req_out[2];
    assign router_center_0_3_to_cluster_ni_0_3_req = router_center_0_3_req_out[4];

    assign router_center_0_3_rsp_in[0] = '0;
    assign router_center_0_3_rsp_in[1] = router_center_1_3_to_router_center_0_3_rsp;
    assign router_center_0_3_rsp_in[2] = router_center_0_2_to_router_center_0_3_rsp;
    assign router_center_0_3_rsp_in[3] = '0;
    assign router_center_0_3_rsp_in[4] = cluster_ni_0_3_to_router_center_0_3_rsp;

    assign router_center_0_3_wide_in[0] = '0;
    assign router_center_0_3_wide_in[1] = router_center_1_3_to_router_center_0_3_wide;
    assign router_center_0_3_wide_in[2] = router_center_0_2_to_router_center_0_3_wide;
    assign router_center_0_3_wide_in[3] = '0;
    assign router_center_0_3_wide_in[4] = cluster_ni_0_3_to_router_center_0_3_wide;

    assign router_center_0_3_to_router_center_1_3_wide = router_center_0_3_wide_out[1];
    assign router_center_0_3_to_router_center_0_2_wide = router_center_0_3_wide_out[2];
    assign router_center_0_3_to_cluster_ni_0_3_wide = router_center_0_3_wide_out[4];

  localparam id_t ROUTER_CENTER_0_3_ID = '{x: 4, y: 3, port_id: 0};

floo_nw_router #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .CollectiveCfg(RouteCfg.CollectiveCfg),
  .red_wide_req_t(red_wide_req_t),
  .red_wide_rsp_t(red_wide_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) router_center_0_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i (ROUTER_CENTER_0_3_ID),
  .id_route_map_i ('0),
  .floo_req_i (router_center_0_3_req_in),
  .floo_rsp_o (router_center_0_3_rsp_out),
  .floo_req_o (router_center_0_3_req_out),
  .floo_rsp_i (router_center_0_3_rsp_in),
  .floo_wide_i (router_center_0_3_wide_in),
  .floo_wide_o (router_center_0_3_wide_out)
);


floo_req_t [4:0] router_center_1_0_req_in;
floo_rsp_t [4:0] router_center_1_0_rsp_out;
floo_req_t [4:0] router_center_1_0_req_out;
floo_rsp_t [4:0] router_center_1_0_rsp_in;
floo_wide_t [4:0] router_center_1_0_wide_in;
floo_wide_t [4:0] router_center_1_0_wide_out;

    assign router_center_1_0_req_in[0] = router_center_1_1_to_router_center_1_0_req;
    assign router_center_1_0_req_in[1] = router_center_2_0_to_router_center_1_0_req;
    assign router_center_1_0_req_in[2] = '0;
    assign router_center_1_0_req_in[3] = router_center_0_0_to_router_center_1_0_req;
    assign router_center_1_0_req_in[4] = cluster_ni_1_0_to_router_center_1_0_req;

    assign router_center_1_0_to_router_center_1_1_rsp = router_center_1_0_rsp_out[0];
    assign router_center_1_0_to_router_center_2_0_rsp = router_center_1_0_rsp_out[1];
    assign router_center_1_0_to_router_center_0_0_rsp = router_center_1_0_rsp_out[3];
    assign router_center_1_0_to_cluster_ni_1_0_rsp = router_center_1_0_rsp_out[4];

    assign router_center_1_0_to_router_center_1_1_req = router_center_1_0_req_out[0];
    assign router_center_1_0_to_router_center_2_0_req = router_center_1_0_req_out[1];
    assign router_center_1_0_to_router_center_0_0_req = router_center_1_0_req_out[3];
    assign router_center_1_0_to_cluster_ni_1_0_req = router_center_1_0_req_out[4];

    assign router_center_1_0_rsp_in[0] = router_center_1_1_to_router_center_1_0_rsp;
    assign router_center_1_0_rsp_in[1] = router_center_2_0_to_router_center_1_0_rsp;
    assign router_center_1_0_rsp_in[2] = '0;
    assign router_center_1_0_rsp_in[3] = router_center_0_0_to_router_center_1_0_rsp;
    assign router_center_1_0_rsp_in[4] = cluster_ni_1_0_to_router_center_1_0_rsp;

    assign router_center_1_0_wide_in[0] = router_center_1_1_to_router_center_1_0_wide;
    assign router_center_1_0_wide_in[1] = router_center_2_0_to_router_center_1_0_wide;
    assign router_center_1_0_wide_in[2] = '0;
    assign router_center_1_0_wide_in[3] = router_center_0_0_to_router_center_1_0_wide;
    assign router_center_1_0_wide_in[4] = cluster_ni_1_0_to_router_center_1_0_wide;

    assign router_center_1_0_to_router_center_1_1_wide = router_center_1_0_wide_out[0];
    assign router_center_1_0_to_router_center_2_0_wide = router_center_1_0_wide_out[1];
    assign router_center_1_0_to_router_center_0_0_wide = router_center_1_0_wide_out[3];
    assign router_center_1_0_to_cluster_ni_1_0_wide = router_center_1_0_wide_out[4];

  localparam id_t ROUTER_CENTER_1_0_ID = '{x: 5, y: 0, port_id: 0};

floo_nw_router #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .CollectiveCfg(RouteCfg.CollectiveCfg),
  .red_wide_req_t(red_wide_req_t),
  .red_wide_rsp_t(red_wide_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) router_center_1_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i (ROUTER_CENTER_1_0_ID),
  .id_route_map_i ('0),
  .floo_req_i (router_center_1_0_req_in),
  .floo_rsp_o (router_center_1_0_rsp_out),
  .floo_req_o (router_center_1_0_req_out),
  .floo_rsp_i (router_center_1_0_rsp_in),
  .floo_wide_i (router_center_1_0_wide_in),
  .floo_wide_o (router_center_1_0_wide_out)
);


floo_req_t [4:0] router_center_1_1_req_in;
floo_rsp_t [4:0] router_center_1_1_rsp_out;
floo_req_t [4:0] router_center_1_1_req_out;
floo_rsp_t [4:0] router_center_1_1_rsp_in;
floo_wide_t [4:0] router_center_1_1_wide_in;
floo_wide_t [4:0] router_center_1_1_wide_out;

    assign router_center_1_1_req_in[0] = router_center_1_2_to_router_center_1_1_req;
    assign router_center_1_1_req_in[1] = router_center_2_1_to_router_center_1_1_req;
    assign router_center_1_1_req_in[2] = router_center_1_0_to_router_center_1_1_req;
    assign router_center_1_1_req_in[3] = router_center_0_1_to_router_center_1_1_req;
    assign router_center_1_1_req_in[4] = cluster_ni_1_1_to_router_center_1_1_req;

    assign router_center_1_1_to_router_center_1_2_rsp = router_center_1_1_rsp_out[0];
    assign router_center_1_1_to_router_center_2_1_rsp = router_center_1_1_rsp_out[1];
    assign router_center_1_1_to_router_center_1_0_rsp = router_center_1_1_rsp_out[2];
    assign router_center_1_1_to_router_center_0_1_rsp = router_center_1_1_rsp_out[3];
    assign router_center_1_1_to_cluster_ni_1_1_rsp = router_center_1_1_rsp_out[4];

    assign router_center_1_1_to_router_center_1_2_req = router_center_1_1_req_out[0];
    assign router_center_1_1_to_router_center_2_1_req = router_center_1_1_req_out[1];
    assign router_center_1_1_to_router_center_1_0_req = router_center_1_1_req_out[2];
    assign router_center_1_1_to_router_center_0_1_req = router_center_1_1_req_out[3];
    assign router_center_1_1_to_cluster_ni_1_1_req = router_center_1_1_req_out[4];

    assign router_center_1_1_rsp_in[0] = router_center_1_2_to_router_center_1_1_rsp;
    assign router_center_1_1_rsp_in[1] = router_center_2_1_to_router_center_1_1_rsp;
    assign router_center_1_1_rsp_in[2] = router_center_1_0_to_router_center_1_1_rsp;
    assign router_center_1_1_rsp_in[3] = router_center_0_1_to_router_center_1_1_rsp;
    assign router_center_1_1_rsp_in[4] = cluster_ni_1_1_to_router_center_1_1_rsp;

    assign router_center_1_1_wide_in[0] = router_center_1_2_to_router_center_1_1_wide;
    assign router_center_1_1_wide_in[1] = router_center_2_1_to_router_center_1_1_wide;
    assign router_center_1_1_wide_in[2] = router_center_1_0_to_router_center_1_1_wide;
    assign router_center_1_1_wide_in[3] = router_center_0_1_to_router_center_1_1_wide;
    assign router_center_1_1_wide_in[4] = cluster_ni_1_1_to_router_center_1_1_wide;

    assign router_center_1_1_to_router_center_1_2_wide = router_center_1_1_wide_out[0];
    assign router_center_1_1_to_router_center_2_1_wide = router_center_1_1_wide_out[1];
    assign router_center_1_1_to_router_center_1_0_wide = router_center_1_1_wide_out[2];
    assign router_center_1_1_to_router_center_0_1_wide = router_center_1_1_wide_out[3];
    assign router_center_1_1_to_cluster_ni_1_1_wide = router_center_1_1_wide_out[4];

  localparam id_t ROUTER_CENTER_1_1_ID = '{x: 5, y: 1, port_id: 0};

floo_nw_router #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .CollectiveCfg(RouteCfg.CollectiveCfg),
  .red_wide_req_t(red_wide_req_t),
  .red_wide_rsp_t(red_wide_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) router_center_1_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i (ROUTER_CENTER_1_1_ID),
  .id_route_map_i ('0),
  .floo_req_i (router_center_1_1_req_in),
  .floo_rsp_o (router_center_1_1_rsp_out),
  .floo_req_o (router_center_1_1_req_out),
  .floo_rsp_i (router_center_1_1_rsp_in),
  .floo_wide_i (router_center_1_1_wide_in),
  .floo_wide_o (router_center_1_1_wide_out)
);


floo_req_t [4:0] router_center_1_2_req_in;
floo_rsp_t [4:0] router_center_1_2_rsp_out;
floo_req_t [4:0] router_center_1_2_req_out;
floo_rsp_t [4:0] router_center_1_2_rsp_in;
floo_wide_t [4:0] router_center_1_2_wide_in;
floo_wide_t [4:0] router_center_1_2_wide_out;

    assign router_center_1_2_req_in[0] = router_center_1_3_to_router_center_1_2_req;
    assign router_center_1_2_req_in[1] = router_center_2_2_to_router_center_1_2_req;
    assign router_center_1_2_req_in[2] = router_center_1_1_to_router_center_1_2_req;
    assign router_center_1_2_req_in[3] = router_center_0_2_to_router_center_1_2_req;
    assign router_center_1_2_req_in[4] = cluster_ni_1_2_to_router_center_1_2_req;

    assign router_center_1_2_to_router_center_1_3_rsp = router_center_1_2_rsp_out[0];
    assign router_center_1_2_to_router_center_2_2_rsp = router_center_1_2_rsp_out[1];
    assign router_center_1_2_to_router_center_1_1_rsp = router_center_1_2_rsp_out[2];
    assign router_center_1_2_to_router_center_0_2_rsp = router_center_1_2_rsp_out[3];
    assign router_center_1_2_to_cluster_ni_1_2_rsp = router_center_1_2_rsp_out[4];

    assign router_center_1_2_to_router_center_1_3_req = router_center_1_2_req_out[0];
    assign router_center_1_2_to_router_center_2_2_req = router_center_1_2_req_out[1];
    assign router_center_1_2_to_router_center_1_1_req = router_center_1_2_req_out[2];
    assign router_center_1_2_to_router_center_0_2_req = router_center_1_2_req_out[3];
    assign router_center_1_2_to_cluster_ni_1_2_req = router_center_1_2_req_out[4];

    assign router_center_1_2_rsp_in[0] = router_center_1_3_to_router_center_1_2_rsp;
    assign router_center_1_2_rsp_in[1] = router_center_2_2_to_router_center_1_2_rsp;
    assign router_center_1_2_rsp_in[2] = router_center_1_1_to_router_center_1_2_rsp;
    assign router_center_1_2_rsp_in[3] = router_center_0_2_to_router_center_1_2_rsp;
    assign router_center_1_2_rsp_in[4] = cluster_ni_1_2_to_router_center_1_2_rsp;

    assign router_center_1_2_wide_in[0] = router_center_1_3_to_router_center_1_2_wide;
    assign router_center_1_2_wide_in[1] = router_center_2_2_to_router_center_1_2_wide;
    assign router_center_1_2_wide_in[2] = router_center_1_1_to_router_center_1_2_wide;
    assign router_center_1_2_wide_in[3] = router_center_0_2_to_router_center_1_2_wide;
    assign router_center_1_2_wide_in[4] = cluster_ni_1_2_to_router_center_1_2_wide;

    assign router_center_1_2_to_router_center_1_3_wide = router_center_1_2_wide_out[0];
    assign router_center_1_2_to_router_center_2_2_wide = router_center_1_2_wide_out[1];
    assign router_center_1_2_to_router_center_1_1_wide = router_center_1_2_wide_out[2];
    assign router_center_1_2_to_router_center_0_2_wide = router_center_1_2_wide_out[3];
    assign router_center_1_2_to_cluster_ni_1_2_wide = router_center_1_2_wide_out[4];

  localparam id_t ROUTER_CENTER_1_2_ID = '{x: 5, y: 2, port_id: 0};

floo_nw_router #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .CollectiveCfg(RouteCfg.CollectiveCfg),
  .red_wide_req_t(red_wide_req_t),
  .red_wide_rsp_t(red_wide_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) router_center_1_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i (ROUTER_CENTER_1_2_ID),
  .id_route_map_i ('0),
  .floo_req_i (router_center_1_2_req_in),
  .floo_rsp_o (router_center_1_2_rsp_out),
  .floo_req_o (router_center_1_2_req_out),
  .floo_rsp_i (router_center_1_2_rsp_in),
  .floo_wide_i (router_center_1_2_wide_in),
  .floo_wide_o (router_center_1_2_wide_out)
);


floo_req_t [4:0] router_center_1_3_req_in;
floo_rsp_t [4:0] router_center_1_3_rsp_out;
floo_req_t [4:0] router_center_1_3_req_out;
floo_rsp_t [4:0] router_center_1_3_rsp_in;
floo_wide_t [4:0] router_center_1_3_wide_in;
floo_wide_t [4:0] router_center_1_3_wide_out;

    assign router_center_1_3_req_in[0] = '0;
    assign router_center_1_3_req_in[1] = router_center_2_3_to_router_center_1_3_req;
    assign router_center_1_3_req_in[2] = router_center_1_2_to_router_center_1_3_req;
    assign router_center_1_3_req_in[3] = router_center_0_3_to_router_center_1_3_req;
    assign router_center_1_3_req_in[4] = cluster_ni_1_3_to_router_center_1_3_req;

    assign router_center_1_3_to_router_center_2_3_rsp = router_center_1_3_rsp_out[1];
    assign router_center_1_3_to_router_center_1_2_rsp = router_center_1_3_rsp_out[2];
    assign router_center_1_3_to_router_center_0_3_rsp = router_center_1_3_rsp_out[3];
    assign router_center_1_3_to_cluster_ni_1_3_rsp = router_center_1_3_rsp_out[4];

    assign router_center_1_3_to_router_center_2_3_req = router_center_1_3_req_out[1];
    assign router_center_1_3_to_router_center_1_2_req = router_center_1_3_req_out[2];
    assign router_center_1_3_to_router_center_0_3_req = router_center_1_3_req_out[3];
    assign router_center_1_3_to_cluster_ni_1_3_req = router_center_1_3_req_out[4];

    assign router_center_1_3_rsp_in[0] = '0;
    assign router_center_1_3_rsp_in[1] = router_center_2_3_to_router_center_1_3_rsp;
    assign router_center_1_3_rsp_in[2] = router_center_1_2_to_router_center_1_3_rsp;
    assign router_center_1_3_rsp_in[3] = router_center_0_3_to_router_center_1_3_rsp;
    assign router_center_1_3_rsp_in[4] = cluster_ni_1_3_to_router_center_1_3_rsp;

    assign router_center_1_3_wide_in[0] = '0;
    assign router_center_1_3_wide_in[1] = router_center_2_3_to_router_center_1_3_wide;
    assign router_center_1_3_wide_in[2] = router_center_1_2_to_router_center_1_3_wide;
    assign router_center_1_3_wide_in[3] = router_center_0_3_to_router_center_1_3_wide;
    assign router_center_1_3_wide_in[4] = cluster_ni_1_3_to_router_center_1_3_wide;

    assign router_center_1_3_to_router_center_2_3_wide = router_center_1_3_wide_out[1];
    assign router_center_1_3_to_router_center_1_2_wide = router_center_1_3_wide_out[2];
    assign router_center_1_3_to_router_center_0_3_wide = router_center_1_3_wide_out[3];
    assign router_center_1_3_to_cluster_ni_1_3_wide = router_center_1_3_wide_out[4];

  localparam id_t ROUTER_CENTER_1_3_ID = '{x: 5, y: 3, port_id: 0};

floo_nw_router #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .CollectiveCfg(RouteCfg.CollectiveCfg),
  .red_wide_req_t(red_wide_req_t),
  .red_wide_rsp_t(red_wide_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) router_center_1_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i (ROUTER_CENTER_1_3_ID),
  .id_route_map_i ('0),
  .floo_req_i (router_center_1_3_req_in),
  .floo_rsp_o (router_center_1_3_rsp_out),
  .floo_req_o (router_center_1_3_req_out),
  .floo_rsp_i (router_center_1_3_rsp_in),
  .floo_wide_i (router_center_1_3_wide_in),
  .floo_wide_o (router_center_1_3_wide_out)
);


floo_req_t [4:0] router_center_2_0_req_in;
floo_rsp_t [4:0] router_center_2_0_rsp_out;
floo_req_t [4:0] router_center_2_0_req_out;
floo_rsp_t [4:0] router_center_2_0_rsp_in;
floo_wide_t [4:0] router_center_2_0_wide_in;
floo_wide_t [4:0] router_center_2_0_wide_out;

    assign router_center_2_0_req_in[0] = router_center_2_1_to_router_center_2_0_req;
    assign router_center_2_0_req_in[1] = router_center_3_0_to_router_center_2_0_req;
    assign router_center_2_0_req_in[2] = '0;
    assign router_center_2_0_req_in[3] = router_center_1_0_to_router_center_2_0_req;
    assign router_center_2_0_req_in[4] = cluster_ni_2_0_to_router_center_2_0_req;

    assign router_center_2_0_to_router_center_2_1_rsp = router_center_2_0_rsp_out[0];
    assign router_center_2_0_to_router_center_3_0_rsp = router_center_2_0_rsp_out[1];
    assign router_center_2_0_to_router_center_1_0_rsp = router_center_2_0_rsp_out[3];
    assign router_center_2_0_to_cluster_ni_2_0_rsp = router_center_2_0_rsp_out[4];

    assign router_center_2_0_to_router_center_2_1_req = router_center_2_0_req_out[0];
    assign router_center_2_0_to_router_center_3_0_req = router_center_2_0_req_out[1];
    assign router_center_2_0_to_router_center_1_0_req = router_center_2_0_req_out[3];
    assign router_center_2_0_to_cluster_ni_2_0_req = router_center_2_0_req_out[4];

    assign router_center_2_0_rsp_in[0] = router_center_2_1_to_router_center_2_0_rsp;
    assign router_center_2_0_rsp_in[1] = router_center_3_0_to_router_center_2_0_rsp;
    assign router_center_2_0_rsp_in[2] = '0;
    assign router_center_2_0_rsp_in[3] = router_center_1_0_to_router_center_2_0_rsp;
    assign router_center_2_0_rsp_in[4] = cluster_ni_2_0_to_router_center_2_0_rsp;

    assign router_center_2_0_wide_in[0] = router_center_2_1_to_router_center_2_0_wide;
    assign router_center_2_0_wide_in[1] = router_center_3_0_to_router_center_2_0_wide;
    assign router_center_2_0_wide_in[2] = '0;
    assign router_center_2_0_wide_in[3] = router_center_1_0_to_router_center_2_0_wide;
    assign router_center_2_0_wide_in[4] = cluster_ni_2_0_to_router_center_2_0_wide;

    assign router_center_2_0_to_router_center_2_1_wide = router_center_2_0_wide_out[0];
    assign router_center_2_0_to_router_center_3_0_wide = router_center_2_0_wide_out[1];
    assign router_center_2_0_to_router_center_1_0_wide = router_center_2_0_wide_out[3];
    assign router_center_2_0_to_cluster_ni_2_0_wide = router_center_2_0_wide_out[4];

  localparam id_t ROUTER_CENTER_2_0_ID = '{x: 6, y: 0, port_id: 0};

floo_nw_router #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .CollectiveCfg(RouteCfg.CollectiveCfg),
  .red_wide_req_t(red_wide_req_t),
  .red_wide_rsp_t(red_wide_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) router_center_2_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i (ROUTER_CENTER_2_0_ID),
  .id_route_map_i ('0),
  .floo_req_i (router_center_2_0_req_in),
  .floo_rsp_o (router_center_2_0_rsp_out),
  .floo_req_o (router_center_2_0_req_out),
  .floo_rsp_i (router_center_2_0_rsp_in),
  .floo_wide_i (router_center_2_0_wide_in),
  .floo_wide_o (router_center_2_0_wide_out)
);


floo_req_t [4:0] router_center_2_1_req_in;
floo_rsp_t [4:0] router_center_2_1_rsp_out;
floo_req_t [4:0] router_center_2_1_req_out;
floo_rsp_t [4:0] router_center_2_1_rsp_in;
floo_wide_t [4:0] router_center_2_1_wide_in;
floo_wide_t [4:0] router_center_2_1_wide_out;

    assign router_center_2_1_req_in[0] = router_center_2_2_to_router_center_2_1_req;
    assign router_center_2_1_req_in[1] = router_center_3_1_to_router_center_2_1_req;
    assign router_center_2_1_req_in[2] = router_center_2_0_to_router_center_2_1_req;
    assign router_center_2_1_req_in[3] = router_center_1_1_to_router_center_2_1_req;
    assign router_center_2_1_req_in[4] = cluster_ni_2_1_to_router_center_2_1_req;

    assign router_center_2_1_to_router_center_2_2_rsp = router_center_2_1_rsp_out[0];
    assign router_center_2_1_to_router_center_3_1_rsp = router_center_2_1_rsp_out[1];
    assign router_center_2_1_to_router_center_2_0_rsp = router_center_2_1_rsp_out[2];
    assign router_center_2_1_to_router_center_1_1_rsp = router_center_2_1_rsp_out[3];
    assign router_center_2_1_to_cluster_ni_2_1_rsp = router_center_2_1_rsp_out[4];

    assign router_center_2_1_to_router_center_2_2_req = router_center_2_1_req_out[0];
    assign router_center_2_1_to_router_center_3_1_req = router_center_2_1_req_out[1];
    assign router_center_2_1_to_router_center_2_0_req = router_center_2_1_req_out[2];
    assign router_center_2_1_to_router_center_1_1_req = router_center_2_1_req_out[3];
    assign router_center_2_1_to_cluster_ni_2_1_req = router_center_2_1_req_out[4];

    assign router_center_2_1_rsp_in[0] = router_center_2_2_to_router_center_2_1_rsp;
    assign router_center_2_1_rsp_in[1] = router_center_3_1_to_router_center_2_1_rsp;
    assign router_center_2_1_rsp_in[2] = router_center_2_0_to_router_center_2_1_rsp;
    assign router_center_2_1_rsp_in[3] = router_center_1_1_to_router_center_2_1_rsp;
    assign router_center_2_1_rsp_in[4] = cluster_ni_2_1_to_router_center_2_1_rsp;

    assign router_center_2_1_wide_in[0] = router_center_2_2_to_router_center_2_1_wide;
    assign router_center_2_1_wide_in[1] = router_center_3_1_to_router_center_2_1_wide;
    assign router_center_2_1_wide_in[2] = router_center_2_0_to_router_center_2_1_wide;
    assign router_center_2_1_wide_in[3] = router_center_1_1_to_router_center_2_1_wide;
    assign router_center_2_1_wide_in[4] = cluster_ni_2_1_to_router_center_2_1_wide;

    assign router_center_2_1_to_router_center_2_2_wide = router_center_2_1_wide_out[0];
    assign router_center_2_1_to_router_center_3_1_wide = router_center_2_1_wide_out[1];
    assign router_center_2_1_to_router_center_2_0_wide = router_center_2_1_wide_out[2];
    assign router_center_2_1_to_router_center_1_1_wide = router_center_2_1_wide_out[3];
    assign router_center_2_1_to_cluster_ni_2_1_wide = router_center_2_1_wide_out[4];

  localparam id_t ROUTER_CENTER_2_1_ID = '{x: 6, y: 1, port_id: 0};

floo_nw_router #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .CollectiveCfg(RouteCfg.CollectiveCfg),
  .red_wide_req_t(red_wide_req_t),
  .red_wide_rsp_t(red_wide_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) router_center_2_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i (ROUTER_CENTER_2_1_ID),
  .id_route_map_i ('0),
  .floo_req_i (router_center_2_1_req_in),
  .floo_rsp_o (router_center_2_1_rsp_out),
  .floo_req_o (router_center_2_1_req_out),
  .floo_rsp_i (router_center_2_1_rsp_in),
  .floo_wide_i (router_center_2_1_wide_in),
  .floo_wide_o (router_center_2_1_wide_out)
);


floo_req_t [4:0] router_center_2_2_req_in;
floo_rsp_t [4:0] router_center_2_2_rsp_out;
floo_req_t [4:0] router_center_2_2_req_out;
floo_rsp_t [4:0] router_center_2_2_rsp_in;
floo_wide_t [4:0] router_center_2_2_wide_in;
floo_wide_t [4:0] router_center_2_2_wide_out;

    assign router_center_2_2_req_in[0] = router_center_2_3_to_router_center_2_2_req;
    assign router_center_2_2_req_in[1] = router_center_3_2_to_router_center_2_2_req;
    assign router_center_2_2_req_in[2] = router_center_2_1_to_router_center_2_2_req;
    assign router_center_2_2_req_in[3] = router_center_1_2_to_router_center_2_2_req;
    assign router_center_2_2_req_in[4] = cluster_ni_2_2_to_router_center_2_2_req;

    assign router_center_2_2_to_router_center_2_3_rsp = router_center_2_2_rsp_out[0];
    assign router_center_2_2_to_router_center_3_2_rsp = router_center_2_2_rsp_out[1];
    assign router_center_2_2_to_router_center_2_1_rsp = router_center_2_2_rsp_out[2];
    assign router_center_2_2_to_router_center_1_2_rsp = router_center_2_2_rsp_out[3];
    assign router_center_2_2_to_cluster_ni_2_2_rsp = router_center_2_2_rsp_out[4];

    assign router_center_2_2_to_router_center_2_3_req = router_center_2_2_req_out[0];
    assign router_center_2_2_to_router_center_3_2_req = router_center_2_2_req_out[1];
    assign router_center_2_2_to_router_center_2_1_req = router_center_2_2_req_out[2];
    assign router_center_2_2_to_router_center_1_2_req = router_center_2_2_req_out[3];
    assign router_center_2_2_to_cluster_ni_2_2_req = router_center_2_2_req_out[4];

    assign router_center_2_2_rsp_in[0] = router_center_2_3_to_router_center_2_2_rsp;
    assign router_center_2_2_rsp_in[1] = router_center_3_2_to_router_center_2_2_rsp;
    assign router_center_2_2_rsp_in[2] = router_center_2_1_to_router_center_2_2_rsp;
    assign router_center_2_2_rsp_in[3] = router_center_1_2_to_router_center_2_2_rsp;
    assign router_center_2_2_rsp_in[4] = cluster_ni_2_2_to_router_center_2_2_rsp;

    assign router_center_2_2_wide_in[0] = router_center_2_3_to_router_center_2_2_wide;
    assign router_center_2_2_wide_in[1] = router_center_3_2_to_router_center_2_2_wide;
    assign router_center_2_2_wide_in[2] = router_center_2_1_to_router_center_2_2_wide;
    assign router_center_2_2_wide_in[3] = router_center_1_2_to_router_center_2_2_wide;
    assign router_center_2_2_wide_in[4] = cluster_ni_2_2_to_router_center_2_2_wide;

    assign router_center_2_2_to_router_center_2_3_wide = router_center_2_2_wide_out[0];
    assign router_center_2_2_to_router_center_3_2_wide = router_center_2_2_wide_out[1];
    assign router_center_2_2_to_router_center_2_1_wide = router_center_2_2_wide_out[2];
    assign router_center_2_2_to_router_center_1_2_wide = router_center_2_2_wide_out[3];
    assign router_center_2_2_to_cluster_ni_2_2_wide = router_center_2_2_wide_out[4];

  localparam id_t ROUTER_CENTER_2_2_ID = '{x: 6, y: 2, port_id: 0};

floo_nw_router #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .CollectiveCfg(RouteCfg.CollectiveCfg),
  .red_wide_req_t(red_wide_req_t),
  .red_wide_rsp_t(red_wide_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) router_center_2_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i (ROUTER_CENTER_2_2_ID),
  .id_route_map_i ('0),
  .floo_req_i (router_center_2_2_req_in),
  .floo_rsp_o (router_center_2_2_rsp_out),
  .floo_req_o (router_center_2_2_req_out),
  .floo_rsp_i (router_center_2_2_rsp_in),
  .floo_wide_i (router_center_2_2_wide_in),
  .floo_wide_o (router_center_2_2_wide_out)
);


floo_req_t [4:0] router_center_2_3_req_in;
floo_rsp_t [4:0] router_center_2_3_rsp_out;
floo_req_t [4:0] router_center_2_3_req_out;
floo_rsp_t [4:0] router_center_2_3_rsp_in;
floo_wide_t [4:0] router_center_2_3_wide_in;
floo_wide_t [4:0] router_center_2_3_wide_out;

    assign router_center_2_3_req_in[0] = '0;
    assign router_center_2_3_req_in[1] = router_center_3_3_to_router_center_2_3_req;
    assign router_center_2_3_req_in[2] = router_center_2_2_to_router_center_2_3_req;
    assign router_center_2_3_req_in[3] = router_center_1_3_to_router_center_2_3_req;
    assign router_center_2_3_req_in[4] = cluster_ni_2_3_to_router_center_2_3_req;

    assign router_center_2_3_to_router_center_3_3_rsp = router_center_2_3_rsp_out[1];
    assign router_center_2_3_to_router_center_2_2_rsp = router_center_2_3_rsp_out[2];
    assign router_center_2_3_to_router_center_1_3_rsp = router_center_2_3_rsp_out[3];
    assign router_center_2_3_to_cluster_ni_2_3_rsp = router_center_2_3_rsp_out[4];

    assign router_center_2_3_to_router_center_3_3_req = router_center_2_3_req_out[1];
    assign router_center_2_3_to_router_center_2_2_req = router_center_2_3_req_out[2];
    assign router_center_2_3_to_router_center_1_3_req = router_center_2_3_req_out[3];
    assign router_center_2_3_to_cluster_ni_2_3_req = router_center_2_3_req_out[4];

    assign router_center_2_3_rsp_in[0] = '0;
    assign router_center_2_3_rsp_in[1] = router_center_3_3_to_router_center_2_3_rsp;
    assign router_center_2_3_rsp_in[2] = router_center_2_2_to_router_center_2_3_rsp;
    assign router_center_2_3_rsp_in[3] = router_center_1_3_to_router_center_2_3_rsp;
    assign router_center_2_3_rsp_in[4] = cluster_ni_2_3_to_router_center_2_3_rsp;

    assign router_center_2_3_wide_in[0] = '0;
    assign router_center_2_3_wide_in[1] = router_center_3_3_to_router_center_2_3_wide;
    assign router_center_2_3_wide_in[2] = router_center_2_2_to_router_center_2_3_wide;
    assign router_center_2_3_wide_in[3] = router_center_1_3_to_router_center_2_3_wide;
    assign router_center_2_3_wide_in[4] = cluster_ni_2_3_to_router_center_2_3_wide;

    assign router_center_2_3_to_router_center_3_3_wide = router_center_2_3_wide_out[1];
    assign router_center_2_3_to_router_center_2_2_wide = router_center_2_3_wide_out[2];
    assign router_center_2_3_to_router_center_1_3_wide = router_center_2_3_wide_out[3];
    assign router_center_2_3_to_cluster_ni_2_3_wide = router_center_2_3_wide_out[4];

  localparam id_t ROUTER_CENTER_2_3_ID = '{x: 6, y: 3, port_id: 0};

floo_nw_router #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .CollectiveCfg(RouteCfg.CollectiveCfg),
  .red_wide_req_t(red_wide_req_t),
  .red_wide_rsp_t(red_wide_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) router_center_2_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i (ROUTER_CENTER_2_3_ID),
  .id_route_map_i ('0),
  .floo_req_i (router_center_2_3_req_in),
  .floo_rsp_o (router_center_2_3_rsp_out),
  .floo_req_o (router_center_2_3_req_out),
  .floo_rsp_i (router_center_2_3_rsp_in),
  .floo_wide_i (router_center_2_3_wide_in),
  .floo_wide_o (router_center_2_3_wide_out)
);


floo_req_t [4:0] router_center_3_0_req_in;
floo_rsp_t [4:0] router_center_3_0_rsp_out;
floo_req_t [4:0] router_center_3_0_req_out;
floo_rsp_t [4:0] router_center_3_0_rsp_in;
floo_wide_t [4:0] router_center_3_0_wide_in;
floo_wide_t [4:0] router_center_3_0_wide_out;

    assign router_center_3_0_req_in[0] = router_center_3_1_to_router_center_3_0_req;
    assign router_center_3_0_req_in[1] = '0;
    assign router_center_3_0_req_in[2] = '0;
    assign router_center_3_0_req_in[3] = router_center_2_0_to_router_center_3_0_req;
    assign router_center_3_0_req_in[4] = cluster_ni_3_0_to_router_center_3_0_req;

    assign router_center_3_0_to_router_center_3_1_rsp = router_center_3_0_rsp_out[0];
    assign router_center_3_0_to_router_center_2_0_rsp = router_center_3_0_rsp_out[3];
    assign router_center_3_0_to_cluster_ni_3_0_rsp = router_center_3_0_rsp_out[4];

    assign router_center_3_0_to_router_center_3_1_req = router_center_3_0_req_out[0];
    assign router_center_3_0_to_router_center_2_0_req = router_center_3_0_req_out[3];
    assign router_center_3_0_to_cluster_ni_3_0_req = router_center_3_0_req_out[4];

    assign router_center_3_0_rsp_in[0] = router_center_3_1_to_router_center_3_0_rsp;
    assign router_center_3_0_rsp_in[1] = '0;
    assign router_center_3_0_rsp_in[2] = '0;
    assign router_center_3_0_rsp_in[3] = router_center_2_0_to_router_center_3_0_rsp;
    assign router_center_3_0_rsp_in[4] = cluster_ni_3_0_to_router_center_3_0_rsp;

    assign router_center_3_0_wide_in[0] = router_center_3_1_to_router_center_3_0_wide;
    assign router_center_3_0_wide_in[1] = '0;
    assign router_center_3_0_wide_in[2] = '0;
    assign router_center_3_0_wide_in[3] = router_center_2_0_to_router_center_3_0_wide;
    assign router_center_3_0_wide_in[4] = cluster_ni_3_0_to_router_center_3_0_wide;

    assign router_center_3_0_to_router_center_3_1_wide = router_center_3_0_wide_out[0];
    assign router_center_3_0_to_router_center_2_0_wide = router_center_3_0_wide_out[3];
    assign router_center_3_0_to_cluster_ni_3_0_wide = router_center_3_0_wide_out[4];

  localparam id_t ROUTER_CENTER_3_0_ID = '{x: 7, y: 0, port_id: 0};

floo_nw_router #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .CollectiveCfg(RouteCfg.CollectiveCfg),
  .red_wide_req_t(red_wide_req_t),
  .red_wide_rsp_t(red_wide_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) router_center_3_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i (ROUTER_CENTER_3_0_ID),
  .id_route_map_i ('0),
  .floo_req_i (router_center_3_0_req_in),
  .floo_rsp_o (router_center_3_0_rsp_out),
  .floo_req_o (router_center_3_0_req_out),
  .floo_rsp_i (router_center_3_0_rsp_in),
  .floo_wide_i (router_center_3_0_wide_in),
  .floo_wide_o (router_center_3_0_wide_out)
);


floo_req_t [4:0] router_center_3_1_req_in;
floo_rsp_t [4:0] router_center_3_1_rsp_out;
floo_req_t [4:0] router_center_3_1_req_out;
floo_rsp_t [4:0] router_center_3_1_rsp_in;
floo_wide_t [4:0] router_center_3_1_wide_in;
floo_wide_t [4:0] router_center_3_1_wide_out;

    assign router_center_3_1_req_in[0] = router_center_3_2_to_router_center_3_1_req;
    assign router_center_3_1_req_in[1] = '0;
    assign router_center_3_1_req_in[2] = router_center_3_0_to_router_center_3_1_req;
    assign router_center_3_1_req_in[3] = router_center_2_1_to_router_center_3_1_req;
    assign router_center_3_1_req_in[4] = cluster_ni_3_1_to_router_center_3_1_req;

    assign router_center_3_1_to_router_center_3_2_rsp = router_center_3_1_rsp_out[0];
    assign router_center_3_1_to_router_center_3_0_rsp = router_center_3_1_rsp_out[2];
    assign router_center_3_1_to_router_center_2_1_rsp = router_center_3_1_rsp_out[3];
    assign router_center_3_1_to_cluster_ni_3_1_rsp = router_center_3_1_rsp_out[4];

    assign router_center_3_1_to_router_center_3_2_req = router_center_3_1_req_out[0];
    assign router_center_3_1_to_router_center_3_0_req = router_center_3_1_req_out[2];
    assign router_center_3_1_to_router_center_2_1_req = router_center_3_1_req_out[3];
    assign router_center_3_1_to_cluster_ni_3_1_req = router_center_3_1_req_out[4];

    assign router_center_3_1_rsp_in[0] = router_center_3_2_to_router_center_3_1_rsp;
    assign router_center_3_1_rsp_in[1] = '0;
    assign router_center_3_1_rsp_in[2] = router_center_3_0_to_router_center_3_1_rsp;
    assign router_center_3_1_rsp_in[3] = router_center_2_1_to_router_center_3_1_rsp;
    assign router_center_3_1_rsp_in[4] = cluster_ni_3_1_to_router_center_3_1_rsp;

    assign router_center_3_1_wide_in[0] = router_center_3_2_to_router_center_3_1_wide;
    assign router_center_3_1_wide_in[1] = '0;
    assign router_center_3_1_wide_in[2] = router_center_3_0_to_router_center_3_1_wide;
    assign router_center_3_1_wide_in[3] = router_center_2_1_to_router_center_3_1_wide;
    assign router_center_3_1_wide_in[4] = cluster_ni_3_1_to_router_center_3_1_wide;

    assign router_center_3_1_to_router_center_3_2_wide = router_center_3_1_wide_out[0];
    assign router_center_3_1_to_router_center_3_0_wide = router_center_3_1_wide_out[2];
    assign router_center_3_1_to_router_center_2_1_wide = router_center_3_1_wide_out[3];
    assign router_center_3_1_to_cluster_ni_3_1_wide = router_center_3_1_wide_out[4];

  localparam id_t ROUTER_CENTER_3_1_ID = '{x: 7, y: 1, port_id: 0};

floo_nw_router #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .CollectiveCfg(RouteCfg.CollectiveCfg),
  .red_wide_req_t(red_wide_req_t),
  .red_wide_rsp_t(red_wide_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) router_center_3_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i (ROUTER_CENTER_3_1_ID),
  .id_route_map_i ('0),
  .floo_req_i (router_center_3_1_req_in),
  .floo_rsp_o (router_center_3_1_rsp_out),
  .floo_req_o (router_center_3_1_req_out),
  .floo_rsp_i (router_center_3_1_rsp_in),
  .floo_wide_i (router_center_3_1_wide_in),
  .floo_wide_o (router_center_3_1_wide_out)
);


floo_req_t [4:0] router_center_3_2_req_in;
floo_rsp_t [4:0] router_center_3_2_rsp_out;
floo_req_t [4:0] router_center_3_2_req_out;
floo_rsp_t [4:0] router_center_3_2_rsp_in;
floo_wide_t [4:0] router_center_3_2_wide_in;
floo_wide_t [4:0] router_center_3_2_wide_out;

    assign router_center_3_2_req_in[0] = router_center_3_3_to_router_center_3_2_req;
    assign router_center_3_2_req_in[1] = '0;
    assign router_center_3_2_req_in[2] = router_center_3_1_to_router_center_3_2_req;
    assign router_center_3_2_req_in[3] = router_center_2_2_to_router_center_3_2_req;
    assign router_center_3_2_req_in[4] = cluster_ni_3_2_to_router_center_3_2_req;

    assign router_center_3_2_to_router_center_3_3_rsp = router_center_3_2_rsp_out[0];
    assign router_center_3_2_to_router_center_3_1_rsp = router_center_3_2_rsp_out[2];
    assign router_center_3_2_to_router_center_2_2_rsp = router_center_3_2_rsp_out[3];
    assign router_center_3_2_to_cluster_ni_3_2_rsp = router_center_3_2_rsp_out[4];

    assign router_center_3_2_to_router_center_3_3_req = router_center_3_2_req_out[0];
    assign router_center_3_2_to_router_center_3_1_req = router_center_3_2_req_out[2];
    assign router_center_3_2_to_router_center_2_2_req = router_center_3_2_req_out[3];
    assign router_center_3_2_to_cluster_ni_3_2_req = router_center_3_2_req_out[4];

    assign router_center_3_2_rsp_in[0] = router_center_3_3_to_router_center_3_2_rsp;
    assign router_center_3_2_rsp_in[1] = '0;
    assign router_center_3_2_rsp_in[2] = router_center_3_1_to_router_center_3_2_rsp;
    assign router_center_3_2_rsp_in[3] = router_center_2_2_to_router_center_3_2_rsp;
    assign router_center_3_2_rsp_in[4] = cluster_ni_3_2_to_router_center_3_2_rsp;

    assign router_center_3_2_wide_in[0] = router_center_3_3_to_router_center_3_2_wide;
    assign router_center_3_2_wide_in[1] = '0;
    assign router_center_3_2_wide_in[2] = router_center_3_1_to_router_center_3_2_wide;
    assign router_center_3_2_wide_in[3] = router_center_2_2_to_router_center_3_2_wide;
    assign router_center_3_2_wide_in[4] = cluster_ni_3_2_to_router_center_3_2_wide;

    assign router_center_3_2_to_router_center_3_3_wide = router_center_3_2_wide_out[0];
    assign router_center_3_2_to_router_center_3_1_wide = router_center_3_2_wide_out[2];
    assign router_center_3_2_to_router_center_2_2_wide = router_center_3_2_wide_out[3];
    assign router_center_3_2_to_cluster_ni_3_2_wide = router_center_3_2_wide_out[4];

  localparam id_t ROUTER_CENTER_3_2_ID = '{x: 7, y: 2, port_id: 0};

floo_nw_router #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .CollectiveCfg(RouteCfg.CollectiveCfg),
  .red_wide_req_t(red_wide_req_t),
  .red_wide_rsp_t(red_wide_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) router_center_3_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i (ROUTER_CENTER_3_2_ID),
  .id_route_map_i ('0),
  .floo_req_i (router_center_3_2_req_in),
  .floo_rsp_o (router_center_3_2_rsp_out),
  .floo_req_o (router_center_3_2_req_out),
  .floo_rsp_i (router_center_3_2_rsp_in),
  .floo_wide_i (router_center_3_2_wide_in),
  .floo_wide_o (router_center_3_2_wide_out)
);


floo_req_t [4:0] router_center_3_3_req_in;
floo_rsp_t [4:0] router_center_3_3_rsp_out;
floo_req_t [4:0] router_center_3_3_req_out;
floo_rsp_t [4:0] router_center_3_3_rsp_in;
floo_wide_t [4:0] router_center_3_3_wide_in;
floo_wide_t [4:0] router_center_3_3_wide_out;

    assign router_center_3_3_req_in[0] = '0;
    assign router_center_3_3_req_in[1] = '0;
    assign router_center_3_3_req_in[2] = router_center_3_2_to_router_center_3_3_req;
    assign router_center_3_3_req_in[3] = router_center_2_3_to_router_center_3_3_req;
    assign router_center_3_3_req_in[4] = cluster_ni_3_3_to_router_center_3_3_req;

    assign router_center_3_3_to_router_center_3_2_rsp = router_center_3_3_rsp_out[2];
    assign router_center_3_3_to_router_center_2_3_rsp = router_center_3_3_rsp_out[3];
    assign router_center_3_3_to_cluster_ni_3_3_rsp = router_center_3_3_rsp_out[4];

    assign router_center_3_3_to_router_center_3_2_req = router_center_3_3_req_out[2];
    assign router_center_3_3_to_router_center_2_3_req = router_center_3_3_req_out[3];
    assign router_center_3_3_to_cluster_ni_3_3_req = router_center_3_3_req_out[4];

    assign router_center_3_3_rsp_in[0] = '0;
    assign router_center_3_3_rsp_in[1] = '0;
    assign router_center_3_3_rsp_in[2] = router_center_3_2_to_router_center_3_3_rsp;
    assign router_center_3_3_rsp_in[3] = router_center_2_3_to_router_center_3_3_rsp;
    assign router_center_3_3_rsp_in[4] = cluster_ni_3_3_to_router_center_3_3_rsp;

    assign router_center_3_3_wide_in[0] = '0;
    assign router_center_3_3_wide_in[1] = '0;
    assign router_center_3_3_wide_in[2] = router_center_3_2_to_router_center_3_3_wide;
    assign router_center_3_3_wide_in[3] = router_center_2_3_to_router_center_3_3_wide;
    assign router_center_3_3_wide_in[4] = cluster_ni_3_3_to_router_center_3_3_wide;

    assign router_center_3_3_to_router_center_3_2_wide = router_center_3_3_wide_out[2];
    assign router_center_3_3_to_router_center_2_3_wide = router_center_3_3_wide_out[3];
    assign router_center_3_3_to_cluster_ni_3_3_wide = router_center_3_3_wide_out[4];

  localparam id_t ROUTER_CENTER_3_3_ID = '{x: 7, y: 3, port_id: 0};

floo_nw_router #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .CollectiveCfg(RouteCfg.CollectiveCfg),
  .red_wide_req_t(red_wide_req_t),
  .red_wide_rsp_t(red_wide_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) router_center_3_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i (ROUTER_CENTER_3_3_ID),
  .id_route_map_i ('0),
  .floo_req_i (router_center_3_3_req_in),
  .floo_rsp_o (router_center_3_3_rsp_out),
  .floo_req_o (router_center_3_3_req_out),
  .floo_rsp_i (router_center_3_3_rsp_in),
  .floo_wide_i (router_center_3_3_wide_in),
  .floo_wide_o (router_center_3_3_wide_out)
);


floo_req_t [4:0] router_right_0_0_req_in;
floo_rsp_t [4:0] router_right_0_0_rsp_out;
floo_req_t [4:0] router_right_0_0_req_out;
floo_rsp_t [4:0] router_right_0_0_rsp_in;
floo_wide_t [4:0] router_right_0_0_wide_in;
floo_wide_t [4:0] router_right_0_0_wide_out;

    assign router_right_0_0_req_in[0] = router_right_0_1_to_router_right_0_0_req;
    assign router_right_0_0_req_in[1] = router_right_1_0_to_router_right_0_0_req;
    assign router_right_0_0_req_in[2] = '0;
    assign router_right_0_0_req_in[3] = '0;
    assign router_right_0_0_req_in[4] = l2_spm_ni_4_to_router_right_0_0_req;

    assign router_right_0_0_to_router_right_0_1_rsp = router_right_0_0_rsp_out[0];
    assign router_right_0_0_to_router_right_1_0_rsp = router_right_0_0_rsp_out[1];
    assign router_right_0_0_to_l2_spm_ni_4_rsp = router_right_0_0_rsp_out[4];

    assign router_right_0_0_to_router_right_0_1_req = router_right_0_0_req_out[0];
    assign router_right_0_0_to_router_right_1_0_req = router_right_0_0_req_out[1];
    assign router_right_0_0_to_l2_spm_ni_4_req = router_right_0_0_req_out[4];

    assign router_right_0_0_rsp_in[0] = router_right_0_1_to_router_right_0_0_rsp;
    assign router_right_0_0_rsp_in[1] = router_right_1_0_to_router_right_0_0_rsp;
    assign router_right_0_0_rsp_in[2] = '0;
    assign router_right_0_0_rsp_in[3] = '0;
    assign router_right_0_0_rsp_in[4] = l2_spm_ni_4_to_router_right_0_0_rsp;

    assign router_right_0_0_wide_in[0] = router_right_0_1_to_router_right_0_0_wide;
    assign router_right_0_0_wide_in[1] = router_right_1_0_to_router_right_0_0_wide;
    assign router_right_0_0_wide_in[2] = '0;
    assign router_right_0_0_wide_in[3] = '0;
    assign router_right_0_0_wide_in[4] = l2_spm_ni_4_to_router_right_0_0_wide;

    assign router_right_0_0_to_router_right_0_1_wide = router_right_0_0_wide_out[0];
    assign router_right_0_0_to_router_right_1_0_wide = router_right_0_0_wide_out[1];
    assign router_right_0_0_to_l2_spm_ni_4_wide = router_right_0_0_wide_out[4];

  localparam id_t ROUTER_RIGHT_0_0_ID = '{x: 8, y: 0, port_id: 0};

floo_nw_router #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .CollectiveCfg(RouteCfg.CollectiveCfg),
  .red_wide_req_t(red_wide_req_t),
  .red_wide_rsp_t(red_wide_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) router_right_0_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i (ROUTER_RIGHT_0_0_ID),
  .id_route_map_i ('0),
  .floo_req_i (router_right_0_0_req_in),
  .floo_rsp_o (router_right_0_0_rsp_out),
  .floo_req_o (router_right_0_0_req_out),
  .floo_rsp_i (router_right_0_0_rsp_in),
  .floo_wide_i (router_right_0_0_wide_in),
  .floo_wide_o (router_right_0_0_wide_out)
);


floo_req_t [4:0] router_right_0_1_req_in;
floo_rsp_t [4:0] router_right_0_1_rsp_out;
floo_req_t [4:0] router_right_0_1_req_out;
floo_rsp_t [4:0] router_right_0_1_rsp_in;
floo_wide_t [4:0] router_right_0_1_wide_in;
floo_wide_t [4:0] router_right_0_1_wide_out;

    assign router_right_0_1_req_in[0] = router_right_0_2_to_router_right_0_1_req;
    assign router_right_0_1_req_in[1] = router_right_1_1_to_router_right_0_1_req;
    assign router_right_0_1_req_in[2] = router_right_0_0_to_router_right_0_1_req;
    assign router_right_0_1_req_in[3] = '0;
    assign router_right_0_1_req_in[4] = l2_spm_ni_5_to_router_right_0_1_req;

    assign router_right_0_1_to_router_right_0_2_rsp = router_right_0_1_rsp_out[0];
    assign router_right_0_1_to_router_right_1_1_rsp = router_right_0_1_rsp_out[1];
    assign router_right_0_1_to_router_right_0_0_rsp = router_right_0_1_rsp_out[2];
    assign router_right_0_1_to_l2_spm_ni_5_rsp = router_right_0_1_rsp_out[4];

    assign router_right_0_1_to_router_right_0_2_req = router_right_0_1_req_out[0];
    assign router_right_0_1_to_router_right_1_1_req = router_right_0_1_req_out[1];
    assign router_right_0_1_to_router_right_0_0_req = router_right_0_1_req_out[2];
    assign router_right_0_1_to_l2_spm_ni_5_req = router_right_0_1_req_out[4];

    assign router_right_0_1_rsp_in[0] = router_right_0_2_to_router_right_0_1_rsp;
    assign router_right_0_1_rsp_in[1] = router_right_1_1_to_router_right_0_1_rsp;
    assign router_right_0_1_rsp_in[2] = router_right_0_0_to_router_right_0_1_rsp;
    assign router_right_0_1_rsp_in[3] = '0;
    assign router_right_0_1_rsp_in[4] = l2_spm_ni_5_to_router_right_0_1_rsp;

    assign router_right_0_1_wide_in[0] = router_right_0_2_to_router_right_0_1_wide;
    assign router_right_0_1_wide_in[1] = router_right_1_1_to_router_right_0_1_wide;
    assign router_right_0_1_wide_in[2] = router_right_0_0_to_router_right_0_1_wide;
    assign router_right_0_1_wide_in[3] = '0;
    assign router_right_0_1_wide_in[4] = l2_spm_ni_5_to_router_right_0_1_wide;

    assign router_right_0_1_to_router_right_0_2_wide = router_right_0_1_wide_out[0];
    assign router_right_0_1_to_router_right_1_1_wide = router_right_0_1_wide_out[1];
    assign router_right_0_1_to_router_right_0_0_wide = router_right_0_1_wide_out[2];
    assign router_right_0_1_to_l2_spm_ni_5_wide = router_right_0_1_wide_out[4];

  localparam id_t ROUTER_RIGHT_0_1_ID = '{x: 8, y: 1, port_id: 0};

floo_nw_router #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .CollectiveCfg(RouteCfg.CollectiveCfg),
  .red_wide_req_t(red_wide_req_t),
  .red_wide_rsp_t(red_wide_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) router_right_0_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i (ROUTER_RIGHT_0_1_ID),
  .id_route_map_i ('0),
  .floo_req_i (router_right_0_1_req_in),
  .floo_rsp_o (router_right_0_1_rsp_out),
  .floo_req_o (router_right_0_1_req_out),
  .floo_rsp_i (router_right_0_1_rsp_in),
  .floo_wide_i (router_right_0_1_wide_in),
  .floo_wide_o (router_right_0_1_wide_out)
);


floo_req_t [4:0] router_right_0_2_req_in;
floo_rsp_t [4:0] router_right_0_2_rsp_out;
floo_req_t [4:0] router_right_0_2_req_out;
floo_rsp_t [4:0] router_right_0_2_rsp_in;
floo_wide_t [4:0] router_right_0_2_wide_in;
floo_wide_t [4:0] router_right_0_2_wide_out;

    assign router_right_0_2_req_in[0] = router_right_0_3_to_router_right_0_2_req;
    assign router_right_0_2_req_in[1] = router_right_1_2_to_router_right_0_2_req;
    assign router_right_0_2_req_in[2] = router_right_0_1_to_router_right_0_2_req;
    assign router_right_0_2_req_in[3] = '0;
    assign router_right_0_2_req_in[4] = l2_spm_ni_6_to_router_right_0_2_req;

    assign router_right_0_2_to_router_right_0_3_rsp = router_right_0_2_rsp_out[0];
    assign router_right_0_2_to_router_right_1_2_rsp = router_right_0_2_rsp_out[1];
    assign router_right_0_2_to_router_right_0_1_rsp = router_right_0_2_rsp_out[2];
    assign router_right_0_2_to_l2_spm_ni_6_rsp = router_right_0_2_rsp_out[4];

    assign router_right_0_2_to_router_right_0_3_req = router_right_0_2_req_out[0];
    assign router_right_0_2_to_router_right_1_2_req = router_right_0_2_req_out[1];
    assign router_right_0_2_to_router_right_0_1_req = router_right_0_2_req_out[2];
    assign router_right_0_2_to_l2_spm_ni_6_req = router_right_0_2_req_out[4];

    assign router_right_0_2_rsp_in[0] = router_right_0_3_to_router_right_0_2_rsp;
    assign router_right_0_2_rsp_in[1] = router_right_1_2_to_router_right_0_2_rsp;
    assign router_right_0_2_rsp_in[2] = router_right_0_1_to_router_right_0_2_rsp;
    assign router_right_0_2_rsp_in[3] = '0;
    assign router_right_0_2_rsp_in[4] = l2_spm_ni_6_to_router_right_0_2_rsp;

    assign router_right_0_2_wide_in[0] = router_right_0_3_to_router_right_0_2_wide;
    assign router_right_0_2_wide_in[1] = router_right_1_2_to_router_right_0_2_wide;
    assign router_right_0_2_wide_in[2] = router_right_0_1_to_router_right_0_2_wide;
    assign router_right_0_2_wide_in[3] = '0;
    assign router_right_0_2_wide_in[4] = l2_spm_ni_6_to_router_right_0_2_wide;

    assign router_right_0_2_to_router_right_0_3_wide = router_right_0_2_wide_out[0];
    assign router_right_0_2_to_router_right_1_2_wide = router_right_0_2_wide_out[1];
    assign router_right_0_2_to_router_right_0_1_wide = router_right_0_2_wide_out[2];
    assign router_right_0_2_to_l2_spm_ni_6_wide = router_right_0_2_wide_out[4];

  localparam id_t ROUTER_RIGHT_0_2_ID = '{x: 8, y: 2, port_id: 0};

floo_nw_router #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .CollectiveCfg(RouteCfg.CollectiveCfg),
  .red_wide_req_t(red_wide_req_t),
  .red_wide_rsp_t(red_wide_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) router_right_0_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i (ROUTER_RIGHT_0_2_ID),
  .id_route_map_i ('0),
  .floo_req_i (router_right_0_2_req_in),
  .floo_rsp_o (router_right_0_2_rsp_out),
  .floo_req_o (router_right_0_2_req_out),
  .floo_rsp_i (router_right_0_2_rsp_in),
  .floo_wide_i (router_right_0_2_wide_in),
  .floo_wide_o (router_right_0_2_wide_out)
);


floo_req_t [4:0] router_right_0_3_req_in;
floo_rsp_t [4:0] router_right_0_3_rsp_out;
floo_req_t [4:0] router_right_0_3_req_out;
floo_rsp_t [4:0] router_right_0_3_rsp_in;
floo_wide_t [4:0] router_right_0_3_wide_in;
floo_wide_t [4:0] router_right_0_3_wide_out;

    assign router_right_0_3_req_in[0] = '0;
    assign router_right_0_3_req_in[1] = router_right_1_3_to_router_right_0_3_req;
    assign router_right_0_3_req_in[2] = router_right_0_2_to_router_right_0_3_req;
    assign router_right_0_3_req_in[3] = '0;
    assign router_right_0_3_req_in[4] = l2_spm_ni_7_to_router_right_0_3_req;

    assign router_right_0_3_to_router_right_1_3_rsp = router_right_0_3_rsp_out[1];
    assign router_right_0_3_to_router_right_0_2_rsp = router_right_0_3_rsp_out[2];
    assign router_right_0_3_to_l2_spm_ni_7_rsp = router_right_0_3_rsp_out[4];

    assign router_right_0_3_to_router_right_1_3_req = router_right_0_3_req_out[1];
    assign router_right_0_3_to_router_right_0_2_req = router_right_0_3_req_out[2];
    assign router_right_0_3_to_l2_spm_ni_7_req = router_right_0_3_req_out[4];

    assign router_right_0_3_rsp_in[0] = '0;
    assign router_right_0_3_rsp_in[1] = router_right_1_3_to_router_right_0_3_rsp;
    assign router_right_0_3_rsp_in[2] = router_right_0_2_to_router_right_0_3_rsp;
    assign router_right_0_3_rsp_in[3] = '0;
    assign router_right_0_3_rsp_in[4] = l2_spm_ni_7_to_router_right_0_3_rsp;

    assign router_right_0_3_wide_in[0] = '0;
    assign router_right_0_3_wide_in[1] = router_right_1_3_to_router_right_0_3_wide;
    assign router_right_0_3_wide_in[2] = router_right_0_2_to_router_right_0_3_wide;
    assign router_right_0_3_wide_in[3] = '0;
    assign router_right_0_3_wide_in[4] = l2_spm_ni_7_to_router_right_0_3_wide;

    assign router_right_0_3_to_router_right_1_3_wide = router_right_0_3_wide_out[1];
    assign router_right_0_3_to_router_right_0_2_wide = router_right_0_3_wide_out[2];
    assign router_right_0_3_to_l2_spm_ni_7_wide = router_right_0_3_wide_out[4];

  localparam id_t ROUTER_RIGHT_0_3_ID = '{x: 8, y: 3, port_id: 0};

floo_nw_router #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .CollectiveCfg(RouteCfg.CollectiveCfg),
  .red_wide_req_t(red_wide_req_t),
  .red_wide_rsp_t(red_wide_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) router_right_0_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i (ROUTER_RIGHT_0_3_ID),
  .id_route_map_i ('0),
  .floo_req_i (router_right_0_3_req_in),
  .floo_rsp_o (router_right_0_3_rsp_out),
  .floo_req_o (router_right_0_3_req_out),
  .floo_rsp_i (router_right_0_3_rsp_in),
  .floo_wide_i (router_right_0_3_wide_in),
  .floo_wide_o (router_right_0_3_wide_out)
);


floo_req_t [4:0] router_right_1_0_req_in;
floo_rsp_t [4:0] router_right_1_0_rsp_out;
floo_req_t [4:0] router_right_1_0_req_out;
floo_rsp_t [4:0] router_right_1_0_rsp_in;
floo_wide_t [4:0] router_right_1_0_wide_in;
floo_wide_t [4:0] router_right_1_0_wide_out;

    assign router_right_1_0_req_in[0] = router_right_1_1_to_router_right_1_0_req;
    assign router_right_1_0_req_in[1] = '0;
    assign router_right_1_0_req_in[2] = '0;
    assign router_right_1_0_req_in[3] = router_right_0_0_to_router_right_1_0_req;
    assign router_right_1_0_req_in[4] = fhg_spu_ni_to_router_right_1_0_req;

    assign router_right_1_0_to_router_right_1_1_rsp = router_right_1_0_rsp_out[0];
    assign router_right_1_0_to_router_right_0_0_rsp = router_right_1_0_rsp_out[3];
    assign router_right_1_0_to_fhg_spu_ni_rsp = router_right_1_0_rsp_out[4];

    assign router_right_1_0_to_router_right_1_1_req = router_right_1_0_req_out[0];
    assign router_right_1_0_to_router_right_0_0_req = router_right_1_0_req_out[3];
    assign router_right_1_0_to_fhg_spu_ni_req = router_right_1_0_req_out[4];

    assign router_right_1_0_rsp_in[0] = router_right_1_1_to_router_right_1_0_rsp;
    assign router_right_1_0_rsp_in[1] = '0;
    assign router_right_1_0_rsp_in[2] = '0;
    assign router_right_1_0_rsp_in[3] = router_right_0_0_to_router_right_1_0_rsp;
    assign router_right_1_0_rsp_in[4] = fhg_spu_ni_to_router_right_1_0_rsp;

    assign router_right_1_0_wide_in[0] = router_right_1_1_to_router_right_1_0_wide;
    assign router_right_1_0_wide_in[1] = '0;
    assign router_right_1_0_wide_in[2] = '0;
    assign router_right_1_0_wide_in[3] = router_right_0_0_to_router_right_1_0_wide;
    assign router_right_1_0_wide_in[4] = fhg_spu_ni_to_router_right_1_0_wide;

    assign router_right_1_0_to_router_right_1_1_wide = router_right_1_0_wide_out[0];
    assign router_right_1_0_to_router_right_0_0_wide = router_right_1_0_wide_out[3];
    assign router_right_1_0_to_fhg_spu_ni_wide = router_right_1_0_wide_out[4];

  localparam id_t ROUTER_RIGHT_1_0_ID = '{x: 9, y: 0, port_id: 0};

floo_nw_router #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .CollectiveCfg(RouteCfg.CollectiveCfg),
  .red_wide_req_t(red_wide_req_t),
  .red_wide_rsp_t(red_wide_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) router_right_1_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i (ROUTER_RIGHT_1_0_ID),
  .id_route_map_i ('0),
  .floo_req_i (router_right_1_0_req_in),
  .floo_rsp_o (router_right_1_0_rsp_out),
  .floo_req_o (router_right_1_0_req_out),
  .floo_rsp_i (router_right_1_0_rsp_in),
  .floo_wide_i (router_right_1_0_wide_in),
  .floo_wide_o (router_right_1_0_wide_out)
);


floo_req_t [4:0] router_right_1_1_req_in;
floo_rsp_t [4:0] router_right_1_1_rsp_out;
floo_req_t [4:0] router_right_1_1_req_out;
floo_rsp_t [4:0] router_right_1_1_rsp_in;
floo_wide_t [4:0] router_right_1_1_wide_in;
floo_wide_t [4:0] router_right_1_1_wide_out;

    assign router_right_1_1_req_in[0] = router_right_1_2_to_router_right_1_1_req;
    assign router_right_1_1_req_in[1] = '0;
    assign router_right_1_1_req_in[2] = router_right_1_0_to_router_right_1_1_req;
    assign router_right_1_1_req_in[3] = router_right_0_1_to_router_right_1_1_req;
    assign router_right_1_1_req_in[4] = top_spm_wide_ni_to_router_right_1_1_req;

    assign router_right_1_1_to_router_right_1_2_rsp = router_right_1_1_rsp_out[0];
    assign router_right_1_1_to_router_right_1_0_rsp = router_right_1_1_rsp_out[2];
    assign router_right_1_1_to_router_right_0_1_rsp = router_right_1_1_rsp_out[3];
    assign router_right_1_1_to_top_spm_wide_ni_rsp = router_right_1_1_rsp_out[4];

    assign router_right_1_1_to_router_right_1_2_req = router_right_1_1_req_out[0];
    assign router_right_1_1_to_router_right_1_0_req = router_right_1_1_req_out[2];
    assign router_right_1_1_to_router_right_0_1_req = router_right_1_1_req_out[3];
    assign router_right_1_1_to_top_spm_wide_ni_req = router_right_1_1_req_out[4];

    assign router_right_1_1_rsp_in[0] = router_right_1_2_to_router_right_1_1_rsp;
    assign router_right_1_1_rsp_in[1] = '0;
    assign router_right_1_1_rsp_in[2] = router_right_1_0_to_router_right_1_1_rsp;
    assign router_right_1_1_rsp_in[3] = router_right_0_1_to_router_right_1_1_rsp;
    assign router_right_1_1_rsp_in[4] = top_spm_wide_ni_to_router_right_1_1_rsp;

    assign router_right_1_1_wide_in[0] = router_right_1_2_to_router_right_1_1_wide;
    assign router_right_1_1_wide_in[1] = '0;
    assign router_right_1_1_wide_in[2] = router_right_1_0_to_router_right_1_1_wide;
    assign router_right_1_1_wide_in[3] = router_right_0_1_to_router_right_1_1_wide;
    assign router_right_1_1_wide_in[4] = top_spm_wide_ni_to_router_right_1_1_wide;

    assign router_right_1_1_to_router_right_1_2_wide = router_right_1_1_wide_out[0];
    assign router_right_1_1_to_router_right_1_0_wide = router_right_1_1_wide_out[2];
    assign router_right_1_1_to_router_right_0_1_wide = router_right_1_1_wide_out[3];
    assign router_right_1_1_to_top_spm_wide_ni_wide = router_right_1_1_wide_out[4];

  localparam id_t ROUTER_RIGHT_1_1_ID = '{x: 9, y: 1, port_id: 0};

floo_nw_router #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .CollectiveCfg(RouteCfg.CollectiveCfg),
  .red_wide_req_t(red_wide_req_t),
  .red_wide_rsp_t(red_wide_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) router_right_1_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i (ROUTER_RIGHT_1_1_ID),
  .id_route_map_i ('0),
  .floo_req_i (router_right_1_1_req_in),
  .floo_rsp_o (router_right_1_1_rsp_out),
  .floo_req_o (router_right_1_1_req_out),
  .floo_rsp_i (router_right_1_1_rsp_in),
  .floo_wide_i (router_right_1_1_wide_in),
  .floo_wide_o (router_right_1_1_wide_out)
);


floo_req_t [4:0] router_right_1_2_req_in;
floo_rsp_t [4:0] router_right_1_2_rsp_out;
floo_req_t [4:0] router_right_1_2_req_out;
floo_rsp_t [4:0] router_right_1_2_rsp_in;
floo_wide_t [4:0] router_right_1_2_wide_in;
floo_wide_t [4:0] router_right_1_2_wide_out;

    assign router_right_1_2_req_in[0] = router_right_1_3_to_router_right_1_2_req;
    assign router_right_1_2_req_in[1] = '0;
    assign router_right_1_2_req_in[2] = router_right_1_1_to_router_right_1_2_req;
    assign router_right_1_2_req_in[3] = router_right_0_2_to_router_right_1_2_req;
    assign router_right_1_2_req_in[4] = top_spm_narrow_ni_to_router_right_1_2_req;

    assign router_right_1_2_to_router_right_1_3_rsp = router_right_1_2_rsp_out[0];
    assign router_right_1_2_to_router_right_1_1_rsp = router_right_1_2_rsp_out[2];
    assign router_right_1_2_to_router_right_0_2_rsp = router_right_1_2_rsp_out[3];
    assign router_right_1_2_to_top_spm_narrow_ni_rsp = router_right_1_2_rsp_out[4];

    assign router_right_1_2_to_router_right_1_3_req = router_right_1_2_req_out[0];
    assign router_right_1_2_to_router_right_1_1_req = router_right_1_2_req_out[2];
    assign router_right_1_2_to_router_right_0_2_req = router_right_1_2_req_out[3];
    assign router_right_1_2_to_top_spm_narrow_ni_req = router_right_1_2_req_out[4];

    assign router_right_1_2_rsp_in[0] = router_right_1_3_to_router_right_1_2_rsp;
    assign router_right_1_2_rsp_in[1] = '0;
    assign router_right_1_2_rsp_in[2] = router_right_1_1_to_router_right_1_2_rsp;
    assign router_right_1_2_rsp_in[3] = router_right_0_2_to_router_right_1_2_rsp;
    assign router_right_1_2_rsp_in[4] = top_spm_narrow_ni_to_router_right_1_2_rsp;

    assign router_right_1_2_wide_in[0] = router_right_1_3_to_router_right_1_2_wide;
    assign router_right_1_2_wide_in[1] = '0;
    assign router_right_1_2_wide_in[2] = router_right_1_1_to_router_right_1_2_wide;
    assign router_right_1_2_wide_in[3] = router_right_0_2_to_router_right_1_2_wide;
    assign router_right_1_2_wide_in[4] = top_spm_narrow_ni_to_router_right_1_2_wide;

    assign router_right_1_2_to_router_right_1_3_wide = router_right_1_2_wide_out[0];
    assign router_right_1_2_to_router_right_1_1_wide = router_right_1_2_wide_out[2];
    assign router_right_1_2_to_router_right_0_2_wide = router_right_1_2_wide_out[3];
    assign router_right_1_2_to_top_spm_narrow_ni_wide = router_right_1_2_wide_out[4];

  localparam id_t ROUTER_RIGHT_1_2_ID = '{x: 9, y: 2, port_id: 0};

floo_nw_router #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .CollectiveCfg(RouteCfg.CollectiveCfg),
  .red_wide_req_t(red_wide_req_t),
  .red_wide_rsp_t(red_wide_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) router_right_1_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i (ROUTER_RIGHT_1_2_ID),
  .id_route_map_i ('0),
  .floo_req_i (router_right_1_2_req_in),
  .floo_rsp_o (router_right_1_2_rsp_out),
  .floo_req_o (router_right_1_2_req_out),
  .floo_rsp_i (router_right_1_2_rsp_in),
  .floo_wide_i (router_right_1_2_wide_in),
  .floo_wide_o (router_right_1_2_wide_out)
);


floo_req_t [4:0] router_right_1_3_req_in;
floo_rsp_t [4:0] router_right_1_3_rsp_out;
floo_req_t [4:0] router_right_1_3_req_out;
floo_rsp_t [4:0] router_right_1_3_rsp_in;
floo_wide_t [4:0] router_right_1_3_wide_in;
floo_wide_t [4:0] router_right_1_3_wide_out;

    assign router_right_1_3_req_in[0] = '0;
    assign router_right_1_3_req_in[1] = '0;
    assign router_right_1_3_req_in[2] = router_right_1_2_to_router_right_1_3_req;
    assign router_right_1_3_req_in[3] = router_right_0_3_to_router_right_1_3_req;
    assign router_right_1_3_req_in[4] = cheshire_ni_to_router_right_1_3_req;

    assign router_right_1_3_to_router_right_1_2_rsp = router_right_1_3_rsp_out[2];
    assign router_right_1_3_to_router_right_0_3_rsp = router_right_1_3_rsp_out[3];
    assign router_right_1_3_to_cheshire_ni_rsp = router_right_1_3_rsp_out[4];

    assign router_right_1_3_to_router_right_1_2_req = router_right_1_3_req_out[2];
    assign router_right_1_3_to_router_right_0_3_req = router_right_1_3_req_out[3];
    assign router_right_1_3_to_cheshire_ni_req = router_right_1_3_req_out[4];

    assign router_right_1_3_rsp_in[0] = '0;
    assign router_right_1_3_rsp_in[1] = '0;
    assign router_right_1_3_rsp_in[2] = router_right_1_2_to_router_right_1_3_rsp;
    assign router_right_1_3_rsp_in[3] = router_right_0_3_to_router_right_1_3_rsp;
    assign router_right_1_3_rsp_in[4] = cheshire_ni_to_router_right_1_3_rsp;

    assign router_right_1_3_wide_in[0] = '0;
    assign router_right_1_3_wide_in[1] = '0;
    assign router_right_1_3_wide_in[2] = router_right_1_2_to_router_right_1_3_wide;
    assign router_right_1_3_wide_in[3] = router_right_0_3_to_router_right_1_3_wide;
    assign router_right_1_3_wide_in[4] = cheshire_ni_to_router_right_1_3_wide;

    assign router_right_1_3_to_router_right_1_2_wide = router_right_1_3_wide_out[2];
    assign router_right_1_3_to_router_right_0_3_wide = router_right_1_3_wide_out[3];
    assign router_right_1_3_to_cheshire_ni_wide = router_right_1_3_wide_out[4];

  localparam id_t ROUTER_RIGHT_1_3_ID = '{x: 9, y: 3, port_id: 0};

floo_nw_router #(
  .AxiCfgN(AxiCfgN),
  .AxiCfgW(AxiCfgW),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .WideRwDecouple(WideRwDecouple),
  .VcImpl(VcImpl),
  .CollectiveCfg(RouteCfg.CollectiveCfg),
  .red_wide_req_t(red_wide_req_t),
  .red_wide_rsp_t(red_wide_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t),
  .floo_wide_t(floo_wide_t)
) router_right_1_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i (ROUTER_RIGHT_1_3_ID),
  .id_route_map_i ('0),
  .floo_req_i (router_right_1_3_req_in),
  .floo_rsp_o (router_right_1_3_rsp_out),
  .floo_req_o (router_right_1_3_req_out),
  .floo_rsp_i (router_right_1_3_rsp_in),
  .floo_wide_i (router_right_1_3_wide_in),
  .floo_wide_o (router_right_1_3_wide_out)
);



endmodule
