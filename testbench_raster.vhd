library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity vga_raster_testBench is 
	end vga_raster_testBench;
	
	
architecture tb of vga_raster_testBench is



  -- Signals for the video controller
  signal Hcount : unsigned(9 downto 0) := "0000000000";  -- Horizontal position (0-800)
  signal Vcount : unsigned(9 downto 0) := "0000000000";  -- Vertical position (0-524)
  signal EndOfLine, EndOfField : std_logic := '0';

  signal vga_hblank, vga_hsync,
    vga_vblank, vga_vsync : std_logic := '0';  -- Sync. signals

  --Secondary clocks for VGA timing
  signal clk25 : std_logic:='0';

  --The circle center storage variables
  signal hcenter : integer := 200;
  signal vcenter : integer := 200;

  -- circle at current pixel boolean
  signal circle: std_logic := '0';
		--zapper signals
  signal hit: std_logic := '0';
  signal hold_2: std_logic := '0';
  signal waitFor: integer := 0; 
  signal waitFor2: integer :=0; 
  signal waitFor3: integer :=0;
  signal waitFor4: integer :=0;
  signal state2 : std_logic :='0';
  signal blackScreen : std_logic := '0';
  signal showTarget : std_logic := '0';
  signal triggerUp :std_logic :='0';
  signal triggerAction: std_logic :='0';

  signal backgroundPixelsRemaining : integer := 1;
  signal rCurrent : std_logic_vector (9 downto 0) := "1111111111";
  signal gCurrent : std_logic_vector (9 downto 0) := "0000000000";
  signal bCurrent : std_logic_vector (9 downto 0) := "1111111111";	
  signal opaque : std_logic := '1';

  signal sr_instructionAddress 		: unsigned(15 downto 0) := "0000000000000000";
 -- signal sr_spriteAddress : unsigned(3 downto 0) := "0000";
  signal read_sr_red	: unsigned(15 downto 0) := "0000000000000000";
  signal currColor      : unsigned (3 downto 0) := "0000";
  signal numElements    : integer := 0;
  signal numInstructions : integer := 0;

  signal clk			: std_logic := '0';
  signal reset			: std_logic := '0';

	signal read       : std_logic := '0';
    signal write      : std_logic := '0';
    signal chipselect : std_logic := '0';
    signal address    : unsigned(4 downto 0) := "00000";
    signal readdata   : unsigned(15 downto 0) := "0000000000000000";
    signal writedata  : unsigned(15 downto 0) := "0000000000000000";

    signal VGA_CLK,                         -- Clock
		VGA_HS,                          -- H_SYNC
		VGA_VS,                          -- V_SYNC
		VGA_BLANK,                       -- BLANK
		VGA_SYNC : std_logic := '0';        -- SYNC
    signal VGA_R,                           -- Red[9:0]
		VGA_G,                           -- Green[9:0]
		VGA_B : std_logic_vector(9 downto 0) := "0000000000"; -- Blue[9:0]

    signal flash_vga : std_logic := '0';
    signal triggerpull_vga : std_logic := '0';

    signal red_pixel_vga: std_logic_vector(9 downto 0) := "0000000000";

begin

--clk<= not clk after 40ns;     --25mhz


process
    begin
		clk <= '0';
		wait for 20 ns;
	loop
		clk <= '0';
		wait for 20 ns;
		clk <= '1';
		wait for 20 ns;
	end loop;
end process;


process
    begin
				wait for 100ns;
			reset <= '1';
		
		read       <= '0';
		write      <= '0';
		chipselect <= '0';
		address    <= "00000";
		readdata   <= "1111111100000000";
		writedata  <= "0000000000000000";

--		VGA_CLK,                        				-- Clock
--		VGA_HS,                          			-- H_SYNC
--		VGA_VS,                          			-- V_SYNC
--		VGA_BLANK,                      				-- BLANK
--		VGA_SYNC : out std_logic;  			 		-- SYNC
--		VGA_R,                           			-- Red[9:0]
--		VGA_G,                           			-- Green[9:0]
--		VGA_B : out std_logic_vector(9 downto 0); -- Blue[9:0]

		flash_vga <= '0';
		triggerpull_vga <= '0';

	--	red_pixel_vga <= "0000000000000000";
			
			
			
				wait for 40ns;
			reset <= '0'; 
				wait for 40ns;
--			assert rCurrent;
--			assert gCurrent;
--			assert bCurrent;
--			sr_instructionAddress <= "0000000000000000";
--			backgroundpixelsremaining <= 3;
--			circle <= '0';
--			read_sr_red <= "0001000000001000";
--			hcount <= "0110010000";
--			vcount <="0100101100";
--			numInstructions <= 10;
				wait for 40ns;
--			backgroundPixelsRemaining <= 2;
		--	read_sr_red <= "0001000001000000";
				wait for 40ns;
		--	read_sr_red <= "0010000000100100";
				wait for 40ns;
		--	read_sr_red <= "0001000000001001";				wait for 40ns;
		--	read_sr_red <= "0010000001001000";
			wait for 40ns;
				wait for 40ns;
					wait for 40ns;	wait for 40ns;	wait for 40ns;	wait for 40ns;	wait for 40ns;
	wait for 40ns;	
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;		
	wait for 40ns;		
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;	
	wait for 40ns;	
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;		
   wait for 40ns;
	wait for 40ns;
	wait for 40ns;	
	wait for 40ns;	
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;		
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;	
	wait for 40ns;	
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;		
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;	
	wait for 40ns;	
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;		
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;	
	wait for 40ns;	
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;		
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;	
	wait for 40ns;	
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;		
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;	
	wait for 40ns;	
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;		
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;	
	wait for 40ns;	
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;		
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;	
	wait for 40ns;	
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;		
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;	
	wait for 40ns;	
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;		
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;	
	wait for 40ns;	
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;		
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;	
	wait for 40ns;	
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;
	wait for 40ns;															
	wait;
end process;



uut : entity work. de2_vga_raster
	port map (  clk=>clk,
				reset => reset,
				read => read,
				write => write,
				chipselect => chipselect,
				address => address,   
				readdata => readdata,  
				writedata => writedata,

				VGA_CLK => VGA_CLK,        	                 -- Clock
				VGA_HS => VGA_HS,                          -- H_SYNC
				VGA_VS => VGA_VS,                          -- V_SYNC
				VGA_BLANK => VGA_BLANK,                       -- BLANK
				VGA_SYNC => VGA_SYNC,				        -- 	SYNC
				VGA_R => VGA_R,                           -- Red[9:0]
				VGA_G => VGA_G,                           -- Green[9:0]
				VGA_B => VGA_B, 						-- Blue[9:0]

				flash_vga => flash_vga,
				triggerpull_vga => triggerpull_vga,

				red_pixel_vga => red_pixel_vga
				
);




end tb;