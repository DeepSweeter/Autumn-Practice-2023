`ifndef INTERFACE_IN
  `include "interface_in.sv"
	`define INTERFACE_IN
`endif

`ifndef INTERFACE_OUT
  `include "interface_out.sv"
	`define INTERFACE_OUT
`endif

`ifndef INTERFACE_INTERN
  `include "interface_intern.sv"
	`define INTERFACE_INTERN
`endif

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

`ifndef GENERATOR
  `include "generator.sv"
	`define GENERATOR
`endif

`ifndef SCOREBOARD
  `include "scoreboard.sv"
	`define SCOREBOARD
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

`ifndef ENVIRONMENT
  `include "environment.sv"
	`define ENVIRONMENT
`endif

`ifndef TEST
  `include "test.sv"
	`define TEST
`endif