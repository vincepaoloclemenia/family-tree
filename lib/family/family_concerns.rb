class Family
  module FamilyConcerns
    def self.included(base)
      base.include Commands
    end

    module Commands
      def parse_string_input(string_input)
        inputs = string_input.gsub(/"/, '').split(' ')
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

      def add_child(mother_name:, child_name:, gender:)
        mother = Member.find_by_name_and_gender! mother_name, FEMALE

        new_child = mother.add_child(child_name: child_name, gender: gender)

        puts CHILD_ADDED

        new_child
      rescue PersonNotFound, InvalidGender => _e
        puts CHILD_ADDITION_FAILED
        false
      end

      def add_member(name:, gender:)
        member = Member.find_by_name_and_gender(name, gender) ||
                 Member.new(name: name, gender: gender)

        puts MEMBER_ADDED

        member
      rescue InvalidGender => e
        puts e.message
        false
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
                     NONE
                   end
        )

        output
      rescue PersonNotFound, UnknownFamilyRelationship => e
        puts e.message
        false
      end

      def make_couple(female_name:, male_name:)
        bride = Member.find_by_name_and_gender!(female_name, FEMALE)
        groom = Member.find_by_name_and_gender!(male_name, MALE)

        bride.spouse = groom
        puts COUPLE_MARRIED
        true
      rescue PersonNotFound => e
        puts e.message
        false
      end
    end
  end
end