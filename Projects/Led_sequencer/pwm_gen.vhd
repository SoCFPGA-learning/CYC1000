-- PWM Generator
-- Generates a PWM signal with adjustable duty cycle
library ieee;
use ieee.std_logic_1164.all;

entity pwm_gen is
generic( duty_cycle : integer;
			count_max  : integer := 100_00);
port (	clock		: in std_logic;
			reset_n  : in std_logic;
			pwm_out	: out std_logic
);
end entity;

architecture rtl of pwm_gen is
begin

process (clock, reset_n)
variable count : integer range 0 to count_max;
begin
	if reset_n = '0' then
		count := 0;
		pwm_out <= '0';

	elsif	rising_edge(clock) then
		count := count + 1;				-- increase count
		if count = duty_cycle then		-- if count reaches duty cycle value pwm = 1
			pwm_out <= '1';
		end if;
	
		if count = count_max then		-- if count reaches max count value pwm = 0
			pwm_out <= '0';
			count := 0;
		end if;		
	end if;
		
end process;

end architecture;