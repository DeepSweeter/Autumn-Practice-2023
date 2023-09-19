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

`ifndef SBITS
`define SBITS 4
`endif



class scoreboard;
  mailbox scb_output_mbx;
  mailbox scb_input_mbx;
  mailbox scb_intern_mbx;

  //Local variables
  int counter_3Reset;
  int counter_SampleTransfer;
  int counter_SecretPhrase;



  //Actual values
  int SampleData;
  logic [3:0] Seq;


  //Supposed values

  int Active; // Until checking the secret phrase we'll suppose it's always 1
  int ExpectedTransfer, ExpectedSample;



  task run();
    $display("T=%0t [SCOREBOARD] starting... ", $time);
    counter_3Reset = 0;
    counter_SecretPhrase = 0;
    SampleData = 0;
    counter_SampleTransfer = 0;
    Active = 0;
    Seq = 4'b0;
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

      check_3Reset(counter_3Reset, pkg_in.Reset, pkg_out);

      check_SampleTransfer(pkg_in, pkg_intern, Active, SampleData, counter_SampleTransfer, ExpectedSample, ExpectedTransfer);
      
      check_SecretPhrase(pkg_in ,counter_SecretPhrase, Seq, Active);

      $display("T=%0t Counter = %0h , ValidCmd = %0h ,InputKey = %0h, Sequence= %4b, Active = %0h", $time, counter_SecretPhrase, pkg_in.ValidCmd, pkg_in.InputKey, Seq, Active);
    end


  endtask

  function automatic void check_3Reset(ref int counter, bit Reset,dut_package_out pkg_out);
    if(Reset)begin
      counter = counter + 1;
      if(counter == 3)begin
        check1: assert({pkg_out.CalcBusy, pkg_out.ClkTx, pkg_out.DoutValid, pkg_out.DataOut} == 7'b00z_zzzz) begin

          $display("[SCOREBOARD-PASS] Reset = %0h for 3 consecutive clocks,\n \t CalcBusy:: Expected = 0 Actual = %0h,\n \t ClkTx:: Expected = 0 Actual = %0h,\n \t DoutValid:: Expected = z Actual = %0h,\n \t DataOut:: Expected = 4'bzzzz Actual = %0h",Reset, pkg_out.CalcBusy, pkg_out.ClkTx, pkg_out.DoutValid, pkg_out.DataOut);
        end
        else begin
          $error("[SCOREBOARD-ERROR] Reset = 1 for 3 consecutive clocks,\n \t CalcBusy:: Expected = 0 Actual = %0h,\n \t ClkTx:: Expected = 0 Actual = %0h,\n \t DoutValid:: Expected = z Actual = %0h,\n \t DataOut:: Expected = zzzz Actual = %0h,\n \t", pkg_out.CalcBusy, pkg_out.ClkTx, pkg_out.DoutValid, pkg_out.DataOut);
        end
        counter = 0;
      end 
    end
    else
      counter = 0;
  endfunction


  function automatic void check_SampleTransfer(dut_package_in pkg_in, dut_package_intern pkg_intern, int Active, ref int SavedSample, ref int counter, ref int ExpectedSample, ref int ExpectedTransfer);

    if(!pkg_in.Reset)begin
      
      if(counter == 0) begin
        if(Active && ~pkg_in.InputKey && pkg_in.ValidCmd)begin
          SavedSample = pkg_intern.SampleData;
          ExpectedSample = 1'b1;
          if(SavedSample == ExpectedSample)
          	counter = counter + 1;
        end
        
        else if(pkg_in.ValidCmd && pkg_in.InputKey && ~pkg_in.RW && Active)
          counter = counter + 1;       
      end
      
      else if(counter == 1)begin
        
        if(Active && ~pkg_in.InputKey) begin
          ExpectedTransfer = 1;
          checkSampleTransfer1: assert(ExpectedTransfer == pkg_intern.TransferData ) begin
            $display("[SCOREBOARD-PASS]SampleDataExpected = %0h SampleDataActual = %0h,\n \t TrasnferData at next clock :: Expected = %0h Actual = %0h",ExpectedSample, SavedSample, ExpectedTransfer, pkg_intern.TransferData);
          end
          
          else begin
            $error("[SCOREBOARD-FAILED]SampleDataExpected = %0h SampleDataActual = %0h,\n \t TrasnferData at next clock :: Expected = %0h Actual = %0h",ExpectedSample, SavedSample, ExpectedTransfer, pkg_intern.TransferData);
          end
          counter = 0;
        end
        
        else if(Active && pkg_in.InputKey)begin
          SavedSample = pkg_intern.SampleData;
          ExpectedSample = 1'b1;
          if(SavedSample == ExpectedSample)
          	counter = counter + 1;
        end
      end
      
      else if(counter == 2) begin
        
        if(Active)begin
          ExpectedTransfer = 1;
          checkSampleTransfer2: assert(ExpectedTransfer == pkg_intern.TransferData ) begin
            $display("[SCOREBOARD-PASS]SampleDataExpected = %0h SampleDataActual = %0h,\n \t TrasnferData at next clock :: Expected = %0h Actual = %0h",ExpectedSample, SavedSample, ExpectedTransfer, pkg_intern.TransferData);
          end
          
          else begin
            $error("[SCOREBOARD-FAILED]SampleDataExpected = %0h SampleDataActual = %0h,\n \t TrasnferData at next clock :: Expected = %0h Actual = %0h",ExpectedSample, SavedSample, ExpectedTransfer, pkg_intern.TransferData);
          end
          counter = 0;
        end
      end
    end

  endfunction


  function automatic void check_SecretPhrase(dut_package_in pkg_in, ref int counter, ref logic[3:0] Seq, ref int Active);
    if(~pkg_in.Reset & pkg_in.ValidCmd & ~Active)begin
      if(counter < 4)begin
        Seq[counter] = pkg_in.InputKey;
        $display("HELLO from SecretPhrase =%4b, InputKey=%0b, Active = %0b", Seq,pkg_in.InputKey,Active);
        counter = counter + 1;
      end
      else if(counter == 4)begin
        if(Seq == 4'b0101)begin
          Active = 1'b1;
          counter =0;
          $display("[SCOREBOARD-PASS] Sequence correct! Calculator Activated\n\t Sequence:: Expected = 4'b0101 // Actual = %4b", Seq);
        end
        else
          $error("[SCOREBOARD-ERROR] Sequence incorrect! Try Again\n\t Sequence:: Expected = 4'b**** // Actual = %4b", Seq);
          counter = 0;
      end
    end

  endfunction




endclass
