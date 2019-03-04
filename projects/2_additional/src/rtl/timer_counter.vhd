-------------------------------------------------------------------------------
--  Odsek za racunarsku tehniku i medjuracunarske komunikacije
--  Autor: LPRS2  <lprs2@rt-rk.com>                                           
--                                                                             
--  Ime modula: timer_counter                                                           
--                                                                             
--  Opis:                                                               
--                                                                             
--    Modul broji sekunde i prikazuje na LED diodama                                         
--                                                                             
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY timer_counter IS PORT (
                              clk_i         : IN STD_LOGIC;                    -- ulazni takt
                              rst_i         : IN STD_LOGIC;                    -- reset aktivan (invertovan)
                              one_sec_i     : IN STD_LOGIC;                    -- signal koji predstavlja proteklu jednu sekundu vremena 
                              cnt_en_i      : IN STD_LOGIC;                    -- signal dozvole brojanja (invertovan)
                              cnt_rst_i     : IN STD_LOGIC;                    -- signal resetovanja brojaca (clear signal) (invertovan)

                              -- modul se prosiruje sa dva ulaza koji predstavljaju stanja tastera

                              button_min_i  : IN STD_LOGIC;	                   -- taster koji cijim se aktiviranjem na LE diodama prikazuju protekle minute (invertovan)
                              button_hour_i : IN STD_LOGIC;                    -- taster koji cijim se aktiviranjem na LE diodama prikazuju protekli sati (invertovan)
                              led_o         : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- izlaz ka LE diodama
                             );
END timer_counter;

ARCHITECTURE rtl OF timer_counter IS

SIGNAL counter_value_s   : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL counter_for_min_s : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL counter_for_h_s   : STD_LOGIC_VECTOR(7 DOWNTO 0);
begin

-- DODATI :

-- sistem za brojane sekundi,minuta i sata kao sistem za generisanje izlaza u odnosu na pritisnuti taster
-- ako nije pritisnut nijedan taster onda se prikazuju sekunde

	process (clk_i, rst_i) begin
		if (rst_i = '0') then
			counter_value_s <= (others => '0');
		elsif (clk_i'event and clk_i = '1') then
			if (cnt_rst_i = '0') then
				counter_value_s <= (others => '0');
			elsif (cnt_en_i = '0') then
				if (one_sec_i = '1') then
					if (counter_value_s = "00111100") then
						if (counter_for_min_s = "00111100") then
							counter_for_h_s <= counter_for_h_s + 1;
							counter_for_min_s <= (others => '0');
						else
							counter_for_min_s <= counter_for_min_s + 1;
							counter_value_s <= (others => '0');
						end if;
					else
						counter_value_s <= counter_value_s + 1;
					end if;
				end if;
			else
				counter_value_s <= counter_value_s;
			end if;
		else
			counter_value_s <= counter_value_s;
		end if;
	end process;
	
	process (button_hour_i, button_min_i) begin
		if (button_hour_i = '0') then 
			led_o <= counter_for_h_s;
		elsif (button_min_i = '0') then 
			led_o <= counter_for_min_s;
		else
			led_o <= counter_value_s;
		end if;
	end process;

END rtl;