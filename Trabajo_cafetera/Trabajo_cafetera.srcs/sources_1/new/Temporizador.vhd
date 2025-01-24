library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity Temporizador is
generic(
        width:positive:=6;
        tiempo:positive:=6
        );
    Port (
        start : in std_logic;
        CLK : in std_logic;
        tiempo_in : in std_logic_vector(tiempo-1 downto 0);
        Habilitar_T : in std_logic_vector(1 downto 0);
        Pause : in std_logic;
        display1 : out std_logic_vector(width downto 0);
        display2 : out std_logic_vector(width downto 0);
        
        final_tiempo : out std_logic
        
     );
end Temporizador;

architecture Behavioral of Temporizador is
   signal Start_i : std_logic :='0';    
   signal final   : std_logic :='0';
   signal clk_1hz : std_logic;
    
    COMPONENT clk1hz
       PORT (
              CLK: in  STD_LOGIC;
              clk_1hz : out STD_LOGIC
            );
    END COMPONENT;
begin
Inst_clk1hz: clk1hz 
    PORT MAP (
        CLK => CLK,
        CLK_1hz => clk_1hz
    );
    
    ME : process (Habilitar_T,Pause)
    begin
--        if Habilitar_t = "00"  then
--            Start_i<='0';

       -- els
        if Pause='1' then
            Start_i<='0';
        elsif -- (Habilitar_T = "11" or Habilitar_T="10")and 
        start = '1'  then
            Start_i<='1';
        
        end if;
        
    end process;
    
    process (clk, start)
    subtype V is integer range 0 to 60;
    variable int : V :=to_integer(unsigned(tiempo_in));
    variable unit_sec : V :=int/10;
    variable dec_sec  : V :=int mod 10;
    begin
    if Habilitar_T = "00" or Habilitar_T = "01" or start ='0' then
        final_tiempo<='0';
    end if;
    if rising_edge(clk) and start='1' then
            if unit_sec=0 and dec_sec=0 then
                final_tiempo <='1';
            elsif unit_sec=0 then
                final_tiempo<='0';
                unit_sec:=9;
                dec_sec:=dec_sec-1;
            else 
                final_tiempo<='0';
                unit_sec:=unit_sec-1;
            end if;
        end if;
        
        display1 <= std_logic_vector(to_unsigned(unit_sec,display1'length));
        display2 <= std_logic_vector(to_unsigned(dec_sec,display2'length));
    end process;

end Behavioral;

