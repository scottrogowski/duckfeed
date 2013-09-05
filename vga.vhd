--Legal Notice: (C)2007 Altera Corporation. All rights reserved.  Your
--use of Altera Corporation's design tools, logic functions and other
--software and tools, and its AMPP partner logic functions, and any
--output files any of the foregoing (including device programming or
--simulation files), and any associated documentation or information are
--expressly subject to the terms and conditions of the Altera Program
--License Subscription Agreement or other applicable license agreement,
--including, without limitation, that your use is for the sole purpose
--of programming logic devices manufactured by Altera and sold by Altera
--or its authorized distributors.  Please refer to the applicable
--agreement for further details.


-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity vga is 
        port (
              -- inputs:
                 signal address : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
                 signal chipselect : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal flash_vga : IN STD_LOGIC;
                 signal read : IN STD_LOGIC;
                 signal reset : IN STD_LOGIC;
                 signal triggerpull_vga : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;
                 signal writedata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

              -- outputs:
                 signal VGA_B : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
                 signal VGA_BLANK : OUT STD_LOGIC;
                 signal VGA_CLK : OUT STD_LOGIC;
                 signal VGA_G : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
                 signal VGA_HS : OUT STD_LOGIC;
                 signal VGA_R : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
                 signal VGA_SYNC : OUT STD_LOGIC;
                 signal VGA_VS : OUT STD_LOGIC;
                 signal readdata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
              );
end entity vga;


architecture europa of vga is
component de2_vga_raster is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal flash_vga : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset : IN STD_LOGIC;
                    signal triggerpull_vga : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

                 -- outputs:
                    signal VGA_B : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
                    signal VGA_BLANK : OUT STD_LOGIC;
                    signal VGA_CLK : OUT STD_LOGIC;
                    signal VGA_G : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
                    signal VGA_HS : OUT STD_LOGIC;
                    signal VGA_R : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
                    signal VGA_SYNC : OUT STD_LOGIC;
                    signal VGA_VS : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
                 );
end component de2_vga_raster;

                signal internal_VGA_B :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal internal_VGA_BLANK :  STD_LOGIC;
                signal internal_VGA_CLK :  STD_LOGIC;
                signal internal_VGA_G :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal internal_VGA_HS :  STD_LOGIC;
                signal internal_VGA_R :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal internal_VGA_SYNC :  STD_LOGIC;
                signal internal_VGA_VS :  STD_LOGIC;
                signal internal_readdata :  STD_LOGIC_VECTOR (15 DOWNTO 0);

begin

  --the_de2_vga_raster, which is an e_instance
  the_de2_vga_raster : de2_vga_raster
    port map(
      VGA_B => internal_VGA_B,
      VGA_BLANK => internal_VGA_BLANK,
      VGA_CLK => internal_VGA_CLK,
      VGA_G => internal_VGA_G,
      VGA_HS => internal_VGA_HS,
      VGA_R => internal_VGA_R,
      VGA_SYNC => internal_VGA_SYNC,
      VGA_VS => internal_VGA_VS,
      readdata => internal_readdata,
      address => address,
      chipselect => chipselect,
      clk => clk,
      flash_vga => flash_vga,
      read => read,
      reset => reset,
      triggerpull_vga => triggerpull_vga,
      write => write,
      writedata => writedata
    );


  --vhdl renameroo for output signals
  VGA_B <= internal_VGA_B;
  --vhdl renameroo for output signals
  VGA_BLANK <= internal_VGA_BLANK;
  --vhdl renameroo for output signals
  VGA_CLK <= internal_VGA_CLK;
  --vhdl renameroo for output signals
  VGA_G <= internal_VGA_G;
  --vhdl renameroo for output signals
  VGA_HS <= internal_VGA_HS;
  --vhdl renameroo for output signals
  VGA_R <= internal_VGA_R;
  --vhdl renameroo for output signals
  VGA_SYNC <= internal_VGA_SYNC;
  --vhdl renameroo for output signals
  VGA_VS <= internal_VGA_VS;
  --vhdl renameroo for output signals
  readdata <= internal_readdata;

end europa;

