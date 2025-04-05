library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

entity tb_Temporizador is
end tb_Temporizador;

architecture Behavioral of tb_Temporizador is

    -- Constants for testbench
 constant T_CLK: time := 1 us;
constant tiempo: natural := 6;
  signal fin: boolean := false;
    -- Signals to connect to the DUT
    signal inicial : std_logic:='0';
    signal unidades : std_logic_vector(3 downto 0);
    signal decenas : std_logic_vector(3 downto 0);
    signal start : std_logic := '0';
    signal CLK : std_logic := '0';
    signal tiempo_in : std_logic_vector(5 downto 0) := (others => '0');
    signal Habilitar_T : std_logic_vector(1 downto 0) := "00";
    signal Pause : std_logic := '0';
    signal display1 : std_logic_vector(6 downto 0);
    signal display2 : std_logic_vector(6 downto 0);
    signal final_tiempo : std_logic;
    signal code_dec :std_logic_vector(3 downto 0);
    signal code_unit :std_logic_vector(3 downto 0);

    -- Clock generation process
   

begin

    -- Instantiate the DUT
    dut: entity work.Temporizador(Behavioral)
--        generic map (
--            width => 6,
--            tiempo => 6
--        )
        port map (
            inicial => inicial,
            start => start,
            CLK => CLK,
            tiempo_in => tiempo_in,
            Habilitar_T => Habilitar_T,
            Pause => Pause,
            display1 => display1,
            display2 => display2,
            code_dec => code_dec,
            code_unit => code_unit,
            unidades => unidades,
            decenas => decenas,
            final_tiempo => final_tiempo
        );

    -- Test process
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
    start <= '0';
    tiempo_in <= "000000";
    Habilitar_T <= "00";
    Pause <= '0';
--    display1 <= "0000000";    
--    display2 <= "0000000";    

 
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';
    
    start <= '1';
    Habilitar_T <="10";
    wait until clk'event and clk = '1';
     
    tiempo_in <= "000010";
    
    wait until clk'event and clk = '1';
    start <= '0';
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';

    start <= '0';

    wait until clk'event and clk = '1';

    tiempo_in <= "000100";
    
    wait until clk'event and clk = '1';

    start <= '1';
    
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';


    start <= '0';
    for i in 0 to 3 loop
      wait until clk'event and clk = '1';
    end loop;
    
    Pause <= '1';
    wait until clk'event and clk = '1';

    Pause <= '0'; --estado apagada

    
  for i in 0 to 5 loop
      wait until clk'event and clk = '1';
    end loop;
    
    start <='0';
    Habilitar_T <= "00";
    
    tiempo_in <="010000";
    
    wait until clk'event and clk = '1';
    
    start <= '1';

    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';

    Habilitar_T <="11";
    
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';
    
    start <='0';
    for i in 0 to 5 loop
      wait until clk'event and clk = '1';
    end loop;
    
     for i in 0 to 10 loop
      wait until clk'event and clk = '1';
    end loop;
    wait until clk'event and clk = '1';
    fin <= true;
    wait;
  end process;


end Behavioral;
