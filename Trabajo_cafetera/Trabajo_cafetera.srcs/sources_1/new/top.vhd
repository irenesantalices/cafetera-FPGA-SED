

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top is
generic(
        tiempo:positive:=6;
        width:positive:=3
        );
end top;

architecture Behavioral of top is
signal CLK         : STD_LOGIC;
signal display1 : std_logic_vector(width downto 0);
signal display2 : std_logic_vector(width downto 0);
signal tiempo_temporizador : std_logic_vector(tiempo-1 downto 0);
signal Habilitar_T : std_logic;
signal Start : std_logic;
signal Pause : std_logic;

COMPONENT temporizador
       PORT (
        CLK : in std_logic;
        tiempo_in : in std_logic_vector(tiempo-1 downto 0);
        display1 : out std_logic_vector(width downto 0);
        display2 : out std_logic_vector(width downto 0);
        Habilitar_T : in std_logic;
        Start : in std_logic;
        Pause : in std_logic
            );
    END COMPONENT;
begin
Inst_temporizador: temporizador 
    PORT MAP (
        CLK => CLK,
        tiempo_in=>tiempo_temporizador,
        display1 => display1,
        display2 => display2,
        Habilitar_T => Habilitar_T,
        Start => Start,
        Pause => Pause
    );
end Behavioral;
