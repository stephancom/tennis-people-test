require './person'

describe Person, '#person' do
  describe "a single person" do
    shared_examples_for 'a person' do
      it "computes a date object" do
        expect(subject.date_of_birth).to be_a(Date)
      end
    end

    describe 'a male person' do
      let(:attrs) { {first: 'Stephan', last: 'Meyers', gender: 'M', favorite_color: 'Orange', month: '2', day: '23', year: '1968'} }
      subject { Person.new(attrs) }

      it_behaves_like 'a person'

      it "should normalize the gender" do
        expect(subject.gender).to eql('Male')
      end

      it "should output the correct string" do
        expect(subject.to_s).to eql('Meyers Stephan Male 2/23/1968 Orange')
      end
    end

    describe 'a female person' do
      let(:attrs) { {first: 'Crystal', last: 'Hefner', gender: 'Female', favorite_color: 'Pink', month: '4', day: '29', year: '1986'} }
      subject { Person.new(attrs) }

      it_behaves_like 'a person'

      it "should not change the gender text" do
        expect(subject.gender).to eql('Female')
      end

      it "should output the correct string" do
        expect(subject.to_s).to eql('Hefner Crystal Female 4/29/1986 Pink')
      end
    end
  end

  describe "a list of people" do
    before(:each) do
      # clear the list
      Person.clear_array
    end
    shared_examples_for 'several people' do
      it "should contain a list of people" do
        Person.all.each do |p|
          expect(p).to be_a(Person)
        end
      end

      it "should sort by last name" do
        expect(Person.all_by_last_name.map { |p| p.last }).to eql(last_name_order)
      end


      it "should sort by date of birth" do
        expect(Person.all_by_date_of_birth.map { |p| p.last }).to eql(date_of_birth_order)
      end

      it "should sort by gender and last name" do
        expect(Person.all_by_gender_and_last_name.map { |p| p.last }).to eql(gender_and_last_name_order)
      end
    end

    describe "from one regexp and input" do
      before(:each) do
        Person.initialize_multiple(regexp, list)
      end

      # example of format "Gender" "First Last" "day/month/year" "Color"
      describe "delimited with quotes" do
        let(:regexp) {
          /^\s*"(?<gender>(Male|Female))"\s*"(?<first>\w+)\s*(?<last>\w+)"\s*"(?<day>\d+)\/(?<month>\d+)\/(?<year>\d+)"\s*"(?<favorite_color>\w+)"\s*$/
        }
        let(:list) {
          <<-EOLIST
            "Male" "Stephan Meyers" "23/2/1968" "Orange"
            "Male" "David Bowie" "8/1/1947" "Silver"
            "Female" "Crystal Hefner" "29/4/1986" "Pink"
            "Male" "Abe Vigoda" "24/2/1921" "Brown"
            "Male" "Oliver Sachs" "9/7/1933" "Grey"
            "Female" "Lily Tomlin" "1/9/1939" "Plaid"
          EOLIST
        }
        let(:date_of_birth_order) {
          %w(Vigoda Sachs Tomlin Bowie Meyers Hefner)
        }
        let(:last_name_order) {
          %w(Bowie Hefner Meyers Sachs Tomlin Vigoda)
        }
        let(:gender_and_last_name_order) {
          %w(Hefner Tomlin Bowie Meyers Sachs Vigoda)
        }

        it_behaves_like 'several people'
      end

      # example of format Last#First@year day month@Color@Gender
      describe "delimited with # and @'s" do
        let(:regexp) {
          /^\s*(?<last>\w+)#(?<first>\w+)@(?<year>\d+)\s(?<month>\d+)\s(?<day>\d+)@(?<favorite_color>\w+)@(?<gender>(M|F))\s*$/
        }
        # source: http://transponsters.tumblr.com/post/37255432163/friends-characters-birthdays-and-ages
        let(:list) {
          <<-EOLIST
            Buffay#Phoebe@1965 2 16@Yellow@F
            Tribbiani#Joey@1967 1 4@Unknown@M
            Geller#Ross@1967 10 18@Blue@M
            Bing#Chandler@1968 4 25@Green@M
            Geller#Monica@1969 4 1@Red@F
            Green#Rachel@1969 5 5@White@F
          EOLIST
        }
        let(:date_of_birth_order) {
          %w(Buffay Tribbiani Geller Bing Geller Green)
        }
        let(:last_name_order) {
          %w(Bing Buffay Geller Geller Green Tribbiani)
        }
        let(:gender_and_last_name_order) {
          %w(Buffay Geller Green Bing Geller Tribbiani)
        }

        it_behaves_like 'several people'
      end
    end

    describe "with multiple regexps and inputs" do
      before(:each) do
        Person.initialize_multiple(quote_regexp, quote_list)
        Person.initialize_multiple(at_regexp, at_list)
      end
      let(:quote_regexp) {
        /^\s*"(?<gender>(Male|Female))"\s*"(?<first>\w+)\s*(?<last>\w+)"\s*"(?<day>\d+)\/(?<month>\d+)\/(?<year>\d+)"\s*"(?<favorite_color>\w+)"\s*$/
      }
      let(:quote_list) {
        <<-EOLIST
          "Male" "Stephan Meyers" "23/2/1968" "Orange"
          "Male" "David Bowie" "8/1/1947" "Silver"
          "Female" "Crystal Hefner" "29/4/1986" "Pink"
          "Male" "Abe Vigoda" "24/2/1921" "Brown"
          "Male" "Oliver Sachs" "9/7/1933" "Grey"
          "Female" "Lily Tomlin" "1/9/1939" "Plaid"
        EOLIST
      }
      let(:at_regexp) {
        /^\s*(?<last>\w+)#(?<first>\w+)@(?<year>\d+)\s(?<month>\d+)\s(?<day>\d+)@(?<favorite_color>\w+)@(?<gender>(M|F))\s*$/
      }
      # source: http://transponsters.tumblr.com/post/37255432163/friends-characters-birthdays-and-ages
      let(:at_list) {
        <<-EOLIST
          Buffay#Phoebe@1965 2 16@Yellow@F
          Tribbiani#Joey@1967 1 4@Unknown@M
          Geller#Ross@1967 10 18@Blue@M
          Bing#Chandler@1968 4 25@Green@M
          Geller#Monica@1969 4 1@Red@F
          Green#Rachel@1969 5 5@White@F
        EOLIST
      }
      let(:date_of_birth_order) {
        %w(Vigoda Sachs Tomlin Bowie Buffay Tribbiani Geller Meyers Bing Geller Green Hefner)
      }
      let(:last_name_order) {
        %w(Bing Bowie Buffay Geller Geller Green Hefner Meyers Sachs Tomlin Tribbiani Vigoda)
      }
      let(:gender_and_last_name_order) {
        %w(Buffay Geller Green Hefner Tomlin Bing Bowie Geller Meyers Sachs Tribbiani Vigoda)
      }

      it_behaves_like 'several people'
   
    end
  end
end