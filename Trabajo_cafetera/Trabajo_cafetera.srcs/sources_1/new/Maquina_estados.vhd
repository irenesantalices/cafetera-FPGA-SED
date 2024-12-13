library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control_Botones is
generic(
        tiempo:positive:=6;
        tiempo_corto : std_logic_vector(5 downto 0) := "000011";
        tiempo_largo : std_logic_vector(5 downto 0) := "111100"

);
  Port (
        boton_corto         : in  STD_LOGIC;    -- Señal del botón para café corto
        boton_largo         : in  STD_LOGIC;    -- Señal del botón para café largo
        boton_personalizar  : in  STD_LOGIC;    -- Señal pdel botón para personalizar tiempo
        boton_confirmar     : in  STD_LOGIC;    -- Señal para confirmar (debe ser un boton)
        boton_no            : in  STD_LOGIC;    -- Señal para decir que no (debe ser un boton)
        boton_encendido     : in  STD_LOGIC;    -- Señal para encender/apagar la cafetera
        clk                 : in  STD_LOGIC;    -- Señal de reloj
        reset               : in  STD_LOGIC;    -- Señal de reinicio
        modo_cafe           : out STD_LOGIC_VECTOR(1 downto 0); -- Modo: 00 = apagado, 01 = corto, 10 = largo
        estado_cafetera     : out STD_LOGIC;     -- Estado: 1 = encendida, 0 = apagada
        tiempo_cafe         : out STD_LOGIC_VECTOR(tiempo-1 downto 0);
        tiempo_leche         : out STD_LOGIC_VECTOR(tiempo-1 downto 0)

    );
end Control_Botones;

architecture Behavioral of Control_Botones is
type STATES is (Apagada,Seleccion_tipo_cafe, cafe_leche, cafe_solo,cafe_terminado);
signal current_state: STATES := Apagada;
signal next_state: STATES;
signal cafetera_on : STD_LOGIC := '0'; -- Estado interno de la cafetera
signal modo_actual : STD_LOGIC_VECTOR (1 DOWNTO 0); -- Modo actual: 00, 01 o 10
signal LESS        : STD_LOGIC;
signal SUM         : STD_LOGIC;
signal INICIO      : STD_LOGIC;
signal tiempo_personalizado : STD_LOGIC_VECTOR(tiempo-1 downto 0);



   COMPONENT time_selection
       PORT (
            INICIO 	: in std_logic;									
            CLK	    : in std_logic;									-- Clock
            SUM     : in std_logic;                                 -- Aumenta el valor del tiempo en uno
            LESS    : in std_logic;                                 -- Disminuye el valor del tiempo en uno
            code	: out std_logic_vector( tiempo downto 0)
            );
    END COMPONENT;
begin
Inst_time_selection: time_selection 
    PORT MAP (
        CLK => CLK,
        INICIO => INICIO,
        SUM => SUM,
        LESS => LESS,
        code =>tiempo_personalizado
    );
begin

nextstate_decod: process (boton_encendido, current_state)
 begin
 next_state <= current_state;
 case current_state is
 when Apagada =>
    cafetera_on <= '0';
    if boton_encendido = '1' then
        next_state <= Seleccion_tipo_cafe;
    end if;
 when Seleccion_tipo_cafe =>
    cafetera_on <= '1';
    if boton_encendido = '1' then
        next_state <= Apagada;
    --Poner aqui pregunta display leche
    elsif boton_confirmar = '1' then
        next_state <= cafe_leche;
    elsif boton_no = '1' then
        next_state <= cafe_solo;
    end if;
 when cafe_leche =>
 if boton_encendido = '1' then
        next_state <= Apagada;
 else 
    if boton_personalizar = '1' then
        INICIO <= '1';
        tiempo_leche <= tiempo_personalizado;
        INICIO <= '0';
    elsif boton_corto = '1' then
        tiempo_leche <= tiempo_corto;
    elsif boton_largo = '1' then
        tiempo_leche <= tiempo_largo;
         end if;
    if boton_personalizar = '1' then
        INICIO <= '1';
        tiempo_cafe <= tiempo_personalizado;
        INICIO <= '0';
    elsif boton_corto = '1' then
        tiempo_cafe <= tiempo_corto;
    elsif boton_largo = '1' then
        tiempo_cafe <= tiempo_largo;
    end if;
 end if;
 when cafe_solo =>
    if boton_encendido = '1' then
        next_state <= Apagada;
    else
        tiempo_leche <= (others=>'0');
        if boton_personalizar = '1' then
            INICIO <= '1';
            tiempo_cafe <= tiempo_personalizado;
            INICIO <= '0';
        elsif boton_corto = '1' then
            tiempo_cafe <= tiempo_corto;
        elsif boton_largo = '1' then
            tiempo_cafe <= tiempo_largo;
         end if;
    end if;
 when others =>
 next_state <= Apagada;
 end case;
 estado_cafetera <= cafetera_on;
 end process;
 
 end Behavioral;
