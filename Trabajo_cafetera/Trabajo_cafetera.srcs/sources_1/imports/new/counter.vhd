
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter is    
    port( 
   
    RST_N 	: in std_logic;									-- Asynchronous active low reset (max. priority)
    CLK	    : in std_logic;									-- Clock
    CE      : in std_logic;  
    code	: out std_logic_vector( 3 downto 0) 				-- Paralel output. 
    														-- Signed: complemento a 2. Unsigned: binario sin signo
	);
end counter;

architecture BEHAVIORAL2 of counter is 
	signal count_i : unsigned(code'range);	-- Mismo tamaño que COUNT
begin
	sr: process(RST_N,CLK)	--Clock and all asyncronous. 
    					-- Clear ahora es síncrono, por lo qeu no debe aparecer en la lista de sensibilidad
    begin
    	if RST_N = '0' then
        		-- Check asynchronous inputs
                -- Check clock edge
            count_i <= (others => '0');
    	elsif rising_edge(CLK) and CE= '1' then --Check kclock active edge = CLK_N event and CLK_N = 0
       		count_i <= count_i + 1;
            	if count_i = 10 then
            	    count_i <= (others => '0');
                end if;
        end if;
   end process;
   code <= std_logic_vector(count_i);
end architecture BEHAVIORAL2;
