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
        display1 : out std_logic_vector(6 downto 0);
        display2 : out std_logic_vector(6 downto 0);
        sumando : out std_logic:='0';

        salida    : out std_logic_vector(5 downto 0)

    );
end time_selection;

architecture Behavioral of time_selection is
    signal tiempo_actual : natural range 10 to 60 := 15;
    signal inicio_prev : std_logic := '0';
    signal s_aumentar : std_logic :='0';
    signal s_dec : std_logic_vector(3 downto 0):="0000";
    signal s_unit : std_logic_vector(3 downto 0):="0000";
    COMPONENT decoder
        PORT (
            code : IN std_logic_vector(3 DOWNTO 0);
            led : OUT std_logic_vector(6 DOWNTO 0)
        );
    END COMPONENT;

begin
    Inst_decoder_dec: decoder
        PORT MAP (
            code=>s_dec,
            led=>display1
        );
    Inst_decoder_unit: decoder
        PORT MAP (
            code=>s_unit,
            led=>display2
        );
    process(clk, reset)
        variable int :natural  :=tiempo_actual;
        variable dec_sec : natural :=int/10;
        variable unit_sec  : natural :=int mod 10;
        variable inicializado : std_logic :='0';
    begin
        
        if reset = '0' then
            tiempo_actual <= 10;
            inicio_prev <= '0';
        elsif rising_edge(clk) then
            inicio_prev <= inicio;  -- Registro del estado anterior
            sumando<='1';

            -- Detección de flanco ascendente en 'inicio'
           -- if inicio = '1' and inicio_prev = '0' then
               -- tiempo_actual <= 10;  -- Reiniciar al valor inicial cuando se activa inicio
            --els
            if inicio = '1' then
                -- Lógica para aumentar/disminuir solo cuando inicio está activo
                if aumentar = '1' and tiempo_actual < 60 then
                    tiempo_actual <= tiempo_actual + 1;
                elsif disminuir = '1' and tiempo_actual > 10 then
                    tiempo_actual <= tiempo_actual - 1;
                end if;
            end if;
        end if;
        s_unit <= std_logic_vector(to_unsigned(unit_sec,4));
        s_dec <= std_logic_vector(to_unsigned(dec_sec,4));
    end process;

    salida <= std_logic_vector(to_unsigned(tiempo_actual, 6));
end Behavioral;