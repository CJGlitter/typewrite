# frozen_string_literal: true

RSpec.describe Typewrite do
  describe ".write" do
    context "output behavior" do
      before do
        allow_any_instance_of(Object).to receive(:sleep)
      end

      it "outputs the message with a trailing newline by default" do
        expect { described_class.write("hello") }.to output("hello\n").to_stdout
      end

      it "outputs the message without a trailing newline when line_break is false" do
        expect { described_class.write("hello", 0.1, 1.5, false) }.to output("hello").to_stdout
      end

      it "outputs only a newline for empty string" do
        expect { described_class.write("") }.to output("\n").to_stdout
      end

      it "outputs single character correctly" do
        expect { described_class.write("x") }.to output("x\n").to_stdout
      end
    end

    context "timing behavior" do
      it "sleeps for type_rate after each character" do
        sleep_calls = []
        allow_any_instance_of(Object).to receive(:sleep) { |_, duration| sleep_calls << duration }

        described_class.write("test", 0.05, 0, false)

        expect(sleep_calls.count(0.05)).to eq(4)
      end

      it "sleeps for punc_rate after period" do
        sleep_calls = []
        allow_any_instance_of(Object).to receive(:sleep) { |_, duration| sleep_calls << duration }

        described_class.write(".", 0.1, 2.0, false)

        expect(sleep_calls).to include(2.0)
      end

      it "sleeps for punc_rate after question mark" do
        sleep_calls = []
        allow_any_instance_of(Object).to receive(:sleep) { |_, duration| sleep_calls << duration }

        described_class.write("?", 0.1, 1.5, false)

        expect(sleep_calls).to include(1.5)
      end

      it "sleeps for punc_rate after exclamation mark" do
        sleep_calls = []
        allow_any_instance_of(Object).to receive(:sleep) { |_, duration| sleep_calls << duration }

        described_class.write("!", 0.1, 1.5, false)

        expect(sleep_calls).to include(1.5)
      end

      it "sleeps for both punc_rate and type_rate on punctuation" do
        sleep_calls = []
        allow_any_instance_of(Object).to receive(:sleep) { |_, duration| sleep_calls << duration }

        described_class.write("Hi.", 0.1, 1.5, false)

        expect(sleep_calls.count(0.1)).to eq(3)  # H, i, .
        expect(sleep_calls.count(1.5)).to eq(1)  # pause after .
      end
    end
  end
end
