library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity Temporizador is
generic(
        width:positive:=3
        );
    Port (
        CLK : in std_logic;
        display1 : out std_logic_vector(width downto 0);
        display2 : out std_logic_vector(width downto 0);
        display3 : out std_logic_vector(width downto 0);
        display4 : out std_logic_vector(width downto 0);
        display5 : out std_logic_vector(width downto 0);
        display6 : out std_logic_vector(width downto 0);
        display7 : out std_logic_vector(width downto 0);
        display8 : out std_logic_vector(width downto 0);
        Habilitar_T : in std_logic;
        Start : in std_logic;
        Pause : in std_logic;
        Reset : in std_logic
     );
end Temporizador;

architecture Behavioral of Temporizador is
   signal Start_i : std_logic :='0';
    signal Reset_i : std_logic :='0';
    
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
    
    ME : process (Habilitar_T,Start,Pause,Reset)
    begin
        if Habilitar_T = '1' and Start = '1' and Pause = '0'then
            Start_i<='1';
            Reset_i<='0';
        elsif Pause='1' then
            Start_i<='0';
            Reset_i<='0';
        elsif Reset = '1'then
            Reset_i<='1';
        end if;
    end process;
    
    process (clk_1hz, Start_i, Reset_i)
    subtype V is integer range 0 to 15;
    variable unit_sec : V :=0;
    variable unit_min : V :=1;
    variable dec_sec  : V :=0;
    variable dec_min  : V :=0;
    begin
        
        if Reset_i='1' then --Reset prioritario
            unit_sec:=0;
            dec_sec:=0;
            unit_min:=1;
            dec_min:=0;

        elsif rising_edge(clk_1hz) and Start_i='1' then
            if unit_sec=0 then
                unit_sec:=9;
                if dec_sec=0 then
                    dec_sec:=5;
                    if unit_min=0 then
                        unit_min:=9;
                        if dec_min=0 then 
                            dec_min:=0;
                        else
                            dec_min:=dec_min-1;
                        end if;
                    else
                        unit_min:=unit_min-1;
                    end if;
                else
                    dec_sec:=dec_sec-1;
                end if;
            else 
                unit_sec:=unit_sec-1;
            end if;
        end if;
        
        display1 <= std_logic_vector(to_unsigned(unit_sec,display8'length));
        display2 <= std_logic_vector(to_unsigned(dec_sec,display7'length));
        display3 <= std_logic_vector(to_unsigned(unit_min,display6'length));
        display4 <= std_logic_vector(to_unsigned(dec_min,display5'length));
    end process;
    
    Indicador : process (Habilitar_T)
    begin
    if Habilitar_T='1' then
        display8<="1011";
        display7<="1100";
        display6<="1100";
        display5<="1100";
    end if;
    end process;

end Behavioral;
