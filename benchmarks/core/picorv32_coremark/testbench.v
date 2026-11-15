`timescale 1 ns / 1 ps

module testbench;
    reg clk = 1;
    reg resetn = 0;
    wire trap;

    always #5 clk = ~clk;

    initial begin
        repeat (100) @(posedge clk);
        resetn <= 1;
    end

    wire mem_valid;
    wire mem_instr;
    wire mem_ready;
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    wire [3:0]  mem_wstrb;
    reg  [31:0] mem_rdata;

    wire mem_la_read;
    wire mem_la_write;
    wire [31:0] mem_la_addr;
    wire [31:0] mem_la_wdata;
    wire [3:0]  mem_la_wstrb;

    picorv32 #(
        .BARREL_SHIFTER(1),
        .ENABLE_FAST_MUL(1),
        .ENABLE_DIV(1),
        .PROGADDR_RESET('h10000),
        .STACKADDR('h10000),
        .ENABLE_COUNTERS(1),
        .ENABLE_COUNTERS64(1)
    ) uut (
        .clk         (clk        ),
        .resetn      (resetn     ),
        .trap        (trap       ),
        .mem_valid   (mem_valid  ),
        .mem_instr   (mem_instr  ),
        .mem_ready   (mem_ready  ),
        .mem_addr    (mem_addr   ),
        .mem_wdata   (mem_wdata  ),
        .mem_wstrb   (mem_wstrb  ),
        .mem_rdata   (mem_rdata  ),
        .mem_la_read (mem_la_read ),
        .mem_la_write(mem_la_write),
        .mem_la_addr (mem_la_addr ),
        .mem_la_wdata(mem_la_wdata),
        .mem_la_wstrb(mem_la_wstrb)
    );

    reg [7:0] memory [0:256*1024-1];
    initial begin
        $readmemh("coremark.hex", memory);
    end

    assign mem_ready = 1;

    always @(posedge clk) begin
        mem_rdata[ 7: 0] <= mem_la_read ? memory[mem_la_addr + 0] : 8'bx;
        mem_rdata[15: 8] <= mem_la_read ? memory[mem_la_addr + 1] : 8'bx;
        mem_rdata[23:16] <= mem_la_read ? memory[mem_la_addr + 2] : 8'bx;
        mem_rdata[31:24] <= mem_la_read ? memory[mem_la_addr + 3] : 8'bx;
        if (mem_la_write) begin
            case (mem_la_addr)
                32'h1000_0000, 32'hc000_0000: begin
                    $write("%c", mem_la_wdata[7:0]);
                    $fflush();
                end
                default: begin
                    if (mem_la_wstrb[0]) memory[mem_la_addr + 0] <= mem_la_wdata[ 7: 0];
                    if (mem_la_wstrb[1]) memory[mem_la_addr + 1] <= mem_la_wdata[15: 8];
                    if (mem_la_wstrb[2]) memory[mem_la_addr + 2] <= mem_la_wdata[23:16];
                    if (mem_la_wstrb[3]) memory[mem_la_addr + 3] <= mem_la_wdata[31:24];
                end
            endcase
        end
    end

    reg [63:0] cycle_count = 0;
    always @(posedge clk) begin
        cycle_count <= cycle_count + 1;
        if (cycle_count % 100000 == 0 && cycle_count > 0) begin
            $display("[TB] Cycle %0d...", cycle_count);
            $fflush();
        end
        if (resetn && trap) begin
            repeat (10) @(posedge clk);
            $display("\nRan for %0d cycles", cycle_count);
            $display("Test complete.");
            $finish;
        end
    end

    // Safety timeout at 100,000,000 cycles
    initial begin
        #1000000000;
        $display("\nERROR: Timeout reached!");
        $finish;
    end

endmodule
