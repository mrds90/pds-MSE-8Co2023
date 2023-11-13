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
    component MiComponente is
      generic (
        N : positive := 2   -- Tamaño configurable
      );
      Port (
        clk : in STD_LOGIC;           -- Reloj
        rst : in STD_LOGIC;           -- Reset asincrónico
        entrada : in STD_LOGIC_VECTOR(N-1 downto 0);        -- Señal de entrada
        sumando : in STD_LOGIC_VECTOR(N-1 downto 0);        -- Sumando
        coeficiente : in STD_LOGIC_VECTOR(N-1 downto 0);    -- Coeficiente
        salida : out STD_LOGIC_VECTOR(N-1 downto 0);        -- Salida del componente
        salida_sin_delay : out STD_LOGIC_VECTOR(N-1 downto 0)      -- Salida del componente
      );
end component;

constant N_tb : natural := 2;

signal clk_s    : STD_LOGIC := '0';
signal rst_s    : STD_LOGIC;
signal coef_s   : STD_LOGIC_VECTOR(N_tb-1 downto 0) := "10";
signal in_s     : STD_LOGIC_VECTOR(N_tb-1 downto 0);
signal sum_s    : STD_LOGIC_VECTOR(N_tb-1 downto 0) := "00";
signal outd_s   : STD_LOGIC_VECTOR(N_tb-1 downto 0);
signal outs_s   : STD_LOGIC_VECTOR(N_tb-1 downto 0);


begin

clk_s <= not clk_s after 10ns;

DUT: MiComponente 

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
    salida_sin_delay    => outs_s
);

process
    begin
        
    
    end process;

end arch;
