
def generate_vhdl(mapping, entity_name="dic_mapper"):
    # 1) sort keys by their binary value
    keys_sorted = sorted(mapping.keys(), key=lambda k: int(k,2))
    # sorted_mapping = {
    #     k: mapping[k]
    #     for k in sorted(mapping.keys(), key=sort_key)
    #     }
    flat_list = [item 
            for key in keys_sorted 
            for item in mapping[key]]
    # print(sorted_mapping)
    print(len(flat_list), flat_list)
    
    lines = []
    lines.append("library IEEE;")
    lines.append("use IEEE.STD_LOGIC_1164.ALL;")
    lines.append("use IEEE.NUMERIC_STD.ALL;")
    lines.append(f"entity {entity_name} is")
    lines.append(f"  generic ( WIDTH : integer := {len(flat_list)} );")
    lines.append("  port(")
    lines.append("    data_in  : in  std_logic_vector(WIDTH-1 downto 0);")
    lines.append("    data_out : out std_logic_vector(WIDTH-1 downto 0)")
    lines.append("  );")
    lines.append("end entity;")
    lines.append("")
    lines.append(f"architecture Behavioral of {entity_name} is")
    lines.append("begin")
    for i in range(len(flat_list)):
        lines.append(f"     data_out({i}) <= data_in({flat_list[i]-1});")
    lines.append("end Behavioral;")

    vhdl_code = "\n".join(lines)
    with open(f"{entity_name}_{len(flat_list)}.vhd", "w") as f:
        f.write(vhdl_code)

    print(f"VHDL saved to {entity_name}_{len(flat_list)}")

def generate_counter_levels(mapping, file_name):
    keys_sorted = sorted(mapping.keys(), key=lambda k: int(k,2))
    levels = []
    # sorted_mapping = {
    #     k: mapping[k]
    #     for k in sorted(mapping.keys(), key=sort_key)
    #     }
    # print(sorted_mapping)
    i = 0
    # print(max(mapping.values()))
    width  = math.ceil(math.log2(max(max(mapping.values()))))
    for k in keys_sorted:
        i = i + len(mapping[k])
        # print(k,i)
        levels.append(i)
    
    levels_bin = [format(x, f"0{width}b") for x in levels[:-1]]
    
    with open(f"{file_name}", "w") as f:
        flat = "(" + ", ".join(f'"{b}"' for b in levels_bin) + ")"
        f.write(flat)


def generate_vhdl_rom(memory, depth, width, rom_name='rom'):
    vhdl_lines = []
    vhdl_lines.append(f"-- VHDL ROM model generated from .mif")
    vhdl_lines.append(f"library ieee;")
    vhdl_lines.append(f"use ieee.std_logic_1164.all;")
    vhdl_lines.append(f"use ieee.numeric_std.all;")
    vhdl_lines.append("")
    vhdl_lines.append(f"entity {rom_name} is")
    vhdl_lines.append(f"    port (")
    vhdl_lines.append(f"        addr : in  std_logic_vector({depth.bit_length()-1} downto 0);")
    vhdl_lines.append(f"        data : out std_logic_vector({width - 1} downto 0)");
    vhdl_lines.append(f"    );")
    vhdl_lines.append(f"end entity;")
    vhdl_lines.append("")
    vhdl_lines.append(f"architecture rtl of {rom_name} is")
    vhdl_lines.append(f"begin")
    vhdl_lines.append(f"    process(addr)")
    vhdl_lines.append(f"    begin")
    vhdl_lines.append(f"        case addr is")

    for addr in range(depth):
        val = memory.get(addr, '0' * width)
        addr_bin = f"{addr:0{depth.bit_length()}b}"
        vhdl_lines.append(f"            when \"{addr_bin}\" => data <= \"{val}\";")

    vhdl_lines.append(f"            when others => data <= (others => '0');")
    vhdl_lines.append(f"        end case;")
    vhdl_lines.append(f"    end process;")
    vhdl_lines.append(f"end architecture;")

    return '\n'.join(vhdl_lines)


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print("Usage: python mif_to_vhdl_rom.py <input.mif>")
        sys.exit(1)

    mif_file = sys.argv[1]
    memory, depth, width = parse_mif(mif_file)
    vhdl_code = generate_vhdl_rom(memory, depth, width)

    output_file = mif_file.rsplit('.', 1)[0] + '_rom.vhd'
    with open(output_file, 'w') as f:
        f.write(vhdl_code)

    print(f"VHDL ROM written to {output_file}")