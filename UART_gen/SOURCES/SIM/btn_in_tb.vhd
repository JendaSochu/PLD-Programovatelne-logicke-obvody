----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY btn_in_tb IS
END btn_in_tb;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF btn_in_tb IS
----------------------------------------------------------------------------------

  COMPONENT btn_in
  GENERIC(
    G_DEB_PERIOD                : POSITIVE := 3
  );
  PORT(
    CLK                         : IN  STD_LOGIC;
    CE                          : IN  STD_LOGIC;
    BTN                         : IN  STD_LOGIC;
    BTN_DEBOUNCED               : OUT STD_LOGIC;
    BTN_EDGE_POS                : OUT STD_LOGIC;
    BTN_EDGE_NEG                : OUT STD_LOGIC;
    BTN_EDGE_ANY                : OUT STD_LOGIC
  );
  END COMPONENT btn_in;

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

  CONSTANT clk_period           : TIME := 20 ns;

  SIGNAL simulation_finished    : BOOLEAN := FALSE;

  SIGNAL clk                    : STD_LOGIC := '0';
  SIGNAL ce                     : STD_LOGIC;
  SIGNAL btn                    : STD_LOGIC := '0';
  SIGNAL btn_debounced          : STD_LOGIC;
  SIGNAL btn_edge_pos           : STD_LOGIC;
  SIGNAL btn_edge_neg           : STD_LOGIC;
  SIGNAL btn_edge_any           : STD_LOGIC;

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  proc_clk_gen: PROCESS BEGIN
    clk <= '0'; WAIT FOR clk_period/2;
    clk <= '1'; WAIT FOR clk_period/2;
    IF simulation_finished THEN
      WAIT;
    END IF;
  END PROCESS proc_clk_gen;

  --------------------------------------------------------------------------------

  ce_gen_i : ce_gen
  GENERIC MAP(
    G_DIV_FACT                  => 5
  )
  PORT MAP(
    CLK                         => clk,
    SRST                        => '0',
    CE                          => '1',
    CE_O                        => ce
  );

  --------------------------------------------------------------------------------

  btn_in_i : btn_in
  GENERIC MAP(
    G_DEB_PERIOD                => 6
  )
  PORT MAP(
    CLK                         => clk,
    CE                          => ce,
    BTN                         => btn,
    BTN_DEBOUNCED               => btn_debounced,
    BTN_EDGE_POS                => btn_edge_pos,
    BTN_EDGE_NEG                => btn_edge_neg,
    BTN_EDGE_ANY                => btn_edge_any
  );

  --------------------------------------------------------------------------------

  proc_stim : PROCESS
  BEGIN
    ------------------------------------------------------------------------------
    -- initial state
    ------------------------------------------------------------------------------
    btn <= '0'; WAIT FOR clk_period *  50;
    ------------------------------------------------------------------------------
    -- rising edge of the btn signal
    ------------------------------------------------------------------------------
    btn <= '1'; WAIT FOR clk_period *  10;
    btn <= '0'; WAIT FOR clk_period *  10;
    btn <= '1'; WAIT FOR clk_period *  20;
    btn <= '0'; WAIT FOR clk_period *  20;
    btn <= '1'; WAIT FOR clk_period * 200;
    ------------------------------------------------------------------------------
    -- falling edge of the btn signal
    ------------------------------------------------------------------------------
    btn <= '0'; WAIT FOR clk_period *   8;
    btn <= '1'; WAIT FOR clk_period *  10;
    btn <= '0'; WAIT FOR clk_period *  10;
    btn <= '1'; WAIT FOR clk_period *  20;
    btn <= '0'; WAIT FOR clk_period * 200;
    ------------------------------------------------------------------------------
    -- end of simulation
    ------------------------------------------------------------------------------
    WAIT FOR clk_period * 5;
    simulation_finished <= TRUE;
    WAIT;
  END PROCESS proc_stim;

----------------------------------------------------------------------------------
END Behavioral;
----------------------------------------------------------------------------------
