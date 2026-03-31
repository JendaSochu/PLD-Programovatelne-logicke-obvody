----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY btn_in IS
  GENERIC(
    G_DEB_PERIOD        : POSITIVE := 3
  );
  PORT(
    CLK                 : IN    STD_LOGIC;
    CE                  : IN    STD_LOGIC;
    BTN                 : IN    STD_LOGIC;
    BTN_DEBOUNCED       : OUT   STD_LOGIC;
    BTN_EDGE_POS        : OUT   STD_LOGIC;
    BTN_EDGE_NEG        : OUT   STD_LOGIC;
    BTN_EDGE_ANY        : OUT   STD_LOGIC
  );
END ENTITY btn_in;
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF btn_in IS
----------------------------------------------------------------------------------

  COMPONENT sync_reg
  PORT(
    CLK                 : IN    STD_LOGIC;
    SIG_IN              : IN    STD_LOGIC; 
    SIG_OUT             : OUT   STD_LOGIC
  ); 
  END COMPONENT sync_reg;

  --------------------------------------------------------------------------------

  COMPONENT debouncer
  GENERIC(
    G_DEB_PERIOD        : POSITIVE := 3
  );
  PORT(
    CLK                 : IN    STD_LOGIC;
    CE                  : IN    STD_LOGIC;
    BTN_IN              : IN    STD_LOGIC;
    BTN_OUT             : OUT   STD_LOGIC
  );
  END COMPONENT debouncer;

  --------------------------------------------------------------------------------

  COMPONENT edge_detector
  PORT(
    CLK                 : IN    STD_LOGIC;
    SIG_IN              : IN    STD_LOGIC; 
    EDGE_POS            : OUT   STD_LOGIC;
    EDGE_NEG            : OUT   STD_LOGIC; 
    EDGE_ANY            : OUT   STD_LOGIC
  ); 
  END COMPONENT edge_detector;

  --------------------------------------------------------------------------------

  SIGNAL btn_nm         : STD_LOGIC;
  SIGNAL btn_deb        : STD_LOGIC;

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  sync_reg_i : sync_reg
  PORT MAP(
    CLK             => CLK,
    SIG_IN          => BTN,
    SIG_OUT         => btn_nm
  );

  --------------------------------------------------------------------------------

  debouncer_i : debouncer
  GENERIC MAP(
    G_DEB_PERIOD    => G_DEB_PERIOD)
  PORT MAP(
    CLK             => CLK,
    CE              => CE,
    BTN_IN          => btn_nm,
    BTN_OUT         => btn_deb
  );

  BTN_DEBOUNCED <= btn_deb;

  --------------------------------------------------------------------------------

  edge_detector_i : edge_detector
  PORT MAP(
    CLK             => CLK,
    SIG_IN          => btn_deb,
    EDGE_POS        => BTN_EDGE_POS,
    EDGE_NEG        => BTN_EDGE_NEG,
    EDGE_ANY        => BTN_EDGE_ANY
  );

----------------------------------------------------------------------------------
END ARCHITECTURE Structural;
----------------------------------------------------------------------------------
