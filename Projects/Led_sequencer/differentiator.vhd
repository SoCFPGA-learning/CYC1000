-- Differentiator
-- Outputs enable signal equal to the width of the clock's half period
-- Useful for syncing multiple components

library ieee;
use ieee.std_logic_1164.all;

entity differentiator is
port(clock 	 : in std_logic;
     reset_n : in std_logic;
     data 	 : in std_logic;
     enable  : out std_logic
    );
end entity;

architecture rtl of differentiator is
signal en : std_logic;
begin
 process(clock, reset_n)
 begin
   if reset_n = '0' then
     en <= '0';
   elsif rising_edge(clock) then
     en <= data;
   end if;
 end process;

enable <= data and not(en);

end architecture;
