
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity time_selection is    
    port( 
   
    RST_N 	: in std_logic;									-- Reset
    CLK	    : in std_logic;									-- Clock
    SUM     : in std_logic;                                 -- Aumenta el valor del tiempo en uno
    LESS    : in std_logic;                                 -- Disminuye el valor del tiempo en uno
    code	: out std_logic_vector( 5 downto 0) 			-- El valor máximo que puede contar es 60 que son 6 bits
    														
	);
end time_selection;

architecture BEHAVIORAL2 of time_selection is 
	signal count_i : unsigned(code'range);	-- Mismo tamaño que COUNT
begin
	sr: process(RST_N,CLK)	--Clock and all asyncronous. 
    					-- Clear ahora es síncrono, por lo qeu no debe aparecer en la lista de sensibilidad
    begin
    	if RST_N = '0' then
        		-- Check asynchronous inputs
                -- Check clock edge
            count_i <= (others => '0');
    	elsif rising_edge(CLK) then
    	   if  SUM = '1' then --Check kclock active edge = CLK_N event and CLK_N = 0
                if count_i < 61 then
                    count_i <= count_i + 1;
                end if;
            end if;
        elsif rising_edge(CLK) then
            if LESS = '1' then
                if count_i > 3 then
       		       count_i <= count_i -1;
       		    end if;
       		end if;
        end if;
   end process;
   code <= std_logic_vector(count_i);
end architecture BEHAVIORAL2;
