library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity Temporizador is
generic(
        width:positive:=2;
        tiempo:positive:=6
        );
    Port (
        CLK : in std_logic;
        tiempo_in : in std_logic_vector(tiempo-1 downto 0);
        display1 : out std_logic_vector(width downto 0);
        display2 : out std_logic_vector(width downto 0);
        final_tiempo : out std_logic;
        Habilitar_T : in std_logic;
        Pause : in std_logic
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
        if Habilitar_T = '1'  and Pause = '0'then
            Start_i<='1';
        elsif Pause='1' then
            Start_i<='0';
        end if;
    end process;
    
    process (clk_1hz, Start_i)
    subtype V is integer range 0 to 60;
    variable int : V :=to_integer(unsigned(tiempo_in));
    variable unit_sec : V :=int/10;
    variable dec_sec  : V :=int mod 10;
    begin
        
--        if Reset_i='1' then --Reset prioritario
--            unit_sec:=0;
--            dec_sec:=0;
--            unit_min:=1;
--            dec_min:=0;

--        els
    if rising_edge(clk_1hz) and Start_i='1' then
            if unit_sec=0 and dec_sec=0 then
                final <='1';
            elsif unit_sec=0 then
                unit_sec:=9;
                if dec_sec=0 then
                    dec_sec:=5;
                    
                else
                    dec_sec:=dec_sec-1;
                end if;
            else 
                unit_sec:=unit_sec-1;
            end if;
        end if;
        
        display1 <= std_logic_vector(to_unsigned(unit_sec,display1'length));
        display2 <= std_logic_vector(to_unsigned(dec_sec,display2'length));
        final_tiempo<=final;
    end process;

end Behavioral;
