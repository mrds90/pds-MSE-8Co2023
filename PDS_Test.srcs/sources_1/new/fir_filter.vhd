library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MiComponente is
  generic (
    N : positive := 2   -- Tamaño configurable
  );
  Port (
    clk : in STD_LOGIC;           -- Reloj
    rst : in STD_LOGIC;           -- Reset asincrónico
    entrada : in STD_LOGIC_VECTOR(N-1 downto 0);     -- Señal de entrada
    sumando : in STD_LOGIC_VECTOR(N-1 downto 0);     -- Sumando
    coeficiente : in STD_LOGIC_VECTOR(N-1 downto 0); -- Coeficiente
    salida : out STD_LOGIC_VECTOR(N-1 downto 0);      -- Salida del componente
    salida_sin_delay : out STD_LOGIC_VECTOR(N-1 downto 0)      -- Salida del componente
  );
end MiComponente;

architecture Behavioral of MiComponente is
  signal multiplicacion1 : STD_LOGIC_VECTOR(2 * N - 1 downto 0);
  signal suma : STD_LOGIC_VECTOR(N - 1 downto 0);
  signal resultado : STD_LOGIC_VECTOR(N-1 downto 0);
  signal flipflop_salida : STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');
begin
  -- Multiplicación 1
  multiplicacion1 <= entrada * coeficiente;

  -- Multiplicación 2
  suma <= multiplicacion1(2 * N - 1 downto N) + sumando;

  -- Resultado
  resultado <= suma;
  
  salida_sin_delay <= resultado;

  -- Flip-flop para almacenar el resultado
  process (clk, rst)
  begin
    if rst = '1' then
      flipflop_salida <= (others => '0');
    elsif rising_edge(clk) then
      flipflop_salida <= resultado;
    end if;
  end process;
  
  -- Salida del componente
  salida <= flipflop_salida;

end Behavioral;
