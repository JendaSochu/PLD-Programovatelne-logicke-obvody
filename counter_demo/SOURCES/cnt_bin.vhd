library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cnt_bin is
--  Port ( );
  PORT(
    CLK             : IN  STD_LOGIC;
    CE              : IN  STD_LOGIC;
    SRST            : IN  STD_LOGIC;
    CNT_LOAD            : IN  STD_LOGIC;
    CNT_UP              : IN  STD_LOGIC;
    CNT             : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
  );
end cnt_bin;

architecture Behavioral of cnt_bin is
  SIGNAL cnt_sig : STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0');
begin

  PROCESS (CLK) BEGIN
    IF rising_edge(CLK) THEN
    --cnt_sig <= STD_LOGIC_VECTOR( UNSIGNED(cnt_sig) + 1);
      IF srst = '1' THEN
        cnt_sig <= (OTHERS => '0');
      ELSIF ce = '1' THEN
        IF CNT_LOAD = '1' THEN
          cnt_sig <= x"55555555";
        ELSIF CNT_UP = '1' THEN
          cnt_sig <= STD_LOGIC_VECTOR( UNSIGNED(cnt_sig) + 1);
        ELSE
          cnt_sig <= STD_LOGIC_VECTOR( UNSIGNED(cnt_sig) - 1);
        END IF;
      END IF;

    END IF;
  END PROCESS;

  CNT <= cnt_sig;

end Behavioral;
