
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


ENTITY uart_tx IS
    PORT (
        CLK      : IN  STD_LOGIC;
        TX_START : IN  STD_LOGIC; -- Hrana z tlačítka
        CLK_EN   : IN  STD_LOGIC; -- Signál CLK_EN_UART z generátoru
        DATA_IN  : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
        TX_BUSY  : OUT STD_LOGIC;
        UART_TXD : OUT STD_LOGIC
    );
END uart_tx;

ARCHITECTURE Behavioral OF uart_tx IS
  TYPE t_st IS (st_idle, st_load, st_start, st_b0, st_b1, st_b2, st_b3, st_b4, st_b5, st_b6, st_b7, st_stop);
  SIGNAL pres_st      : t_st := st_idle;
  SIGNAL next_st      : t_st;
  SIGNAL sig_data_reg : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL uart_txd_reg : STD_LOGIC := '1';
  SIGNAL uart_txd_c   : STD_LOGIC := '1';
  SIGNAL tx_busy_reg  : STD_LOGIC := '0';
  SIGNAL tx_busy_c    : STD_LOGIC := '0';
BEGIN

  -- 1. Registr stavu (posun o stav při každém tiku CLK_EN)
  process(CLK) begin
    if rising_edge(CLK) then
      if CLK_EN = '1' then pres_st <= next_st; end if;
      -- Okamžitý přechod z IDLE do LOAD při startu
      if pres_st = st_idle and TX_START = '1' then pres_st <= st_load; end if;
    end if;
  end process;

  -- 2. Logika příštího stavu (posloupnost bitů)
  process(pres_st, TX_START) begin
    case pres_st is
      when st_idle  => if TX_START = '1' then next_st <= st_load; else next_st <= st_idle; end if;
      when st_load  => next_st <= st_start;
      when st_start => next_st <= st_b0;
      when st_b0    => next_st <= st_b1;
      when st_b1    => next_st <= st_b2;
      when st_b2    => next_st <= st_b3;
      when st_b3    => next_st <= st_b4;
      when st_b4    => next_st <= st_b5;
      when st_b5    => next_st <= st_b6;
      when st_b6    => next_st <= st_b7;
      when st_b7    => next_st <= st_stop;
      when st_stop  => next_st <= st_idle;
      when others   => next_st <= st_idle;
    end case;
  end process;

  -- 3. Data load registr (uloží data na vstupu při TX_START)
  process(CLK) begin
    if rising_edge(CLK) then
      if pres_st = st_idle and TX_START = '1' then
        sig_data_reg <= DATA_IN;
      end if;
    end if;
  end process;

  -- 4. Mooreova výstupní logika (všechny bity UARTu)
  process(pres_st, sig_data_reg) begin
    case pres_st is
      when st_idle  => uart_txd_c <= '1'; tx_busy_c <= '0';
      when st_load  => uart_txd_c <= '1'; tx_busy_c <= '1';
      when st_start => uart_txd_c <= '0'; tx_busy_c <= '1'; -- Start bit = 0
      when st_b0    => uart_txd_c <= sig_data_reg(0); tx_busy_c <= '1';
      when st_b1    => uart_txd_c <= sig_data_reg(1); tx_busy_c <= '1';
      when st_b2    => uart_txd_c <= sig_data_reg(2); tx_busy_c <= '1';
      when st_b3    => uart_txd_c <= sig_data_reg(3); tx_busy_c <= '1';
      when st_b4    => uart_txd_c <= sig_data_reg(4); tx_busy_c <= '1';
      when st_b5    => uart_txd_c <= sig_data_reg(5); tx_busy_c <= '1';
      when st_b6    => uart_txd_c <= sig_data_reg(6); tx_busy_c <= '1';
      when st_b7    => uart_txd_c <= sig_data_reg(7); tx_busy_c <= '1';
      when st_stop  => uart_txd_c <= '1'; tx_busy_c <= '1'; -- Stop bit = 1
      when others   => uart_txd_c <= '1'; tx_busy_c <= '0';
    end case;
  end process;
  
  -- 5. výstupní registr
  PROCESS (clk) BEGIN
    IF rising_edge(clk) THEN
      uart_txd_reg <= uart_txd_c;
      tx_busy_reg  <= tx_busy_c;
    END IF;
  END PROCESS;
  
  UART_TXD <= uart_txd_reg;
  TX_BUSY  <= tx_busy_reg;
  
END Behavioral;

