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

    context "interrupt functionality" do
      before do
        allow_any_instance_of(Object).to receive(:sleep)
      end

      it "works without interrupt parameter (backwards compatibility)" do
        expect { described_class.write("hello") }.to output("hello\n").to_stdout
      end

      it "works with interrupt: false (backwards compatibility)" do
        expect { described_class.write("hello", 0.1, 1.5, true, interrupt: false) }.to output("hello\n").to_stdout
      end

      context "when interrupt is enabled" do
        let(:mock_stdin) { instance_double(IO) }

        before do
          allow($stdin).to receive(:raw).and_yield(mock_stdin)
        end

        it "outputs full message when no key is pressed (interrupt: true)" do
          allow(mock_stdin).to receive(:wait_readable).and_return(nil)

          expect { described_class.write("hello", 0.1, 1.5, true, interrupt: true) }.to output("hello\n").to_stdout
        end

        it "outputs full message when no key is pressed (interrupt: :enter)" do
          allow(mock_stdin).to receive(:wait_readable).and_return(nil)

          expect { described_class.write("hello", 0.1, 1.5, true, interrupt: :enter) }.to output("hello\n").to_stdout
        end

        it "outputs full message when no key is pressed (interrupt: :any)" do
          allow(mock_stdin).to receive(:wait_readable).and_return(nil)

          expect { described_class.write("hello", 0.1, 1.5, true, interrupt: :any) }.to output("hello\n").to_stdout
        end

        it "outputs full message when no key is pressed (interrupt: array)" do
          allow(mock_stdin).to receive(:wait_readable).and_return(nil)

          expect { described_class.write("hello", 0.1, 1.5, true, interrupt: ["q"]) }.to output("hello\n").to_stdout
        end

        it "prints remaining text immediately when enter is pressed (interrupt: true)" do
          call_count = 0
          allow(mock_stdin).to receive(:wait_readable) do
            call_count += 1
            call_count == 2 ? true : nil
          end
          allow(mock_stdin).to receive(:getc).and_return("\n")

          expect { described_class.write("hello", 0.1, 1.5, true, interrupt: true) }.to output("hello\n").to_stdout
        end

        it "prints remaining text immediately when enter is pressed (interrupt: :enter)" do
          call_count = 0
          allow(mock_stdin).to receive(:wait_readable) do
            call_count += 1
            call_count == 2 ? true : nil
          end
          allow(mock_stdin).to receive(:getc).and_return("\r")

          expect { described_class.write("hello", 0.1, 1.5, true, interrupt: :enter) }.to output("hello\n").to_stdout
        end

        it "prints remaining text immediately when any key is pressed (interrupt: :any)" do
          call_count = 0
          allow(mock_stdin).to receive(:wait_readable) do
            call_count += 1
            call_count == 2 ? true : nil
          end
          allow(mock_stdin).to receive(:getc).and_return("x")

          expect { described_class.write("hello", 0.1, 1.5, true, interrupt: :any) }.to output("hello\n").to_stdout
        end

        it "prints remaining text when matching key is pressed (interrupt: array)" do
          call_count = 0
          allow(mock_stdin).to receive(:wait_readable) do
            call_count += 1
            call_count == 3 ? true : nil
          end
          allow(mock_stdin).to receive(:getc).and_return("q")

          expect do
            described_class.write("hello", 0.1, 1.5, true, interrupt: %w[q x])
          end.to output("hello\n").to_stdout
        end

        it "does not interrupt when non-matching key is pressed (interrupt: array)" do
          allow(mock_stdin).to receive(:wait_readable).and_return(true)
          allow(mock_stdin).to receive(:getc).and_return("a", "b", "c", "d", "e")

          expect { described_class.write("hello", 0.1, 1.5, true, interrupt: ["q"]) }.to output("hello\n").to_stdout
        end

        it "does not interrupt when non-enter key is pressed (interrupt: :enter)" do
          allow(mock_stdin).to receive(:wait_readable).and_return(true)
          allow(mock_stdin).to receive(:getc).and_return("x", "y", "z", "a", "b")

          expect { described_class.write("hello", 0.1, 1.5, true, interrupt: :enter) }.to output("hello\n").to_stdout
        end

        it "handles empty string with interrupt enabled" do
          expect { described_class.write("", 0.1, 1.5, true, interrupt: true) }.to output("\n").to_stdout
        end

        it "handles single character with interrupt enabled" do
          allow(mock_stdin).to receive(:wait_readable).and_return(nil)

          expect { described_class.write("x", 0.1, 1.5, true, interrupt: true) }.to output("x\n").to_stdout
        end

        it "respects line_break: false with interrupt" do
          allow(mock_stdin).to receive(:wait_readable).and_return(nil)

          expect { described_class.write("hi", 0.1, 1.5, false, interrupt: true) }.to output("hi").to_stdout
        end
      end
    end
  end
end
