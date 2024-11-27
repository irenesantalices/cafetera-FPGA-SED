library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control_Botones is
  Port (
        boton_corto     : in  STD_LOGIC;    -- Señal del botón para café corto
        boton_largo     : in  STD_LOGIC;    -- Señal del botón para café largo
        boton_encendido : in  STD_LOGIC;    -- Señal para encender/apagar la cafetera
        clk             : in  STD_LOGIC;    -- Señal de reloj
        reset           : in  STD_LOGIC;    -- Señal de reinicio
        modo_cafe       : out STD_LOGIC_VECTOR(1 downto 0); -- Modo: 00 = apagado, 01 = corto, 10 = largo
        estado_cafetera : out STD_LOGIC     -- Estado: 1 = encendida, 0 = apagada
    );
end Control_Botones;

architecture Behavioral of Control_Botones is
signal cafetera_on : STD_LOGIC := '0'; -- Estado interno de la cafetera
signal modo_actual : STD_LOGIC_VECTOR (1 DOWNTO 0); -- Modo actual: 00, 01 o 10
begin
    process(clk, reset)
    begin
    -- Reset de todos los estados
        if reset = '1' then 
            cafetera_on <= '0';
            modo_actual <= "00";
        elsif rising_edge(clk) then
        --Control de ON/OFF
        if boton_encendido = '1' then
            cafetera_on <= not cafetera_on;
        end if;
 -- Control del modo de café
        if cafetera_on = '1' then
            if boton_corto = '1' then
                modo_actual <= "01"; -- Modo café corto
            elsif boton_largo = '1' then
                modo_actual <= "10"; -- Modo café largo
            else
                modo_actual <= "00"; -- Sin acción
            end if;
        else
            modo_actual <= "00"; -- Si está apagada, sin acción
        end if;
    end if;
    end process;

    estado_cafetera <= cafetera_on;
    modo_cafe <= modo_actual;        
        
end Behavioral;
