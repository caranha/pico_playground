# Teaching Demos:

- `collision_1.p8`: Illustration of algorithmic efficiency in game
  programming. All vs All collision in O(N^2). Having about 200
  characters on the screen uses up to 0.3 of the available CPU.
- `collision_2.p8`: Illustration of algorithmic efficiency in game
  programming. Collision using vertical buckets in O(k * m^2). Even
  300 characters on 10 buckets uses less than 0.05 of the available
  CPU.
- `evolution_demo.p8`: Illustration of artificial evolution
  constrained by resources. A grid world host individuals that
  multiply based on a frequency encoded in their genes. This frequency
  can mutate, and the world will quickly be dominated by individuals
  with high reproduction factors even without a explicit fitness
  function.
