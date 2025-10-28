LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE IEEE.STD_LOGIC_TEXTIO.ALL;  -- For std_logic I/O
USE std.textio.ALL;             -- Standard I/O package

entity top_module is
    generic (
        dimension_size     : integer := 1024;   -- dimension size 
        dimension_WIDTH    : integer := 10;     -- log2 dimension size 
        class_size    : integer := 10;     -- number of classes
        ECC_WIDTH          : integer := 32       -- bit-width of ECC_code 
    );
	port (
	clk                     : in std_logic;
    rst                     : in std_logic;
    pop_en                  : in std_logic;
	din 					: in std_logic_vector(dimension_size-1 downto 0);
	--current_index 					: in std_logic_vector(dimension_WIDTH-1 downto 0);
	count_reg 					: in std_logic_vector(dimension_WIDTH-1 downto 0);
--    dout                    : out std_logic
count_sim_shuffled : out std_logic_vector(dimension_WIDTH-1 downto 0)
	);	
	attribute DONT_TOUCH : string;
	attribute KEEP : string;
	attribute DONT_TOUCH of top_module : entity is "TRUE";
	attribute KEEP of top_module : entity is "TRUE";
end entity;

architecture behavior of top_module is

--signal count_sim_shuffled               :  std_logic_vector(dimension_WIDTH-1 downto 0);
signal count_sim             :  std_logic_vector(dimension_WIDTH-1 downto 0);
begin 

--	ECCuutMem: entity work.reading_normal 
--	generic map(
--		dimension_size  => dimension_size,
--        dimension_WIDTH  => dimension_WIDTH,
--        class_size => class_size,
--        ECC_WIDTH => ECC_WIDTH)
--	port map(
--		clk  => clk,
--		rst  => rst,
--		din  => din,
--		count_reg  => count_reg,
--		dout  => count_sim
--		);

	ECCuutPop: entity work.reading_shuffle 
	generic map(
		dimension_size  => dimension_size,
        dimension_WIDTH  => dimension_WIDTH,
        class_size => class_size,
        ECC_WIDTH => ECC_WIDTH)
	port map(
		clk  => clk,
		rst  => rst,
		din  => din,
		count_reg  => count_reg,
		dout  => count_sim_shuffled
		);


--dout <= '1' when count_sim_shuffled = count_sim else '0';

end architecture;