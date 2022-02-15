# frozen_string_literal: true

# NOTE: It does conflict with builtin matrix, so either
#   + require it directly
#   + prepend to $LOAD_PATH

# Representation of a matrix
class Matrix
  class ParseError < StandardError; end

  # Parses given string into an instance of Matrix
  #
  # @param input [String] string to parse
  #
  # @return [Matrix]
  def self.parse(input)
    rows = input.lines.map { |row| row.chomp.chars }

    expected_cols = rows.first.length
    if (invalid_row_idx = rows.find_index { |row| row.length != expected_cols })
      raise ParseError, <<~MSG
        expected row number #{invalid_row_idx} to have #{expected_cols} columns, \
        got #{rows[invalid_row_idx].length}
      MSG
    end

    new(rows)
  end

  def initialize(rows)
    @rows = rows
  end

  # Returns total number of rows
  #
  # @return [Integer]
  def rows
    @rows.length
  end

  # Returns total number of columns
  #
  # @return [Integer]
  def cols
    @rows.first.length
  end

  # Returns an element of matrix at +row+ row, +col+ col
  #
  # @return [String]
  def [](row, col)
    @rows[row][col]
  end

  # Consecutively yields all [row, col] pairs for current matrix
  def each_cell
    return to_enum(__method__) unless block_given?

    0.upto(rows - 1) do |row|
      0.upto(cols - 1) do |col|
        yield row, col
      end
    end
  end

  # Compares +self+ against given matrix.
  #
  # +Comparable+ module is not include because other types of comparison are out of scope
  def ==(other)
    return false if rows != other.rows || cols != other.cols

    each_cell.all? { |row, col| self[row, col] == other[row, col] }
  end

  # Rotates matrix to left
  #
  # For example, for matrix
  #
  # 10
  # 00
  #
  # Returns a new matrix
  #
  # 00
  # 10
  def rotate
    rotated = Array.new(cols) { Array.new(rows) { nil } }
    each_cell do |row, col|
      rotated[cols - 1 - col][row] = @rows[row][col]
    end
    self.class.new(rotated)
  end

  # Mirrors matrix vertically
  #
  # For example, for matrix
  #
  # 100
  # 010
  #
  # Returns a new matrix
  #
  # 001
  # 010
  def mirror
    mirrored = Array.new(rows) { Array.new(cols) { nil } }
    each_cell do |row, col|
      mirrored[row][cols - 1 - col] = @rows[row][col]
    end
    self.class.new(mirrored)
  end

  # Returns a slice that start at [start_row, start_col] with size [rows, cols]
  #
  # @return [Matrix]
  def slice(start_row:, rows:, start_col:, cols:)
    self.class.new(
      @rows[start_row...start_row + rows].map { |row| row[start_col...start_col + cols] }
    )
  end

  # Consecutevely yields all submatrixes of given size
  # (left-to-right top-to-bottom)
  # together with their offsets (row, col)
  #
  # @yield [[Integer, Integer, Matrix]]
  def each_submatrix_of_size(rows:, cols:)
    return to_enum(__method__, rows:, cols:) unless block_given?

    0.upto(self.rows - rows) do |start_row|
      0.upto(self.cols - cols) do |start_col|
        yield start_row, start_col, slice(start_row:, rows:, start_col:, cols:)
      end
    end
  end
end
