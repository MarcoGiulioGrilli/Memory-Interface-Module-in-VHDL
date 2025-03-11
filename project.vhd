----------------------------------------------------------------------------------
-- Company: Politecnico di Milano
-- Engineer: Marco Giulio Grilli, Martina Giacomelli
-- 
-- Create Date: 17.03.2023 13:40:17
-- Design Name: 
-- Module Name: project_reti_logiche - Behavioral
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


-- UNISIM;
--use UNISIM.VComponents.all;

entity project_reti_logiche is
    port (
    i_clk : in std_logic;
    i_rst : in std_logic;
    i_start : in std_logic;
    i_w : in std_logic;
    o_z0 : out std_logic_vector(7 downto 0);
    o_z1 : out std_logic_vector(7 downto 0);
    o_z2 : out std_logic_vector(7 downto 0);
    o_z3 : out std_logic_vector(7 downto 0);
    o_done : out std_logic;
    o_mem_addr : out std_logic_vector(15 downto 0);
    i_mem_data : in std_logic_vector(7 downto 0);
    o_mem_we : out std_logic;
    o_mem_en : out std_logic
    );
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is
type state is (START, SELECTION2, READ_W, CONCATENATION, READ_RAM, WAIT_READ, DEMULTIPLEXING, DONE);

begin
process(i_clk)
variable next_state, curr_state : state :=START;
variable sel_1: std_logic :='0';-- bit per tenere traccia delle prima lettura di i_w
variable sel_2: std_logic :='0';-- bit per tenere traccia delle seconda lettura di i_w
variable data_reg : std_logic_vector(15 downto 0) := "0000000000000000"; -- registro per l'indirizzo di memoria
variable z0 : std_logic_vector(7 downto 0):="00000000"; -- variabili per tenere conto delle uscite quando o_done è 1
variable z1 : std_logic_vector(7 downto 0):="00000000"; 
variable z2 : std_logic_vector(7 downto 0):="00000000"; 
variable z3 : std_logic_vector(7 downto 0):="00000000"; 
variable mem_data : std_logic_vector (7 downto 0):="00000000";
variable first_bit: std_logic :='0'; -- bit per leggere il primo bit di data_reg

begin 
if(i_clk'event and i_clk='1') then
    if(i_rst = '1') then 
          curr_state := START;
          o_z0 <= "00000000";
          o_z1 <= "00000000";
          o_z2 <= "00000000";
          o_z3 <= "00000000";
          z0:="00000000";
          z1:="00000000";
          z2:="00000000";
          z3:="00000000";
          o_mem_we <= '0';
          o_done<='0';
          o_mem_en<='0';
          data_reg:="0000000000000000";
          o_mem_addr<="0000000000000000";
          sel_1:='0';
          sel_2:='0';
      else 
          curr_state := next_state;
     end if;
     
      case curr_state is
          when START =>
            o_done <= '0';
            o_mem_addr <= "0000000000000000";
            data_reg:="0000000000000000";
            o_mem_we <= '0';
            o_mem_en <= '0';
            o_z0 <= "00000000"; 
            o_z1 <= "00000000";
            o_z2 <= "00000000";
            o_z3 <= "00000000";
            sel_1:='0';
            sel_2:='0';
 
            if i_start = '1' then
                sel_1 := i_w;
                next_state := SELECTION2;
            else  
                next_state:=START;
            end if;
            
		when SELECTION2 =>
            if(i_start = '1') then
                sel_2 := i_w;
            end if;
            next_state := READ_W;
            
        when READ_W =>
            if (i_start ='0') then 
                next_state := READ_RAM;
            else
               first_bit:=i_w;
               data_reg:=data_reg(14 downto 0) & first_bit;
               next_state := CONCATENATION; 
            end if;
            
        when CONCATENATION =>
            if (i_start='1') then 
                data_reg:=data_reg(14 downto 0) & i_w;
                next_state:=CONCATENATION;
            else
                o_mem_addr <= data_reg;
                data_reg:="0000000000000000";
                next_state := READ_RAM;
            end if;

        when READ_RAM =>
            o_mem_en<='1';
            next_state := WAIT_READ;
            
        when WAIT_READ =>
            o_mem_en<='0';    
            next_state := DEMULTIPLEXING;
            
        when DEMULTIPLEXING =>
            mem_data := i_mem_data;
            if(sel_1 = '0' and sel_2 = '0') then
                o_z0 <= mem_data;
                z0 := mem_data;
                o_z1 <= z1;
                o_z2 <= z2;
                o_z3 <= z3;
            elsif(sel_1 = '0' and sel_2 = '1') then
                o_z1 <= mem_data;
                z1 := mem_data;
                o_z0 <= z0;
                o_z2 <= z2;
                o_z3 <= z3;
            elsif (sel_1 = '1' and sel_2 = '0') then
                o_z2 <= mem_data;
                z2 := mem_data;
                o_z1 <= z1;
                o_z0 <= z0;
                o_z3 <= z3;
            elsif (sel_1 = '1' and sel_2 = '1') then
                o_z3 <= mem_data;
                z3 := mem_data;
                o_z1 <= z1;
                o_z2 <= z2;
                o_z0 <= z0;
            end if;
            o_done <= '1';
            next_state := DONE;
       when DONE=>
        o_done <= '0';
        o_z0 <= "00000000"; 
        o_z1 <= "00000000";
        o_z2 <= "00000000";
        o_z3 <= "00000000";
        next_state := START;
    end case;
  end if;
end process;
end Behavioral;   
       
    