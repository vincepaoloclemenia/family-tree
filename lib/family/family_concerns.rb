class Family
  module FamilyConcerns
    def self.included(base)
      base.include Commands
    end

    module Commands
      def add_child(mother_name:, child_name:, gender:)
        mother = Member.find_by_name! mother_name

        new_child = Member.new(name: child_name, gender: gender)

        mother.add_child new_child

        puts CHILD_ADDED

        new_child
      rescue PersonNotFound, InvalidGender => _e
        puts CHILD_ADDITION_FAILED
      end

      def add_member(name:, gender:)
        member = Member.find_by_name_and_gender(name, gender) ||
                 Member.new(name: name, gender: gender)

        puts MEMBER_ADDED

        member
      end

      def get_relationship(name:, relationship:)
        member = Member.find_by_name! name

        relationship = relationship.to_s.gsub('-', '_').downcase.to_sym
        VALID_RELATIONSHIPS.include?(relationship) or
          raise UnknownFamilyRelationship, INVALID_RELATIONSHIP_DESCRIPTION

        puts(
          output = case relationship
                   when :paternal_uncle, :paternal_aunt, :maternal_aunt, :siblings,
                       :maternal_uncle, :son, :daughter, :sister_in_law, :brother_in_law
                     member.public_send("#{relationship}_names")
                   else
                     'None'
                   end
        )

        output
      rescue PersonNotFound, UnknownFamilyRelationship => e
        puts e.message
      end

      def make_couple(female_name:, male_name:)
        (bride = Member.find_by_name_and_gender(female_name, FEMALE)).nil? and
          raise PersonNotFound, PERSON_NOT_FOUND
        (groom = Member.find_by_name_and_gender(male_name, MALE)).nil? and
          raise PersonNotFound, PERSON_NOT_FOUND

        bride.spouse = groom
        puts COUPLE_MARRIED
      rescue PersonNotFound => e
        puts e.message
      end
    end
  end
end