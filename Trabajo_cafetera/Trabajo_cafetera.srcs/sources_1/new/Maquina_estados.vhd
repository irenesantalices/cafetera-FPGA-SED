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
        start_count : out std_logic;
        display1 : out std_logic_vector(6 downto 0);	
        display2 : out std_logic_vector(6 downto 0)
        

    );
end Maquina_estados;

architecture Behavioral of Maquina_estados is
type STATES is (Apagada,Seleccion_leche, cafe, leche);
signal current_state: STATES := Apagada;
--signal next_state: STATES;
--signal cafetera : STD_LOGIC_VECTOR(1 downto 0) := "00"; -- Estado interno de la cafetera
--signal modo_actual : STD_LOGIC_VECTOR (1 DOWNTO 0); -- Modo actual: 00, 01 o 10
signal LESS        : STD_LOGIC;
signal SUM         : STD_LOGIC;
signal INICIO      : STD_LOGIC;
signal tiempo_personalizado : STD_LOGIC_VECTOR(tiempo-1 downto 0);
signal tiempo_elegido : STD_LOGIC:='0';
signal personalizar : std_logic:='0';
--signal s_largo :std_logic:='0';
--signal s_no :std_logic:='0';
--signal s_personalizar :std_logic:='0';
--signal s_corto :std_logic:='0';





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

nextstate_decod: process (boton_encendido, current_state,clk)
 begin
 if boton_personalizar='1' then
    personalizar<='1';
 end if;
-- current_state <= next_state;
 case current_state is
 when Apagada =>
    modo_cafe <= "00";
    leds<="001";
    tiempo_cafe<=(others=>'0');
   -- tiempo_leche<=(others=>'0');
    if boton_encendido = '1' then
        current_state <= cafe;
    end if;
    when cafe =>
    leds<="010";
    modo_cafe <="10";
    if boton_encendido = '0' or reset = '1' then
        current_state <= Apagada;
        tiempo_cafe <= "000000";
    else
    
    if tiempo_elegido='0' then
        --tiempo_leche <= (others=>'0');
        tiempo_cafe<="000000";
        if personalizar = '1' then
            leds<="101";
            INICIO <= '1';
            --if boton_confirmar = '1' then
            if boton_confirmar='1' then 
                tiempo_cafe <= tiempo_personalizado;
                personalizar<='0';
                tiempo_elegido<='1';
                start_count <= '1';
            else 
                start_count <='0';
            end if;
            INICIO <= '0';
        elsif boton_corto = '1' then
            leds<="111";
            tiempo_cafe <= tiempo_corto;
            tiempo_elegido<='1';
            start_count <= '1';
        elsif boton_largo='1' then
            leds<="110";
            tiempo_cafe <= tiempo_largo;
            elegido_tiempo<='1';
            start_count <= '1';
         end if;
         end if;
         
    end if;
    -- Hay que arreglar que pueda saltar antes de que termine el tiempo
    if  tiempo_acabado='1' then
    start_count <= '0';
    tiempo_elegido <= '0';
    current_state<=Seleccion_leche;
    end if;
 when Seleccion_leche =>
    leds<="011";
    modo_cafe <= "01";
    if boton_encendido = '0' or reset = '1' then
        current_state <= Apagada;
        tiempo_cafe <= "000000";
    else
        --Se activa el display con leche
        
        --if boton_confirmar = '1' then
        if boton_confirmar = '1' then
            current_state <= leche;
            leds<="100";
        elsif boton_no='1'  then
            current_state <= Apagada;
            leds<="101";
        end if;
    end if;
 when leche =>
    leds<="100";
        modo_cafe <= "11";
if boton_encendido = '0' or reset = '1' then
        current_state <= Apagada;
        tiempo_cafe <= "000000";
 else 
    if tiempo_elegido='0' then
    if personalizar = '1' then
        leds <= "101";
        INICIO <= '1';
       -- tiempo_leche <= tiempo_personalizado;
        if  boton_confirmar = '1'  then 
            tiempo_cafe <= tiempo_personalizado;
            personalizar<='0';
            tiempo_elegido<='1'; 
            start_count <= '1';
        end if;      
        INICIO <= '0';

    elsif boton_corto = '1' then
        leds <= "111";
       -- tiempo_leche <= tiempo_corto;
       tiempo_cafe <= tiempo_corto;
       tiempo_elegido<='1';
       start_count <= '1';
    elsif boton_largo='1' then
        leds <= "110";
       -- tiempo_leche <= tiempo_largo;
       tiempo_elegido<='1';
       tiempo_cafe <= tiempo_largo;
       start_count <= '1';
    end if;
    end if;
 end if;
 if tiempo_acabado='1'then
 tiempo_elegido <= '0';
 current_state<=Apagada;
 start_count <= '0';
 end if;
 
 when others =>
 current_state <= Apagada;
 end case;


--modo_cafe <=cafetera;
elegido_tiempo<=tiempo_elegido;
 end process;
 
 end Behavioral;
