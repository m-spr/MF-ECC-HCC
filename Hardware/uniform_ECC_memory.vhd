
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

use IEEE.STD_LOGIC_TEXTIO.ALL; -- Use this for text files with std_logic
use std.textio.all;            -- Standard text I/O package

ENTITY uniform_ECC_memory IS
	generic (
    dimension_size            : integer := 1000;   -- dimension size 
    dimension_WIDTH            : integer := 10;   -- log2 dimension size 
    ECC_WIDTH            : integer := 8   -- bit-width of ECC_code 
    );
    port (
    clk       : in  std_logic;
    rst       : in  std_logic;
    ECC_pointer       : in  std_logic_vector(dimension_WIDTH-1 downto 0);
    ECC_out : out std_logic_vector(ECC_WIDTH-1 downto 0)
    );
    	attribute DONT_TOUCH : string;
	attribute KEEP : string;
	attribute DONT_TOUCH of uniform_ECC_memory : entity is "TRUE";
	attribute KEEP of uniform_ECC_memory : entity is "TRUE";
END ENTITY uniform_ECC_memory;

ARCHITECTURE behavioral OF uniform_ECC_memory IS

-- Define the type for an array of std_logic_vector
type ECC_memory_array is array (dimension_size-1 downto 0) of std_logic_vector(ECC_WIDTH-1 downto 0);
-- memory signal
signal ECCmemory : ECC_memory_array;
-- File-related for memory
file ECCmif_file : text open read_mode is "ECC_CHV_img_10000.mif"; -- Specify ECC file name

BEGIN
	
    -- The process read the file for ECC check and store data in the signal
    process
	variable mif_line : line;
	variable temp_bv : bit_vector(ECC_WIDTH-1 downto 0); -- Temporary buffer for each line

    begin
        -- Loop through each line of the file
        for i in 0 to dimension_size-1 loop
            if not endfile(ECCmif_file) then
                -- Read one line from the file
                readline(ECCmif_file, mif_line);
                -- Read the binary data into the temporary bit_vector
                read(mif_line, temp_bv);
                -- Convert the bit_vector to std_logic_vector and store it in the memory signal
                ECCmemory(i) <= to_stdlogicvector(temp_bv);
            else
                -- Handle end of file if fewer lines exist than expected
                ECCmemory(i) <= (others => '0'); -- Optional: Initialize remaining entries to 0
            end if;
        end loop;
        wait; -- Stop the process after reading the file
    end process; 


read_proc: process(clk)
begin
    if rising_edge(clk) then
        ECC_out <= ECCmemory(to_integer(unsigned(ECC_pointer)));
    end if;
end process read_proc;

END ARCHITECTURE behavioral;
