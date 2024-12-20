library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Display_pregunta is
generic(
        width:positive:=6
        );
  Port ( 
    estado : in std_logic_vector(1 downto 0);
    display1 : out std_logic_vector(width downto 0);
    display2 : out std_logic_vector(width downto 0);
    display3 : out std_logic_vector(width downto 0);
    display4 : out std_logic_vector(width downto 0);
    display5 : out std_logic_vector(width downto 0)  );
end Display_pregunta;

architecture Behavioral of Display_pregunta is

begin
process (estado)
begin
    if estado = "01" then
        display1 <="0111000";
        display2 <="1111001";
        display3 <="0111101";
        display4 <="1011011";
        display5 <="1111001"; 
    else
        display1 <="0000000";
        display2 <="0000000";
        display3 <="0000000";
        display4 <="0000000";
        display5 <="0000000";       
    end if;
end process;
end Behavioral;
