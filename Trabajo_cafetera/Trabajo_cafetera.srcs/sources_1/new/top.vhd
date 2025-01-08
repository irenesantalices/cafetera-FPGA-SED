

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top is
generic(
        tiempo:positive:=6;
        width:positive:=6
        );
 Port(
    CLK      : in  STD_LOGIC;
    boton_corto : in std_logic;
    boton_largo : in std_logic;
    boton_personalizar : in std_logic;
    boton_confirmar : in std_logic;
    boton_no : in std_logic;
    boton_encendido : in std_logic;
    RST : in std_logic;
    led_fin_tiempo :out std_logic;
    display1 : out std_logic_vector(width downto 0);
    display2 : out std_logic_vector(width downto 0);
    display3 : out std_logic_vector(width downto 0);
    display4 : out std_logic_vector(width downto 0);
    display5 : out std_logic_vector(width downto 0)
 );
end top;

architecture Behavioral of top is

signal tiempo_temporizador : std_logic_vector(tiempo-1 downto 0);
signal cafe_listo : std_logic;
signal Start : std_logic;
signal modo_cafe : std_logic_vector(1 downto 0);
signal tiempo_c : std_logic_vector(tiempo-1 downto 0);
signal tiempo_l : std_logic_vector(tiempo-1 downto 0);
signal s_display1 : std_logic_vector(width downto 0);
signal s_display2 : std_logic_vector(width downto 0);

signal Pause : std_logic;

COMPONENT temporizador
       PORT (
        CLK : in std_logic;
        cafe : in std_logic;
        tiempo_in : in std_logic_vector(tiempo-1 downto 0);
        display1 : out std_logic_vector(width downto 0);
        display2 : out std_logic_vector(width downto 0);
        Habilitar_T : in std_logic_vector(1 downto 0);
        final_tiempo : out std_logic;
        cafe_terminado : out std_logic;
        Pause : in std_logic
            );
    END COMPONENT;
COMPONENT Display_pregunta
       PORT (
           estado : in std_logic_vector(1 downto 0);
           display1 : out std_logic_vector(width downto 0);
           display2 : out std_logic_vector(width downto 0);
           display3 : out std_logic_vector(width downto 0);
           display4 : out std_logic_vector(width downto 0);
           display5 : out std_logic_vector(width downto 0)  
            );
    END COMPONENT;
COMPONENT Maquina_estados
       PORT (
        boton_corto         : in  STD_LOGIC;    -- Señal del botón para café corto
        boton_largo         : in  STD_LOGIC;    -- Señal del botón para café largo
        boton_personalizar  : in  STD_LOGIC;    -- Señal pdel botón para personalizar tiempo
        boton_confirmar     : in  STD_LOGIC;    -- Señal para confirmar (debe ser un boton)
        boton_no            : in  STD_LOGIC;    -- Señal para decir que no (debe ser un boton)
        boton_encendido     : in  STD_LOGIC;    -- Señal para encender/apagar la cafetera
        clk                 : in  STD_LOGIC;    -- Señal de reloj
        reset               : in  STD_LOGIC;    -- Señal de reinicio
        modo_cafe           : out STD_LOGIC_VECTOR(1 downto 0); -- Modo: 00 = apagado, 01 = eligiendo, 10 = elegir tiempo, 11 = temporizador
        tiempo_cafe         : out STD_LOGIC_VECTOR(tiempo-1 downto 0);
        tiempo_leche        : out STD_LOGIC_VECTOR(tiempo-1 downto 0)
            );
    END COMPONENT;
begin
Inst_temporizador_leche: temporizador 
    PORT MAP (
        CLK => CLK,
        cafe=>cafe_listo,
        tiempo_in=>tiempo_l,
        display1 => s_display1,
        display2 => s_display2,
        Habilitar_T => modo_cafe,
        final_tiempo=>led_fin_tiempo,
        Pause => RST
    );
    Inst_temporizador_cafe: temporizador 
    PORT MAP (
        CLK => CLK,
        cafe =>'1',
        tiempo_in=>tiempo_c,
        display1 => s_display1,
        display2 => s_display2,
        Habilitar_T => modo_cafe, 
        final_tiempo=>led_fin_tiempo,
        Pause => RST,
        cafe_terminado=>cafe_listo
    );
   Inst_display_pregunta: Display_pregunta 
    PORT MAP (
        estado =>modo_cafe,
        display1 =>s_display1,
        display2 =>s_display2,
        display3 =>display3,
        display4 =>display4,
        display5 =>display5
    );
Inst_estados: Maquina_estados 
    PORT MAP (
        boton_corto  => boton_corto,
        boton_largo => boton_largo,    -- Señal del botón para café largo
        boton_personalizar  =>boton_personalizar,   -- Señal pdel botón para personalizar tiempo
        boton_confirmar =>boton_confirmar,    -- Señal para confirmar (debe ser un boton)
        boton_no => boton_no,    -- Señal para decir que no (debe ser un boton)
        boton_encendido  => boton_encendido,   -- Señal para encender/apagar la cafetera
        clk  =>CLK,    -- Señal de reloj
        reset => RST,    -- Señal de reinicio
        modo_cafe =>modo_cafe, -- Modo: 00 = apagado, 01 = eligiendo, 10 = solo, 11 = con leche
        tiempo_cafe => tiempo_c,
        tiempo_leche =>tiempo_l
    );
    display1<=s_display1;
    display2<=s_display2;
end Behavioral;
