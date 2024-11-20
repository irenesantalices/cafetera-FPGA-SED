
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity segundo is
    port (
        CLK     : in std_logic;  -- Señal de reloj
        RESET   : in std_logic;  -- Reinicia el contador
        START   : in std_logic;
        DONE    : out std_logic  -- Señal que indica que se completaron los ciclos
    );
end segundo;

architecture Behavioral of segundo is
    constant ciclos    : integer := 100000; -- Número de ciclos a esperar
    signal counter     : integer := 0;      -- Contador interno
begin
    process(CLK)
    begin
    if START = '1' then
        if rising_edge(CLK) then
            if RESET = '1' then
                counter <= 0; -- Reinicia el contador
                DONE <= '0';  -- Indica que no se ha terminado
            elsif counter < ciclos then
                counter <= counter + 1; -- Incrementa el contador
                DONE <= '0';
            else
                DONE <= '1'; -- Señal activa cuando se alcanzan los 100,000 ciclos
                counter <= 0;
            end if;
        end if;
    end if;
    end process;
end Behavioral;