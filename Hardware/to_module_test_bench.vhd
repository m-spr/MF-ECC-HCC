
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE IEEE.STD_LOGIC_TEXTIO.ALL;  -- For std_logic I/O
USE std.textio.ALL;             -- Standard I/O package

entity top_module_test_bench is
    generic (
        dimension_size     : integer := 10240;   -- dimension size 
        dimension_WIDTH    : integer := 14;     -- log2 dimension size 
        dimension_segmentation    : integer := 1280;     -- genrate input
        class_size    : integer := 10;     -- number of classes
        ECC_WIDTH          : integer := 5       -- bit-width of ECC_code 
    );
    port (
	clk                     : in std_logic;
    rst                     : in std_logic;
    pop_en                  : in std_logic;
	din 					: in std_logic_vector((dimension_size/dimension_segmentation)-1 downto 0);
--    dout                    : out std_logic
count_sim_shuffled  :out std_logic_vector(dimension_WIDTH-1 downto 0)
	);	
	attribute DONT_TOUCH : string;
	attribute KEEP : string;
	attribute DONT_TOUCH of top_module_test_bench : entity is "TRUE";
	attribute KEEP of top_module_test_bench : entity is "TRUE";
end entity;

architecture behavior of top_module_test_bench is

signal realdin 					:  std_logic_vector((dimension_size)-1 downto 0);

type index_array is array (0 to dimension_size-1) of std_logic_vector(dimension_WIDTH-1 downto 0);
    
signal index_memory               : index_array;
signal current_index : std_logic_vector(dimension_WIDTH-1 downto 0);
file index_memory_mif_file : text open read_mode is "index_level_10000.mif";

	
signal count_reg               :  std_logic_vector(dimension_WIDTH-1 downto 0);
       
begin
--	-- Read CHV memory
--    process
--        variable mif_line : line;
--        variable temp_bv  : bit_vector(dimension_WIDTH-1 downto 0);
--    begin
--        for i in 0 to dimension_size-1 loop
--            if not endfile(index_memory_mif_file) then
--                readline(index_memory_mif_file, mif_line);
--                read(mif_line, temp_bv);
--                index_memory(i) <= to_stdlogicvector(temp_bv);
--            else
--                index_memory(i) <= (others => '0');
--            end if;
--        end loop;
--        wait;
--    end process;

--    CHV_mem_read_proc: process(clk)
--    begin
--        if rising_edge(clk) then
--            current_index <= index_memory(to_integer(unsigned(count_reg)));
--        end if;
--    end process;

    input_gen: for k in 0 to dimension_segmentation-1 generate
        realdin((dimension_size/dimension_segmentation)*(k+1)-1 downto (dimension_size/dimension_segmentation)*k) <= din;
    end generate;
    
    
    ECCuutMem: entity work.top_module 
	generic map(
		dimension_size  => dimension_size,
        dimension_WIDTH  => dimension_WIDTH,
        class_size  =>  class_size,
        ECC_WIDTH => ECC_WIDTH)
	port map(
		clk  => clk,
		rst  => rst,
		pop_en  => pop_en,
		din  => realdin,
	--current_index 		=> current_index,
	count_reg 		=> count_reg,
--		dout  => dout
		count_sim_shuffled => count_sim_shuffled
		);

    -- Count_reg counter
    counter: entity work.popCount 
        generic map(lenPop => dimension_WIDTH)
        port map(
            clk  => clk,
            rst  => rst,
            en   => pop_en,
            dout => count_reg
        );

end architecture;
