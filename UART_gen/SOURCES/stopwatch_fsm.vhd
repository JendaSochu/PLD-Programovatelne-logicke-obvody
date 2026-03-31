--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--------------------------------------------------------------------------------
ENTITY stopwatch_fsm IS
  PORT (
    CLK                 : IN    STD_LOGIC;
    BTN_S_S             : IN    STD_LOGIC;
    BTN_L_C             : IN    STD_LOGIC;
    CNT_RESET           : OUT   STD_LOGIC;
    CNT_ENABLE          : OUT   STD_LOGIC;
    DISP_ENABLE         : OUT   STD_LOGIC
  );
END ENTITY stopwatch_fsm;
--------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF stopwatch_fsm IS
--------------------------------------------------------------------------------

  type t_state is (Idle, Run, Stop, Lap, Refresh);
  signal pres_st, next_st : t_state := Idle;
    
--------------------------------------------------------------------------------
BEGIN
--------------------------------------------------------------------------------

  PROCESS (clk) BEGIN
    IF rising_edge(clk) THEN
      pres_st <= next_st;
    END IF;
  END PROCESS;
    
    
  next_state_logic: process(pres_st, BTN_S_S, BTN_L_C)
    begin
        case pres_st is
            when Idle =>
                if BTN_S_S = '1' then next_st <= Run;
                else                next_st <= Idle;
                end if;

            when Run =>
                if BTN_S_S = '1' then next_st <= Stop;
                elsif BTN_L_C = '1' then next_st <= Lap;
                else                next_st <= Run;
                end if;

            when Stop =>
                if BTN_S_S = '1' then next_st <= Run;
                elsif BTN_L_C = '1' then next_st <= Idle;
                else                next_st <= Stop;
                end if;

            when Lap =>
                if BTN_S_S = '1' then next_st <= Run;
                elsif BTN_L_C = '1' then next_st <= Refresh;
                else                next_st <= Lap;
                end if;

            when Refresh =>
                next_st <= Lap; -- Automatický návrat do Lap (pouze jeden takt CLK pro update)

            when others =>
                next_st <= Idle;
        end case;
    end process next_state_logic;
    
    
    output_logic: process(pres_st)
    begin
        case pres_st is
            when Idle    => CNT_ENABLE <= '0'; CNT_RESET <= '1'; DISP_ENABLE <= '1';
            when Run     => CNT_ENABLE <= '1'; CNT_RESET <= '0'; DISP_ENABLE <= '1';
            when Stop    => CNT_ENABLE <= '0'; CNT_RESET <= '0'; DISP_ENABLE <= '1';
            when Lap     => CNT_ENABLE <= '1'; CNT_RESET <= '0'; DISP_ENABLE <= '0';
            when Refresh => CNT_ENABLE <= '1'; CNT_RESET <= '0'; DISP_ENABLE <= '1';
            when others  => CNT_ENABLE <= '0'; CNT_RESET <= '0'; DISP_ENABLE <= '1';
        end case;
    end process output_logic;
    
--------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
--------------------------------------------------------------------------------
