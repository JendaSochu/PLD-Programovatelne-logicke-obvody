


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY uart_ce_gen IS
  GENERIC (
    G_DIV_FACT : POSITIVE := 434 -- 50 MHz / 115 200 Bd = 434
  );
  PORT (
    CLK          : IN  STD_LOGIC;
    SRST         : IN  STD_LOGIC;
    CE           : IN  STD_LOGIC;
    CLK_EN_UART  : OUT STD_LOGIC -- Přejmenovaný signál dle požadavku
  );
END ENTITY uart_ce_gen;

ARCHITECTURE Behavioral OF uart_ce_gen IS
  signal clk_counter      : INTEGER range 1 to G_DIV_FACT:= 1;
  signal clk_en           : STD_LOGIC := '0';

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
  clk_en_gen : process (CLK) BEGIN
    IF rising_edge(CLK) THEN
      IF clk_counter = G_DIV_FACT THEN
        clk_counter <= 1;
        clk_en <= '1';
      ELSE
        clk_counter <= clk_counter + 1;
        clk_en <= '0';
      END IF;
    END IF;
  END process clk_en_gen;
  
  CLK_EN_UART <= clk_en;
END ARCHITECTURE Behavioral;
