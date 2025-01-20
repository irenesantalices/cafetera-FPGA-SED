
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Display_pregunta is
generic(
        width:positive:=6
        );
  Port ( 
    in_clk : in std_logic;
    in_display1_cafe : in std_logic_vector(width downto 0);
    in_display2_cafe : in std_logic_vector(width downto 0);
    tiempo_elegido   : in std_logic;
    in_display1_t : in std_logic_vector(width downto 0);
    in_display2_t : in std_logic_vector(width downto 0);
--    in_display1_leche : in std_logic_vector(width downto 0);
--    in_display2_leche : in std_logic_vector(width downto 0);
    estado : in std_logic_vector(1 downto 0);
    digctrl  : out std_logic_vector(7 downto 0);
    display : out std_logic_vector(width downto 0));
   
end Display_pregunta;

    architecture Behavioral of Display_pregunta is
    signal clk : std_logic ;
    signal estado_display : std_logic_vector(2 downto 0):="000";
    signal next_estado : std_logic_vector(2 downto 0):="000";

COMPONENT clk70hz
       PORT (
              CLK: in  STD_LOGIC;
              clk_70hz : out STD_LOGIC
            );
    END COMPONENT;
begin
Inst_clk70hz: clk70hz 
    PORT MAP (
        CLK => in_clk,
        clk_70hz => clk
    );
process (estado,clk)
begin

if rising_edge(clk) then
    if estado= "00" then
        digctrl<="11111111";
    
    elsif estado = "01" then
        estado_display<=next_estado;
        case estado_display is
        when "000" =>
        digctrl<="01111111";
        display <="0111000";
        next_estado<="001";
        --hay que hacer el convertido de frecuencia
        when "001" =>
        digctrl<="10111111";
        display <="1111001";
        next_estado<="010";
        when "010" =>
        digctrl<="11011111";
        display <="0111101";
        next_estado<="011";
        when "011" =>
        digctrl<="11101111";
        display <="1011011";
        next_estado<="100";
        when "100" =>
        digctrl<="11110111";
        display <="1111001"; 
        next_estado<="000";
        when others =>
        next_estado<="000";
        end case;
    elsif tiempo_elegido='0' then
    estado_display<=next_estado;
    case estado_display is
        when "000" =>
        digctrl<="01111111";
        display<=in_display1_t;
        next_estado<="001";
        when "001" =>
        digctrl<="10111111";
        display<=in_display2_t;
        next_estado<="000";
        when others=>
        next_estado<="000";
        end case;
        
     elsif (estado="10"or estado="11") --and cafe='1' 
     then
        estado_display<=next_estado;
       case estado_display is
        when "000" =>
        digctrl<="01111111";
        display<=in_display1_cafe;
        next_estado<="001";
        when "001" =>
        digctrl<="10111111";
        display<=in_display2_cafe;
        next_estado<="000";
        when others=>
        next_estado<="000";
        end case;
        
   
--    elsif estado="11" and cafe='0' then
--        display1 <=in_display1_leche;
--        display2 <=in_display2_leche;
--        display3 <="0000000";
--        display4 <="0000000";
--        display5 <="0000000";   
    else  
        digctrl<="11111111";
    end if;
end if;
end process;
end Behavioral;
