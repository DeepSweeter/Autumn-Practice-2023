`ifndef GENERATOR
  `include "generator.sv"
	`define GENERATOR
`endif

`ifndef DRIVER
  `include "driver.sv"
	`define DRIVER
`endif

`ifndef MONITOR_IN
  `include "monitor_in.sv"
	`define MONITOR_IN
`endif

`ifndef MONITOR_OUT
  `include "monitor_out.sv"
	`define MONITOR_OUT
`endif

`ifndef MONITOR_INTERN
  `include "monitor_intern.sv"
	`define MONITOR_INTERN
`endif

`ifndef SCOREBOARD
  `include "scoreboard.sv"
	`define SCOREBOARD
`endif


class env;
  driver d0;
  monitor_input m_i0;
  monitor_output m_o0;
  monitor_intern m_int0;
  generator g0;
  scoreboard s0;
  
  mailbox drv_mbx;
  mailbox scb_input_mbx;
  mailbox scb_output_mbx;
  mailbox scb_intern_mbx;
  event drv_done;
  
  virtual inputData interfaceID;
  virtual outputData interfaceOD;
  virtual interface_Intern interfaceInt;
  
  function new();
    d0 = new;
    m_i0 = new;
    m_o0 = new;
    m_int0 = new;
    g0 = new;
    s0 = new;
    drv_mbx = new();
    scb_input_mbx = new();
    scb_output_mbx = new();
    scb_intern_mbx = new();
    
    d0.drv_mbx = drv_mbx;
    g0.drv_mbx = drv_mbx;
    m_i0.scb_input_mbx = scb_input_mbx;
    m_o0.scb_output_mbx = scb_output_mbx;
    m_int0.scb_intern_mbx = scb_intern_mbx;
    
    s0.scb_output_mbx = scb_output_mbx;
    s0.scb_input_mbx = scb_input_mbx;
    s0.scb_intern_mbx = scb_intern_mbx;
    d0.drv_done = drv_done;
    g0.drv_done = drv_done;
    
    
  endfunction
  
  virtual task run();
    d0.interfaceID = interfaceID;
    m_i0.interfaceID = interfaceID;
    m_o0.interfaceOD = interfaceOD;
    m_int0.interfaceInt = interfaceInt;
    
    fork
      d0.run();
      g0.run();
      m_i0.run();
      m_o0.run();
      m_int0.run();
      s0.run();
    join_any
  endtask

  
  
endclass