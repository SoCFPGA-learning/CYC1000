-- Clock Divisor
-- Frequency output : 12MHz / count_max
-- Configurable through generics

library ieee;
use ieee.std_logic_1164.all; 

entity clock_div is
generic( count_max  : integer := 1_000_000);
port(	   clock_in  : in std_logic;
			reset     : in std_logic;
			clock_out : out std_logic
       );
end entity;

architecture behavior of clock_div  is
signal cnt : integer range 0 to count_max;
begin
  process(reset,clock_in)
    begin
      if reset = '0' then
        cnt <= 0;
      elsif clock_in'event and clock_in = '1' then
        if cnt = (count_max-1) then  
          cnt <= 0;
        else
          cnt <= cnt + 1;
        end if; 
      end if;
    end process;
    
    clock_out <= '0' when cnt < (count_max/2) else '1'; 
    
  end architecture;
