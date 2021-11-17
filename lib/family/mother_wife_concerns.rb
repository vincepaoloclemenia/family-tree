class Family
  module MotherWifeConcerns
    def self.included(base)
      base.include MotherInstanceMethods
      base.include WifeInstanceMethods
    end

    module MotherInstanceMethods
      def look_for_my_child(name:, gender:)
        children.find { |c| c.name == name && c.gender == gender.downcase.to_sym }
      end

      def add_child(child_name:, gender:)
        child = look_for_my_child(name: child_name, gender: gender)
        return if child

        child = Member.new(name: child_name, gender: gender)
        child.mother = self
        child.father = husband

        if child.male?
          sons.append child
          husband.sons.append(child) unless husband.nil?
        elsif child.female?
          daughters.append child
          husband.daughters.append(child) unless husband.nil?
        end

        children.append(child)
        husband.children.append(child) unless husband.nil?
      end

      def mother_brothers
        return [] if mother.nil?

        mother.brothers
      end

      def mother_sisters
        return [] if mother.nil?

        mother.sisters
      end

      def son_names
        return NONE if sons.empty?

        sons.map(&:name).join(' ')
      end

      def daughter_names
        return NONE if daughters.empty?

        daughters.map(&:name).join(' ')
      end
    end

    module WifeInstanceMethods
      def husband_brothers
        return [] if husband.nil?

        husband.brothers
      end

      def husband_sisters
        return [] if husband.nil?

        husband.sisters
      end
    end
  end
end