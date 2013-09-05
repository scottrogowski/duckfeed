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

entity de2_zapper_controller_inst is 
        port (
              -- inputs:
                 signal address : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
                 signal chipselect : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal read : IN STD_LOGIC;
                 signal reset : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;
                 signal writedata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

              -- outputs:
                 signal GPIO_1 : INOUT STD_LOGIC_VECTOR (35 DOWNTO 0);
                 signal flash_zapper : OUT STD_LOGIC;
                 signal readdata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal triggerpull_zapper : OUT STD_LOGIC
              );
end entity de2_zapper_controller_inst;


architecture europa of de2_zapper_controller_inst is
component de2_zapper_controller is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

                 -- outputs:
                    signal GPIO_1 : INOUT STD_LOGIC_VECTOR (35 DOWNTO 0);
                    signal flash_zapper : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal triggerpull_zapper : OUT STD_LOGIC
                 );
end component de2_zapper_controller;

                signal internal_flash_zapper :  STD_LOGIC;
                signal internal_readdata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal internal_triggerpull_zapper :  STD_LOGIC;

begin

  --the_de2_zapper_controller, which is an e_instance
  the_de2_zapper_controller : de2_zapper_controller
    port map(
      GPIO_1 => GPIO_1,
      flash_zapper => internal_flash_zapper,
      readdata => internal_readdata,
      triggerpull_zapper => internal_triggerpull_zapper,
      address => address,
      chipselect => chipselect,
      clk => clk,
      read => read,
      reset => reset,
      write => write,
      writedata => writedata
    );


  --vhdl renameroo for output signals
  flash_zapper <= internal_flash_zapper;
  --vhdl renameroo for output signals
  readdata <= internal_readdata;
  --vhdl renameroo for output signals
  triggerpull_zapper <= internal_triggerpull_zapper;

end europa;

