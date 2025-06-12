library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity Temporizador is
    generic(
        width:positive:=6;
        tiempo:positive:=6
    );
    Port (
        inicial  : out STD_LOGIC;
        decenas : out std_logic_vector(3 downto 0);
        unidades : out std_logic_vector(3 downto 0);
        start : in std_logic;
        CLK : in std_logic;
        tiempo_in : in std_logic_vector(tiempo-1 downto 0);
        Reset : in std_logic;
        display1 : out std_logic_vector(width downto 0);
        display2 : out std_logic_vector(width downto 0);
        code_unit : out std_logic_vector(3 downto 0);
        code_dec : out std_logic_vector(3 downto 0);
        contando : out std_logic:='0';
        final_tiempo : out std_logic:='0'

    );
end Temporizador;

architecture Behavioral of Temporizador is
    signal final   : std_logic :='0';
    signal s_tiempo :std_logic_vector(tiempo-1 downto 0);
    signal clk_1hz : std_logic;
    signal s_dec : std_logic_vector(3 downto 0):="0000";
    signal s_unit : std_logic_vector(3 downto 0):="0000";


    COMPONENT decoder
        PORT (
            code : IN std_logic_vector(3 DOWNTO 0);
            led : OUT std_logic_vector(6 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT clk1hz
        PORT (
            CLK: in  STD_LOGIC;
            clk_1hz : out STD_LOGIC
        );
    END COMPONENT;
begin
    Inst_clk1hz: clk1hz
        PORT MAP (
            CLK => CLK,
            CLK_1hz => clk_1hz
        );
    Inst_decoder_dec: decoder
        PORT MAP (
            code=>s_dec,
            led=>display1
        );
    Inst_decoder_unit: decoder
        PORT MAP (
            code=>s_unit,
            led=>display2
        );
    --    Inst_BCD: BCD 
    --    PORT MAP (
    --        tiempo_in =>tiempo_in,
    --        dec_bcd  =>dec_sec,
    --        unit_bcd => unit_sec
    --    );



    process (clk_1hz, start)

        --  subtype V is integer range 0 to 60;
        variable int :natural  :=to_integer(unsigned(tiempo_in));
        variable dec_sec : natural :=int/10;
        variable unit_sec  : natural :=int mod 10;
        variable inicializado : std_logic :='0';
    begin
        if start='0' then
            final_tiempo<='0';
        end if;
        if tiempo_in="000000" then
            contando<='0';
            final_tiempo<='0';
            inicializado:='0';
        elsif inicializado = '0' then
            contando <='0';
            int := to_integer(unsigned(tiempo_in));
            dec_sec :=int/10;
            unit_sec := int mod 10;
            inicializado := '1';
            final_tiempo <='0';
        end if;
        if rising_edge(clk_1hz) and start='1' then


            if unit_sec=0 and dec_sec=0 then
                contando <='0';
                inicializado :='0';

                if start = '1' then
                    final_tiempo <='1';
                end if;
            elsif unit_sec=0 then
                contando <='1';
                unit_sec:=9;
                dec_sec:=dec_sec-1;
                final_tiempo<='0';

            else
                contando <='1';
                final_tiempo<='0';
                unit_sec:=unit_sec-1;
            end if;
            unidades <= std_logic_vector(to_unsigned(unit_sec,4));
            decenas <=  std_logic_vector(to_unsigned(dec_sec,4));
        end if;
        s_unit <= std_logic_vector(to_unsigned(unit_sec,code_unit'length));
        s_dec <= std_logic_vector(to_unsigned(dec_sec,code_dec'length));
        code_dec<=s_dec;
        code_unit<=s_unit;
        inicial <= inicializado;
        if tiempo_in="000000" then
            contando<='0';
            final_tiempo<='0';
            inicializado:='0';
         end if;
    end process;

end Behavioral;


