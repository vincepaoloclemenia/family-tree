class Family
  class Member
    include MotherWifeConcerns
    include FatherHusbandConcerns

    @all = []

    class << self
      attr_accessor :all
    end

    def initialize(name:, gender:)
      @name = name
      gender = gender.downcase
      gender = gender.to_sym unless gender.is_a?(Symbol)
      @gender = gender

      VALID_GENDERS.include?(@gender) or
        raise InvalidGender, "Invalid gender #{@gender}"

      @sons = []
      @daughters = []

      self.class.all.push self
    end

    attr_accessor :name, :gender, :wife, :husband, :sons,
                  :father, :mother, :daughters

    def self.find_by_name(name)
      all.find { |m| m.name.downcase == name.downcase }
    end

    def self.find_by_name_and_gender(name, gender)
      all.find { |m| m.name.downcase == name.downcase && m.gender == gender.downcase.to_sym }
    end

    def self.find_by_name!(name)
      (member = find_by_name name).nil? and
        raise PersonNotFound, PERSON_NOT_FOUND

      member
    end

    %w[brother sister].each do |method_name|
      define_method "#{method_name}s" do
        return [] if mother.nil?

        if method_name == 'brother'
          mother.sons - [self]
        else
          mother.daughters - [self]
        end
      end

      define_method "#{method_name}s_in_law" do
        if method_name == 'brother'
          spouse_brothers = male? ? wife_brothers : husband_brothers
          [*spouse_brothers, *siblings.map(&:husband).compact]
        else
          spouse_sisters = male? ? wife_sisters : husband_sisters
          [*spouse_sisters, *siblings.map(&:wife).compact]
        end
      end

      define_method "#{method_name}_in_law_names" do
        if method_name == 'brother'
          return 'None' if brothers_in_law.empty?

          brothers_in_law.map(&:name).join(' ')
        else
          return 'None' if sisters_in_law.empty?

          sisters_in_law.map(&:name).join(' ')
        end
      end
    end

    %w[maternal paternal].each do |method_name|
      define_method "#{method_name}_uncles" do
        if method_name == 'paternal'
          father_brothers
        else
          mother_brothers
        end
      end

      define_method "#{method_name}_uncle_names" do
        if method_name == 'paternal'
          return 'None' if paternal_uncles.empty?

          paternal_uncles.map(&:name).join(' ')
        else
          return 'None' if maternal_uncles.empty?

          maternal_uncles.map(&:name).join(' ')
        end
      end

      define_method "#{method_name}_aunts" do
        if method_name == 'maternal'
          mother_sisters
        else
          father_sisters
        end
      end

      define_method "#{method_name}_aunt_names" do
        if method_name == 'maternal'
          return 'None' if maternal_aunts.empty?

          maternal_aunts.map(&:name).join(' ')
        else
          return 'None' if paternal_aunts.empty?

          paternal_aunts.map(&:name).join(' ')
        end
      end
    end

    def inspect
      "<#{self.class.name} object_id=#{object_id} name=#{name}>"
    end

    def male?
      gender == MALE
    end

    def female?
      not male?
    end

    def siblings
      [*brothers, *sisters]
    end

    def siblings_names
      return 'None' if siblings.empty?

      siblings.map(&:name).sort.join(' ')
    end

    def spouse=(partner)
      if male?
        @wife = partner
        partner.husband = self
      else
        @husband = partner
        partner.wife = self
      end
    end
  end
end