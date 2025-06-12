library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity clk70Hz is
generic(
        --div:positive:=1428571
        div:positive:=94286
        );

    Port (
        CLK     : in  STD_LOGIC;
        CLK_70hz : out STD_LOGIC
    );
end clk70Hz;
 
architecture Behavioral of clk70Hz is
    signal temporal: STD_LOGIC;
    signal contador: integer range 0 to div := 0;
  begin
    divisor_frecuencia: process (CLK) begin        
        if rising_edge(CLK) then
            if (contador = div) then
                temporal <= NOT(temporal);
                contador <= 0;
            else
                contador <= contador+1;
            end if;
        end if;
    end process;
     
    CLK_70hz <= temporal;
    
end Behavioral;