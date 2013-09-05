-------------------------------------------------------------------------------
--
-- Simple VGA raster display
--
-- Stephen A. Edwards
-- sedwards@cs.columbia.edu

--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity de2_vga_raster is

 
  port (
    reset : in std_logic;
    clk   : in std_logic;                    -- Should be 25.125 MHz
    read       : in  std_logic;
    write      : in  std_logic;
    chipselect : in  std_logic;
    address    : in  unsigned(4 downto 0);
    readdata   : out unsigned(15 downto 0);
    writedata  : in  unsigned(15 downto 0);

    VGA_CLK,                         -- Clock
    VGA_HS,                          -- H_SYNC
    VGA_VS,                          -- V_SYNC
    VGA_BLANK,                       -- BLANK
    VGA_SYNC : out std_logic;        -- SYNC
    VGA_R,                           -- Red[9:0]
    VGA_G,                           -- Green[9:0]
    VGA_B : out std_logic_vector(9 downto 0); -- Blue[9:0]

    flash_vga : in std_logic;
    triggerpull_vga : in std_logic
    );

end de2_vga_raster;

architecture rtl of de2_vga_raster is
 
  -- Video parameters
 
  constant HTOTAL       : integer := 800;
  constant HSYNC        : integer := 96;
  constant HBACK_PORCH  : integer := 48;
  constant HACTIVE      : integer := 640;
  constant HFRONT_PORCH : integer := 16;
 
  constant VTOTAL       : integer := 525;
  constant VSYNC        : integer := 2;
  constant VBACK_PORCH  : integer := 33;
  constant VACTIVE      : integer := 480;
  constant VFRONT_PORCH : integer := 10;
--  constant VTOTAL       : integer := 262;
--  constant VSYNC        : integer := 1;
--  constant VBACK_PORCH  : integer := 16;
--  constant VACTIVE      : integer := 240;
--  constant VFRONT_PORCH : integer := 5;

  constant BLANKSCREENTIME : integer := 450000;  --this is the shortest timer i could use while still registering hits reliably
  constant SHOWTARGETTIME : integer := 450000;
  constant SWITCHBOUNCETIME : integer := 100000;   --amount of cycles to wait before we're sure the switch was released. 
                                                   --not a concrete number, but it eliminates the bounce problem and is not noticably long


  constant RADIUS       : integer := 40;
  constant RADIUSSQ : integer := RADIUS*RADIUS;

  -- Signals for the video controller
  signal Hcount : unsigned(9 downto 0);  -- Horizontal position (0-800)
  signal Vcount : unsigned(9 downto 0);  -- Vertical position (0-524)
  signal EndOfLine, EndOfField : std_logic;

  signal vga_hblank, vga_hsync,
    vga_vblank, vga_vsync : std_logic;  -- Sync. signals

  --Secondary clocks for VGA timing
  signal clk25 : std_logic:='0';
  signal clk12 : std_logic:='0'; 
  signal clk5 : std_logic:='0';

  --The circle center storage variables
  signal hcenter : integer := 200;
  signal vcenter : integer := 200;

  -- circle at current pixel boolean
  signal circle: std_logic;

  signal hit: std_logic := '0';
  signal hold_2: std_logic;
  signal waitFor: integer; --For 525*800
  signal waitFor2: integer :=0; --For 525*800
  signal waitFor3: integer :=0;
  signal waitFor4: integer :=1;
  signal state2 : std_logic :='0';
  signal blackScreen : std_logic := '0';
  signal showTarget : std_logic := '0';
  signal triggerUp :std_logic :='0';
  signal triggerAction: std_logic :='0';

 

begin
    --When the processor writes to this peripheral, update the horizontal or vertical center
    NewCenter : process (clk)
    begin
        if rising_edge(clk) then
            if chipselect = '1' then
                if write = '1' then
                    if writedata(15) = '0' then
                        hcenter <= to_integer(writedata(14 downto 0));
                    else
                        vcenter <= to_integer(writedata(14 downto 0));

                        end if;
                    end if;
                end if;
            end if;
        end process;

  --Ensure that the clock is within VGA niceness by halving the speed.
-- HalfClock2 : process (clk)

--  begin
--    if rising_edge(clk) then
--      clk5 <= not clk5;
--    end if;
--  end process;
--
-- HalfClock1 : process (clk)

--  begin
--    if rising_edge(clk) then
--      clk12 <= not clk12;
--    end if;
--  end process;
--           

  HalfClock : process (clk)

  begin
    if rising_edge(clk) then
      clk25 <= not clk25;
    end if;
  end process;


--the purpose of this process is to prevent the screen from staying blanked while the trigger is held down
process (clk25) begin           
    if rising_edge(clk25) then
        if triggerpull_vga='1' then
            triggerUp <= '1';
        elsif triggerUp='1' and triggerpull_vga = '0' then 
			waitFor4 <= SWITCHBOUNCETIME;
			triggerUp<='0';
		elsif waitFor4 = 1 then
			triggerAction <= '1';
			waitFor4<=0;
		elsif triggerAction = '1' then
			triggerAction <= '0';
		else 
			waitFor4 <= waitFor4-1;
           end if;
        end if;
    end process;

   
--set a short timer to blank the screen  
process (clk25) begin
    if rising_edge(clk25) then
     --   if triggerpull_vga='1' then
        if triggerAction='1' then
            blackScreen <= '1';
            waitFor2 <= BLANKSCREENTIME;
        elsif waitfor2 = 1 then     --flicker "state2" to enter the target flashing process
			state2 <= '1';
			waitFor2 <= waitFor2-1;
        elsif waitFor2 = 0 then    
            blackScreen <= '0';
			state2 <= '0';
        else
            waitFor2 <= waitFor2-1;

           end if;
        end if;
    end process;
--next stage, set a timer to show targets on a black screen
process (clk25) begin
    if rising_edge(clk25) then
        if state2 = '1' then 
            showTarget <= '1';
            waitFor3 <= SHOWTARGETTIME;
        elsif waitFor3 = 0 then
            showTarget <= '0';
        else
            waitFor3 <= waitFor3-1;

            end if;
        end if;
    end process;

--set a short timer to indicate a hit has occured (testing purposes)
 process (clk25) begin
    if rising_edge(clk25) then  --can we sample faster? use clk'event or the 50Mhz clock?
        if flash_vga= '1' and showTarget = '1' then
            hit <= '1';
            waitFor <= 30000000;
        elsif waitFor = 0 then
            hit <= '0';
        else
            waitFor <= waitFor-1;

            end if;
        end if;
    end process;

  -- Horizontal and vertical counters

  HCounter : process (clk25)
  begin
    if rising_edge(clk25) then     
      if reset = '1' then
        Hcount <= (others => '0');
      elsif EndOfLine = '1' then
        Hcount <= (others => '0');
      else
        Hcount <= Hcount + 1;
      end if;     
    end if;
  end process HCounter;

  EndOfLine <= '1' when Hcount = HTOTAL - 1 else '0';
 
  VCounter: process (clk25)
  begin
    if rising_edge(clk25) then     
      if reset = '1' then
        Vcount <= (others => '0');
      elsif EndOfLine = '1' then
        if EndOfField = '1' then
          Vcount <= (others => '0');
        else
          Vcount <= Vcount + 1;
        end if;
      end if;
    end if;
  end process VCounter;

  EndOfField <= '1' when Vcount = VTOTAL - 1 else '0';

  -- State machines to generate HSYNC, VSYNC, HBLANK, and VBLANK

  HSyncGen : process (clk25)
  begin
    if rising_edge(clk25) then    
      if reset = '1' or EndOfLine = '1' then
        vga_hsync <= '1';
      elsif Hcount = HSYNC - 1 then
        vga_hsync <= '0';
      end if;
    end if;
  end process HSyncGen;
 
  HBlankGen : process (clk25)
  begin
    if rising_edge(clk25) then
      if reset = '1' then
        vga_hblank <= '1';
      elsif Hcount = HSYNC + HBACK_PORCH then
        vga_hblank <= '0';
      elsif Hcount = HSYNC + HBACK_PORCH + HACTIVE then
        vga_hblank <= '1';
      end if;     
    end if;
  end process HBlankGen;

  VSyncGen : process (clk25)
  begin
    if rising_edge(clk25) then
      if reset = '1' then
        vga_vsync <= '1';
      elsif EndOfLine ='1' then
        if EndOfField = '1' then
          vga_vsync <= '1';
        elsif Vcount = VSYNC - 1 then
          vga_vsync <= '0';
        end if;
      end if;     
    end if;
  end process VSyncGen;

  VBlankGen : process (clk25)
  begin
    if rising_edge(clk25) then   
      if reset = '1' then
        vga_vblank <= '1';
      elsif EndOfLine = '1' then
        if Vcount = VSYNC + VBACK_PORCH - 1 then
          vga_vblank <= '0';
        elsif Vcount = VSYNC + VBACK_PORCH + VACTIVE - 1 then
          vga_vblank <= '1';
        end if;
      end if;
    end if;
  end process VBlankGen;

--Circle generator magic
--By the pythagorean theorem, given a circle center, determine whether a pixel is within the circle
CircleGen : process (clk)

begin
if rising_edge(clk) then
--    circle <= '0';
        if (Vcount<vcenter) then
                        if (Hcount<hcenter) then
                                if ((vcenter-Vcount)*(vcenter-Vcount)+(hcenter-Hcount)*(hcenter-Hcount) < RADIUSSQ) then
                                        circle <= '1';
                                else
                    circle <= '0';
                    end if;
                        else
                                if ((vcenter-Vcount)*(vcenter-Vcount)+(Hcount-hcenter)*(Hcount-hcenter) < RADIUSSQ) then
                                        circle <= '1';
                else
                    circle<= '0';
                    end if;
                                end if;
                else
                        if (Hcount<hcenter) then
                                if ((Vcount-vcenter)*(Vcount-vcenter)+(hcenter-Hcount)*(hcenter-Hcount) < RADIUSSQ) then
                                        circle <= '1';
                            else
                    circle <= '0';       
                    end if;
                        else
                                if ((Vcount-vcenter)*(Vcount-vcenter)+(Hcount-hcenter)*(Hcount-hcenter) < RADIUSSQ) then
                                        circle <= '1';
                else
                    circle <= '0';

                                        end if;
                                end if;
                        end if;
                end if;
        end process CircleGen;

  -- Registered video signals going to the video DAC

  VideoOut: process (clk25, reset)
  begin
    if reset = '1' then
      VGA_R <= "0000000000";
      VGA_G <= "0000000000";
      VGA_B <= "0000000000";

    elsif clk25'event and clk25 = '1' then
      if blackScreen = '1' then
        VGA_R <= "1111111111";
        VGA_G <= "1111111111";
        VGA_B <= "1111111111";
--four different cases for showing the target
      elsif circle = '1' and showTarget = '1' and hit = '0' then 
        VGA_R <= "1111111111";
        VGA_G <= "1111111111";
        VGA_B <= "1111111111";
      elsif circle = '1' and showTarget = '1' and hit = '1' then 
        VGA_R <= "1111111111";
        VGA_G <= "0000000000";
        VGA_B <= "1111111111";
      elsif circle = '1' and showTarget = '0' and hit = '1' then
        VGA_R <= "0000000000";
        VGA_G <= "1111111111";
        VGA_B <= "0000000000";
      elsif circle = '1' and showTarget = '0' and hit = '0' then
        VGA_R <= "1111111111";
        VGA_G <= "0000000000";
        VGA_B <= "0000000000";
--rest of screen
      elsif vga_hblank = '0' and vga_vblank ='0' and showTarget='1' then
        VGA_R <= "0000000000";
        VGA_G <= "0000000000";
        VGA_B <= "0000000000";
      elsif vga_hblank = '0' and vga_vblank ='0' and showTarget = '0' then
        VGA_R <= "0000000000";
        VGA_G <= "0000000000";
        VGA_B <= "1111111111";


--      elsif vga_hblank = '0' and vga_vblank ='0' and triggerAction='0' then
--        VGA_R <= "0000001111";
--        VGA_G <= "0000001111";
--        VGA_B <= "0000000000";
--      elsif vga_hblank = '0' and vga_vblank ='0' and hold = '1' then
--        VGA_R <= "1111111111";
--        VGA_G <= "1111111111";
--        VGA_B <= "1111111111";
      else
        VGA_R <= "0000000000";
        VGA_G <= "0000000000";
        VGA_B <= "0000000000";   
      end if;
    end if;
  end process VideoOut;

  VGA_CLK <= clk25;
  VGA_HS <= not vga_hsync;
  VGA_VS <= not vga_vsync;
  VGA_SYNC <= '0';
  VGA_BLANK <= not (vga_hsync or vga_vsync);

end rtl;
