library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- -- Define an unconstrained integer array for thresholds
-- package counter_pkg is
--   type integer_array is array (natural range <>) of integer;
-- end package counter_pkg;

-- use work.counter_pkg.all;

entity configurable_counter is
  generic (
    dimension_WIDTH            : integer := 8;   -- bit-width of dimension size -- log2D
    ECC_WIDTH            : integer := 8   -- bit-width of ECC_code 
    -- NUM_THRESHOLDS   : natural := 3;   -- how many trigger values you’ll supply
    -- TRIGGER_THRESHOLDS : integer_array(0 to NUM_THRESHOLDS-1)
    --                   := (10, 20, 30)           -- default single-entry array
  );
  port (
    clk       : in  std_logic;
    rst       : in  std_logic;
    CHV_pointer       : in  std_logic_vector(dimension_WIDTH-1 downto 0);
    ECC_out : out std_logic_vector(ECC_WIDTH-1 downto 0)
  );
end entity configurable_counter;

architecture behavioral of configurable_counter is
  signal count_reg : unsigned(ECC_WIDTH-1 downto 0) := (others => '0');
  type rom_t is array (0 to (2**ECC_WIDTH)-1) of std_logic_vector(dimension_WIDTH-1 downto 0); -- 8*3 + 7 = 24 +7 = 31
  signal triggers : rom_t :=("01000010100100", "01000011110010", "01000100100110", "01000101100011", "01000110010000", "01000111001001", "10000001011110", 
  "10000010101010", "10000011011100", "10000100100010", "10000101101110", "10001000110010", "10001001110101", "10001100110010", "10001101110111", "10001110110100",
   "10001111100110", "10010000100111", "10010001100001", "10010010111101", "10010011101111", "10010101001001", "10010101111000", "10010110111110",
   "10011000000011", "10011010000000", "10011011000011", "10011011101001", "10011100101101", "10011101010101", "10011110010100", "10011110010100");
begin
  process(clk, rst)
  begin
    if rst = '1' then
      count_reg <= (others => '0');    -- in case of multiple instances, the initiate should be different for each... 
    elsif rising_edge(clk) then
        if CHV_pointer = triggers(to_integer(count_reg)) then
          count_reg <= count_reg + 1;
        else
          count_reg <= count_reg;  -- hold
        end if;
    end if;
  end process;

  ECC_out <= std_logic_vector(count_reg);
end architecture behavioral;
