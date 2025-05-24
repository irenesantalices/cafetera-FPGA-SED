library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity time_selection is
    Port (
        clk       : in  std_logic;
        reset     : in  std_logic;
        inicio    : in  std_logic;
        aumentar  : in  std_logic;
        disminuir : in  std_logic;
        salida    : out std_logic_vector(5 downto 0)
    );
end time_selection;

architecture Behavioral of time_selection is
    signal tiempo_actual : natural range 10 to 60 := 10;
    signal inicio_prev : std_logic := '0';
begin
    process(clk, reset)
    begin
        if reset = '1' then
            tiempo_actual <= 10;
            inicio_prev <= '0';
        elsif rising_edge(clk) then
            inicio_prev <= inicio;  -- Registro del estado anterior
            
            -- Detección de flanco ascendente en 'inicio'
            if inicio = '1' and inicio_prev = '0' then
                tiempo_actual <= 10;  -- Reiniciar al valor inicial cuando se activa inicio
            elsif inicio = '1' then
                -- Lógica para aumentar/disminuir solo cuando inicio está activo
                if aumentar = '1' and tiempo_actual < 60 then
                    tiempo_actual <= tiempo_actual + 1;
                elsif disminuir = '1' and tiempo_actual > 10 then
                    tiempo_actual <= tiempo_actual - 1;
                end if;
            end if;
        end if;
    end process;

    salida <= std_logic_vector(to_unsigned(tiempo_actual, 6));
end Behavioral;