library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity uart_tx_tb is
--  Port ( );
end uart_tx_tb;

ARCHITECTURE Behavioral OF uart_tx_tb IS

    -- Definice komponent (DUT - Device Under Test)
    COMPONENT uart_ce_gen
        GENERIC ( G_DIV_FACT : POSITIVE );
        PORT
        (
          CLK                 : IN STD_LOGIC;
          SRST                : IN STD_LOGIC;
          CE                  : IN STD_LOGIC;
          CLK_EN_UART         : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT uart_tx
        PORT
        (
          CLK                 : IN STD_LOGIC;
          TX_START            : IN STD_LOGIC;
          CLK_EN              : IN STD_LOGIC;
          DATA_IN             : IN STD_LOGIC_VECTOR(7 downto 0);
          TX_BUSY             : OUT STD_LOGIC;
          UART_TXD            : OUT STD_LOGIC
        );
    END COMPONENT;

    -- Signály pro propojení
    SIGNAL clk          : STD_LOGIC := '0';
    SIGNAL ce_uart      : STD_LOGIC;
    SIGNAL tx_start     : STD_LOGIC := '0';
    SIGNAL data_in      : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    SIGNAL tx_busy      : STD_LOGIC;
    SIGNAL uart_txd     : STD_LOGIC;
    
    -- Signál pro ukončení simulace
    SIGNAL simulation_finished    : BOOLEAN := FALSE;

    -- Konstanta pro periodu hodin (50 MHz = 20 ns)
    constant CLK_PERIOD : time := 20 ns;

BEGIN

    -- 1. Instance generátoru hodin (pro simulaci zvolen malý dělící faktor 20)
    -- V reálu je 434, ale v simulaci chceme vidět výsledek rychle 
    uut_gen: uart_ce_gen
        GENERIC MAP ( G_DIV_FACT => 20 )
        PORT MAP ( CLK => clk, SRST => '0', CE => '1', CLK_EN_UART => ce_uart );

    -- 2. Instance samotného vysílače
    uut_tx: uart_tx
        PORT MAP (
            CLK      => clk,
            TX_START => tx_start,
            CLK_EN   => ce_uart,
            DATA_IN  => data_in,
            TX_BUSY  => tx_busy,
            UART_TXD => uart_txd
        );

    -- Proces pro generování hodin (50 MHz)
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
        IF simulation_finished THEN
          WAIT;
        END IF;
    end process;

    -- Stimulační proces (samotný test)
    stim_proc: process
    begin
        -- Počáteční čekání
        wait for 100 ns;

        -- Test 1: Vyslání znaku 'M' (ASCII 0x4D = "01001101")
        data_in  <= X"4D";
        wait for CLK_PERIOD * 5;
        tx_start <= '1';
        wait for CLK_PERIOD; -- Puls startu trvá 1 takt
        tx_start <= '0';

        wait for CLK_PERIOD * 15;
        tx_start <= '1';
        wait for CLK_PERIOD; -- Puls startu trvá 1 takt
        tx_start <= '0';
        
        wait for CLK_PERIOD * 5;
        tx_start <= '1';
        wait for CLK_PERIOD; -- Puls startu trvá 1 takt
        tx_start <= '0';

        -- Čekáme, dokud vysílač nepřenese všechny bity (1 start + 8 data + 1 stop = 10 bitů)
        wait until tx_busy = '0';
        wait for 500 ns;

        -- Test 2: Vyslání znaku 'A' (ASCII 0x41 = "01000001")
        data_in  <= X"41";
        tx_start <= '1';
        wait for CLK_PERIOD;
        tx_start <= '0';

        wait until tx_busy = '0';
        
        -- Ukončení simulace
        WAIT FOR clk_period * 5;
        simulation_finished <= TRUE;
        WAIT;
    end process;

END Behavioral;
