class Family
  class PersonNotFound < RuntimeError; end

  class InvalidGender < RuntimeError; end

  class UnknownFamilyRelationship < RuntimeError; end

  # Commands
  ADD_CHILD = 'ADD_CHILD'.freeze
  GET_RELATIONSHIP = 'GET_RELATIONSHIP'.freeze

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

  def add_child(mother_name:, child_name:, gender:)
    mother = Member.find_by_name! mother_name

    new_child = Member.new(name: child_name, gender: gender)

    mother.add_child new_child

    puts CHILD_ADDED
  rescue FamilyMemberNotFound, InvalidGender => _e
    puts CHILD_ADDITION_FAILED
  end

  def get_relationship(name:, relationship:)
    member = Member.find_by_name! name

    relationship = relationship.to_s.gsub('-', '_').downcase.to_sym
    VALID_RELATIONSHIPS.include?(relationship) or
      raise UnknownFamilyRelationship, INVALID_RELATIONSHIP_DESCRIPTION

    case relationship
    when :paternal_uncle, :paternal_aunt, :maternal_aunt, :siblings,
        :maternal_uncle, :son, :daughter, :sister_in_law, :brother_in_law
      member.public_send("#{relationship}_names")
    else
      'None'
    end
  rescue FamilyMemberNotFound, UnknownFamilyRelationship => e
    puts e.message
  end

  private

  def seed_members!

  end
end