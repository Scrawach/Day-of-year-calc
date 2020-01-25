////////////////////////////////
// ----------
// Module : day_of_year_calc.sv
// Author : Kuznetsov Aleksander
// Date   : January 25, 2020
// ----------
// Description:
// ----------
// DAY OF YEAR CALCULATOR:
// Given the month (1-12), year(0-2047) and day of month (1-31).
// Module return the day number of the year (1-366).
// It correct work with leap years, without divide.
// ...
// EXAMPLE: 1 February, 2020 (month = 2, year = 2020, day of month = 1)
// ANSWER: 32 day of year.  
// ----------
////////////////////////////////
module day_of_year_calc
(                                  // Range for correct work:
 input  logic [5:0]  day_of_month, // from 1 to 31
 input  logic [3:0]  month,        // from 1 to 12
 input  logic [10:0] year,         // from 0 to 2020
 output logic [8:0]  day_of_year   // from 1 to 366
 );

   // ----------
   // internal logic variable's
   logic [8:0] 	    month_offset;
   logic 	    is_leap_year;
   logic 	    leap_day;

   // ----------
   // module implementation
   // ROM storage offset for month's
   always_comb begin
      unique case ( month )
	4'd1: month_offset  = 0;   // January   (+0 )
	4'd2: month_offset  = 31;  // February  (+31)
	4'd3: month_offset  = 59;  // March     (+28)
	4'd4: month_offset  = 90;  // April     (+31)
	4'd5: month_offset  = 120; // May       (+30)
	4'd6: month_offset  = 151; // Juny      (+31)
	4'd7: month_offset  = 181; // July      (+30)
	4'd8: month_offset  = 212; // August    (+31)
	4'd9: month_offset  = 243; // September (+31)
	4'd10: month_offset = 273; // October   (+30)
	4'd11: month_offset = 304; // November  (+31)
	4'd12: month_offset = 334; // December  (+30)
      endcase
   end // always_comb

   // ----------
   // ROM storage years divinded on 100
   always_comb begin
      case ( year[10:2] )
	9'b000_0110_01,   // Num 100 in bin
        9'b000_1100_10,   // Num 200 in bin
	9'b001_0010_11,   // Num 300 in bin
	9'b001_1111_01,   // Num 500 in bin
        9'b010_0101_10,   // Num 600 in bin
	9'b010_1011_11,   // Num 700 in bin
        9'b011_1000_01,   // Num 900 in bin
	9'b011_1110_10,   // Num 1000 in bin
        9'b100_0100_11,   // Num 1100 in bin
	9'b101_0001_01,   // Num 1300 in bin
        9'b101_0111_10,   // Num 1400 in bin
	9'b101_1101_11,   // Num 1500 in bin
        9'b110_1010_01,   // Num 1700 in bin
	9'b111_0000_10,   // Num 1800 in bin
        9'b111_0110_11:   // Num 1900 in bin
	  is_leap_year = 0;
	default:
	  is_leap_year = ( year[1:0] == 2'b00 );
      endcase
   end

   // ----------
   // If now is leap year, then use leap_day for calculating
   assign leap_day = ( month > 2 && is_leap_year ) ? 1'b1 : 1'b0;
   
   // ----------
   // Calculating day of year with leap day
   assign day_of_year = month_offset + day_of_month + leap_day;
   
   
endmodule // day_of_calc
