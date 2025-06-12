

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_completo is
    --  Port ( );
end test_completo;

architecture Behavioral of test_completo is

    constant T_CLK: time := 1 us;
    constant tiempo: natural := 6;
    signal fin: boolean := false;
    signal final_tiempo : std_logic:='0';
    signal digctrl  : std_logic_vector(7 downto 0):="11111111"; --out
    signal CLK      : std_logic; --in
    signal sw_encendido : std_logic:='0'; --in
    signal tiempo_selec: std_logic;
    signal  RST : std_logic;
    signal personalizar :  std_logic;
    signal start_tiempo:  std_logic;
    signal contando : std_logic;

    --    led_fin_tiempo :out std_logic;
    signal  leds : std_logic_vector(3 downto 0);
    signal display : std_logic_vector(6 downto 0):="0000000";
    signal      boton_confirmar     : std_logic;
    signal      boton_corto         :   STD_LOGIC;    -- Señal del botón para café corto
    signal      boton_largo         :   STD_LOGIC;    -- Señal del botón para café largo
    signal       boton_personalizar  :   STD_LOGIC;    -- Señal pdel botón para personalizar tiempo
    signal      boton_no            :  STD_LOGIC;    -- Señal para decir que no (debe ser un boton)
    signal     modo_cafe           :  STD_LOGIC_VECTOR(1 downto 0);
    signal        tiempo_out        :  STD_LOGIC_VECTOR(tiempo-1 downto 0);

    -- Modo: 00 = apagado, 01 = preguntando, 10 = cafe solo y 11 = cafe con leche

begin

    dut: entity work.top (Behavioral)
        port map(digctrl => digctrl,
                 final_tiempo => final_tiempo,  
                 start_tiempo => start_tiempo,
                 tiempo_selec=>tiempo_selec,
                 boton_confirmar => boton_confirmar,
                 boton_corto => boton_corto,
                 boton_largo => boton_largo,
                 boton_personalizar => boton_personalizar,
                 boton_no => boton_no,
                 sw_encendido => sw_encendido,
                 clk => clk,
                 RST => RST,
                 leds => leds,
                 contando =>contando,
                 tiempo_out=> tiempo_out,
                 out_personalizar =>personalizar,
                 display => display
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

        RST <= '1'; --boton reset negado
        sw_encendido <= '1'; --estado cafe solo

        wait until clk'event and clk = '1';
        wait until clk'event and clk = '1';


        boton_largo <= '1';

        wait until clk'event and clk = '1';
        wait until clk'event and clk = '1';
        boton_largo <= '0';
        for i in 0 to 20 loop
            wait until clk'event and clk = '1';
        end loop;
        boton_no <='1';
        wait until clk'event and clk = '1';
        wait until clk'event and clk = '1';

        boton_no <='0';

        wait until clk'event and clk = '1';
        wait until clk'event and clk = '1';
        sw_encendido <= '0';

        wait until clk'event and clk = '1';

        sw_encendido <= '1';
        wait until clk'event and clk = '1';

        wait until clk'event and clk = '1';
         boton_largo <= '1';

        wait until clk'event and clk = '1';
        wait until clk'event and clk = '1';
        boton_largo <= '0';
        for i in 0 to 30 loop
            wait until clk'event and clk = '1';
        end loop;
        wait until clk'event and clk = '1';
        boton_no <= '1';
        wait until clk'event and clk = '1';
        boton_no <= '0';

        boton_personalizar <= '1';

        wait until clk'event and clk = '1';

        boton_largo <= '1';
        boton_personalizar <='0';
         for i in 0 to 2 loop
             wait until clk'event and clk = '1';
              boton_largo <= '1';

              wait until clk'event and clk = '1';

         boton_largo <= '0';
      end loop;

        wait until clk'event and clk = '1';

        boton_largo <= '0';
        boton_confirmar <='1';

        wait until clk'event and clk = '1';

        boton_confirmar <='0';
        boton_personalizar <='0';

        wait until clk'event and clk = '1';
        for i in 0 to 20 loop
            wait until clk'event and clk = '1';
        end loop;

        boton_confirmar <='1';

        wait until clk'event and clk = '1';

        boton_confirmar <='0';
        
        boton_corto <= '1';

        wait until clk'event and clk = '1';

        boton_corto <= '0';
        for i in 0 to 50 loop
            wait until clk'event and clk = '1';
        end loop;
        fin <= true;
        wait;
    end process;

end Behavioral;
