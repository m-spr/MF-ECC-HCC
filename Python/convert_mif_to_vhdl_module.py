def convert_mif_to_vhdl_module(mif_path, number_of_classes = 5, output_path="trans_CHV_mem_10000.vhdl"):
    with open(mif_path, 'r') as file:
        lines = file.readlines()

    # Flatten data lines, remove commas and newlines
    data = ''.join(lines).replace(',', '').replace('\n', '')
    data_chunks = [data[i:i+number_of_classes] for i in range(0, len(data), number_of_classes)]  # 8-bit words

    address_width = (len(data_chunks) - 1).bit_length()
    entity_name = mif_path[:-4]
    output_path=entity_name+".vhdl"
    with open(output_path, 'w') as vhdl_file:
        vhdl_file.write(f"library IEEE;\nuse IEEE.STD_LOGIC_1164.ALL;\nuse IEEE.STD_LOGIC_UNSIGNED.ALL;\n\n")
        vhdl_file.write(f"entity {entity_name} is\n")
        vhdl_file.write(f"    Port (\n")
        vhdl_file.write(f"        clk     : in  STD_LOGIC;\n")
        vhdl_file.write(f"        address : in  STD_LOGIC_VECTOR({address_width - 1} downto 0);\n")
        vhdl_file.write(f"        data    : out STD_LOGIC_VECTOR({number_of_classes} downto 0)\n")
        vhdl_file.write(f"    );\n")
        vhdl_file.write(f"end {entity_name};\n\n")

        vhdl_file.write(f"architecture Behavioral of {entity_name} is\n")
        vhdl_file.write(f"begin\n")
        vhdl_file.write(f"    process(clk)\n")
        vhdl_file.write(f"    begin\n")
        vhdl_file.write(f"        if rising_edge(clk) then\n")
        vhdl_file.write(f"            case address is\n")
        for i, word in enumerate(data_chunks):
            vhdl_file.write(f"                when x\"{i:02X}\" => data <= \"{word}\";\n")
        vhdl_file.write(f"                when others => data <= (others => '0');\n")
        vhdl_file.write(f"            end case;\n")
        vhdl_file.write(f"        end if;\n")
        vhdl_file.write(f"    end process;\n")
        vhdl_file.write(f"end Behavioral;\n")

    print(f"Complete VHDL ROM module written to {output_path}")
# mif_to_vhdl_case.py

convert_mif_to_vhdl_module("MNIST_ECC_CHVs/ECC_CHV_img_10000.mif") #change the path
