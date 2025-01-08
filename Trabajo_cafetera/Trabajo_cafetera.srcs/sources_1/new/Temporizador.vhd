library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity Temporizador is
generic(
        width:positive:=6;
        tiempo:positive:=6
        );
    Port (
        CLK : in std_logic;
        tiempo_in : in std_logic_vector(tiempo-1 downto 0);
        cafe : in std_logic;
        Habilitar_T : in std_logic_vector(1 downto 0);
        Pause : in std_logic;
        display1 : out std_logic_vector(width downto 0);
        display2 : out std_logic_vector(width downto 0);
        final_tiempo : out std_logic;
        cafe_terminado : out std_logic
        
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
        if Habilitar_t = "00" then
            final_tiempo<='0';
            cafe_terminado<='0';
            Start_i<='0';
        elsif Habilitar_T = "10" and cafe = '0' then --Si es el modo cafe solo y no es temporixador de cafe
            Start_i<='0';
        elsif Habilitar_T="10" and tiempo_in ="000000" then 
            Start_i<='0';
        elsif Pause='1' then
            Start_i<='0';
        elsif Habilitar_T = "11" or Habilitar_T="10"  then
            Start_i<='1';
        
        end if;
        
    end process;
    
    process (clk_1hz, Start_i)
    subtype V is integer range 0 to 60;
    variable int : V :=to_integer(unsigned(tiempo_in));
    variable unit_sec : V :=int/10;
    variable dec_sec  : V :=int mod 10;
    begin
        
    if rising_edge(clk_1hz) and Start_i='1' then
            if unit_sec=0 and dec_sec=0 then
                final <='1';
            elsif unit_sec=0 then
                final<='0';
                unit_sec:=9;
                if dec_sec=0 then
                    dec_sec:=5;
                    
                else
                    dec_sec:=dec_sec-1;
                end if;
            else 
                final<='0';
                unit_sec:=unit_sec-1;
            end if;
        end if;
        
        display1 <= std_logic_vector(to_unsigned(unit_sec,display1'length));
        display2 <= std_logic_vector(to_unsigned(dec_sec,display2'length));
        if (Habilitar_T="10" and cafe='1')or(Habilitar_T="11" and cafe='0') then
        final_tiempo<=final;
        end if;        
        if cafe='1' then
        cafe_terminado<=final;
        end if;
    end process;

end Behavioral;
