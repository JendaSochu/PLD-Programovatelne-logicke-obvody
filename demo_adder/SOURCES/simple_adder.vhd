library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity simple_adder is
    Port ( 
      A : in   STD_LOGIC_VECTOR (3 downto 0);
      B : in   STD_LOGIC_VECTOR (3 downto 0);
      Y : out  STD_LOGIC_VECTOR (3 downto 0);
      C : out  STD_LOGIC;
      Z : out  STD_LOGIC
    );
end simple_adder;

architecture Behavioral of simple_adder is

--SIGNAL a_uns : unsigned(A'range);
--SIGNAL a_uns : unsigned(A'high downto A'low);
  SIGNAL a_uns : unsigned(3 downto 0);
  SIGNAL b_uns : unsigned(3 downto 0);
  SIGNAL y_uns : unsigned(4 downto 0);

begin

  a_uns <= unsigned(A);
  b_uns <= unsigned(B);
  
  y_uns <= "00000" + a_uns + b_uns;
  
  
  Y <= STD_LOGIC_VECTOR(y_uns(3 DOWNTO 0));
  C <= STD_LOGIC(y_uns(A'length));
 

end Behavioral;
