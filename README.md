### Goals

+ `Matrix` class
  + `.parse(input: String) -> Matrix`
  + `#rotate() -> Matrix`
  + `#mirror() -> Matrix`
  + `#each_submatrix_of_size(rows: u32, col: u32) -> Enumerator<(row: u32, col: u32, matrix: Matrix)>`

### Structure

+ `lib/matrix.rb` - implementation of the `Matrix` class
+ `spec/matrix_spec.rb` - unit tests for the `Matrix class`

### Development

+ `rake spec` (or just `rake`) to run tests
+ `rubocop` to run linter
