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
end
