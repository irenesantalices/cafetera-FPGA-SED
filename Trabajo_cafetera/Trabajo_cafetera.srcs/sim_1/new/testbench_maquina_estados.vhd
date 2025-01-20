library ieee;
use ieee.std_logic_1164.all;


entity test_maquina is
end entity;

architecture test of test_maquina is

  constant T_CLK: time := 1 us;
constant tiempo: natural := 6;
  signal fin: boolean := false;



signal tiempo_acabado      :  STD_LOGIC;
  signal      boton_corto         :   STD_LOGIC;    -- Señal del botón para café corto
  signal      boton_largo         :   STD_LOGIC;    -- Señal del botón para café largo
signal       boton_personalizar  :   STD_LOGIC;    -- Señal pdel botón para personalizar tiempo
  signal      boton_no            :  STD_LOGIC;    -- Señal para decir que no (debe ser un boton)
  signal      boton_encendido     :  STD_LOGIC;    -- Señal para encender/apagar la cafetera
  signal      clk                 :   STD_LOGIC;    -- Señal de reloj
  signal      reset               :  STD_LOGIC;    -- Señal de reinicio
   signal     modo_cafe           :  STD_LOGIC_VECTOR(1 downto 0); 
        -- Modo: 00 = apagado, 01 = preguntando, 10 = cafe solo y 11 = cafe con leche
 signal       tiempo_cafe         : STD_LOGIC_VECTOR(tiempo-1 downto 0);
       -- tiempo_leche        : out STD_LOGIC_VECTOR(tiempo-1 downto 0);
   signal     elegido_tiempo      :  STD_LOGIC;
  signal      display1 :  std_logic_vector(6 downto 0);	
    signal    display2 :  std_logic_vector(6 downto 0);
begin

dut: entity work.Maquina_estados (Behavioral)
     port map(tiempo_acabado => tiempo_acabado,   
   		boton_corto => boton_corto,
      boton_largo => boton_largo,      
     boton_personalizar => boton_personalizar,
      boton_no => boton_no,         
      boton_encendido => boton_encendido,  
      clk => clk,                 
     reset => reset,            
      modo_cafe => modo_cafe,         
       tiempo_cafe => tiempo_cafe,       
       elegido_tiempo => elegido_tiempo,   
        display1 => display1, 
       display2 => display2);

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
    reset <= '1';
    tiempo_acabado <= '0';  
    boton_corto <= '0';
    boton_largo <= '0';  
    boton_personalizar <= '0';
    boton_no <= '0';
    boton_encendido <= '0';     
 
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';
    
    reset <= '0';
    boton_encendido <= '1'; --estado cafe solo
    elegido_tiempo <= '1'; 

    wait until clk'event and clk = '1';
     
    elegido_tiempo <= '0';

    for i in 0 to 50 loop
      wait until clk'event and clk = '1';
    end loop;
    wait until clk'event and clk = '1';
 
    tiempo_acabado <= '1'; -- estado seleccion tipo

    wait until clk'event and clk = '1';
    tiempo_acabado <= '0';

    for i in 0 to 10 loop
      wait until clk'event and clk = '1';
    end loop;
    wait until clk'event and clk = '1';

    boton_no <= '1'; --estado apagada

    wait until clk'event and clk = '1';
    boton_no <= '0';

  for i in 0 to 50 loop
      wait until clk'event and clk = '1';
    end loop;
    wait until clk'event and clk = '1';

--Segunda vuelta

    boton_encendido <= '1'; --estado cafe solo
    elegido_tiempo <= '1'; 
    
    wait until clk'event and clk = '1';
 --estado cafe solo
    elegido_tiempo <= '0'; 
    

    for i in 0 to 50 loop
      wait until clk'event and clk = '1';
    end loop;
    wait until clk'event and clk = '1';
 
    tiempo_acabado <= '1'; -- estado seleccion tipo

    wait until clk'event and clk = '1'; 
    tiempo_acabado <= '0';

    for i in 0 to 10 loop
      wait until clk'event and clk = '1';
    end loop;
    wait until clk'event and clk = '1';

    boton_personalizar <= '1'; --estado cafa leche

    wait until clk'event and clk = '1';
    boton_personalizar <= '0';

  for i in 0 to 50 loop
      wait until clk'event and clk = '1';
    end loop;
    wait until clk'event and clk = '1';

    tiempo_acabado <= '1'; ----estado apagada
    wait until clk'event and clk = '1';
    tiempo_acabado <= '0';
     for i in 0 to 6 loop
      wait until clk'event and clk = '1';
    end loop;
    wait until clk'event and clk = '1';
    fin <= true;
    wait;
  end process;

end test;


