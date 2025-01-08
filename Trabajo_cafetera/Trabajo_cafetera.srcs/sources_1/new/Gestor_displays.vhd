
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Gestor_displays is
    Port ( 
    temp_cafe : in std_logic_vector(6 downto 0);
    temp_leche : in std_logic_vector(6 downto 0);
    pregunta : in std_logic_vector(6 downto 0);
    estado : in std_logic_vector(1 downto 0);
    cafe_terminado : in std_logic;
    display : out std_logic_vector(6 downto 0)
    );
end Gestor_displays;

architecture Behavioral of Gestor_displays is

begin


end Behavioral;
