library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity de2_led_flasher is
  
  port (
    clk        : in  std_logic;
    reset_n    : in  std_logic;
    read       : in  std_logic;
    write      : in  std_logic;
    chipselect : in  std_logic;
    address    : in  unsigned(4 downto 0);
    readdata   : out unsigned(15 downto 0);
    writedata  : in  unsigned(15 downto 0);

    leds       : out unsigned(15 downto 0)
    );
  
end de2_led_flasher;

architecture rtl of de2_led_flasher is

  type ram_type is array(15 downto 0) of unsigned(15 downto 0);
  signal RAM : ram_type := "0000000000000000";
  signal ram_address, display_address : unsigned(3 downto 0) := "0000";
  signal counter_delay : unsigned(15 downto 0) := "0000000000000000";
  signal counter : unsigned(31 downto 0) := "00000000000000000000000000000000";

begin
  ram_address <= address(3 downto 0);

  process (clk)
  begin
    if rising_edge(clk) then
      if reset_n = '0' then
        readdata <= (others => '0');
        display_address <= (others => '0');        
        counter <= (others => '0');        
        counter_delay <= (others => '1');
      else
        if chipselect = '1' then
          if address(4) = '0' then
            if read = '1' then
              readdata <= RAM(to_integer(ram_address));
            elsif write = '1' then
              RAM(to_integer(ram_address)) <= writedata;
            end if;
          else
            if write = '1' then
              counter_delay <= writedata;
            end if;
          end if;
        else
          leds <= RAM(to_integer(display_address));
          if counter = x"00000000" then
            counter <= counter_delay & x"0000";
            display_address <= display_address + 1;
          else
            counter <= counter - 1;
          end if;
        end if;
      end if;
    end if;
  end process;

end rtl;
