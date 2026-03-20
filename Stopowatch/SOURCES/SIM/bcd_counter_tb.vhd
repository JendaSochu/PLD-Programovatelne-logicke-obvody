----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
entity bcd_counter_tb is
end bcd_counter_tb;
----------------------------------------------------------------------------------
architecture Behavioral of bcd_counter_tb is
----------------------------------------------------------------------------------

  COMPONENT bcd_counter
  PORT (
    CLK                         : IN  STD_LOGIC;
    CE_100HZ                    : IN  STD_LOGIC;
    CNT_ENABLE                  : IN  STD_LOGIC;
    DISP_ENABLE                 : IN  STD_LOGIC;
    CNT_RESET                   : IN  STD_LOGIC;
    CNT_0                       : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0);
    CNT_1                       : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0);
    CNT_2                       : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0);
    CNT_3                       : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0)
  );
  END COMPONENT bcd_counter;

  --------------------------------------------------------------------------------

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

  CONSTANT C_CLK_PERIOD         : TIME := 20 ns;

  SIGNAL simulation_finished    : BOOLEAN := FALSE;

  SIGNAL clk                    : STD_LOGIC := '0';
  SIGNAL ce_100Hz               : STD_LOGIC;
  SIGNAL cnt_enable             : STD_LOGIC := '0';
  SIGNAL disp_enable            : STD_LOGIC := '0';
  SIGNAL cnt_reset              : STD_LOGIC := '0';
  SIGNAL cnt_0                  : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL cnt_1                  : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL cnt_2                  : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL cnt_3                  : STD_LOGIC_VECTOR( 3 DOWNTO 0);

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  proc_clk_gen: PROCESS BEGIN
    clk <= '0'; WAIT FOR C_CLK_PERIOD/2;
    clk <= '1'; WAIT FOR C_CLK_PERIOD/2;
    IF simulation_finished THEN
      WAIT;
    END IF;
  END PROCESS proc_clk_gen;

  --------------------------------------------------------------------------------

  bcd_counter_i : bcd_counter
  PORT MAP(
    CLK                         => clk,
    CE_100HZ                    => ce_100hz,
    CNT_ENABLE                  => cnt_enable,
    DISP_ENABLE                 => disp_enable,
    CNT_RESET                   => cnt_reset,
    CNT_0                       => cnt_0,
    CNT_1                       => cnt_1,
    CNT_2                       => cnt_2,
    CNT_3                       => cnt_3
  );

  --------------------------------------------------------------------------------

  ce_gen_i : ce_gen
  GENERIC MAP(
    G_DIV_FACT                  => 10
  )
  PORT MAP(
    CLK                         => clk,
    SRST                        => '0',
    CE                          => '1',
    CE_O                        => ce_100hz
  );

  --------------------------------------------------------------------------------

  proc_stim : PROCESS
  BEGIN
    cnt_enable  <= '0';
    disp_enable <= '0';
    cnt_reset   <= '0';
    ------------------------------------------------------------------------------
    -- reset of the counter
    ------------------------------------------------------------------------------
    WAIT FOR C_CLK_PERIOD * 5;
    cnt_reset   <= '1';
    WAIT FOR C_CLK_PERIOD * 2;
    cnt_reset   <= '0';
    WAIT FOR C_CLK_PERIOD * 1;
    cnt_enable   <= '1';
    WAIT FOR C_CLK_PERIOD * 60500;
    ------------------------------------------------------------------------------
    -- place your own stimuli below
    ------------------------------------------------------------------------------









    ------------------------------------------------------------------------------
    -- end of simulation
    ------------------------------------------------------------------------------
    WAIT FOR C_CLK_PERIOD * 5;
    simulation_finished <= TRUE;
    WAIT;
  END PROCESS proc_stim;

----------------------------------------------------------------------------------
end Behavioral;
----------------------------------------------------------------------------------
