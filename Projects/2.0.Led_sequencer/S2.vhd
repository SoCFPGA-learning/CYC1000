-- S2 : Shift Register Sequence

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity S2 is
port(		mode   : in std_logic_vector(1 downto 0);
			enable 	 : in std_logic;
			clock 	 : in std_logic;
			reset_n   : in std_logic;
			LED		 : out std_logic_vector(7 downto 0)
);
end entity;

architecture rtl of S2 is

signal shift_reg : std_logic_vector(7 downto 0) := X"00";
signal dummy : std_logic := '1';
signal reg : std_logic_vector(7 downto 0) := "10000000";
begin


 -- shift register
 process (enable)
 variable i : integer range 0 to 7 := 0;
 begin

	if (reset_n = '0' or mode /= "01") then
		shift_reg <= "00000000";
	elsif rising_edge(clock) then
			if enable = '1' then
				shift_reg(7) <= dummy;
				shift_reg(6) <= shift_reg(7);
				shift_reg(5) <= shift_reg(6);
				shift_reg(4) <= shift_reg(5);
				shift_reg(3) <= shift_reg(4);
				shift_reg(2) <= shift_reg(3);
				shift_reg(1) <= shift_reg(2);
				shift_reg(0) <= shift_reg(1);
			 end if;
	end if;

end process;

dummy <= '0' when (shift_reg = "11111111") else '1' when shift_reg = "00000000";
LED <= shift_reg;

end architecture;