----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY edge_detector IS
  PORT(
    CLK                 : IN    STD_LOGIC;
    SIG_IN              : IN    STD_LOGIC;
    EDGE_POS            : OUT   STD_LOGIC;
    EDGE_NEG            : OUT   STD_LOGIC;
    EDGE_ANY            : OUT   STD_LOGIC
  );
END ENTITY edge_detector;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF edge_detector IS
----------------------------------------------------------------------------------

signal sig_in_del : std_logic := '0';

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
  PROCESS (clk) BEGIN
    IF rising_edge(clk) THEN
      sig_in_del <= SIG_IN; 
      
   
      EDGE_POS <= SIG_IN and (not sig_in_del);
      EDGE_NEG <= (not SIG_IN) and sig_in_del;
      EDGE_ANY <= SIG_IN xor sig_in_del;
    END IF;
  END PROCESS;


----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
