library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

entity tb_Temporizador is
end tb_Temporizador;

architecture Behavioral of tb_Temporizador is

    -- Constants for testbench
    constant CLK_PERIOD : time := 10 ns;

    -- Signals to connect to the DUT
    signal start : std_logic := '0';
    signal CLK : std_logic := '0';
    signal tiempo_in : std_logic_vector(5 downto 0) := (others => '0');
    signal Habilitar_T : std_logic_vector(1 downto 0) := "00";
    signal Pause : std_logic := '0';
    signal display1 : std_logic_vector(6 downto 0);
    signal display2 : std_logic_vector(6 downto 0);
    signal segundos    : integer;
    signal decenas     : integer;
    signal final_tiempo : std_logic;

    -- Clock generation process
   

begin

    -- Instantiate the DUT
    DUT: entity work.Temporizador
        generic map (
            width => 6,
            tiempo => 6
        )
        port map (
            start => start,
            CLK => CLK,
            tiempo_in => tiempo_in,
            Habilitar_T => Habilitar_T,
            Pause => Pause,
            display1 => display1,
            display2 => display2,
            segundos =>segundos,
            decenas => decenas,
            final_tiempo => final_tiempo
        );

    -- Test process
     process
    begin
        while true loop
            CLK <= '0';
            wait for CLK_PERIOD / 2;
            CLK <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;
    process
    begin
        -- Test Case 1: Initialize and wait
        report "Starting Test Case 1: Initialize and wait.";
        start <= '0';
        tiempo_in <= "001010"; -- 10 seconds
        Habilitar_T <= "00";
        Pause <= '0';
        wait for 100 ns;

        -- Test Case 2: Enable and start counting
        report "Starting Test Case 2: Enable and start counting.";
        Habilitar_T <= "11";
        start <= '1';
        wait for 3 ns; -- Simulate some time

        -- Test Case 3: Pause the timer
        report "Starting Test Case 3: Pause the timer.";
        Pause <= '1';
        wait for 10 ns;
        Pause <= '0';

        -- Test Case 4: Countdown complete
        report "Starting Test Case 4: Countdown complete.";
        wait for 10 ns; -- Wait for countdown to finish
        Habilitar_T <= "00";
        report "Testbench completed.";
        wait;
    end process;

end Behavioral;
