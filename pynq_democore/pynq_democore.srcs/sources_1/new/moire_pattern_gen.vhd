library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity moire_pattern_gen is
    Generic (
        H_RES : integer := 1280;
        V_RES : integer := 720
    );
    Port (
        aclk    : in STD_LOGIC;
        aresetn : in STD_LOGIC;
        m_axis_video_tdata  : out STD_LOGIC_VECTOR(23 downto 0); 
        m_axis_video_tvalid : out STD_LOGIC;
        m_axis_video_tready : in  STD_LOGIC;
        m_axis_video_tlast  : out STD_LOGIC;
        m_axis_video_tuser  : out STD_LOGIC 

    );
end moire_pattern_gen;

architecture Behavioral of moire_pattern_gen is
    signal h_count : unsigned(11 downto 0) := (others => '0');
    signal v_count : unsigned(11 downto 0) := (others => '0');
    signal frame_count : unsigned(15 downto 0) := (others => '0');
    signal axis_valid : std_logic := '0';
    signal axis_last  : std_logic := '0';
    signal axis_user  : std_logic := '0';

begin
    m_axis_video_tvalid <= axis_valid;
    m_axis_video_tlast  <= axis_last;
    m_axis_video_tuser  <= axis_user;

    process(aclk)
    begin
        if rising_edge(aclk) then
            if aresetn = '0' then
                h_count <= (others => '0');
                v_count <= (others => '0');
                frame_count <= (others => '0');
                axis_valid <= '0';
                axis_last <= '0';
                axis_user <= '0';
            else
                axis_valid <= '1';
                if m_axis_video_tready = '1' and axis_valid = '1' then
                    if h_count = H_RES - 1 then
                        h_count <= (others => '0');
                        axis_last <= '0'; 
                        if v_count = V_RES - 1 then
                            v_count <= (others => '0');
                            axis_user <= '1'; 
                            frame_count <= frame_count + 1; 
                        else
                            v_count <= v_count + 1;
                            axis_user <= '0';
                        end if;
                    else
                        h_count <= h_count + 1;
                        if h_count = H_RES - 2 then
                            axis_last <= '1';
                        else
                            axis_last <= '0';
                        end if;

                        axis_user <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;

    process(h_count, v_count, frame_count)
        variable r, g, b : unsigned(7 downto 0);
    begin
        g := (h_count(7 downto 0) + frame_count(7 downto 0)) XOR v_count(7 downto 0);
        r := h_count(8 downto 1); 
        b := v_count(8 downto 1) + frame_count(7 downto 0);
        m_axis_video_tdata <= std_logic_vector(b) & std_logic_vector(g) & std_logic_vector(r);
    end process;

end Behavioral;