---------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
---------------------------------------------
entity LED_demo is
  Port (
    SW  : in STD_LOGIC_VECTOR (1 to 4);
    BTN : in STD_LOGIC_VECTOR (1 to 4);
    LED : out STD_LOGIC_VECTOR (7 downto 0)
  );
end LED_demo;
------------------------------------------------
architecture Behavioral of LED_demo is

begin

    LED(0) <=     BTN(1);
    LED(1) <= NOT BTN(2);
    
    --BTN=0011 SW=1010
    --LED(2) <= NOT BTN(1) AND;
    LED(2) <= '1' WHEN BTN(1 TO 4) = "0011" AND SW(1 TO 4) = "0101" ELSE '0';
    
    LED(3) <= '1';

    LED(7 DOWNTO 4) <= "1100";

end Behavioral;
---------------------------------------------------