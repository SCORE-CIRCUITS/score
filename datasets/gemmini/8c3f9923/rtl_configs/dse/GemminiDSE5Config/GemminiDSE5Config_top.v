// Top-level module for GemminiDSE5Config configuration
// Generated on Sun Nov 15 09:07:36 AM +08 2026
// Gemmini dse accelerator

module GemminiDSE5Config_top (
    input  clk,
    input  rst_n,
    output ready
);

    // Configuration parameters
    parameter CORE_TYPE = "dse";
    
    // Simple ready signal for synthesis
    reg ready_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            ready_reg <= 1'b0;
        else
            ready_reg <= 1'b1;
    end
    
    assign ready = ready_reg;

endmodule
