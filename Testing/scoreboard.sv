`ifndef PACKAGE_IN
  `include "package_in.sv"
	`define PACKAGE_IN
`endif

`ifndef PACKAGE_OUT
  `include "package_out.sv"
	`define PACKAGE_OUT
`endif

`ifndef PACKAGE_INTERN
  `include "package_intern.sv"
	`define PACKAGE_INTERN
`endif




class scoreboard;
  mailbox scb_output_mbx;
  mailbox scb_input_mbx;
   mailbox scb_intern_mbx;
  int counter;
  int SampleData;

      
  
  task run();
    $display("T=%0t [SCOREBOARD] starting... ", $time);
	counter = 0;
    SampleData = 0;
    forever begin
      dut_package_in pkg_in;
      dut_package_out pkg_out;
      dut_package_intern pkg_intern;
      
      scb_output_mbx.get(pkg_out);
      scb_input_mbx.get(pkg_in);
      scb_intern_mbx.get(pkg_intern);
      
      pkg_in.print("SCOREBOARD");
      pkg_out.print("SCOREBOARD");
      pkg_intern.print("SCOREBOARD");
      
//      sequence SampleToTransfer;
//       @(posedge pkg_intern.Clk) pkg_intern.SampleData |=> pkg_intern.TransferData;
//     endsequence

//      assert property(SampleToTransfer);
//       @(posedge pkg_intern.Clk);
      if(counter == 0)begin
        if(pkg_intern.SampleData) begin
        SampleData = pkg_intern.SampleData;
        counter = counter + 1;
        end
      end
      else if(counter == 1) begin 
        if(SampleData)begin
          if(pkg_intern.TransferData) begin
            $display("[SCOREBOARD-PASS]SampleData = %0h,\n \t TrasnferData at next clock :: Expected = %0h Actual = %0h",SampleData, SampleData, pkg_intern.TransferData );
            counter = 0;
          end
          else begin
            $error("[SCOREBOARD-FAIL] SampleData = %0h,\n \t TrasnferData at next clock :: Expected = %0h Actual = %0h",SampleData, SampleData, pkg_intern.TransferData);
            counter = 0;
          end
        end
      end
      
      
    end
    

  endtask
  
endclass