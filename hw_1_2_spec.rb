require 'rspec'

describe Parcel do
  describe '#full_address' do
    subject { Parcel.new('San Francisco', 'CA', '94105', 'Second st.', '235', '130', 15) }
    its(:full_address) { should eq '235 Second st., San Francisco, CA 94105 Apt 130' }
  end
end

describe MailFacility do
  let(:cities) { {'San Francisco' => 4, 'San Antonio' => 3, 'New York' => 15, 'Portland' => 6} }

  describe 'creation' do
    subject { MailFacility.new }
    its(:posted_parcels_count) { should eq 0 }
  end

  describe '#post' do
    subject { MailFacility.new }
    it 'posts a parcel' do
      expect{ subject.post(Parcel.new('City', 'ST', '00000', 'First st.', '1', '1', 1)) }.to change{subject.posted_parcels_count}.from(0).to(1)
    end

    it 'only accepts instance of Parcel class' do
      expect{ subject.post(Object.new) }.to raise_error ArgumentError
    end
  end

  describe '#parcels_sent_to' do
    subject { MailFacility.new }

    before do
      cities.each do |k,v|
        v.times { subject.post(Parcel.new(k, 'ST', '00000', 'First st.', '1', '1', 15)) }
      end
    end

    it "returns correct value for city provided" do
      cities.each do |k,v|
        subject.parcels_sent_to(k).count.should eq v
      end
    end

    it "returns 0 for unknown city" do
      subject.parcels_sent_to('Nowhere').count.should eq 0
    end
  end

  describe '#parcels_with_value_gt' do
    subject { MailFacility.new }
    before do
      1.upto(20) {|i| subject.post(Parcel.new('City', 'ST', '00000', 'First st.', '1', '1', i)) }
    end
    it { subject.parcels_with_value_gt(0).count.should eq 20 }
    it { subject.parcels_with_value_gt(10).count.should eq 10 }
    it { subject.parcels_with_value_gt(20).count.should eq 0 }
  end

  describe '#most_popular_address' do
    subject { MailFacility.new }

    before do
      cities.each do |k,v|
        v.times { subject.post(Parcel.new(k, 'ST', '00000', 'First st.', '1', '1', 1)) }
      end
    end

    it { subject.most_popular_address.should eq '1 First st., New York, ST 00000 Apt 1' }
  end
end
