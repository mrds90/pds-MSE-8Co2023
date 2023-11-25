----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/12/2023 08:02:26 PM
-- Design Name: 
-- Module Name: tb_fir_filter - Behavioral
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_fir_filter is
--  Port ( );
end tb_fir_filter;

architecture arch of tb_fir_filter is
    component fir_core is
      generic (
        N : positive := 4   -- Tamaño configurable
      );
      Port (
        clk : in STD_LOGIC;           -- Reloj
        rst : in STD_LOGIC;           -- Reset asincrónico
        entrada : in STD_LOGIC_VECTOR(N-1 downto 0);        -- Señal de entrada
        sumando : in STD_LOGIC_VECTOR(N-1 downto 0);        -- Sumando
        coeficiente : in STD_LOGIC_VECTOR(N-1 downto 0);    -- Coeficiente
        salida : out STD_LOGIC_VECTOR(N-1 downto 0);        -- Salida del componente
        salida_sin_delay : out STD_LOGIC_VECTOR(N-1 downto 0);      -- Salida del componente
        salida_mul : out STD_LOGIC_VECTOR(2 * N - 1 downto 0);
        salida_sum : out STD_LOGIC_VECTOR(N - 1 downto 0)
      );
end component;

constant N_tb : natural := 4;

signal clk_s    : STD_LOGIC := '0';
signal rst_s    : STD_LOGIC;
signal coef_s   : STD_LOGIC_VECTOR(N_tb-1 downto 0);
signal in_s     : STD_LOGIC_VECTOR(N_tb-1 downto 0);
signal sum_s    : STD_LOGIC_VECTOR(N_tb-1 downto 0);
signal outd_s   : STD_LOGIC_VECTOR(N_tb-1 downto 0);
signal outs_s   : STD_LOGIC_VECTOR(N_tb-1 downto 0);
signal outmul_s   : STD_LOGIC_VECTOR(2*N_tb-1 downto 0);
signal outsum_s   : STD_LOGIC_VECTOR(N_tb-1 downto 0);


begin

clk_s <= not clk_s after 10ns;

DUT: fir_core 

generic map(
    N => N_tb
)

port map(
    clk                 => clk_s,
    rst                 => rst_s,
    entrada             => in_s,
    sumando             => sum_s,
    coeficiente         => coef_s,
    salida              => outd_s,
    salida_sin_delay    => outs_s,
    salida_mul          => outmul_s,
    salida_sum          => outsum_s
);

STIMULI:
process
begin
report("Starting simulation");
coef_s <=  std_logic_vector(to_signed (8, N_tb));
sum_s  <=  std_logic_vector(to_signed (2, N_tb));
rst_s <= '1';
for i in 0 to 5 loop
    wait until rising_edge(clk_s);
end loop;
rst_s <= '0';

for i in 1 to 15 loop
    in_s <= std_logic_vector(to_unsigned(i,N_tb));
    if (i > 9) then
        rst_s <= '1';
    end if;
    wait until rising_edge(clk_s);
end loop;

end process;

end arch;
