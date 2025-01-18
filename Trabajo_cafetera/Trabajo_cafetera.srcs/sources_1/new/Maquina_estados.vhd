library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Maquina_estados is
generic(
        width : positive:=2;
        tiempo:positive:=6;
        tiempo_corto : std_logic_vector(5 downto 0) := "000011";
        tiempo_largo : std_logic_vector(5 downto 0) := "111100"

);
  Port (
        tiempo_acabado      : in STD_LOGIC;
        boton_corto         : in  STD_LOGIC;    -- Señal del botón para café corto
        boton_largo         : in  STD_LOGIC;    -- Señal del botón para café largo
        boton_personalizar  : in  STD_LOGIC;    -- Señal pdel botón para personalizar tiempo
        boton_confirmar     : in  STD_LOGIC;    -- Señal para confirmar (debe ser un boton)
        boton_no            : in  STD_LOGIC;    -- Señal para decir que no (debe ser un boton)
        boton_encendido     : in  STD_LOGIC;    -- Señal para encender/apagar la cafetera
        clk                 : in  STD_LOGIC;    -- Señal de reloj
        reset               : in  STD_LOGIC;    -- Señal de reinicio
        modo_cafe           : out STD_LOGIC_VECTOR(1 downto 0); 
        -- Modo: 00 = apagado, 01 = preguntando, 10 = cafe solo y 11 = cafe con leche
        tiempo_cafe         : out STD_LOGIC_VECTOR(tiempo-1 downto 0);
       -- tiempo_leche        : out STD_LOGIC_VECTOR(tiempo-1 downto 0);
        elegido_tiempo      : out STD_LOGIC;
        leds                : out std_logic_vector(2 downto 0);
        display1 : out std_logic_vector(6 downto 0);	
        display2 : out std_logic_vector(6 downto 0)
        

    );
end Maquina_estados;

architecture Behavioral of Maquina_estados is
type STATES is (Apagada,Seleccion_tipo_cafe, cafe_leche, cafe_solo,cafe_terminado);
signal current_state: STATES := Apagada;
signal next_state: STATES;
signal cafetera : STD_LOGIC_VECTOR(1 downto 0) := "00"; -- Estado interno de la cafetera
signal modo_actual : STD_LOGIC_VECTOR (1 DOWNTO 0); -- Modo actual: 00, 01 o 10
signal LESS        : STD_LOGIC;
signal SUM         : STD_LOGIC;
signal INICIO      : STD_LOGIC;
signal tiempo_personalizado : STD_LOGIC_VECTOR(tiempo-1 downto 0);
signal tiempo_elegido : STD_LOGIC:='0';
signal personalizar : std_logic:='0';



   COMPONENT time_selection
       PORT (
            INICIO 	: in std_logic;									
            CLK	    : in std_logic;									-- Clock
            SUM     : in std_logic;                                 -- Aumenta el valor del tiempo en uno
            LESS    : in std_logic;                                 -- Disminuye el valor del tiempo en uno
            code	: out std_logic_vector( tiempo-1 downto 0);
            display1 : out std_logic_vector(6 downto 0);	
            display2 : out std_logic_vector(6 downto 0)	
            );
    END COMPONENT;
begin
Inst_time_selection: time_selection 
    PORT MAP (
        CLK => CLK,
        INICIO => INICIO,
        SUM => boton_largo,     --usamos el boton de cafe largo para sumar 
        LESS => boton_corto,    -- y el de cafe corto para restar
        code =>tiempo_personalizado,
        display1=>display1,
        display2=>display2
    );

nextstate_decod: process (boton_encendido, current_state)
 begin
 if boton_personalizar='1' then
    personalizar<='1';
 end if;
 next_state <= current_state;
 case current_state is
 when Apagada =>
    cafetera <= "00";
    leds<="001";
    tiempo_cafe<=(others=>'0');
   -- tiempo_leche<=(others=>'0');
    if boton_encendido = '1' then
        next_state <= cafe_solo;
    end if;
 when Seleccion_tipo_cafe =>
    leds<="011";
    cafetera <= "01";
    if boton_encendido = '0' then
        next_state <= Apagada;
    else
        --Se activa el display con leche
        
        if boton_confirmar = '1' then
            next_state <= cafe_leche;
        elsif boton_no = '1' then
            next_state <= Apagada;
        end if;
    end if;
 when cafe_leche =>
    leds<="100";
        cafetera <= "11";
 if boton_encendido = '0' then
        next_state <= Apagada;
 else 
    if tiempo_elegido='0' then
    if boton_personalizar = '1' then
        INICIO <= '1';
       -- tiempo_leche <= tiempo_personalizado;
       tiempo_cafe <= tiempo_personalizado;
        INICIO <= '0';

    elsif boton_corto = '1' then
       -- tiempo_leche <= tiempo_corto;
       tiempo_cafe <= tiempo_corto;

    elsif boton_largo = '1' then
       -- tiempo_leche <= tiempo_largo;
       tiempo_cafe <= tiempo_largo;
    end if;
    end if;
 end if;
 if tiempo_acabado='1'then
 next_state<=Apagada;
 end if;
 when cafe_solo =>
    leds<="010";
    cafetera <="10";
    if boton_encendido = '0' then
        next_state <= Apagada;
    else
    if tiempo_elegido='0' then
        --tiempo_leche <= (others=>'0');
        if personalizar = '1' then
            INICIO <= '1';
            if boton_confirmar = '1' then 
            tiempo_cafe <= tiempo_personalizado;
            personalizar<='0';
            tiempo_elegido<='1';
            end if;
            INICIO <= '0';
        elsif boton_corto = '1' then
            tiempo_cafe <= tiempo_corto;
        elsif boton_largo = '1' then
            tiempo_cafe <= tiempo_largo;
         end if;
         end if;
    end if;
    -- Hay que arreglar que pueda saltar antes de que termine el tiempo
    if  tiempo_acabado='1' then
    next_state<=Seleccion_tipo_cafe;
    end if;
 when others =>
 next_state <= Apagada;
 end case;
modo_cafe <=cafetera;
elegido_tiempo<=tiempo_elegido;
 end process;
 
 end Behavioral;
