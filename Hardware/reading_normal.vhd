LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE IEEE.STD_LOGIC_TEXTIO.ALL;  -- For std_logic I/O
USE std.textio.ALL;             -- Standard I/O package


entity reading_normal is
    generic (
        dimension_size     : integer := 1024;   -- dimension size 
        dimension_WIDTH    : integer := 10;     -- log2 dimension size 
        class_size    : integer := 10;     -- number of classes
        ECC_WIDTH          : integer := 8       -- bit-width of ECC_code 
    );
	port (
	clk                     : in std_logic;
    rst                     : in std_logic;
	din 					: in std_logic_vector(dimension_size-1 downto 0);
    count_reg               : in std_logic_vector(dimension_WIDTH-1 downto 0);
    dout                    : out std_logic_vector(dimension_WIDTH-1 downto 0)
	);	
	attribute DONT_TOUCH : string;
	attribute KEEP : string;
	attribute DONT_TOUCH of reading_normal : entity is "TRUE";
	attribute KEEP of reading_normal : entity is "TRUE";
end entity;

architecture behavior of reading_normal is

    -- Array types
    type CHV_memory_array is array (0 to dimension_size-1) of std_logic_vector(class_size-1 downto 0);
    type countingCheck is array (0 to dimension_WIDTH-1) of std_logic_vector(dimension_WIDTH-1 downto 0);

    -- Signals
    signal CHV_memory               : CHV_memory_array;
    signal CHV_memory_out : std_logic_vector(class_size-1 downto 0);
    signal corrected_CHV_memory_out : std_logic_vector(class_size-1 downto 0);

    signal count_sim               : countingCheck;
    signal double_error    : std_logic;

    -- File I/O
    file CHV_memory_mif_file : text open read_mode is "trans_CHV_mem_10000.mif";
    
    signal en_pops_regular         : std_logic_vector(class_size-1 downto 0);
    
    signal LFSRasHVCheck           : std_logic;
    signal LFSR_suffleAsHVCheck    : std_logic;

	signal ECC_out             : std_logic_vector(5-1 downto 0);
    
begin
  -- Read CHV memory
    process
        variable mif_line : line;
        variable temp_bv  : bit_vector(class_size-1 downto 0);
    begin
        for i in 0 to dimension_size-1 loop
            if not endfile(CHV_memory_mif_file) then
                readline(CHV_memory_mif_file, mif_line);
                read(mif_line, temp_bv);
                CHV_memory(i) <= to_stdlogicvector(temp_bv);
            else
                CHV_memory(i) <= (others => '0');
            end if;
        end loop;
        wait;
    end process;

    CHV_mem_read_proc: process(clk)
    begin
        if rising_edge(clk) then
            CHV_memory_out <= CHV_memory(to_integer(unsigned(count_reg)));
        end if;
    end process;

	ECCuut: entity work.ECC_vhdl_module
    generic map(
        C  => class_size,
        ECC_bit => 5   )
    port map(
        d => CHV_memory_out,
        p => ECC_out,
        double_error => double_error,
        dcw   => corrected_CHV_memory_out
    );
    
	ECCuutMem: entity work.uniform_ECC_memory 
	generic map(
    dimension_size => dimension_size,
    dimension_WIDTH    =>  dimension_WIDTH,
    ECC_WIDTH => ECC_WIDTH )
    port map(
    clk  => clk,
    rst  => rst,
    ECC_pointer => count_reg,
    ECC_out => ECC_out
    );


    LFSRasHVCheck  <= din(to_integer(unsigned(count_reg)));

    en_regular_pops: for k in 0 to class_size-1 generate
        en_pops_regular(k) <= corrected_CHV_memory_out(k) xor LFSRasHVCheck;
    end generate;

    -- Counters for regular
    class_counter: for k in 0 to class_size-1 generate
        simcounter: entity work.popCount 
            generic map(lenPop => dimension_WIDTH)
            port map(
                clk  => clk,
                rst  => rst,
                en   => en_pops_regular(k),
                dout => count_sim(k)
            );
    end generate;
	
	dout <= std_logic_vector(unsigned(count_sim(0)) + unsigned(count_sim(1)) + unsigned(count_sim(2)) + unsigned(count_sim(3)) + unsigned(count_sim(4)) + unsigned(count_sim(5)) + unsigned(count_sim(6)) + unsigned(count_sim(7)) + unsigned(count_sim(8)) + unsigned(count_sim(9)));
end architecture;
