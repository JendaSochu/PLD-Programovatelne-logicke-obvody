----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY debouncer IS
  GENERIC(
    G_DEB_PERIOD        : POSITIVE := 3
  );    
  PORT( 
    CLK                 : IN    STD_LOGIC;
    CE                  : IN    STD_LOGIC;
    BTN_IN              : IN    STD_LOGIC;
    BTN_OUT             : OUT   STD_LOGIC
  );
END ENTITY debouncer;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF debouncer IS
----------------------------------------------------------------------------------
SIGNAL shreg : STD_LOGIC_VECTOR(G_DEB_PERIOD DOWNTO 0):= (others => '0');

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  PROCESS (CLK) BEGIN
      IF rising_edge(CLK) THEN
        IF CE = '1' THEN
            shreg <= shreg (shreg'high - 1 DOWNTO 0) & BTN_IN;
        END IF;
      END IF;
    END process;

  PROCESS (clk) BEGIN
    IF rising_edge(clk) THEN
      IF shreg = (shreg'RANGE => '0') THEN
        BTN_OUT <= '0';
      END IF;
      IF shreg = (shreg'RANGE => '1') THEN
        BTN_OUT <= '1';
      END IF;
    END IF;
  END PROCESS;


----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
