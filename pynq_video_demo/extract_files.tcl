# extract_files.tcl
# Automates exporting Bitstream and Handoff for Pynq

# 1. Setup Names and Paths
set proj_dir [get_property DIRECTORY [current_project]]
set proj_name [current_project]
set impl_dir "$proj_dir/${proj_name}.runs/impl_1"
set bd_name "design_1"
set top_name "design_1_wrapper"

# Define the Target Name (What you want the files to be called)
set target_name "screensaver"

# 2. Define Source Paths
set bit_src "$impl_dir/${top_name}.bit"
# Vivado 2020+ uses the .gen folder structure
set hwh_src "$proj_dir/${proj_name}.gen/sources_1/bd/${bd_name}/hw_handoff/${bd_name}.hwh"

# 3. Define Destination Paths (Project Root)
set bit_dst "$proj_dir/${target_name}.bit"
set hwh_dst "$proj_dir/${target_name}.hwh"

# 4. Perform the Copy
puts "-------------------------------------------------------"
puts "  PYNQ EXPORT: Copying files to project root..."

if {[file exists $bit_src]} {
    file copy -force $bit_src $bit_dst
    puts "  SUCCESS: Copied $bit_src -> $bit_dst"
} else {
    puts "  ERROR: Could not find bitstream at $bit_src"
}

if {[file exists $hwh_src]} {
    file copy -force $hwh_src $hwh_dst
    puts "  SUCCESS: Copied $hwh_src -> $hwh_dst"
} else {
    # Fallback check for older Vivado versions or different directory structures
    set hwh_old_src "$proj_dir/${proj_name}.srcs/sources_1/bd/${bd_name}/hw_handoff/${bd_name}.hwh"
    if {[file exists $hwh_old_src]} {
        file copy -force $hwh_old_src $hwh_dst
        puts "  SUCCESS: Copied $hwh_old_src -> $hwh_dst"
    } else {
        puts "  ERROR: Could not find .hwh file!"
    }
}
puts "-------------------------------------------------------"