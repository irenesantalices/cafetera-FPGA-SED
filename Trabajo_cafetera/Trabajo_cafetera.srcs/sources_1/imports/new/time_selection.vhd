
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity time_selection is    
    port( 
   
   -- RST_N 	: in std_logic;									-- Reset
    INICIO  : in std_logic;
    CLK	    : in std_logic;									-- Clock
    SUM     : in std_logic;                                 -- Aumenta el valor del tiempo en uno
    LESS    : in std_logic;                                 -- Disminuye el valor del tiempo en uno
    code	: out std_logic_vector( 5 downto 0); 			-- El valor máximo que puede contar es 60 que son 6 bits
    display1 : out std_logic_vector(6 downto 0);	
    display2 : out std_logic_vector(6 downto 0)	
													
	);
end time_selection;
--Instanciar el decoder
architecture BEHAVIORAL2 of time_selection is 

COMPONENT decoder
       PORT (
        code : IN std_logic_vector(3 DOWNTO 0);
        led : OUT std_logic_vector(6 DOWNTO 0)
            );
    END COMPONENT;
	signal count_i : unsigned(5 downto 0) :="000011"; 	-- Mismo tamaño que COUNT
	signal numero_dec : integer;
    signal dec : unsigned(3 downto 0);
	signal unidades : unsigned(3 downto 0);

	
begin
 Inst_decoder_dec: decoder 
    PORT MAP (
        code=>std_logic_vector(dec),
        led=>display1
    );
  Inst_decoder_unidades: decoder 
    PORT MAP (
        code=>std_logic_vector(unidades),
        led=>display2
    );
	sr: process(CLK,INICIO)	--Clock and all asyncronous. 
    					-- Clear ahora es síncrono, por lo qeu no debe aparecer en la lista de sensibilidad
    
    begin
--    	if RST_N = '0' then
--        		-- Check asynchronous inputs
--                -- Check clock edge
--            count_i <= (others => '0');
    if INICIO = '1' then
      	if rising_edge(CLK) then
    	   if  SUM = '1' then --Check kclock active edge = CLK_N event and CLK_N = 0
                if count_i < 61 then
                    count_i <= count_i + 1;
                end if;
            end if;
            if LESS = '1' then
                if count_i > 3 then
       		       count_i <= count_i -1;
       		    end if;
       		end if;
        end if;
    numero_dec <= to_integer(count_i);
    dec <=to_unsigned(numero_dec/10,dec'length);
    unidades<=to_unsigned(numero_dec mod 10,unidades'length);
    end if;
    

    
   end process;
   code <= std_logic_vector(count_i);
end architecture BEHAVIORAL2;
