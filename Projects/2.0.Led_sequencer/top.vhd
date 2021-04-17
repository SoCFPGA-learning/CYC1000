-- MAX1000 LED Sequencer Implementation
-- 
-- Date : 3/08/2017
--
-- User Button toggles through 4 different LED sequences
--
-- (c) 2017 Arrow Central Europe Gmb

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity top is
port(		CLK12M 	 : in std_logic;
--			RESET_BTN : in std_logic;
			USER_BTN  : in std_logic;
			LED		 : out std_logic_vector(7 downto 0)
);
end entity;

architecture rtl of top is
--##### component declaration
component clock_div 
generic( count_max   : integer := 800_000);
port(		clock_in  	: in std_logic;
			reset   	   : in std_logic;
			clock_out   : out std_logic
);
end component;

-- Differentiator
component differentiator 
port(		clock 	 	: in std_logic;
			reset_n 		: in std_logic;
			data 	 		: in std_logic;
			enable  		: out std_logic
);
end component;

-- Control: Toggles through 4 different LED sequence modes
component control
port(		clock 	 	: in std_logic;
			reset_n   	: in std_logic;
			USER_BTN  	: in std_logic;
			mode   		: out std_logic_vector(1 downto 0)
);
end component;

-- Mode 1
component S1 
port(		mode   		: in std_logic_vector(1 downto 0);
			enable 	 	: in std_logic;
			clock 	 	: in std_logic;
			reset_n   	: in std_logic;
			LED		 	: out std_logic_vector(7 downto 0)
);
end component;

-- Mode 2
component S2
port(		mode   	 	: in std_logic_vector(1 downto 0);
			enable 	 	: in std_logic;
			clock 	 	: in std_logic;
			reset_n   	: in std_logic;
			LED		 	: out std_logic_vector(7 downto 0)
);
end component;

-- Mode 3
component S3
port(		mode   	 	: in std_logic_vector(1 downto 0);
			enable 	 	: in std_logic;
			clock 	 	: in std_logic;
			reset_n   	: in std_logic;
			pwm1      	: in std_logic;
			pwm2      	: in std_logic;
			LED		 	: out std_logic_vector(7 downto 0)
);
end component;

-- Mode 4
component S4
generic( n : integer := 11);
port(		mode   	 	: in std_logic_vector(1 downto 0);
			clock 	 	: in std_logic;
			enable	 	: in std_logic;
			reset_n   	: in std_logic;
			LED		 	: out std_logic_vector(7 downto 0)
);
end component;

-- Fixed PWM generator for Mode 3 - KnightRider
component pwm_gen
generic( duty_cycle 	: integer;
			count_max  	: integer := 100_00);
port (	clock			: in std_logic;
			reset_n  	: in std_logic;
			pwm_out		: out std_logic
);
end component;


--##### signal declaration
signal clk : std_logic;
signal clk_pwm : std_logic;
signal enable, enable_pwm : std_logic;
signal mode : std_logic_vector(1 downto 0) := "00";
signal temp_LED1, temp_LED2, temp_LED3, temp_LED4 : std_logic_vector(7 downto 0);
signal pwm1, pwm2 : std_logic;
signal RESET_BTN : std_logic;

begin

C0     : clock_div generic map(count_max => 1_000_000) port map(CLK12M, RESET_BTN, clk);	-- clock 12Hz
C1     : clock_div generic map(count_max => 12_000) port map(CLK12M, RESET_BTN, clk_pwm);	-- clock 1kHz
DIFF0  : differentiator port map(CLK12M, RESET_BTN, clk, enable);	
DIFF1  : differentiator port map(CLK12M, RESET_BTN, clk_pwm, enable_pwm);
Control0 : control port map(enable_pwm, RESET_BTN, USER_BTN, mode);								-- controller
LED_S1   : S1 port map (mode, enable, CLK12M, RESET_BTN, temp_LED1);								-- case statement
LED_S2   : S2 port map (mode, enable, CLK12M, RESET_BTN, temp_LED2);								-- shift register
LED_S3   : S3 port map (mode, enable, CLK12M, RESET_BTN, pwm1, pwm2, temp_LED3);				-- KnightRider
LED_S4   : S4 generic map(11) port map (mode, CLK12M, enable_pwm, RESET_BTN, temp_LED4);	-- pwm
PWM_GEN0 : pwm_gen generic map (duty_cycle => 70_000, count_max => 100_000) port map(CLK12M, RESET_BTN, pwm1); -- PWM1
PWM_GEN1 : pwm_gen generic map (duty_cycle => 95_000, count_max => 100_000) port map(CLK12M, RESET_BTN, pwm2); -- PWM2

RESET_BTN <= '1';

-- Pass LED sequence to LEDs depending on mode
process(mode)
begin

	case mode is
		when "00" => LED <= temp_LED1;	
		when "01" => LED <= temp_LED2;
		when "10" => LED <= temp_LED3;
		when "11" => LED <= temp_LED4;
		when others => LED <="00000000";
	end case;
	
end process;


end architecture;