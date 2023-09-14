

class dut_package_in #(int INBITS = 8, int WIDTH = 8);
    randc bit [INBITS-1:0] inA;
    randc bit [INBITS-1:0] inB;
    randc bit [3:0] Sel;
    randc bit [31:0] Din;
    randc bit [WIDTH-1:0] Addr;
    bit InputKey, ValidCmd, RW, ConfigDiv, Reset;

    constraint valid_Din {
        Din <= 32'd4;
    };
    
    function void print(string tag="");
      $display("T=%0t %s inA = 0x%0h inB = 0x%0h sel = 0x%0h Din = 0x%0h, Addr = 0x%0h, ValidCmd = 0x%0h",
        $time, tag, inA, inB, Sel, Din, Addr, ValidCmd);
    endfunction

endclass