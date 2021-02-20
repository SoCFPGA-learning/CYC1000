-- S3 : NightRider

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity S3 is
port(		mode   : in std_logic_vector(1 downto 0);
			enable 	 : in std_logic;
			clock 	 : in std_logic;
			reset_n   : in std_logic;
			pwm1      : in std_logic;
			pwm2      : in std_logic;
			LED		 : out std_logic_vector(7 downto 0)
);
end entity;

architecture rtl of S3 is

type state_types is (start, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10);
signal cs, ns: state_types;
signal dir : std_logic := '0';

begin

-- next / current state
process(clock, reset_n)
begin
if reset_n = '0' or mode /= "10" then	
	cs <= state_types'left;
elsif clock'event and clock = '1' then	
	if enable = '1' then
		cs <= ns;
	end if;
end if;
end process;


-- direction toggled when LED(0) or LED(7) reached
dir <= '0' when cs = f1  else '1' when cs = f10;


-- FSM
-- LED output based on state and direction
-- three LEDS, each with different brightness
process(cs, dir, pwm1, pwm2)
begin

if mode = "10" then

case cs is

	when start =>		ns <= f1;
							LED <= "00000000";
							
	when f1    =>		LED <= "0000000" & '1';
							if dir = '0' then
								ns <= f2;
							end if;
							
	when f2    =>		if dir = '0' then
								LED <= "000000" & '1' & pwm1;
								ns <= f3;
							else
								LED <= "000000" & pwm1 & '1';
								ns <= f1;
							end if;
							
	when f3    =>		if dir = '0' then
								LED <= "00000" & '1' & pwm1 & pwm2;
								ns <= f4;
							else
								LED <= "00000" & pwm2 & pwm1 & '1';
								ns <= f2;
							end if;

	when f4    =>		if dir = '0' then
								LED <= "0000" & '1' & pwm1 & pwm2 & '0';
								ns <= f5;
							else
								LED <= "0000" & pwm2 & pwm1 & '1' & '0';
								ns <= f3;
							end if;
	
	when f5    =>		if dir = '0' then
								LED <= "000" & '1' & pwm1 & pwm2 & "00";
								ns <= f6;
							else
								LED <= "000" & pwm2 & pwm1 & '1' & "00";
								ns <= f4;
							end if;
								
	when f6    =>		if dir = '0' then
								LED <= "00" & '1' & pwm1 & pwm2 & "000";
								ns <= f7;
							else
								LED <= "00" & pwm2 & pwm1 & '1' & "000";
								ns <= f5;
							end if;
					
			
	when f7    =>		if dir = '0' then
								LED <= '0' & '1' & pwm1 & pwm2 & "0000";
								ns <= f8;
							else
								LED <= '0' & pwm2 & pwm1 & '1' & "0000";
								ns <= f6;
							end if;
					
	when f8    =>		if dir = '0' then
								LED <=  '1' & pwm1 & pwm2 & "00000";
								ns <= f9;
							else
								LED <=  pwm2 & pwm1 & '1' & "00000";
								ns <= f7;
							end if;
							
	when f9    =>		if dir = '0' then
								LED <=  '1' & pwm1 & "000000";
								ns <= f10;
							else
								LED <=  pwm1 & '1' & "000000";
								ns <= f8;
							end if;
	
	when f10    =>		LED <=  '1' &  "0000000";
							ns <= f9;
	
	when others =>    LED <= "00000000";
							ns <= start;
end case;

end if;

end process;



end architecture;