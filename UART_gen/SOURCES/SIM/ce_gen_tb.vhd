----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY ce_gen_tb IS
END ce_gen_tb;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF ce_gen_tb IS
----------------------------------------------------------------------------------

  COMPONENT ce_gen
  GENERIC (
    G_DIV_FACT          : POSITIVE := 2
  );
  PORT (
    CLK                 : IN  STD_LOGIC;
    SRST                : IN  STD_LOGIC;
    CE                  : IN  STD_LOGIC;
    CE_O                : OUT STD_LOGIC 
  );
  END COMPONENT ce_gen;

  --------------------------------------------------------------------------------
    
  CONSTANT clk_period           : TIME := 20 ns;

  SIGNAL simulation_finished    : BOOLEAN := FALSE;

  SIGNAL clk                    : STD_LOGIC := '0';
  SIGNAL srst                   : STD_LOGIC := '0';
  SIGNAL ce                     : STD_LOGIC := '0';
  SIGNAL ce_o                   : STD_LOGIC;

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  PROCESS BEGIN
    clk <= '0'; WAIT FOR clk_period/2;
    clk <= '1'; WAIT FOR clk_period/2;
    IF simulation_finished THEN
      WAIT;
    END IF;
  END PROCESS;

  --------------------------------------------------------------------------------

  ce_gen_i : ce_gen
  GENERIC MAP(
    G_DIV_FACT                  => 5
  )
  PORT MAP(
    clk                         => clk,
    srst                        => srst,
    ce                          => ce,
    ce_o                        => ce_o
  );

  --------------------------------------------------------------------------------

  proc_stim : PROCESS
  BEGIN
    srst  <= '1';
    ce <= '0';
    WAIT FOR clk_period * 5;
    srst  <= '0';
    WAIT FOR clk_period * 5;
    ce <= '1';
    WAIT FOR clk_period * 50;
    srst  <= '0';
    WAIT FOR clk_period * 5;
    simulation_finished <= TRUE;
    WAIT;
  END PROCESS proc_stim;

----------------------------------------------------------------------------------
END Behavioral;
----------------------------------------------------------------------------------
