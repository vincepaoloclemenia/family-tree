class Family
  include FamilyConcerns

  class PersonNotFound < RuntimeError; end

  class InvalidGender < RuntimeError; end

  class UnknownFamilyRelationship < RuntimeError; end

  # Commands
  COMMANDS = [
    ADD_CHILD = 'ADD_CHILD'.freeze,
    GET_RELATIONSHIP = 'GET_RELATIONSHIP'.freeze,
    ADD_MEMBER = 'ADD_MEMBER'.freeze,
    MAKE_COUPLE = 'MAKE_COUPLE'.freeze
  ]

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
    Member.all = []
    seed_members!
  end

  def parse_input_from_cli(string_input)
    parse_string_input string_input
  end

  private

  def seed_members!
    father = Member.new(name: 'Arthur', gender: MALE)
    mother = Member.new(name: 'Margaret', gender: FEMALE)

    father.spouse = mother
    family_member_inputs = read_from_seeds

    family_member_inputs.each do |line|
      parse_string_input line
    end
  end

  def read_from_seeds
    file = File.open(Dir.pwd + '/lib/files/seeds.txt')
    data = file.readlines.map(&:chomp)
    file.close

    data
  end
end