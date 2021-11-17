require 'rspec'
require 'pry'
require 'family/family_concerns'
require 'family'
require 'family/mother_wife_concerns'
require 'family/father_husband_concerns'
require 'family/member'

describe Family do
  let(:instance) do
    described_class.new
  end

  before(:each) do
    described_class::Member.all = []
  end

  context 'when instantiating' do
    it 'builds the members of the family' do
      expect(instance).to be_truthy
      expect(described_class::Member.all.count).to eq(31)

      expect(instance.get_relationship(name: 'Remus', relationship: 'Maternal-Aunt'))
        .to eq('Dominique')

      expect(instance.add_child(mother_name: 'Flora', child_name: 'Minerva', gender: 'Female').nil?)
        .to be_falsy

      expect(instance.get_relationship(name: 'Minerva', relationship: 'Siblings'))
        .to eq('Victoire Dominique Louis')

      expect(instance.get_relationship(name: 'Lily', relationship: 'Sister-In-Law'))
        .to eq('Darcy Alice')
    end
  end
end