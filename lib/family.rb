class Family
  include FamilyConcerns

  class PersonNotFound < RuntimeError; end

  class InvalidGender < RuntimeError; end

  class UnknownFamilyRelationship < RuntimeError; end

  # Commands
  ADD_CHILD = 'ADD_CHILD'.freeze
  GET_RELATIONSHIP = 'GET_RELATIONSHIP'.freeze
  ADD_MEMBER = 'ADD_MEMBER'.freeze
  MAKE_COUPLE = 'MAKE_COUPLE'.freeze

  # Genders
  VALID_GENDERS = [
    MALE = :male,
    FEMALE = :female
  ].freeze

  # Indications
  CHILD_ADDED = 'CHILD_ADDED'.freeze
  CHILD_ADDITION_FAILED = 'CHILD_ADDITION_FAILED'.freeze
  PERSON_NOT_FOUND = 'PERSON_NOT_FOUND'.freeze
  INVALID_RELATIONSHIP_DESCRIPTION = 'INVALID_RELATIONSHIP_DESCRIPTION'.freeze
  MEMBER_ADDED = 'MEMBER_ADDED'.freeze
  COUPLE_MARRIED = 'COUPLE_MARRIED'.freeze
  NONE = 'NONE'.freeze

  # Valid Relationship Input
  VALID_RELATIONSHIPS = %i[
    siblings
    paternal_uncle
    paternal_aunt
    maternal_uncle
    maternal_aunt
    sister_in_law
    brother_in_law
    son
    daughter
  ].freeze

  def initialize
    seed_members!
  end

  private

  def seed_members!
    father = Member.new(name: 'Arthur', gender: MALE)
    mother = Member.new(name: 'Margaret', gender: FEMALE)

    father.spouse = mother
    family_member_inputs = read_from_seeds

    family_member_inputs.each do |line|
      inputs = line.gsub(/"/, '').split(' ')
      command = inputs.shift

      case command
      when ADD_CHILD
        mother_name, child_name, gender = inputs

        add_child(mother_name: mother_name, child_name: child_name, gender: gender)
      when GET_RELATIONSHIP
        name, relationship = inputs

        get_relationship(name: name, relationship: relationship)
      when ADD_MEMBER
        name, gender = inputs

        add_member(name: name, gender: gender)
      when MAKE_COUPLE
        female_name, male_name = inputs

        make_couple(female_name: female_name, male_name: male_name)
      end
    end
  end

  def read_from_seeds
    file = File.open(Dir.pwd + '/lib/files/seeds.txt')
    data = file.readlines.map(&:chomp)
    file.close

    data
  end
end