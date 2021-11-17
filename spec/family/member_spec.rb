require 'rspec'
require 'pry'
require 'family/family_concerns'
require 'family'
require 'family/mother_wife_concerns'
require 'family/father_husband_concerns'
require 'family/member'

describe Family::Member do
  shared_examples 'it adds new member' do
    it do
      expect(described_class.all.count).to eq(expected_member_count)
    end
  end

  before(:each) do
    described_class.all = []
  end

  context 'when instantiating' do
    let(:name) { 'Paolo' }
    let(:gender) { Family::MALE }
    let!(:father) do
      described_class.new(name: name, gender: gender)
    end
    let(:expected_member_count) { 1 }

    it_behaves_like 'it adds new member'

    context 'when adding wife' do
      let!(:mother) do
        described_class.new(name: 'Kay', gender: Family::FEMALE)
      end
      let(:expected_member_count) { 2 }

      before(:each) do
        mother.spouse = father
      end

      it_behaves_like 'it adds new member'

      it 'creates couple' do
        expect(father.wife).to eq(mother)
        expect(mother.husband).to eq(father)
      end

      context 'when adding children' do
        let!(:son) { described_class.new(name: 'Tyler', gender: Family::MALE) }
        let!(:daughter) { described_class.new(name: 'Astrid', gender: Family::FEMALE) }
        let(:children) { [son, daughter] }
        let!(:expected_member_count) { 4 }

        it_behaves_like 'it adds new member'

        before do
          mother.add_child children
        end

        it 'adds brothers relationship' do
          expect(father.sons).to eq([son])
          expect(mother.daughters).to eq([daughter])
          expect(mother.children).to eq(children)
          expect(son.siblings).to eq([daughter])
          expect(son.sisters).to eq([daughter])
          expect(son.brothers).to be_empty

          expect(daughter.siblings).to eq([son])
          expect(daughter.sisters).to be_empty
          expect(daughter.brothers).to eq([son])
        end

        context 'when their children grows up and have spouses' do
          let!(:son_wife) { described_class.new(name: 'Liza', gender: Family::FEMALE) }
          let!(:daughter_husband) { described_class.new(name: 'Sebastian', gender: Family::MALE) }
          let(:expected_member_count) { 6 }

          before do
            son.spouse = son_wife
            daughter.spouse = daughter_husband
          end

          it 'creates in laws for their children' do
            expect(son.wife).to eq(son_wife)
            expect(son_wife.husband).to eq(son)

            expect(daughter.husband).to eq(daughter_husband)
            expect(daughter_husband.wife).to eq(daughter)

            expect(son.brothers_in_law).to eq([daughter_husband])
            expect(son.sisters_in_law).to be_empty
            expect(son_wife.brothers_in_law).to be_empty
            expect(son_wife.sisters_in_law).to eq([daughter])

            expect(daughter.brothers_in_law).to be_empty
            expect(daughter.sisters_in_law).to eq([son_wife])
            expect(daughter_husband.brothers_in_law).to eq([son])
            expect(daughter_husband.sisters_in_law).to be_empty
          end

          context 'when adding grand children' do
            let!(:grandson) { described_class.new(name: 'Vincent', gender: Family::MALE) }
            let!(:granddaughter) { described_class.new(name: 'Margarette', gender: Family::FEMALE) }

            it do
              son_wife.add_child granddaughter
              daughter.add_child grandson

              expect(son_wife.children).to eq([granddaughter])
              expect(granddaughter.mother).to eq(son_wife)
              expect(granddaughter.father).to eq(son)
              expect(granddaughter.paternal_uncles).to be_empty
              expect(granddaughter.paternal_aunts).to eq([daughter])
              expect(granddaughter.maternal_uncles).to be_empty
              expect(granddaughter.maternal_aunts).to be_empty

              expect(daughter.children).to eq([grandson])
              expect(grandson.mother).to eq(daughter)
              expect(grandson.father).to eq(daughter_husband)
              expect(grandson.paternal_uncles).to be_empty
              expect(grandson.paternal_aunts).to be_empty
              expect(grandson.maternal_uncles).to eq([son])
              expect(grandson.maternal_aunts).to be_empty
            end
          end
        end
      end
    end
  end
end