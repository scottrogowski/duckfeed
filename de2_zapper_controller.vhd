-------------------------------------------------------------------------------
--
-- Simple Zapper Controller
--
-- Scott Rogowski
-- smr2167@columbia.edu
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity de2_zapper_controller is
  port (
    reset : in std_logic;
    clk   : in std_logic;                    -- Should be 25.125 MHz
    read       : in  std_logic;
    write      : in  std_logic;
    chipselect : in  std_logic;
    address    : in  unsigned(4 downto 0);
    readdata   : out unsigned(15 downto 0);
    writedata  : in  unsigned(15 downto 0);

    GPIO_1: inout std_logic_vector(35 downto 0); -- Blue[9:0]

	flash_zapper : out std_logic;
	triggerpull_zapper : out std_logic
    );

end de2_zapper_controller;

architecture rtl of de2_zapper_controller is
	signal ison : std_logic:='0';
	signal trigger : std_logic:='0';
--	signal waiter : integer := 0;
--	begin
--	Flash : process (clk) begin
--		if rising_edge(clk) then
--			waiter <= waiter + 1;
--			if waiter = 25000000 then
--				waiter <= 0;
--				ison <= not ison;
--				end if;
--			end if;
--		end process;
--	
--	GPIO_1(2) <= not ison;

	begin process (clk) begin
		if GPIO_1(0) = '1' then
			ison <= '1';
		else
			ison <= '0';
			end if;
		if GPIO_1(1) = '0' then    --the trigger is a high signal until the trigger pulls it low
			trigger <= '1';
		else
			trigger <= '0';
			end if;
		end process;

	flash_zapper <= ison;
	triggerpull_zapper <= trigger;
	GPIO_1(35 downto 2) <= "0000000000000000000000000000000000";
	end rtl;