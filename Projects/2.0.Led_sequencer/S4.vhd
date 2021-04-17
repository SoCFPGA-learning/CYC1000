-- Simple PWM sequence

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity S4 is
generic( n  : integer := 11);
port(		mode   : in std_logic_vector(1 downto 0);
			clock 	 : in std_logic;
			enable	 : in std_logic;
			reset_n   : in std_logic;
			LED		 : out std_logic_vector(7 downto 0)
);
end entity;

architecture rtl of S4 is
signal pwm_out 		: std_logic;
signal pulse_pass, flag, pol: std_logic;
signal duty_cycle		: std_logic_vector(n-1 downto 0);
signal cnt				: std_logic_vector(n-1 downto 0);

begin

process(clock) -- Duty Cycle
begin
	if(clock'event and clock = '1') then
		if (enable = '1') then 			-- 1ms Pulse
			if (pol = '0') then 			-- Polarity
				if (duty_cycle < 1249) then
					duty_cycle <= duty_cycle + 1;
					pol <= '0';
				else
					pol <= '1';
				end if;
			else
				if (duty_cycle > 1) then
					duty_cycle <= duty_cycle - 1;
					pol <= '1';
				else
					pol <= '0';
				end if;
			end if;
		end if;
	end if;
end process;

-- Counting
process(clock) 
begin
	if(clock'event and clock = '1') then
		if (cnt < 1249) then
			cnt <= cnt + 1;
		else
			cnt <= (others => '0');
		end if;
	end if;
end process;


process(clock) -- Pulsing
begin
	if(clock'event and clock = '1') then
		if (duty_cycle > cnt) then
			pwm_out <= '1';
		else
			pwm_out <= '0';
		end if;
	end if;
end process;

LED(7 downto 4) <= (others => pwm_out)		 when mode = "11" else (others => '0');
LED(3 downto 0) <= (others => not pwm_out) when mode = "11" else (others => '0');




end architecture;
