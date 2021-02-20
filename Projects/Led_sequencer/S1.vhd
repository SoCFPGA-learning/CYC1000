-- S1 : Case statement sequence

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity S1 is
port(		mode   : in std_logic_vector(1 downto 0);
			enable 	 : in std_logic;
			clock 	 : in std_logic;
			reset_n   : in std_logic;
			LED		 : out std_logic_vector(7 downto 0)
);
end entity;

architecture rtl of S1 is
signal count : std_logic_vector(3 downto 0);
begin


 -- counter
 process (clock, reset_n)
 begin
	  if reset_n = '0' or mode /= "000"then	
			count <= (others => '0');
	  elsif rising_edge(clock) then
			if enable = '1' then
				if mode = "000" then
					count <= count + '1';
				end if;
			end if;
	  end if;
 end process;

process (count, mode)
begin

if mode = "00" then
  case count is
		when "0000" => LED <=  "00000000";
		when "0001" => LED <=  "10000001";
		when "0010" => LED <=  "01000010";
		when "0011" => LED <=  "00100100";
		when "0100" => LED <=  "00011000";
		when "0101" => LED <=  "00100100";
		when "0110" => LED <=  "01000010";
		when "0111" => LED <=  "10000001";
		when "1000" => LED <=  "10000001";
		when "1001" => LED <=  "11000011";
		when "1010" => LED <=  "11100111";
		when "1011" => LED <=  "11111111";
		when "1100" => LED <=  "11100111";
		when "1101" => LED <=  "11000011";
		when "1110" => LED <=  "10000001";
		when "1111" => LED <=  "00000000";
		when others => LED <=  "00000000";
  end case;
 else 
	LED <=  "00000000";
 end if;
end process;

end architecture;