-- Mode Controller
-- Toggles through choosing 1 out of 4 possible LED sequence modes
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity control is
port(		clock     : in std_logic;
			reset_n   : in std_logic;
			USER_BTN  : in std_logic;
			mode   : out std_logic_vector(1 downto 0)
);
end entity;

architecture rtl of control is
signal cnt : std_logic_vector(1 downto 0);
signal delay1, delay2, delay3, db_btn : std_logic;
begin


-- debounce key
process(clock, reset_n)
begin

if reset_n = '0' then
	delay1 <= '0';
	delay2 <= '0';
	delay3 <= '0';
elsif rising_edge(clock) then
	delay1 <= USER_BTN;
	delay2 <= delay1;
	delay3 <= delay2;
end if;
end process;

db_btn <= delay1 or delay2 or delay3;

-- toggle through states
process(db_btn, reset_n)
begin
if reset_n = '0' then
	cnt <= (others => '0');
elsif falling_edge(db_btn) then
		cnt <= cnt + 1;
end if;

end process;

mode <= cnt;

end architecture;