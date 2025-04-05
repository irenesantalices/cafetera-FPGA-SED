

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top is
generic(
        tiempo:positive:=6;
        width:positive:=6
        );
 Port(
   -- final_tiempo : out std_logic;
   -- start_tiempo    : out std_logic;
    digctrl  : out std_logic_vector(7 downto 0);
    CLK      : in  std_logic;
    boton_corto : in std_logic;
    boton_largo : in std_logic;
    boton_personalizar : in std_logic;
    boton_confirmar : in std_logic;
    boton_no : in std_logic;
    sw_encendido : in std_logic;
    RST : in std_logic;
--    led_fin_tiempo :out std_logic;
    leds :out std_logic_vector(3 downto 0);
    
    display : out std_logic_vector(width downto 0)
 );
end top;

architecture Behavioral of top is

signal fin_tiempo : std_logic;
signal tiempo_elegido : std_logic;
signal modo_cafe : std_logic_vector(1 downto 0);
signal tiempo_c : std_logic_vector(tiempo-1 downto 0);
signal start_temp : std_logic;
signal sync_boton_no : std_logic;
signal s_boton_no : std_logic;
signal sync_boton_corto : std_logic;
signal s_boton_corto : std_logic;
signal sync_boton_personalizar : std_logic;
signal s_boton_personalizar : std_logic;
signal sync_boton_largo : std_logic;
signal sync_boton_confirmar : std_logic;
signal s_boton_confirmar : std_logic;
signal s_boton_largo : std_logic;
signal out_personalizar :std_logic;

signal s_display1_cafe : std_logic_vector(width downto 0);
signal s_display2_cafe : std_logic_vector(width downto 0);
signal s_display1_t : std_logic_vector(width downto 0);
signal s_display2_t : std_logic_vector(width downto 0);

signal s_code_unit  :  STD_LOGIC_VECTOR(3 downto 0);
signal s_code_dec  :  STD_LOGIC_VECTOR(3 downto 0);


signal Pause : std_logic;
COMPONENT EDGEDTCTR
       PORT (
        CLK : in std_logic;
        SYNC_IN : in std_logic;
        EDGE : out std_logic
            );
    END COMPONENT;
    COMPONENT SYNCHRNZR
       PORT (
        CLK : in std_logic;
        ASYNC_IN : in std_logic;
        SYNC_OUT : out std_logic
            );
    END COMPONENT;
COMPONENT temporizador
       PORT (
        Start : in std_logic;
        CLK : in std_logic;
        tiempo_in : in std_logic_vector(tiempo-1 downto 0);
        display1 : out std_logic_vector(width downto 0);
        display2 : out std_logic_vector(width downto 0);
        Habilitar_T : in std_logic_vector(1 downto 0);
        code_unit : out std_logic_vector(3 downto 0);
        code_dec : out std_logic_vector(3 downto 0);
        final_tiempo : out std_logic;
        Pause : in std_logic
            );
    END COMPONENT;
--COMPONENT Display_pregunta
--       PORT (
--           personalizar : in std_logic;
--           in_clk : in std_logic;
--           digctrl  : out std_logic_vector(7 downto 0);
--           in_display1_cafe : in std_logic_vector(width downto 0);
--           in_display2_cafe : in std_logic_vector(width downto 0);
----           in_display1_leche : in std_logic_vector(width downto 0);
----           in_display2_leche : in std_logic_vector(width downto 0);
--           in_display1_t : in std_logic_vector(width downto 0);
--           in_display2_t : in std_logic_vector(width downto 0);
--           tiempo_elegido : in std_logic;
--           estado : in std_logic_vector(1 downto 0);
--           display : out std_logic_vector(width downto 0)
           
--            );
--    END COMPONENT;
COMPONENT Maquina_estados
       PORT (
        --out_personalizar    : out std_logic;
        start_count         : out std_logic;
        tiempo_acabado      : in STD_LOGIC;
        boton_corto         : in  STD_LOGIC;    -- Señal del botón para café corto
        boton_largo         : in  STD_LOGIC;    -- Señal del botón para café largo
        boton_personalizar  : in  STD_LOGIC;    -- Señal pdel botón para personalizar tiempo
        boton_confirmar  : in  STD_LOGIC;    -- Señal pdel botón para personalizar tiempo
        boton_no            : in  STD_LOGIC;    -- Señal para decir que no (debe ser un boton)
        boton_encendido     : in  STD_LOGIC;    -- Señal para encender/apagar la cafetera
        clk                 : in  STD_LOGIC;    -- Señal de reloj
        reset               : in  STD_LOGIC;    -- Señal de reinicio
        modo_cafe           : out STD_LOGIC_VECTOR(1 downto 0); -- Modo: 00 = apagado, 01 = eligiendo, 10 = elegir tiempo, 11 = temporizador
        tiempo_cafe         : out STD_LOGIC_VECTOR(tiempo-1 downto 0);
--        tiempo_leche        : out STD_LOGIC_VECTOR(tiempo-1 downto 0);
        leds                : out std_logic_vector(3 downto 0)
       -- display1            : out std_logic_vector(6 downto 0);	
        --display2            : out std_logic_vector(6 downto 0)	
            );
    END COMPONENT;
begin

    Inst_temporizador_cafe: temporizador 
    PORT MAP (
        start => start_temp,
        CLK => CLK,
        tiempo_in=>tiempo_c,
        display1 => s_display1_cafe,
        display2 => s_display2_cafe,
        Habilitar_T => modo_cafe, 
        final_tiempo=>fin_tiempo,
        Pause => RST
    );
    Inst_sync_boton_no: SYNCHRNZR 
    PORT MAP (
        CLK =>clk,
        ASYNC_IN =>boton_no,
        SYNC_OUT =>sync_boton_no
    );
    Inst_edge_boton_no: EDGEDTCTR 
    PORT MAP (
        CLK =>clk,
        SYNC_IN =>sync_boton_no,
        EDGE =>s_boton_no
    );
 
    Inst_sync_boton_corto: SYNCHRNZR 
    PORT MAP (
        CLK =>clk,
        ASYNC_IN =>boton_corto,
        SYNC_OUT =>sync_boton_corto
    );
    Inst_edge_boton_corto: EDGEDTCTR 
    PORT MAP (
        CLK =>clk,
        SYNC_IN =>sync_boton_corto,
        EDGE =>s_boton_corto
    );
    Inst_sync_boton_largo: SYNCHRNZR 
    PORT MAP (
        CLK =>clk,
        ASYNC_IN =>boton_largo,
        SYNC_OUT =>sync_boton_largo
    );
    Inst_edge_boton_largo: EDGEDTCTR 
    PORT MAP (
        CLK =>clk,
        SYNC_IN =>sync_boton_largo,
        EDGE =>s_boton_largo
    );
    Inst_sync_boton_personalizar: SYNCHRNZR 
    PORT MAP (
        CLK =>clk,
        ASYNC_IN =>boton_personalizar,
        SYNC_OUT =>sync_boton_personalizar
    );
    Inst_edge_boton_personalizar: EDGEDTCTR 
    PORT MAP (
        CLK =>clk,
        SYNC_IN =>sync_boton_personalizar,
        EDGE =>s_boton_personalizar
    );
    Inst_sync_boton_confirmar: SYNCHRNZR 
    PORT MAP (
        CLK =>clk,
        ASYNC_IN =>boton_confirmar,
        SYNC_OUT =>sync_boton_confirmar
    );
    Inst_edge_boton_confirmar: EDGEDTCTR 
    PORT MAP (
        CLK =>clk,
        SYNC_IN =>sync_boton_confirmar,
        EDGE =>s_boton_confirmar
    );
--   Inst_display_pregunta: Display_pregunta 
--    PORT MAP (
--        personalizar => out_personalizar,
--        in_clk => clk,
--        digctrl=>digctrl,
--        in_display1_cafe =>s_display1_cafe,
--        in_display2_cafe  =>s_display2_cafe,
--        in_display1_t =>s_display1_t,
--        in_display2_t  =>s_display2_t,
----        in_display1_leche  =>s_display1_leche,
----        in_display2_leche  =>s_display2_leche,
--        tiempo_elegido=>tiempo_elegido,
--        estado =>modo_cafe,
--        display =>display
        
--    );
Inst_estados: Maquina_estados 
    PORT MAP (
        start_count =>start_temp,
        leds =>leds,
        tiempo_acabado=> fin_tiempo,
        boton_corto  => boton_corto,
        boton_largo => boton_largo,    -- Señal del botón para café largo
        boton_personalizar  => boton_personalizar,   -- Señal pdel botón para personalizar tiempo
        boton_confirmar => boton_confirmar,    -- Señal para confirmar (debe ser un boton)
        boton_no => boton_no,    -- Señal para decir que no (debe ser un boton)
        boton_encendido  => sw_encendido,   -- Señal para encender/apagar la cafetera
        clk  =>CLK,    -- Señal de reloj
        reset => RST,    -- Señal de reinicio
        modo_cafe =>modo_cafe, -- Modo: 00 = apagado, 01 = eligiendo, 10 = solo, 11 = con leche
        tiempo_cafe => tiempo_c
       -- out_personalizar => out_personalizar,
--        tiempo_leche =>tiempo_l,
      --  display1=>s_display1_t,
       -- display2=>s_display2_t
    );
  -- final_tiempo <= fin_tiempo;
  -- start_tiempo <= start_temp;
end Behavioral;
