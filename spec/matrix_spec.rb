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
    let(:matrix) do
      Matrix.parse(<<~MATRIX)
        123
        456
        789
      MATRIX
    end

    it 'consecutively yields all submatrixes of given size' do
      expect { |b| matrix.each_submatrix_of_size(rows: 2, cols: 2, &b) }.to yield_successive_args(
        [0, 0, Matrix.parse("12\n45")],
        [0, 1, Matrix.parse("23\n56")],
        [1, 0, Matrix.parse("45\n78")],
        [1, 1, Matrix.parse("56\n89")]
      )
    end
  end

  describe '#find_exact' do
    let(:matrix) do
      Matrix.parse(<<~MATRIX)
        ---00--
        ---00--
        00-----
        00-----
      MATRIX
    end

    let(:pattern) do
      Matrix.parse(<<~MATRIX)
        00
        00
      MATRIX
    end

    it 'returns all occurrences of given matrix in the current matrix' do
      expect { |b| matrix.find_exact(pattern, &b) }.to yield_successive_args(
        [0, 3],
        [2, 0]
      )
    end
  end

  describe '#find_all_possible_occurrences_of' do
    let(:matrix) do
      Matrix.parse(<<~MATRIX)
        ---12-----
        ---34-----
        24--------
        13--------
        ^^rotate--
        ----------
        --21------
        --43------
        --^^mirror
      MATRIX
    end

    let(:pattern) do
      Matrix.parse(<<~MATRIX)
        12
        34
      MATRIX
    end

    it 'returns all occurrences of rotations/mirrors of given matrix in the current matrix' do
      expect { |b| matrix.find_all_possible_occurrences_of(pattern, &b) }.to yield_successive_args(
        [0, 3],
        [2, 0],
        [6, 2]
      )
    end
  end
end
