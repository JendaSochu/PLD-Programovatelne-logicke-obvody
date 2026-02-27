----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
entity simple_adder_tb is
end simple_adder_tb;
----------------------------------------------------------------------------------
architecture Behavioral of simple_adder_tb is
----------------------------------------------------------------------------------

  -- component declaration
  COMPONENT simple_adder
    Port ( 
      A : in   STD_LOGIC_VECTOR (3 downto 0);
      B : in   STD_LOGIC_VECTOR (3 downto 0);
      Y : out  STD_LOGIC_VECTOR (3 downto 0);
      C : out  STD_LOGIC;
      Z : out  STD_LOGIC
    );
  end COMPONENT simple_adder;

  SIGNAL a_sig : STD_LOGIC_VECTOR (3 downto 0);
  SIGNAL b_sig : STD_LOGIC_VECTOR (3 downto 0);
  SIGNAL y_sig : STD_LOGIC_VECTOR (3 downto 0);
  SIGNAL y_ref : STD_LOGIC_VECTOR (3 downto 0);
  SIGNAL c_sig : STD_LOGIC;                    
  SIGNAL z_sig : STD_LOGIC; 
                      
----------------------------------------------------------------------------------
begin                                                                             
----------------------------------------------------------------------------------

  -- Component Instantiation
  -- Unit Under Test UUT
  simple_adder_i : simple_adder
    Port Map( 
      A => a_sig,
      B => b_sig,
      Y => y_sig,
      C => c_sig,
      Z => z_sig
    );

----------------------------------------------------------------------------------
--stimulus generatod
  PROCESS
  
  BEGIN
  --a_sig <= STD_LOGIC_VECTOR(  TO_UNSIGNED(1,4) );
  --a_sig <= "0001";
  --a_sig <= STD_LOGIC_VECTOR(  TO_UNSIGNED(1,a_sig'length) );
    
    LOOP_1: FOR i IN 0 TO 15 LOOP
      LOOP_2: FOR j IN 0 TO 15 LOOP
        a_sig <= STD_LOGIC_VECTOR(  TO_UNSIGNED(i,a_sig'length) );
        b_sig <= STD_LOGIC_VECTOR(  TO_UNSIGNED(j,b_sig'length) );
        WAIT FOR 10ns;
      END LOOP LOOP_2;
    END LOOP LOOP_1;
       
    --a_sig <= X"1";
    --b_sig <= X"1";
    --WAIT FOR 10ns;

    
    WAIT;
    REPORT "Simulator Finised" SEVERITY FAILURE;
    
  END PROCESS;

 --OUTPUT CHECKER
 --PROCESS (a_sig, b_sig)
 PROCESS
   VARIABLE cnt_err : INTEGER :=0;
 BEGIN
 
   WAIT ON a_sig, b_sig;
   y_ref <= STD_LOGIC_VECTOR ( UNSIGNED(a_sig) + UNSIGNED(b_sig) );
   WAIT FOR 1 ns;
   
   --? y_sig = y_ref
   ASSERT y_sig = y_ref REPORT "ERROR in addition!" SEVERITY ERROR;
   
   IF NOT (y_sig = y_ref) THEN
     cnt_err := cnt_err +1;
     REPORT "ERROR in addition! Cerrent error count: " & integer'image(cnt_err) SEVERITY ERROR;
     REPORT "ERROR: expected Y = " & integer'image(to_integer(unsigned(y_ref))) &
            ", actual Y = " & integer'image(to_integer(unsigned(y_sig))) &
            "(inputs A =" & integer'image(to_integer(unsigned(a_sig))) &
            ",B = " & integer'image(to_integer(unsigned(b_sig))) &
            ")";
   END IF;
 
 END PROCESS;


----------------------------------------------------------------------------------
end Behavioral;
----------------------------------------------------------------------------------