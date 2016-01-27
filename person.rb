
class Person
  @@array = Array.new

  def self.all
    @@array
  end

  # rather than manually managing an array, we could instead use Objectspace
  # however, this confuses things a bit in testing
  # def self.all
  #   ObjectSpace.each_object(self).entries
  # end

  # this is (or should be) used only for testing
  def self.clear_array
    @@array = Array.new
  end

  # takes as input a regexp and a string containing one entry per line
  # I was originially going to create a subclass for each parsing option
  # but this ended up being cleaner, really
  def self.initialize_multiple(regexp, list)
    list.each_line do |line|
      results = line.chomp.match(regexp)
      self.new results
    end
  end

  # just for kicks, and to be real meta, let's abstract these to work for any field
  # I'm not using it, I just thought it would be cool to throw in
  def self.all_by_attribute(attr)
    self.all.sort { |a,b| a.send(attr) <=> b.send(attr) }
  end

  # output 1 - appears to be by gender (female/male) then by last name
  # unclear how identical last names should be ordered
  def self.all_by_gender_and_last_name
    # sorting by gender really doesn't insure that the last name ordering is maintained
    # so instead we're just grabbing groups from a last name sorted list
    results = self.all_by_last_name
    results.select { |p| p.gender == "Female" } + results.select { |p| p.gender == "Male" }
  end

  # output 2 - appears to be by birthdate
  # unclear how identical birthdates should be ordered
  def self.all_by_date_of_birth
    self.all.sort { |a,b| a.date_of_birth <=> b.date_of_birth }
    # alternate: self.all_by_attribute(:date_of_birth)
  end

  # output 3 - appears to be by last name, reversed
  # unclear how identical last names should be ordered
  # I'm actually doing it forward and expecting it to be reversed by the caller
  def self.all_by_last_name
    self.all.sort { |a,b| a.last.downcase <=> b.last.downcase }
  end

  attr_accessor :first, :last, :gender, :favorite_color, :day, :month, :year, :date_of_birth

  def initialize(attrs = {})
    @first = attrs[:first]
    @last = attrs[:last]
    @gender = attrs[:gender]

    # Normalize gender value to match desired output format
    if @gender.upcase == "M"
      @gender = "Male"
    elsif @gender.upcase == "F"
      @gender = "Female"
    end

    @favorite_color = attrs[:favorite_color]

    @year = attrs[:year]
    @month = attrs[:month]
    @day = attrs[:day]

    # we compute date of birth object to use in comparisons
    # but keep the input elements because it's less of a pain to format the outpus
    @date_of_birth = Date.new(@year.to_i, @month.to_i, @day.to_i)

    @@array << self
  end

  def to_s
    "#{@last} #{@first} #{@gender} #{@month}/#{@day}/#{@year} #{@favorite_color}"
  end
end
