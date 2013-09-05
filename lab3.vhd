library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab3 is
  
  port (
    signal CLOCK_50 : in std_logic;                -- 50 MHz clock
  --  signal LEDR : out std_logic_vector(17 downto 0); -- Red LEDs

    SRAM_DQ : inout std_logic_vector(15 downto 0); -- Data bus 16 Bits
    SRAM_ADDR : out std_logic_vector(17 downto 0); -- Address bus 18 Bits
    SRAM_UB_N,                                     -- High-byte Data Mask
    SRAM_LB_N,                                     -- Low-byte Data Mask
    SRAM_WE_N,                                     -- Write Enable
    SRAM_CE_N,                                     -- Chip Enable
    SRAM_OE_N : out std_logic;                      -- Output Enable

    VGA_CLK,                         -- Clock
    VGA_HS,                          -- H_SYNC
    VGA_VS,                          -- V_SYNC
    VGA_BLANK,                       -- BLANK
    VGA_SYNC : out std_logic;        -- SYNC
    VGA_R,                           -- Red[9:0]
    VGA_G,                           -- Green[9:0]
    VGA_B : out std_logic_vector(9 downto 0); -- Blue[9:0]

	GPIO_1 : inout std_logic_vector(35 downto 0);

	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,
	HEX6,
	HEX7 : out std_logic_vector(6 downto 0)
    );
  
end lab3;

architecture rtl of lab3 is
  
  signal counter : unsigned(15 downto 0) := "0000000000000000";
  signal reset_n : std_logic := '0';
  signal flash : std_logic := '0';
  signal shoot : std_logic := '0';

begin
  --DUCKFEED
  HEX7 <= "0100001";
  HEX6 <= "1000001";
  HEX5 <= "1000110";
  HEX4 <= "0001010";
  HEX3 <= "0001110";
  HEX2 <= "0000110";
  HEX1 <= "0000110";
  HEX0 <= "0100001";

  process (CLOCK_50)
  begin
    if rising_edge(CLOCK_50) then
      if counter = x"ffff" then
        reset_n <= '1';
      else
        reset_n <= '0';
        counter <= counter + 1;
      end if;
    end if;
  end process;

  nios : entity work.nios_system port map (
    clk                          => CLOCK_50,
    reset_n                      => reset_n,
--    leds_from_the_leds           => LEDR(15 downto 0),
    SRAM_ADDR_from_the_sram      => SRAM_ADDR,
    SRAM_CE_N_from_the_sram      => SRAM_CE_N,
    SRAM_DQ_to_and_from_the_sram => SRAM_DQ,
    SRAM_LB_N_from_the_sram      => SRAM_LB_N,
    SRAM_OE_N_from_the_sram      => SRAM_OE_N,
    SRAM_UB_N_from_the_sram      => SRAM_UB_N,
    SRAM_WE_N_from_the_sram      => SRAM_WE_N,

    VGA_BLANK_from_the_vga          => VGA_BLANK,
	VGA_B_from_the_vga            => VGA_B,
	VGA_CLK_from_the_vga          => VGA_CLK,
	VGA_G_from_the_vga            => VGA_G,
	VGA_HS_from_the_vga           => VGA_HS,
	VGA_R_from_the_vga            => VGA_R,
	VGA_SYNC_from_the_vga         => VGA_SYNC,
	VGA_VS_from_the_vga           => VGA_VS,
	
	GPIO_1_to_and_from_the_zapper	=> GPIO_1,
	
	flash_zapper_from_the_zapper => flash,
	flash_vga_to_the_vga => flash,
	
	triggerpull_zapper_from_the_zapper => shoot,
	triggerpull_vga_to_the_vga => shoot
	);

end rtl;
