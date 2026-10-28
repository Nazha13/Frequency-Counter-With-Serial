----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.10.2026 13:55:47
-- Design Name: 
-- Module Name: tx_controller - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tx_controller is
  Port (clk, reset : in std_logic;
        bcd_in : in std_logic_vector(15 downto 0);
        flag : in std_logic;
        tx_out : out std_logic);
end tx_controller;

architecture Behavioral of tx_controller is

component clock_divider is
  Port (clk_in  : in std_logic;
        baud_out : out std_logic);
end component;

component edge_detector is
  Port (clk, reset, sync_in : in std_logic; 
        pulse_out           : out std_logic);
end component;

component uart_tx is
  Port (clk, reset, baud    : in std_logic;
        busy                : out std_logic;
        txin                : in std_logic_vector(7 downto 0);
        txout               : out std_logic);
end component;

component falling_edge_detector is
  Port (clk, reset, sync_in : in std_logic;
        pulse_out : out std_logic);
end component;

type statetype is (idle, prep, sendd1, sendd2, sendd3, sendd4, sendh, sendz, sendcr, sendlf);
signal data_package : std_logic_vector(7 downto 0) := "00000000";
signal busy_flag, busy_pulse : std_logic;
signal baud_signal, baud_pulse : std_logic;
signal state : statetype;

begin
process(clk, reset)
begin
if reset = '1' then
    data_package <= "00000000";
    state <= idle;
elsif rising_edge(clk) then
    if state = idle then
        if flag = '1' then
            data_package <= "0011" & bcd_in(15 downto 12);
            state <= sendd1;
        else
            state <= prep;
        end if;
    elsif state = prep then
        state <= sendd1;
    elsif state = sendd1 then
        if busy_pulse = '1' then
            data_package <= "0011" & bcd_in(11 downto 8);
            state <= sendd2;
        end if;
    elsif state = sendd2 then
        if busy_pulse = '1' then
            data_package <= "0011" & bcd_in(7 downto 4);
            state <= sendd3;
        end if;
    elsif state = sendd3 then
        if busy_pulse = '1' then
            data_package <= "0011" & bcd_in(3 downto 0);
            state <= sendd4;
        end if;
    elsif state = sendd4 then
        if busy_pulse = '1' then
            data_package <= x"48";
            state <= sendh;
        end if;
    elsif state = sendh then
        if busy_pulse = '1' then
            data_package <= x"7A";
            state <= sendz;
        end if;
    elsif state = sendz then
        if busy_pulse = '1' then
            data_package <= x"0D";
            state <= sendcr;
        end if;
    elsif state = sendcr then
        if busy_pulse = '1' then
            data_package <= x"0A";
            state <= sendlf;
        end if;
    elsif state = sendlf then
        if busy_pulse = '1' then
            data_package <= "0011" & bcd_in(15 downto 12);
            state <= idle;
        end if;
    else
        state <= idle;
    end if;    
end if;
end process;

baud_generator : clock_divider port map(clk_in => clk, baud_out => baud_signal);

baud_pulse_signal : edge_detector port map(clk => clk,
                                           reset => reset,
                                           sync_in => baud_signal,
                                           pulse_out => baud_pulse);                                  
transmit : uart_tx port map(clk => clk,
                            reset => reset,
                            baud => baud_pulse,
                            busy => busy_flag,
                            txin => data_package,
                            txout => tx_out);
fall_detect : falling_edge_detector port map(clk => clk,
                                             reset => reset,
                                             sync_in => busy_flag,
                                             pulse_out => busy_pulse);                    
end Behavioral;
