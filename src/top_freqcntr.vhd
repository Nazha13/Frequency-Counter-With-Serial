----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.10.2026 13:03:42
-- Design Name: 
-- Module Name: top_freqcntr - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_freqcntr is
  Port (clk100, reset : in std_logic;
        signal_in  : in std_logic;
        active_bit : out std_logic_vector(7 downto 0);
        bcd_out    : out std_logic_vector(6 downto 0);
        tx_out : out std_logic);
end top_freqcntr;

architecture Behavioral of top_freqcntr is

component clk_wiz_0 is
  Port (clk_out1 : out std_logic;
        reset    : in std_logic;
        locked   : out std_logic;
        clk_in1  : in std_logic);
end component;

component synchronizer is
  Port (clk, reset, async_in : in std_logic;
        sync_out             : out std_logic);
end component;

component edge_detector is
  Port (clk, reset, sync_in : in std_logic; 
        pulse_out           : out std_logic);
end component;

component period_counter is
  Port (clk, reset, pulse_in : in std_logic;
        data_valid           : out std_logic;
        period_ticks         : out std_logic_vector(24 downto 0));
end component;

component divider is
  Port (clk, reset   : in std_logic;
        valid_in     : in std_logic;
        period_in    : in std_logic_vector(24 downto 0);
        valid_out    : out std_logic;
        freq_out     : out std_logic_vector(24 downto 0));
end component;

component doubdab is
  Port (clk, reset, valid_in : in std_logic;
        freq_in    : in std_logic_vector(24 downto 0);
        bcd_out    : out std_logic_vector(15 downto 0);
        valid_out  : out std_logic);
end component;

component display_controller is
  Port (clk, reset : in std_logic; 
        bcd_in     : in std_logic_vector(15 downto 0);
        active_bit : out std_logic_vector(7 downto 0);
        bcd_out    : out std_logic_vector(6 downto 0));
end component;

component tx_controller is
  Port (clk, reset : in std_logic;
        bcd_in : in std_logic_vector(15 downto 0);
        flag : in std_logic;
        tx_out : out std_logic);
end component;

signal clk : std_logic;

signal out1, out2, flag1, flag2, flag3 : std_logic;
signal out3, out4 : std_logic_vector(24 downto 0);
signal out5 : std_logic_vector(15 downto 0);

begin

clkdivide : clk_wiz_0 port map(clk_out1 => clk,
                               reset => reset,
                               locked => open,
                               clk_in1 => clk100);

section1 : synchronizer port map(clk => clk,
                                 reset => reset,
                                 async_in => signal_in,
                                 sync_out => out1);
section2 : edge_detector port map(clk => clk,
                                  reset => reset,
                                  sync_in => out1,
                                  pulse_out => out2);
section3 : period_counter port map(clk => clk,
                                   reset => reset,
                                   pulse_in => out2,
                                   data_valid => flag1,
                                   period_ticks => out3);
section4 : divider port map(clk => clk,
                            reset => reset,
                            valid_in => flag1,
                            period_in => out3,
                            valid_out => flag2,
                            freq_out => out4);
section5 : doubdab port map(clk => clk,
                            reset => reset,
                            valid_in => flag2,
                            freq_in => out4,
                            bcd_out => out5,
                            valid_out => flag3);
section6 : display_controller port map(clk => clk,
                                       reset => reset,
                                       bcd_in => out5,
                                       active_bit => active_bit,
                                       bcd_out => bcd_out);
additional_section : tx_controller port map(clk => clk,
                                            reset => reset,
                                            bcd_in => out5,
                                            flag => flag3,
                                            tx_out => tx_out);                 
end Behavioral;
