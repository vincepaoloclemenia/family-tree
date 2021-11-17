class Family
  module MotherWifeConcerns
    def self.included(base)
      base.include MotherInstanceMethods
      base.include WifeInstanceMethods
    end

    module MotherInstanceMethods
      def add_child(child_or_children)
        child_or_children = [child_or_children] unless child_or_children.is_a?(Array)

        child_or_children.each do |child|
          child.mother = self
          child.father = husband

          if child.male?
            sons.push child
            husband.sons.push(child) unless husband.nil?
          else
            daughters.push child
            husband.daughters.push(child) unless husband.nil?
          end
        end
      end

      def mother_brothers
        return [] if mother.nil?

        mother.brothers
      end

      def mother_sisters
        return [] if mother.nil?

        mother.sisters
      end

      def children
        [*sons, *daughters]
      end

      def son_names
        return 'None' if sons.empty?

        sons.map(&:name).join(' ')
      end

      def daughter_names
        return 'None' if daughters.empty?

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