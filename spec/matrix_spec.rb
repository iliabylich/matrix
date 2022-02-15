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
    it 'rotates matrix to the left'

    context 'when rotated 4 times' do
      it 'is equal to initial matrix'
    end
  end

  describe '#mirror' do
    it 'mirros matrix'

    context 'when mirrored 2 times' do
      it 'is equal to initial matrix'
    end
  end

  describe '#each_submatrix_of_size' do
    it 'consecutively yields all submatrixes of given size'
  end
end
