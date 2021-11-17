class Family
  module FatherHusbandConcerns
    def self.included(base)
      base.include FatherInstanceMethods
      base.include HusbandInstanceMethods
    end

    module HusbandInstanceMethods
      def wife_brothers
        return [] if wife.nil?

        wife.brothers
      end

      def wife_sisters
        return [] if wife.nil?

        wife.sisters
      end
    end

    module FatherInstanceMethods
      def father_brothers
        return [] if father.nil?

        father.brothers
      end

      def father_sisters
        return [] if father.nil?

        father.sisters
      end
    end
  end
end