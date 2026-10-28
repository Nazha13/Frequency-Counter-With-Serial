----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.10.2026 14:21:22
-- Design Name: 
-- Module Name: tb_freqcntr - Behavioral
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

entity tb_freqcntr is
--  Port ( );
end tb_freqcntr;

architecture Behavioral of tb_freqcntr is

component top_freqcntr is
  Port (clk100, reset : in std_logic;
        signal_in  : in std_logic;
        active_bit : out std_logic_vector(7 downto 0);
        bcd_out    : out std_logic_vector(6 downto 0);
        tx_out : out std_logic);
end component;

signal clkin, resetin, sigin : std_logic := '0';
signal active_out : std_logic_vector(7 downto 0);
signal bcd_segment: std_logic_vector(6 downto 0);
signal transmit_out : std_logic;

begin

global_clock : process
begin
clkin <= not clkin;
wait for 5ns;
end process;

generate_signal : process
begin
sigin <= not sigin;
wait for 0.5ms;
end process;

stimulus : process
begin
resetin <= '1';
wait for 100ns;
resetin <= '0';
wait;
end process;

testing : top_freqcntr port map(clk100 => clkin,
                                reset => resetin,
                                signal_in => sigin,
                                active_bit => active_out,
                                bcd_out => bcd_segment,
                                tx_out => transmit_out);


end Behavioral;
