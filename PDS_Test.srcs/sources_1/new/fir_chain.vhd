library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package bus_multiplexer_pkg is
    constant N : natural := 4;
    type bus_array is array(natural range <>) of std_logic_vector(N to 0);
end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.bus_multiplexer_pkg.all;

entity filtro_fir_cadena is
  generic
  (
    N : positive := 2; -- Tamaño configurable
    M : positive := 3  -- Número de componentes FIR en la cadena
  );
  port
  (
    clk     : in STD_LOGIC; -- Reloj
    rst     : in STD_LOGIC; -- Reset asincrónico
    entrada : in STD_LOGIC_VECTOR(N - 1 downto 0); -- Señal de entrada común
    coeficientes : in bus_array(0 to M-1);
    salida  : out STD_LOGIC_VECTOR(N - 1 downto 0) -- Salida del componente TOP
  );
end filtro_fir_cadena;

architecture Behavioral of filtro_fir_cadena is
  
  signal sumando_intermedio : std_logic_vector(N - 1 downto 0) := (others => '0');
  signal salida_final: std_logic_vector(N - 1 downto 0) := (others => '0');

  -- Declarar instancias de los componentes FIR
  component fir_core
    port
    (
      clk              : in std_logic;
      rst              : in std_logic;
      entrada          : in std_logic_vector(N - 1 downto 0);
      sumando          : in std_logic_vector(N - 1 downto 0);
      coeficiente      : in std_logic_vector(N - 1 downto 0);
      salida           : out std_logic_vector(N - 1 downto 0);
      salida_sin_delay : out std_logic_vector(N - 1 downto 0)
    );
  end component;

  -- Arreglo de señales de salida sin delay para cada componente FIR


begin
  -- Instancias de los componentes FIR en cadena
  fir_insts: for i in 0 to M - 1 generate
    fir_i: fir_core
      port map(
        clk              => clk,
        rst              => rst,
        entrada          => entrada,
        sumando          => sumando_intermedio,
        coeficiente      => coeficientes(i),
        salida           => sumando_intermedio,
        salida_sin_delay => salida_final
      );
  end generate;

  -- Salida del componente TOP
  salida <= salida_final;

end Behavioral;
