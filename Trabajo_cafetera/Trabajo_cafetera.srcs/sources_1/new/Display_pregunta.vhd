

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity Display_pregunta is
generic(
        width:positive:=6
        );
  Port ( 
    personalizar : in std_logic;
    in_clk : in std_logic;
    start : in std_logic;
    display1_t : in std_logic_vector(width downto 0);
    display2_t: in std_logic_vector(width downto 0);
    in_display1_cafe : in std_logic_vector(width downto 0);
    in_display2_cafe : in std_logic_vector(width downto 0);
    tiempo_selection : in std_logic_vector(width -1 downto 0);
    tiempo_elegido   : in std_logic;
    estado : in std_logic_vector(1 downto 0);
    digctrl  : out std_logic_vector(7 downto 0);
    display : out std_logic_vector(width downto 0));
   
end Display_pregunta;

    architecture Behavioral of Display_pregunta is
    signal clk : std_logic ;
    signal estado_display : std_logic_vector(2 downto 0):="000";
    signal next_estado : std_logic_vector(2 downto 0):="000";
    signal s_dec : std_logic_vector(3 downto 0):="0000";
    signal s_unit : std_logic_vector(3 downto 0):="0000";

    signal display1_selection :  std_logic_vector(width downto 0);
    signal display2_selection:  std_logic_vector(width downto 0);

COMPONENT clk70hz
       PORT (
              CLK: in  STD_LOGIC;
              clk_70hz : out STD_LOGIC
            );
    END COMPONENT;
   COMPONENT decoder
        PORT (
            code : IN std_logic_vector(3 DOWNTO 0);
            led : OUT std_logic_vector(6 DOWNTO 0)
        );
            END COMPONENT;

begin
Inst_clk70hz: clk70hz 
    PORT MAP (
        CLK => in_clk,
        clk_70hz => clk
    );
Inst_decoder_dec: decoder
        PORT MAP (
            code=>s_dec,
            led=>display1_selection
        );
    Inst_decoder_unit: decoder
        PORT MAP (
            code=>s_unit,
            led=>display2_selection
            );
process (estado,clk)
variable int :natural  :=to_integer(unsigned(tiempo_selection));
        variable dec_sec : natural :=int/10;
        variable unit_sec  : natural :=int mod 10;
        variable inicializado : std_logic :='0';
      
begin
     s_unit <= std_logic_vector(to_unsigned(unit_sec,4));
        s_dec <= std_logic_vector(to_unsigned(dec_sec,4));
if rising_edge(clk) then
    if estado= "00" then    --Si está apagada la máquina
        digctrl<="11111111";
   -- elsif personalizar ='0' and tiempo_elegido='0' then
        digctrl<="11111111";
    elsif estado = "01" then
        estado_display<=next_estado;
        case estado_display is
        when "000" =>
        digctrl<="01111111";
        display <=not("0111000");
        next_estado<="001";
        --hay que hacer el convertido de frecuencia
        when "001" =>
        digctrl<="10111111";
        display <=not("1111001");
        next_estado<="010";
        when "010" =>
        digctrl<="11011111";
        display <=not("0111001");
        next_estado<="011";
        when "011" =>
        digctrl<="11101111";
        display <=not("1110110");
        next_estado<="100";
        when "100" =>
        digctrl<="11110111";
        display <=not("1111001"); 
        next_estado<="000";
        when others =>
        next_estado<="000";
        end case;
    
    elsif tiempo_elegido='0' and personalizar ='1' then
    estado_display<=next_estado;
    case estado_display is
        when "000" =>
        digctrl<="01111111";
        display<=not(in_display1_cafe);
        next_estado<="001";
        when "001" =>
        digctrl<="10111111";
        display<=not(in_display2_cafe);
        next_estado<="000";
        when others=>
        next_estado<="000";
        end case;
        
     --elsif (estado="10"or estado="11") --and cafe='1' 
     

     elsif start ='1'  then
        estado_display<=next_estado;
       case estado_display is
        when "000" =>
        digctrl<="01111111";
        display<=not(display1_t);
        next_estado<="001";
        when "001" =>
        digctrl<="10111111";
        display<=not(display2_t);
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
