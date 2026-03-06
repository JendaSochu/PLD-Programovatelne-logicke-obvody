----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY rp_top IS
  PORT (
    CLK             : IN  STD_LOGIC;
    BTN             : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    SW              : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    LED             : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    DISP_SEG        : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    DISP_DIG        : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
  );
END rp_top;
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF rp_top IS
----------------------------------------------------------------------------------

  COMPONENT seg_disp_driver
  PORT (
    CLK             : IN  STD_LOGIC;
    DIG_1           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    DIG_2           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    DIG_3           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    DIG_4           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    DP              : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);        -- [DP4 DP3 DP2 DP1]
    DOTS            : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);        -- [L3 L2 L1]
    DISP_SEG        : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    DISP_DIG        : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
  );
  END COMPONENT;

  --------------------------------------------------------------------------------
  COMPONENT cnt_bin
  PORT (
    CLK          : IN  STD_LOGIC;
    SRST         : IN  STD_LOGIC;
    CE           : IN  STD_LOGIC;
    CNT_LOAD     : IN  STD_LOGIC;
    CNT_UP       : IN  STD_LOGIC;
    CNT          : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
  END COMPONENT;

  SIGNAL cnt_output : STD_LOGIC_VECTOR(31 DOWNTO 0);

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  --------------------------------------------------------------------------------
  --
  --       DIG 1       DIG 2       DIG 3       DIG 4
  --                                       L3
  --       -----       -----       -----   o   -----
  --      |     |     |     |  L1 |     |     |     |
  --      |     |     |     |  o  |     |     |     |
  --       -----       -----       -----       -----
  --      |     |     |     |  o  |     |     |     |
  --      |     |     |     |  L2 |     |     |     |
  --       -----  o    -----  o    -----  o    -----  o
  --             DP1         DP2         DP3         DP4
  --
  --------------------------------------------------------------------------------
  cnt_bin_i : cnt_bin
    PORT MAP (
        CLK         => CLK,
        SRST        => BTN(2),
        CE          => SW(2),
        CNT_LOAD    => BTN(1),
        CNT_UP      => SW(3),
        CNT         => cnt_output
    );
--------------------------------------------------------------------------------
  seg_disp_driver_i : seg_disp_driver
  PORT MAP (
    CLK                 => CLK,
    --DIG_1               => cnt_output(19 downto 16),
    --DIG_2               => cnt_output(23 downto 20),
    --DIG_3               => cnt_output(27 downto 24),
    --DIG_4               => cnt_output(31 downto 28),
    DIG_4               => cnt_output(19 downto 16),
    DIG_3               => cnt_output(23 downto 20),
    DIG_2               => cnt_output(27 downto 24),
    DIG_1               => cnt_output(31 downto 28),
    DP                  => "0000",
    DOTS                => "000",
    DISP_SEG            => DISP_SEG,
    DISP_DIG            => DISP_DIG
  );

--------------------------------------------------------------------------------

LED <= cnt_output(31 downto 24);

----------------------------------------------------------------------------------
END Structural;
----------------------------------------------------------------------------------
