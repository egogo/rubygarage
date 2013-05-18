require 'rspec'
require_relative 'hw_1_1'

describe BookOrder do

  describe 'creation' do
    subject { BookOrder.new('book', 'person') }

    its(:order_date) { should be_within(1).of(Time.now) }
  end

  describe '#lookup_duration' do
    describe 'when not satisfied' do
      subject { BookOrder.new('book', 'person').lookup_duration }
      it { should eq Float::INFINITY }
    end
    describe 'when satisfied' do
      subject { BookOrder.new('book', 'person', Time.now - 600, Time.now).lookup_duration }
      it { should eq 600 }
    end
  end

  describe '#satisfied?' do
    describe 'when not satisfied' do
      subject { BookOrder.new('book', 'person', Time.now - 600, Time.now).satisfied? }
      it { should be_true }
    end
    describe 'when satisfied' do
      subject { BookOrder.new('book', 'person').satisfied? }
      it { should be_false }
    end
  end
end

describe Library do

  describe 'creation' do
    subject { Library.new.order_count }
    it { should eq 0 }
  end

  describe '#add' do
    subject { Library.new }
    describe 'when passing an instance of BookOrder' do
      it 'adds it to orders collection' do
        expect{ subject.add(BookOrder.new('a','b')) }.to change{subject.order_count}.from(0).to(1)
      end
    end

    describe 'when passing not an instance of BookOrder' do
      it 'raises an exception' do
        expect{ subject.add(Object.new) }.to raise_error ArgumentError
      end
    end
  end
  context 'statistics' do

    describe '#shortest_lookup' do
      subject { Library.new }
      before { 1.upto(5) {|i| subject.add(BookOrder.new('a','b',Time.now - i*123, Time.now)) }}
      its(:shortest_lookup) {should eq 123}
    end

    describe '#not_satisfied_orders' do
      let(:library) do
        library = Library.new
        library.add(BookOrder.new('a','b', Time.now - 100, Time.now))
        1.upto(3) {|i| library.add(BookOrder.new('a','b')) }
        library
      end
      subject { library.not_satisfied_orders }

      its(:count) { should eq 3 }
    end

    describe '#top_lenders_for' do
      let(:library) do
        library = Library.new
        # satisfied
        1.upto(5) do |i|
          i.times { library.add(BookOrder.new('b1',"u#{i}", Time.now - 100, Time.now)) }
        end
        # not satisfied
        1.upto(5) do |i|
          (5-i).times { library.add(BookOrder.new('b1',"u#{i}", Time.now)) }
        end
        # other book
        6.upto(12) do |i|
          (12-i).times { library.add(BookOrder.new('b2',"u#{i}", Time.now - 100, Time.now)) }
        end
        library
      end

      describe 'with no max lenders param' do
        subject { library.top_lenders_for('b1') }
        its(:count) { should eq 3 }
        it { should eq ['u5', 'u4', 'u3'] }
      end

      describe 'with max lenders param' do
        let(:max_lenders) { 2 }
        subject { library.top_lenders_for('b1', max_lenders) }
        its(:count) { should eq 2 }
        it { should eq ['u5', 'u4'] }
      end

    end

    describe '#most_popular_books' do
      let(:library) do
        library = Library.new
        1.upto(10) {|i| library.add(BookOrder.new('b5',"u#{i}")) }
        1.upto(7) {|i| library.add(BookOrder.new('b3',"u#{i}")) }
        1.upto(2) {|i| library.add(BookOrder.new('b4',"u#{i}")) }
        library
      end

      describe 'with no limit param' do
        subject { library.most_popular_books }
        it { should eq ['b5'] }
      end
      describe 'with limit param' do
        subject { library.most_popular_books(2) }
        it { should eq ['b5', 'b3'] }
      end
    end

    describe '#number_of_people_ordered_one_of_the_three_most_popular_books' do #OMFG method name
      let(:library) do
        library = Library.new
        library.add(BookOrder.new('b5',"u2"))
        library.add(BookOrder.new('b5',"u1"))
        library.add(BookOrder.new('b5',"u3"))

        library.add(BookOrder.new('b3',"u3"))
        library.add(BookOrder.new('b3',"u11"))
        library.add(BookOrder.new('b3',"u8"))

        library.add(BookOrder.new('b4',"u12"))

        library.add(BookOrder.new('b4',"u6"))
        library
      end

      subject { library.number_of_people_ordered_one_of_the_three_most_popular_books }
      it { should eq 6 }
    end

  end

end
