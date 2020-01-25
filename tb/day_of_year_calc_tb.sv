////////////////////////////////
// ----------
// Module : day_of_year_calc_tb.sv
// Author : Kuznetsov Aleksander
// Date   : January 25, 2020
// ----------
// Description:
// ----------
// DAY OF YEAR CALCULATOR TESTBENCH
// Simple verification module for day of year calculator
// Testing all correct inputs to module.  
////////////////////////////////
module day_of_year_calc_tb;

   // ----------
   // Local variables
   reg [10:0] 	 year;
   reg [5:0] 	 day_of_month;
   reg [3:0] 	 month;
   reg 		 is_leap_year;
   reg [8:0] 	 exp_day_of_year;
   wire [8:0] 	 day_of_year;

   // ----------
   // DEVICE UNDER TEST
   day_of_year_calc dut( .day_of_month ( day_of_month ),
			 .month        ( month        ),
			 .year         ( year         ),
			 .day_of_year  ( day_of_year  ));

   // ----------
   // Main initial block
   initial begin

      $monitor("YEAR: %4d; MONTH: %2d; DAY OF MONTH: %2d; DAY: %3d", year, month, day_of_month, day_of_year);
      
      for ( year = 1; year < 2047; year++ ) begin
	 // -----
	 for ( month = 1; month < 13; month++ )
	   for ( day_of_month = 1; day_of_month < 32; day_of_month++ ) begin
	      #1;
	      day_calc;
	   end
	 // -----
	 if ( day_of_year != 365 && day_of_year != 366 ) begin
	    $display("WARNING! YEAR CAN CONTAIN ONLY 365 OR 366 DAYS");
	    display_current_state;
	 end
	 
      end

      #1;
      $display("END OF SIMULATION.");
      $finish;
      
   end // initial begin

   // -----------
   // Task's
   // Calculate day of year (programm)
   task day_calc;
      begin
	 is_leap_year = 0;
	 
	 if ( month > 2 ) begin
	    if ( year % 400 == 0 )
	      is_leap_year = 1;
	    else if ( year % 100 == 0 )
	      is_leap_year = 0;
	    else if ( year % 4 == 0 )
	      is_leap_year = 1;
	    else
	      is_leap_year = 0;
	 end

	 exp_day_of_year = dut.month_offset + day_of_month + is_leap_year;

	 if(exp_day_of_year != day_of_year) begin
	    display_current_state;
	 end
      end
   endtask // day_calc

   // ----------
   // Display curren variable's values and stop simulation
   task display_current_state;
      begin
	 $display("Year: %4d; Month: %2d; Day: %2d.", year, month, day_of_year);	    
	 $display("EXP: %3d. GET: %3d.", exp_day_of_year, day_of_year);
	 $stop;
      end
   endtask // display_current_state

endmodule // testbench
