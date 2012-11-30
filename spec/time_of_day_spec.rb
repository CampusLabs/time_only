require 'rspec'
require 'timecop'
require 'time_of_day'

describe TimeOfDay do
  describe '.new(args)' do
    it 'accepts seconds since midnight' do
      expect(described_class.new(45296).to_i).to eq(45296)
    end

    it 'accepts hours, minutes, seconds' do
      expect(described_class.new(12, 34, 56).to_i).to eq(45296)
    end

    it 'raises an error when the wrong number of arguments is passed' do
      expect{ described_class.new(1, 2) }.to raise_error(ArgumentError)
    end

    it "rolls over seconds that are greater than #{described_class::SECONDS_PER_DAY}" do
      expect(described_class.new(described_class::SECONDS_PER_DAY * 2 + 1).to_i).to eq(1)
    end

    it 'handles negative seconds which rolls back' do
      expect(described_class.new(-10).to_i).to eq(described_class::SECONDS_PER_DAY - 10)
    end
  end

  describe '.at(seconds)' do
    it 'creates a time based on the number of seconds since midnight' do
      expect(described_class.at(300).to_i).to eq(300)
    end

    it "rolls over seconds that are greater than #{described_class::SECONDS_PER_DAY}" do
      expect(described_class.at(described_class::SECONDS_PER_DAY * 2 + 1).to_i).to eq(1)
    end

    it 'handles negative seconds which rolls back' do
      expect(described_class.at(-10).to_i).to eq(described_class::SECONDS_PER_DAY - 10)
    end
  end

  describe '.now' do
    it "returns a #{described_class} object for the current system time" do
      hour, min, sec = 12, 34, 56
      Timecop.freeze(Time.local(2012, 11, 30, hour, min, sec)) do
        expect(described_class.now.to_s).to eq('12:34:56')
      end
    end
  end

  describe '#+(seconds)' do
    it "returns a new #{described_class} object with n seconds added to it" do
      current_time = described_class.new(0)
      new_time = current_time + 1

      expect(current_time).not_to equal(new_time)
      expect(new_time).to eq(described_class.new(1))
    end

    it 'rolls over time when greater than 23:59:59' do
      expect(described_class.new(23, 59, 59) + 2).to eq(described_class.new(0, 0, 1))
    end
  end

  describe '#-(seconds)' do
    it "returns a new #{described_class} object with n seconds subtracted from it" do
      current_time = described_class.new(1)
      new_time = current_time - 1

      expect(current_time).not_to equal(new_time)
      expect(new_time).to eq(described_class.new(0))
    end

    it 'rolls back time when less than 00:00:00' do
      expect(described_class.new(00, 00, 01) - 2).to eq(described_class.new(23, 59, 59))
    end
  end

  describe '#==(other)' do # aliases: eql?
    it 'returns true when the times are the same' do
      expect(described_class.new(12, 34, 56) == described_class.new(12, 34, 56)).to be_true
    end

    it 'returns false when the times are not the same' do
      expect(described_class.new(12, 34, 56) == described_class.new(0, 0, 0)).to be_false
    end
  end

  describe '#<=>(other)' do
    it 'returns 0 when the times are equal' do
      other = described_class.new(0)

      expect(described_class.new(0) <=> other).to eq(0)
    end

    it 'returns -1 when the times are equal' do
      other = described_class.new(1)

      expect(described_class.new(0) <=> other).to eq(-1)
    end
    
    it 'returns 1 when the times are equal' do
      other = described_class.new(0)

      expect(described_class.new(1) <=> other).to eq(1)
    end
  end

  describe '#hour' do
    subject { described_class.new(2, 4, 6) }

    its(:hour) { should be 2 }
  end

  describe '#min' do
    subject { described_class.new(2, 4, 6) }

    its(:min) { should be 4 }
  end

  describe '#sec' do
    subject { described_class.new(2, 4, 6) }

    its(:sec) { should be 6 }
  end

  describe '#strftime' do
  end

  describe '#succ' do
    it "returns a new #{described_class} object, one second later than the original" do
      current_time = described_class.new(0)
      new_time = current_time.succ

      expect(current_time).not_to equal(new_time)
      expect(new_time).to eq(described_class.new(1))
    end

    it 'rolls over time when greater than 23:59:59' do
      expect(described_class.new(23, 59, 59).succ).to eq(described_class.new(0, 0, 0))
    end
  end

  describe '#to_a' do
    subject { described_class.new(2, 3, 4) }

    its(:to_a) { should == [2, 3, 4] }
  end

  describe '#to_f' do
    subject { described_class.new(300) }

    its(:to_f) { should == 300.0 }
  end

  describe '#to_i' do # aliases: tv_sec
    subject { described_class.new(300) }

    its(:to_i) { should == 300 }
  end

  describe '#to_s' do # aliases: asctime, ctime, inspect
    subject { described_class.new(2, 4, 6) }

    its(:to_s) { should == '02:04:06' }
  end
end
