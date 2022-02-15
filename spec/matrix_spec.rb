$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))
require 'matrix'

RSpec.describe Matrix do
  describe '.parse' do
    context 'when given string does not represent a NxM matrix' do
      it 'throws an error'
    end

    context 'when given string represents a valid matrix' do
      it 'parses it to rows and columns'
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