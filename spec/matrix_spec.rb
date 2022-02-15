# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))
require 'matrix'

RSpec.describe Matrix do
  describe '.parse' do
    context 'when given string does not represent a NxM matrix' do
      it 'throws an error' do
        expect do
          Matrix.parse("abc\nde")
        end.to raise_error(Matrix::ParseError, /expected row number 1 to have 3 columns, got 2/)
        expect do
          Matrix.parse("abc\ndefg")
        end.to raise_error(Matrix::ParseError, /expected row number 1 to have 3 columns, got 4/)
      end
    end

    context 'when given string represents a valid matrix' do
      it 'parses it to rows and columns' do
        matrix = Matrix.parse("0011\n1110")

        expect(matrix.rows).to eq(2)
        expect(matrix.cols).to eq(4)

        expect(matrix[0, 0]).to eq('0')
        expect(matrix[1, 2]).to eq('1')
      end
    end
  end

  describe '#rotate' do
    let(:matrix) do
      Matrix.parse(<<~MATRIX)
        100
        002
      MATRIX
    end

    it 'rotates matrix to the left' do
      expect(matrix.rotate).to eq(Matrix.parse(<<~MATRIX))
        02
        00
        10
      MATRIX
    end

    context 'when rotated 4 times' do
      it 'is equal to initial matrix' do
        matrix_to_rotate = matrix
        4.times { matrix_to_rotate = matrix_to_rotate.rotate }
        expect(matrix_to_rotate).to eq(matrix)
      end
    end
  end

  describe '#mirror' do
    let(:matrix) do
      Matrix.parse(<<~MATRIX)
        --+
        -+-
      MATRIX
    end

    it 'mirrors matrix' do
      expect(matrix.mirror).to eq(Matrix.parse(<<~MATRIX))
        +--
        -+-
      MATRIX
    end

    context 'when mirrored 2 times' do
      it 'is equal to initial matrix' do
        matrix_to_mirror = matrix
        2.times { matrix_to_mirror = matrix_to_mirror.mirror }
        expect(matrix_to_mirror).to eq(matrix)
      end
    end
  end

  describe '#each_submatrix_of_size' do
    it 'consecutively yields all submatrixes of given size'
  end
end
