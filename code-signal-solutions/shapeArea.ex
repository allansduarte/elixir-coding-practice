def shapeArea(n) when n === 1, do: 1
def shapeArea(n), do: shapeArea(n - 1) + (n - 1) * 4
