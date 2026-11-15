// Top-level module for GemminiBF16DefaultConfig configuration
// Generated on Sun Nov 15 09:07:35 AM +08 2026
// Gemmini bf16 accelerator

module GemminiBF16DefaultConfig_top (
    input  clk,
    input  rst_n,
    output ready
);

    // Configuration parameters
    parameter CORE_TYPE = "bf16";
    
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
