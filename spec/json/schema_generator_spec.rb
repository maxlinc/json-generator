# encoding: utf-8
require 'json/schema_generator'
require 'ansi/code'
require 'ansi/diff'
require 'tempfile'

def clean_output(output)
  output = ANSI.unansi(output)
  output.gsub!(/^\s+/,'')
  output.gsub!(/\s+$/,'')
  output.gsub!("\e[0G", '')
  output

  file = Tempfile.new('json')
  file.write output
  file.flush
  `cat #{file.path} | python -m json.tool`
end

def compare_without_whitespace actual, expected
  actual_cleaned = clean_output actual
  expected_cleaned = clean_output expected
  expect(actual_cleaned).to eq expected_cleaned
  # require 'pry'; binding.pry
  # raise ANSI::Diff.new(actual_cleaned, expected_cleaned)
end

module JSON
  describe SchemaGenerator do
    describe '.generate' do
      Dir['spec/fixtures/examples/*.json'].each do |example_file|
        example = File.basename example_file
        expected = File.expand_path(example, 'spec/fixtures/schemas')
        it "generates the expected schema for #{example}" do
          data = File.read example_file
          schema = described_class.generate example_file, data
          compare_without_whitespace schema, File.read(expected)
        end
      end
    end
  end
end
