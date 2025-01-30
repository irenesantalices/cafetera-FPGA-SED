

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_completo is
    --  Port ( );
end test_completo;

architecture behavioral of test_completo is

    constant T_CLK: time := 1 us;
    constant tiempo: natural := 6;
    signal fin: boolean := false;
    signal final_tiempo : std_logic:='0';
    signal  RST : std_logic;
    signal CLK      : std_logic; --in
    signal sw_encendido : std_logic:='0'; --in
    --    led_fin_tiempo :out std_logic;
    signal  leds : std_logic_vector(3 downto 0);
    signal tiempo_acabado :  std_logic:='0';
    signal     modo_cafe           :  STD_LOGIC_VECTOR(1 downto 0);
    signal     out_tiempo_acabado    : std_logic;
    signal      boton_confirmar     : std_logic;
    signal      boton_corto         :   STD_LOGIC;    -- Señal del botón para café corto
    signal      boton_largo         :   STD_LOGIC;    -- Señal del botón para café largo
    signal       boton_personalizar  :   STD_LOGIC;    -- Señal pdel botón para personalizar tiempo
    signal      boton_no            :  STD_LOGIC;    -- Señal para decir que no (debe ser un boton)
    -- Modo: 00 = apagado, 01 = preguntando, 10 = cafe solo y 11 = cafe con leche
    signal     tiempo_cafe          : std_logic_vector(5 downto 0);
    signal     tiempo_elegido       : std_logic;
    signal     start_count          : std_logic;
    signal display : std_logic_vector(6 downto 0):="0000000";
begin

    dut: entity work.Maquina_estados (Behavioral)
        port map(
            --final_tiempo => final_tiempo,  
            boton_confirmar => boton_confirmar,
            tiempo_acabado => tiempo_acabado,
            boton_corto => boton_corto,
            boton_largo => boton_largo,
            boton_personalizar => boton_personalizar,
            boton_no => boton_no,
            boton_encendido => sw_encendido,
            clk => clk,
            tiempo_cafe => tiempo_cafe,
            modo_cafe => modo_cafe,
            reset => RST,
            leds => leds,
            start_count => start_count,

            out_tiempo_acabado => out_tiempo_acabado,
            elegido_tiempo => tiempo_elegido
        );

    process
    begin
        clk <= '0';
        wait for T_CLK/2;
        clk <= '1';
        if fin = true then
            wait;
        end if;
        wait for T_CLK/2;

    end process;

    process
    begin
        RST <= '1';
        boton_corto <= '0';
        boton_largo <= '0';
        boton_personalizar <= '0';
        boton_confirmar <= '0';
        boton_no <= '0';
        sw_encendido <= '0';

        wait until clk'event and clk = '1';
        wait until clk'event and clk = '1';

        RST <= '0';
        sw_encendido <= '1'; --estado cafe solo

        wait until clk'event and clk = '1';
        wait until clk'event and clk = '1';


        boton_corto <= '1';

        wait until clk'event and clk = '1';
        wait until clk'event and clk = '1';
        tiempo_acabado <= '1';

        wait until clk'event and clk = '1';
        wait until clk'event and clk = '1';


        boton_no <='1';
        boton_corto <= '0';

        wait until clk'event and clk = '1';
        tiempo_acabado <='0';
        boton_no <='0';

        wait until clk'event and clk = '1';
        wait until clk'event and clk = '1';

        sw_encendido <= '0';

        wait until clk'event and clk = '1';

        sw_encendido <= '1';

        wait until clk'event and clk = '1';

        -- boton_personalizar <= '1';

        wait until clk'event and clk = '1';

        boton_largo <= '1';

        wait until clk'event and clk = '1';

        boton_largo <= '0';

        wait until clk'event and clk = '1';

        tiempo_acabado <='1';

        wait until clk'event and clk = '1';
        tiempo_acabado <= '0';
        boton_confirmar <='1';

        wait until clk'event and clk = '1';

        boton_confirmar <='0';

        wait until clk'event and clk = '1';

        wait until clk'event and clk = '1';

        boton_corto <= '1';

        wait until clk'event and clk = '1';

        boton_corto <= '0';

        wait until clk'event and clk = '1';

        tiempo_acabado <= '1';
        wait until clk'event and clk = '1';
        tiempo_acabado <= '1';

        for i in 0 to 50 loop
            wait until clk'event and clk = '1';
        end loop;
        fin <= true;
        wait;
    end process;

end Behavioral;
