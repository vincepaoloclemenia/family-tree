require 'rspec'
require 'pry'
require 'family'
require 'family/person'
require 'family/male'
require 'family/female'
require 'family/father'
require 'family/mother'
require 'family/son'
require 'family/daughter'

describe Family do
  let!(:instance) do
    described_class.new
  end

  context 'when instantiating' do
    it 'builds the members of the family' do
      expect(described_class::Mother.all).not_to be_empty
      expect(described_class::Father.all).not_to be_empty
    end
  end

  context 'when getting relationship' do
    let(:name) { 'Bill' }

    context 'when looking for siblings' do
      let(:relationship) { 'Siblings' }

      it do
        expect(siblings = instance.get_relationship(name: name, relationship: relationship)).not_to be_empty
        expect(siblings).to eq('Charlie, Ginerva, Percy, Ronald')
      end
    end
  end

  context 'when getting maternal aunt' do
    
  end
end